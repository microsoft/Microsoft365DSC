function Get-MgGraphModuleCmdLetDifference
{
    $modules = Get-Module -Name Microsoft.Graph.* -ListAvailable | Sort-Object -Property Name, Version | Out-GridView -PassThru

    if ($modules.Count -eq 0)
    {
        Write-Host "[ERROR] No module selected!" -ForegroundColor Red
        return
    }

    if (($modules.Name | Sort-Object | Select-Object -Unique).Count -ne 1 -or $modules.Count -ne 2)
    {
        Write-Host "[ERROR] Please select two versions of the same module" -ForegroundColor Red
        return
    }

    [array]$exportedKeysModule1 = $modules[0].ExportedCommands.Keys
    [array]$exportedKeysModule2 = $modules[1].ExportedCommands.Keys

    $diffs = Compare-Object -ReferenceObject $exportedKeysModule1 -DifferenceObject $exportedKeysModule2
    foreach ($diff in $diffs)
    {
        switch ($diff.SideIndicator)
        {
            "=>"
            {
                Write-Host "Cmdlet '$($diff.InputObject)' is new in $($modules[1].Name) v$($modules[1].Version)" -ForegroundColor Green
            }
            "<="
            {
                Write-Host "Cmdlet '$($diff.InputObject)' has been removed from $($modules[1].Name) v$($modules[1].Version)" -ForegroundColor Yellow
            }
        }
    }
}

function New-M365DSCResourceForGraphCmdLet
{
    param (
        # Name of one graph module, e.g. "Microsoft.Graph.Intune"
        [Parameter()]
        [System.String]
        $MgGraphModule,

        # Generate resources for all cmdLets within Microsoft.Graph.* modules
        [Parameter()]
        [Switch]
        $All = $false
    )

    if ($null -ne $MgGraphModuleName)
    {
        $modules = Get-InstalledModule -Name $MgGraphModule
    }
    if ($All)
    {
        $modules = Get-InstalledModule -Name Microsoft.Graph.*
    }

    foreach ($module in $modules)
    {
        Write-Verbose -Message "$($module.Name)"
        $commands = (Get-Command -Module $module.Name -Verb Get | Where-Object -FilterScript { $_.CommandType -eq "Function" }).Noun

        $commands = Get-Command -Module $module.Name
        $nouns = $commands.Noun | Sort-Object | Select-Object -Unique

        foreach ($noun in $nouns)
        {
            Write-Verbose -Message "- $($noun)"

            $nounCommands = $commands | Where-Object { $_.Noun -eq $noun }
            if ($nounCommands.Verb -notcontains "Get" -or `
                    $nounCommands.Verb -notcontains "Update" -or `
                    $nounCommands.Verb -notcontains "New")
            {
                Write-Verbose "  [SKIPPING] Noun does not have Get, New and/or Update method" -ForegroundColor Magenta
                continue
            }

            $shortNoun = $noun.Substring(2, $noun.Length - 2)
            New-M365DSCResource -ResourceName $shortNoun -GraphModule $module.Name -GraphModuleVersion $module.Version -GraphModuleCmdLetNoun $noun
        }
    }
}

function Get-DerivedType
{

    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Entity,

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [string]
        $APIVersion
    )

    if ($ApiVersion -eq "v1.0")
    {
        $Version = "cleanv1"
    }
    else
    {
        $Version = "cleanbeta"
    }
    $rawJson = Invoke-RestMethod -Method Get -Uri "https://metadataexplorerstorage.blob.core.windows.net/`$web/$($Version).js#search:$($Entity)"
    # Clean JSON
    $cleanJsonString = $rawJson.TrimStart("const json = ")
    $cleanJsonString = $CleanJsonString -replace ",}", "}"
    $targetIndex = $cleanJsonString.IndexOf(";")
    $cleanJsonString = $cleanJsonString.Remove($targetIndex)
    $entityRelationships = $cleanJsonString | ConvertFrom-Json

    $returnValue = $entityRelationships | Where-Object -FilterScript { $_.BaseType -eq $Entity }
    # Multiple Result

    if ($null -eq $returnValue)
    {
        $returnValue = $entityRelationships | Where-Object -FilterScript { $_.Name -eq $Entity }
        # One Result
    }
    return $returnValue
}

