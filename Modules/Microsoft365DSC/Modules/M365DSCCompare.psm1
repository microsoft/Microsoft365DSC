<#
.SYNOPSIS
    This module contains the comparison logic for M365DSC.
#>
function Compare-M365DSCResourceState
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $DesiredValues,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $CurrentValues,

        [Parameter()]
        [System.String[]]
        $ExcludedProperties,

        [Parameter()]
        [System.String[]]
        $IncludedProperties,

        [Parameter()]
        [System.Func[Hashtable, Hashtable, Hashtable, [Object[]], Tuple[Hashtable, Hashtable, Hashtable]]]
        $PostProcessing,

        [Parameter()]
        [System.Object[]]
        $PostProcessingArgs = @()
    )

    $Global:AllDrifts = @{
        DriftInfo     = @()
        CurrentValues = @{}
        DesiredValues = @{}
    }
    $Global:PotentialDrifts = @()

    # Retrieve the primary keys of the given resource and remove them from the list of values to check.
    $currentPath = $PSScriptRoot
    if ($null -eq $Script:M365DSCSchema)
    {
        $schemaPath = Join-Path -Path $currentPath -ChildPath '..\SchemaDefinition.json'
        $schemaJSON = Get-Content $schemaPath -Raw
        $Script:M365DSCSchema = ConvertFrom-Json $schemaJSON
    }
    $resourceDefinition = $Script:M365DSCSchema | Where-Object -FilterScript { $_.ClassName -eq "MSFT_$ResourceName" }
    $resourceKeys = $resourceDefinition.Parameters | Where-Object -FilterScript { $_.Option -eq 'Key' }

    $ValuesToCheck = $DesiredValues.Clone()

    # Apply custom post-processing to CurrentValues and ValuesToCheck if specified
    if ($null -ne $PostProcessing)
    {
        Write-Verbose -Message "Applying custom post-processing to CurrentValues and ValuesToCheck for resource $ResourceName"
        try
        {
            $result = $PostProcessing.Invoke($DesiredValues, $CurrentValues, $ValuesToCheck, $PostProcessingArgs)
            if ($null -ne $result -and $result.Item1 -is [Hashtable] -and $result.Item2 -is [Hashtable] -and $result.Item3 -is [Hashtable])
            {
                $DesiredValues = $result.Item1
                $CurrentValues = $result.Item2
                $ValuesToCheck = $result.Item3
            }
            else
            {
                Write-Warning -Message "PostProcessing function did not return a valid tuple for resource $ResourceName. Using original values."
            }
        }
        catch
        {
            Write-Warning -Message "Error occurred during post-processing for resource $ResourceName`: $_"
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck.Remove('Identity') | Out-Null

    # Remove the key parameters from the comparison
    foreach ($keyToRemove in $resourceKeys)
    {
        $ValuesToCheck.Remove($keyToRemove.Name) | Out-Null
    }

    # Remove PSCredential object from the list of properties to be evaluated
    $credentialProperties = $resourceDefinition.Parameters | Where-Object -FilterScript { $_.CIMType -eq 'MSFT_Credential' }
    foreach ($property in $credentialProperties)
    {
        $ValuesToCheck.Remove($property.Name) | Out-Null
    }

    # Remove the ExcludedProperties from the list of properties to be evaluated
    foreach ($property in $ExcludedProperties)
    {
        $ValuesToCheck.Remove($property) | Out-Null
    }

    # Add the IncludedProperties to the list of properties to be evaluated
    foreach ($property in $IncludedProperties)
    {
        if ($DesiredValues.ContainsKey($property) -and -not $ValuesToCheck.ContainsKey($property))
        {
            $ValuesToCheck.Add($property, $DesiredValues.$property)
        }
    }

    $testTargetResource = $true
    $skipEvaluation = $false
    if ($DesiredValues.Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "The resource $ResourceName with $finalString was not found in the tenant."
        $Global:AllDrifts.DriftInfo += @{
            PropertyName = 'Ensure'
            CurrentValue = 'Absent'
            DesiredValue = 'Present'
        }
        $testTargetResource = $false
    }
    elseif ($DesiredValues.Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "The resource $ResourceName with $finalString should not exist in the tenant."
        $Global:AllDrifts.DriftInfo += @{
            PropertyName = 'Ensure'
            CurrentValue = 'Present'
            DesiredValue = 'Absent'
        }
        $testTargetResource = $false
    }
    elseif ($DesiredValues.Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "The resource $ResourceName with $finalString does not exist in the tenant as desired." -Verbose:$Verbose
        $skipEvaluation = $true
    }

    $testResult = $true
    if ($testTargetResource -and -not $skipEvaluation)
    {
        # Compare Cim instances
        $desiredKeys = $DesiredValues.Clone().Keys
        foreach ($key in $desiredKeys)
        {
            $source = $DesiredValues.$key
            $target = $CurrentValues.$key
            $parameterDefinition = $resourceDefinition.Parameters | Where-Object -FilterScript { $_.Name -eq $key }
            if ($null -ne $source -and ($source.GetType().Name -like '*CimInstance*' -or $parameterDefinition.CIMType -like "MSFT_*"))
            {
                Write-Verbose -Message "Comparing complex object property $key of resource $ResourceName"
                $CIMProperty = $parameterDefinition
                $CIMName = $CIMProperty.CIMType.Replace('[]', '')
                $CIMDefinition = $Script:M365DSCSchema | Where-Object -FilterScript { $_.ClassName -eq $CIMName }
                $CIMPrimaryKeys = $CIMDefinition.Parameters | Where-Object -FilterScript { $_.Option -eq 'Required' }

                $targetObjects = @{}
                if ($source.GetType().Name -in @('CimInstance[]', 'Object[]'))
                {
                    $targetObjects = @()
                }

                # Filter all target objects that match the primary keys of the source object(s)
                $target = $target | Where-Object -FilterScript {
                    $match = $true
                    foreach ($primaryKey in $CIMPrimaryKeys.Name)
                    {
                        # Because $source can be an array, we need to check if the
                        # primary key value exists in any of the source objects
                        $sourceValue = $source.$primaryKey | Select-Object -Unique
                        if ($_.$primaryKey -notin @($sourceValue))
                        {
                            $match = $false
                        }
                    }
                    return $match
                }

                foreach ($targetObject in $target)
                {
                    foreach ($primaryKey in $CIMPrimaryKeys.Name)
                    {
                        if ($primaryKey -notin $IncludedProperties)
                        {
                            $targetObject.Remove($primaryKey) | Out-Null
                        }
                    }

                    if ($targetObjects -is [array])
                    {
                        $targetObjects += $targetObject
                    }
                    else
                    {
                        $targetObjects = $targetObject
                    }
                }

                $testResult = Compare-M365DSCComplexObject `
                    -Source ($source) `
                    -Target ($targetObjects) `
                    -PropertyName $key

                if (-not $testResult)
                {
                    Write-Verbose "TestResult returned False for $source"
                    $testTargetResource = $false
                }

                $DesiredValues.Remove($key) | Out-Null
                $ValuesToCheck.Remove($key) | Out-Null
            }
        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult2 = $true
    if (-not $skipEvaluation)
    {
        $testResult2 = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $ResourceName `
            -DesiredValues $DesiredValues `
            -ValuesToCheck $ValuesToCheck.Keys `
            -NoEventMessage `
            -NoDriftReset
    }

    if ($testResult -and -not $testResult2)
    {
        $testResult = $false
    }

    if (-not $testResult)
    {
        $testTargetResource = $false
    }

    return $testTargetResource
}

Export-ModuleMember -Function Compare-M365DSCResourceState
