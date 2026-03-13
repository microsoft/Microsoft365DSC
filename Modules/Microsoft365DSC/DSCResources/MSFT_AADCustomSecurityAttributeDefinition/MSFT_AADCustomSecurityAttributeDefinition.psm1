Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADCustomSecurityAttributeDefinition'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AttributeSet,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AllowedValues,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsCollection,

        [Parameter()]
        [System.Boolean]
        $IsSearchable,

        [Parameter()]
        [ValidateSet('Available', 'Deprecated')]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [System.Boolean]
        $UsePreDefinedValuesOnly,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of AzureAD Custom Security Attribute Definition for {$Name}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $instance = Get-MgBetaDirectoryCustomSecurityAttributeDefinition -CustomSecurityAttributeDefinitionId $Id `
                    -ExpandProperty 'allowedValues' `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $instance)
            {
                $instance = Get-MgBetaDirectoryCustomSecurityAttributeDefinition -Filter "Name eq '$($Name -replace "'", "''")'" `
                    -ExpandProperty 'allowedValues' `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $instance)
            {
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        $complexAllowedValues = @()
        foreach ($allowedValue in $instance.AllowedValues)
        {
            $complexAllowedValues += [ordered]@{
                ValueId  = $allowedValue.Id
                IsActive = $allowedValue.IsActive
            }
        }

        $results = @{
            Name                    = $instance.Name
            AllowedValues           = $complexAllowedValues
            AttributeSet            = $instance.AttributeSet
            Id                      = $instance.Id
            Description             = $instance.Description
            IsCollection            = $instance.IsCollection
            IsSearchable            = $instance.IsSearchable
            Status                  = $instance.Status
            Type                    = $instance.Type
            UsePreDefinedValuesOnly = $instance.UsePreDefinedValuesOnly
            Ensure                  = 'Present'
            Credential              = $Credential
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            ApplicationSecret       = $ApplicationSecret
            CertificateThumbprint   = $CertificateThumbprint
            ManagedIdentity         = $ManagedIdentity.IsPresent
            AccessTokens            = $AccessTokens
        }
        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AttributeSet,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AllowedValues,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsCollection,

        [Parameter()]
        [System.Boolean]
        $IsSearchable,

        [Parameter()]
        [ValidateSet('Available', 'Deprecated')]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [System.Boolean]
        $UsePreDefinedValuesOnly,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of AzureAD Custom Security Attribute Definition for {$Name}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $setParameters.Remove('AllowedValues') | Out-Null

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $setParameters.Remove('Id') | Out-Null
        Write-Verbose -Message "Creating new Atribute Definition {$Name}"
        $attributeDefinition = New-MgBetaDirectoryCustomSecurityAttributeDefinition @SetParameters

        foreach ($allowedValue in $AllowedValues)
        {
            New-MgBetaDirectoryCustomSecurityAttributeDefinitionAllowedValue `
                -CustomSecurityAttributeDefinitionId $attributeDefinition.Id `
                -Id $allowedValue.ValueId `
                -IsActive:$allowedValue.IsActive
        }
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Atribute Definition {$Name}"
        $setParameters.Add('CustomSecurityAttributeDefinitionId', $currentInstance.Id)
        $setParameters.Remove('Id') | Out-Null
        $setParameters.Remove('AttributeSet') | Out-Null
        $setParameters.Remove('IsCollection') | Out-Null
        $setParameters.Remove('IsSearchable') | Out-Null
        $setParameters.Remove('Name') | Out-Null
        $setParameters.Remove('Type') | Out-Null
        if ($setParameters.ContainsKey('UsePreDefinedValuesOnly') -and $setParameters.UsePreDefinedValuesOnly -eq $currentInstance.UsePreDefinedValuesOnly)
        {
            $setParameters.Remove('UsePreDefinedValuesOnly') | Out-Null
        }
        Update-MgBetaDirectoryCustomSecurityAttributeDefinition @SetParameters

        # Allowed values cannot be removed, therefore we only need to add new ones or update existing ones
        foreach ($allowedValue in $AllowedValues)
        {
            $existingAllowedValue = $currentInstance.AllowedValues | Where-Object { $_.Id -eq $allowedValue.ValueId }
            if ($null -eq $existingAllowedValue)
            {
                # Add new allowed value
                New-MgBetaDirectoryCustomSecurityAttributeDefinitionAllowedValue `
                    -CustomSecurityAttributeDefinitionId $currentInstance.Id `
                    -Id $allowedValue.ValueId `
                    -IsActive:$allowedValue.IsActive
            }
            elseif ($existingAllowedValue.IsActive -ne $allowedValue.IsActive)
            {
                # Update existing allowed value
                Update-MgBetaDirectoryCustomSecurityAttributeDefinitionAllowedValue `
                    -CustomSecurityAttributeDefinitionId $currentInstance.Id `
                    -AllowedValueId $allowedValue.ValueId `
                    -IsActive:$allowedValue.IsActive
            }
        }
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Atribute Definition {$Name}. Setting its status to 'Deprecated'"
        Update-MgBetaDirectoryCustomSecurityAttributeDefinition -CustomSecurityAttributeDefinitionId $currentInstance.Id `
            -Status 'Deprecated'
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $AttributeSet,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AllowedValues,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsCollection,

        [Parameter()]
        [System.Boolean]
        $IsSearchable,

        [Parameter()]
        [ValidateSet('Available', 'Deprecated')]
        [System.String]
        $Status,

        [Parameter()]
        [System.String]
        $Type,

        [Parameter()]
        [System.Boolean]
        $UsePreDefinedValuesOnly,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array] $Script:exportedInstances = Get-MgBetaDirectoryCustomSecurityAttributeDefinition `
            -ExpandProperty 'allowedValues' `
            -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                Name                  = $config.Name
                AttributeSet          = $config.AttributeSet
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            if ($null -ne $Results.AllowedValues)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AllowedValues `
                    -CIMInstanceName 'CustomSecurityAttributeAllowedValue'

                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AllowedValues = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AllowedValues') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('AllowedValues')
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        IncludedProperties = @('ValueId', 'IsActive')
        PostProcessing     = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            # Values cannot be removed from AllowedValues
            # Therefore, we add the missing values from CurrentValues to DesiredValues for comparison
            if ($DesiredValues.ContainsKey('AllowedValues'))
            {
                foreach ($currentValue in $CurrentValues.AllowedValues)
                {
                    $matchingValue = $DesiredValues.AllowedValues | Where-Object { $_.ValueId -eq $currentValue.ValueId }
                    if ($null -eq $matchingValue)
                    {
                        # AllowedValues is either an array of CIM instances or an array of hashtables
                        # CIM instances is when using Test-DscConfiguration (compiled configuration) and hashtables when creating a report, using values from ConvertTo-DscObject
                        if ($DesiredValues.AllowedValues -is [CimInstance[]])
                        {
                            $DesiredValues.AllowedValues += New-CimInstance -ClassName MSFT_CustomSecurityAttributeAllowedValue -Property @{
                                IsActive = $currentValue.IsActive
                                ValueId  = $currentValue.ValueId
                            } -Namespace root/Microsoft/Windows/DesiredStateConfiguration -ClientOnly
                        }
                        else
                        {
                            $DesiredValues.AllowedValues = @($DesiredValues.AllowedValues)
                            $DesiredValues.AllowedValues += @{
                                CIMInstance = 'MSFT_CustomSecurityAttributeAllowedValue'
                                IsActive    = $currentValue.IsActive
                                ValueId     = $currentValue.ValueId
                            }
                        }
                    }
                }

                if ($DesiredValues.AllowedValues -is [CimInstance[]])
                {
                    $DesiredValues.AllowedValues = [CimInstance[]]$DesiredValues.AllowedValues
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