function Get-ParameterBlockInformation
{
    param (
        [Parameter()]
        [Object[]]
        $Properties,

        # Parameter help description
        [Parameter()]
        [System.Object]
        $DefaultParameterSetProperties
    )

    $parameterBlock = New-Object System.Collections.ArrayList

    $Properties | ForEach-Object -Process {
        $property = $_
        $isMandatory = $false
        # Replace this one with the proper mandatory key value
        $cmdletParameter = $DefaultParameterSetProperties | Where-Object -FilterScript { $_.Name -eq $property.Name }
        if ($null -ne $cmdletParameter `
                -and $cmdletParameter.IsMandatory -eq $true)
        {
            $isMandatory = $true
            $parameterAttribute = "[Parameter(Mandatory = `$true)]"
        }
        else
        {
            $parameterAttribute = "[Parameter()]"
        }

        $parameterType = Get-M365DSCDRGParameterType -Type $cmdletParameter.ParameterType.ToString()

        $parameterName = $_.Name
        $parameterNameFirstLetter = $_.Name.Substring(0, 1)
        $parameterNameFirstLetter = $parameterNameFirstLetter.ToUpper()
        $parameterNameCamelCaseString = $parameterName.Substring(1)
        $parameterName = "$($parameterNameFirstLetter)$($parameterNameCamelCaseString)"

        $parameterBlock.Add(@{
                IsMandatory = $isMandatory
                Attribute   = $parameterAttribute
                Type        = $parameterType
                Name        = $parameterName
            }) | Out-Null


    }
    return $parameterBlock
}

function Get-M365DSCDRGParameterType
{
    param(
        [parameter(Mandatory = $true)]
        [System.String]
        $Type
    )
    $parameterType = ""
    switch ($Type.ToLower())
    {
        "system.String"
        {
            $parameterType = "System.String"
        }
        "system.datetime"
        {
            $parameterType = "System.String"
        }
        "system.boolean"
        {
            $parameterType = "System.Boolean"
        }
        "system.int32"
        {
            $parameterType = "System.Int32"
        }
        "system.int64"
        {
            $parameterType = "System.Int64"
        }
        "system.string[]"
        {
            $parameterType = "System.String[]"
        }
        Default
        {
            $parameterType = $_
        }
    }
    return $parameterType
}

function Get-M365DSCDRGParameterTypeForSchema
{
    param(
        [parameter(Mandatory = $true)]
        [System.String]
        $Type
    )
    $parameterType = ""
    switch ($Type.ToLower())
    {
        "system.String"
        {
            $parameterType = "String"
        }
        "system.datetime"
        {
            $parameterType = "String"
        }
        "system.boolean"
        {
            $parameterType = "Boolean"
        }
        "system.int32"
        {
            $parameterType = "UInt32"
        }
        "system.int64"
        {
            $parameterType = "UInt64"
        }
        Default
        {
            $parameterType = "String"
        }
    }
    return $parameterType
}

function New-M365CmdLetHelper
{
    param(# Parameter help description
        [Parameter()]
        [System.String]
        $CmdLetVerb,
        [Parameter()]
        [System.String]
        $CmdLetNoun,
        [Parameter()]
        [System.String]
        $Properties
    )

    $returnValue = "$($CmdLetVerb)-$($CmdLetNoun) "

    foreach ($property in $Properties)
    {
        if ($property.IsMandatory -eq $true)
        {
            $returnValue += "-$($property.Name) `$$($property.Name)0"
        }
    }
}

function New-M365DSCResource
{
    param (
        # Name for the new Resource
        [Parameter()]
        [System.String]
        $ResourceName,

        # Name of the Workload the resource is for.
        [Parameter(Mandatory = $true)]
        [ValidateSet("ExchangeOnline", "Intune", `
                "SecurityComplianceCenter", "PnP", "PowerPlatforms", `
                "MicrosoftTeams", "MicrosoftGraph")]
        [System.String]
        $Workload,

        # CmdLet Noun
        [Parameter()]
        [System.String]
        $GraphModuleCmdLetNoun,

        # Path to the new Resource
        [Parameter()]
        [System.String]
        $Path = "c:\temp\newresource"
    )
    $APIVersion = 'v1.0'
    $GetcmdletName = "Get-$GraphModuleCmdletNoun"
    $commandDetails = Find-MgGraphCommand -Command $GetcmdletName -ApiVersion $ApiVersion -ErrorAction SilentlyContinue
    $cmdletFound = Get-Command $GetcmdletName -ErrorAction SilentlyContinue
    if (-not $commandDetails)
    {
        $APIVersion = 'beta'
        $commandDetails = Find-MgGraphCommand -Command $GetcmdletName -ApiVersion $ApiVersion -ErrorAction SilentlyContinue

        if (-not $commandDetails)
        {
            throw "Cmdlet {$GetcmdletName} was not found"
        }
    }
    Select-MgProfile $APIVersion
    $cmdletFound = Get-Command $GetcmdletName -ErrorAction SilentlyContinue
    $GraphModule = $cmdletFound.ModuleName
    Import-Module $GraphModule -ErrorAction Stop
    $commandDetails = Find-MgGraphCommand -Command $GetcmdletName -ApiVersion $ApiVersion

    $cmdletCommandDetails = Get-Command -Name "New-$($GraphModuleCmdLetNoun)" -Module $GraphModule
    $defaultParameterSet = $cmdletCommandDetails.ParameterSets | Where-Object -FilterScript { $_.IsDefault -eq $true }

    $defaultParameterSetProperties = $defaultParameterSet.Parameters

    # if ([System.String]::IsNullOrEmpty($commandDetails.OutputType) -eq $false) {
    #     Write-Error "There was an error obtaining command information"
    # }

    $outputTypes = $commandDetails | Select-Object OutputType | Get-Unique

    if ($outputTypes.GetType().BaseType.Name -eq "Array")
    {
        $outputTypeInformationChoices = @()
        for ($i = 0; $i -lt $typeInformation.Count; $i++)
        {
            $outputTypeInformationChoices += [System.Management.Automation.Host.ChoiceDescription]("$($commandDetails[$i].Name) &$($i+1)")
        }
        $outputTypeChoice = $host.UI.PromptForChoice("Output Type Selection", "Please select an output type", $outputTypeInformationChoices, 0) + 1
        $outputType = $outputTypes[$outputTypeChoice - 1].OutputType
    }
    else
    {
        $outputType = $outputTypes.OutputType
    }

    if ($outputType.EndsWith(1))
    {
        $outputType = $outputType -replace ".$"
    }

    $actualType = $outputType.Replace("IMicrosoftGraph", "")

    $typeInformation = Get-DerivedType -Entity $actualType `
        -APIVersion $ApiVersion
    if ($typeInformation.GetType().BaseType.Name -eq "Array")
    {
        $typeInformationChoices = @()
        for ($i = 0; $i -lt $typeInformation.Count; $i++)
        {
            $typeInformationChoices += [System.Management.Automation.Host.ChoiceDescription]("$($typeInformation[$i].Name) &$($i+1)")
        }
        $typeChoice = $host.UI.PromptForChoice("Additional Type Information", "Please select an addtional type", $typeInformationChoices, 0) + 1

        $selectedODataType = $typeInformation[$typeChoice - 1]
        $isAdditionalProperty = $true
    }
    else
    {
        $selectedODataType = $typeInformation
        $isAdditionalProperty = $false
    }

    $typeProperties = $selectedODataType.Properties

    $null = New-M365DSCResourceFolder -ResourceName $ResourceName -Path $Path
    $moduleFilePath = New-M365DSCModuleFile -ResourceName $ResourceName -Path $Path

    $parameterInformation = Get-ParameterBlockInformation -Properties $typeProperties -DefaultParameterSetProperties $defaultParameterSetProperties

    $CimInstances = Get-M365DSCDRGCimInstances -ResourceName $ResourceName `
        -Properties $parameterInformation `
        -Workload $Workload
    $CimInstancesSchemaContent = Get-M365DSCDRGCimInstancesSchemaStringContent -CIMInstances $CimInstances `
                                     -Workload $Workload

    $parameterString = Get-ParameterBlockStringForModule -ParameterBlockInformation $parameterInformation
    $hashtableResults = New-M365HashTableMapping -Properties $typeProperties `
                            -UseAddtionalProperties $isAdditionalProperty `
                            -GraphNoun $GraphModuleCmdLetNoun `
                            -Workload $Workload
    $hashTableMapping = $hashtableResults.StringContent

    Write-TokenReplacement -Token "<ParameterBlock>" -Value $parameterString -FilePath $moduleFilePath

    Write-TokenReplacement -Token "<GetCmdLetName>" -Value "Get-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<NewCmdLetName>" -Value "New-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<SetCmdLetName>" -Value "Set-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<UpdateCmdLetName>" -Value "Update-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<RemoveCmdLetName>" -Value "Remove-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<ODataType>" -Value $selectedODataType.Name -FilePath $moduleFilePath

    Write-TokenReplacement -Token "<FilterScript>" -Value "`$_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.$($selectedODataType.Name)' -and ` `$_.displayName -eq `$(`$DisplayName)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<HashTableMapping>" -Value $hashTableMapping -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<#ComplexTypeContent#>" -Value $hashtableResults.ComplexTypeContent -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<#ConvertComplexToString#>" -Value $hashtableResults.ConvertToString -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<#ConvertComplexToVariable#>" -Value $hashtableResults.ConvertToVariable -FilePath $moduleFilePath

    $updateCmdlet = Get-Command -Name "Update-$($GraphModuleCmdLetNoun)" -Module $GraphModule
    $updateDefaultParameterSet = $updateCmdlet.ParameterSets | Where-Object -FilterScript{$_.IsDefault}
    $updateKeyIdentifier = $updateDefaultParameterSet.Parameters | Where-Object -FilterScript {$_.IsMandatory}
    Write-TokenReplacement -Token "<#UpdateKeyIdentifier#>" -Value $UpdateKeyIdentifier.Name -FilePath $moduleFilePath

    # Remove comments
    Write-TokenReplacement -Token "<#ResourceGenerator" -Value "" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "ResourceGenerator#>" -Value "" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<#APIVersion#>" -Value $ApiVersion -FilePath $moduleFilePath

    $schemaFilePath = New-M365DSCSchemaFile -ResourceName $ResourceName -Path $Path
    $schemaProperties = New-M365SchemaPropertySet -Properties $parameterInformation `
                            -Workload $Workload

    Write-TokenReplacement -Token "<CIMInstances>" -Value $CimInstancesSchemaContent -FilePath $schemaFilePath
    Write-TokenReplacement -Token "<FriendlyName>" -Value $ResourceName -FilePath $schemaFilePath
    Write-TokenReplacement -Token "<ResourceName>" -Value $ResourceName -FilePath $schemaFilePath
    Write-TokenReplacement -Token "<Properties>" -Value $schemaProperties -FilePath $schemaFilePath
}

function Get-M365DSCDRGCimInstancesSchemaStringContent
{
    param (
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $CIMInstances,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Workload
    )

    $stringResult = ''
    foreach ($cimInstance in $CIMInstances)
    {
        $stringResult += "[ClassVersion(`"1.0.0`")]`r`n"
        $stringResult += 'class MSFT_' + $cimInstance.Name + "`r`n"
        $stringResult += "{`r`n"

        $nestedResults = ''
        foreach ($property in $cimInstance.Properties)
        {
            if ($property.Type.StartsWith("microsoft.graph.powershell.models."))
            {
                $nestedResults = Get-M365DSCDRGCimInstancesSchemaStringContent -CIMInstances $property.NestedCIM `
                                     -Workload $Workload
                $propertyType = $property.Type -replace "microsoft.graph.powershell.models.", ""
                $propertyType = $propertyType -replace "imicrosoftgraph", ""
                $propertyType = $propertyType -replace '[[\]]',''
                $propertyType = $workload + $propertyType
                $stringResult += "    [Write, Description(`"`"), EmbeddedInstance(`"MSFT_$propertyType`")] String $($property.Name)"
                if ($property.IsArray)
                {
                    $stringResult += "[]"
                }
                $stringResult += ";`r`n"
            }
            else
            {
                $propertyType = Get-M365DSCDRGParameterTypeForSchema -Type $property.Type
                $stringResult += "    [Write, Description(`"`")] $($propertyType) $($property.Name)"
                if ($property.IsArray)
                {
                    $stringResult += "[]"
                }
                $stringResult += ";`r`n"
            }
        }
        $stringResult += "};`r`n"
        $stringResult += $nestedResults
    }

    return $stringResult
}

function Get-M365DSCDRGCimInstances
{
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Workload,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter()]
        [Object[]]
        $Properties
    )

    $cimInstances = $Properties | Where-Object -FilterScript {$_.Type -like "Microsoft.Graph.PowerShell.Models.*"}

    $results = @()
    foreach ($cimInstance in $cimInstances)
    {
        $IsArray = $false
        $currentInstance = @{}
        $originalType = $cimInstance.Type
        $cimInstanceName = $cimInstance.Type -replace "Microsoft.Graph.PowerShell.Models.", ""
        $cimInstanceName = $cimInstanceName -replace "IMicrosoftGraph", ""
        if ($cimInstanceName.EndsWith("[]"))
        {
            $IsArray = $true
            $cimInstanceName = $cimInstanceName -replace '[[\]]',''
            $originalType = $cimInstance.Type.ToString() -replace '[[\]]',''
        }
        $currentInstance.Add("IsArray",$IsArray)

        $cimInstanceName = $Workload + $cimInstanceName
        $currentInstance.Add("Name", $cimInstanceName)

        $objectInstance = Invoke-Expression "[$originalType]"
        $declaredProperties = $objectInstance.DeclaredProperties

        $propertiesValues = @()
        foreach ($declaredProperty in $declaredProperties)
        {
            $propertyIsArray = $false
            $currentProperty = @{}
            $currentProperty.Add("Name", $declaredProperty.Name)

            if ($declaredProperty.PropertyType.ToString().EndsWith("[]"))
            {
                $propertyIsArray = $true
            }
            $currentProperty.Add("IsArray", $propertyIsArray)
            $propertyType = $declaredProperty.PropertyType -replace 'System.Nullable`1',''
            $propertyType = $propertyType -replace [regex]::escape('['), ''
            $propertyType = $propertyType -replace [regex]::escape(']'), ''
            $propertyType = Get-M365DSCDRGParameterType -Type $propertyType

            if ($propertyType.StartsWith("microsoft.graph.powershell.models."))
            {
                $subProperties = @{Type = $propertyType}
                $subResult = Get-M365DSCDRGCimInstances -Workload $Workload `
                                 -ResourceName $ResourceName `
                                 -Properties $subProperties
                $currentProperty.Add("NestedCIM", $subResult)
            }
            $currentProperty.Add("Type", $propertyType)
            $propertiesValues += $currentProperty
        }
        $currentInstance.Add("Properties", $propertiesValues)
        $results += $currentInstance
    }
    return $results
}

function New-M365SchemaPropertySet
{
    param (
        [Parameter()]
        [Object[]]
        $Properties,

        [Parameter()]
        [System.String]
        $Workload
    )
    $schemaProperties = ""
    $Properties | ForEach-Object -Process {
        if ($_.Type.ToString().StartsWith("microsoft.graph.powershell.models."))
        {
            $propertyType = $_.Type -replace "microsoft.graph.powershell.models.", ""
            $propertyType = $propertyType -replace "imicrosoftgraph", ""
            $propertyType = $Workload + $propertyType
            $propertyType = $propertyType -replace '[[\]]',''
            $schemaProperties += "    [Write, Description(`"`"), EmbeddedInstance(`"MSFT_$propertyType`")] String $($_.Name)"
            if ($_.Type.EndsWith("[]"))
            {
                $schemaProperties += "[]"
            }
            $schemaProperties += ";`r`n"
        }
        else
        {
            $propertyType = Get-M365DSCDRGParameterTypeForSchema -Type $_.Type
            $schemaProperties += "    [Write, Description(`"`")] $($propertyType) $($_.Name)"
            if ($_.Type.EndsWith("[]"))
            {
                $schemaProperties += "[]"
            }
            $schemaProperties += ";`r`n"
        }
    }
    return $schemaProperties
}

function Write-TokenReplacement
{
    param (
        [Parameter()]
        [System.String]
        $Token,

        # Parameter help description
        [Parameter()]
        [System.String]
        $Value,

        # Parameter help description
        [Parameter()]
        [System.String]
        $FilePath
    )

    $content = Get-Content -Path $FilePath
    $content = $content.Replace($Token, $Value)
    Set-Content -Path $FilePath -Value $content
}

function New-M365DSCResourceFolder
{
    param (
        [Parameter()]
        [System.String]
        $ResourceName,

        # Parameter help description
        [Parameter()]
        [System.String]
        $Path,

        # Parameter help description
        [Parameter()]
        [Object[]]
        $Properties
    )

    $directoryPath = "$Path\MSFT_$ResourceName"
    if (-not(Test-Path $directoryPath))
    {
        New-Item -Path $directoryPath -ItemType Directory
    }
}

function New-M365DSCModuleFile
{
    param (
        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.String]
        $Path
    )
    $filePath = "$Path\MSFT_$ResourceName\MSFT_$($ResourceName).psm1"
    Copy-Item -Path .\Module.Template.psm1 -Destination $filePath

    return $filePath
}

function New-M365DSCSchemaFile
{

    param (
        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.String]
        $Path
    )
    $filePath = "$Path\MSFT_$ResourceName\MSFT_$($ResourceName).schema.mof"
    Copy-Item -Path .\Schema.Template.mof -Destination $filePath

    return $filePath
}

function New-M365HashTableMapping
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter()]
        [Object[]]
        $Properties,

        [Parameter()]
        [System.String]
        $GraphNoun,

        [Parameter()]
        [System.String]
        $Workload,

        # Parameter help description
        [Parameter()]
        [System.Boolean]
        $UseAddtionalProperties
    )

    $newCmdlet = Get-Command "New-$GraphNoun"

    $results = @{}
    $hashtable = ""
    $complexTypeContent = ""
    $convertToString = ""
    $convertToVariable = ""
    foreach ($property in $properties)
    {
        $paramType = $newCmdlet.Parameters.$($property.Name).ParameterType.ToString()
        $parameterName = $property.Name
        $parameterNameFirstLetter = $property.Name.Substring(0, 1)
        $parameterNameFirstLetter = $parameterNameFirstLetter.ToUpper()
        $parameterNameCamelCaseString = $parameterName.Substring(1)
        $parameterName = "$($parameterNameFirstLetter)$($parameterNameCamelCaseString)"

        if ($paramType.StartsWith("Microsoft.Graph.PowerShell.Models."))
        {
            $CimInstanceName = $paramType -replace "Microsoft.Graph.PowerShell.Models.IMicrosoftGraph", ""
            $CimInstanceName = $CimInstanceName  -replace '[[\]]',''
            $CimInstanceName = $Workload + $CimInstanceName

            $complexTypeContent += "            if (`$getValue.$($property.Name))`r`n"
            $complexTypeContent += "            {`r`n"
            $complexTypeContent += "                `$results.Add(`"$parameterName`", (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject `$getValue.$($property.Name)))`r`n"
            $complexTypeContent += "            }`r`n"

            $convertToString += "        if (`$Results.$parameterName)`r`n"
            $convertToString += "        {`r`n"
            $convertToString += "            `$Results.$parameterName = Get-M365DSCDRGComplexTypeToString -ComplexObject `$Results.$parameterName -CIMInstanceName $CimInstanceName`r`n"
            $convertToString += "        }`r`n"

            $convertToVariable += "        if (`$Results.$parameterName)`r`n"
            $convertToVariable += "        {`r`n"
            $convertToVariable += "            `$currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock `$currentDSCBlock -ParameterName `"$parameterName`"`r`n"
            $convertToVariable += "        }`r`n"
        }
        else
        {
            if ($UseAddtionalProperties)
            {
                $hashtable += "$($parameterName) = `$getValue.AdditionalProperties.$($_propertyName) `r`n"
            }
            else
            {
                $hashtable += "$($parameterName) = `$getValue.$($property.Name) `r`n"
            }
        }
    }

    $results.Add("ConvertToVariable", $convertToVariable)
    $results.Add("ConvertToString", $convertToString)
    $results.Add("StringContent", $hashtable)
    $results.Add("ComplexTypeContent", $complexTypeContent)
    return $results
}

function Get-ParameterBlockStringForModule
{

    param (
        [Parameter()]
        [Object[]]
        $ParameterBlockInformation
    )

    $parameterBlockOutput = ""
    $ParameterBlockInformation | ForEach-Object -Process {
        $parameterBlockOutput += "        $($_.Attribute)`r`n"

        $propertyType = $_.Type.ToString()
        if ($propertyType.StartsWith("microsoft.graph.powershell.models."))
        {
            $parameterBlockOutput += "        [Microsoft.Management.Infrastructure.CimInstance"
        }
        else
        {
            $parameterBlockOutput += "        [$($_.Type)"
        }
        if ($_.Type.ToString().EndsWith("[]"))
        {
            $parameterBlockOutput += "[]"
        }
        $parameterBlockOutput += "]`r`n"
        $parameterBlockOutput += "        `$$($_.Name),`r`n"
        $parameterBlockOutput += "`r`n"
    }
    return $parameterBlockOutput
}

Export-ModuleMember -Function Get-MgGraphModuleCmdLetDifference, New-M365DSCResourceForGraphCmdLet, New-M365DSCResource
