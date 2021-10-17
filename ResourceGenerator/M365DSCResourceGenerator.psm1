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
        $Entity # = "DeviceCompliancePolicy"
    )

    $apiVersion = "v1.0" # or beta
    if ($ApiVersion -eq "v1.0")
    {
        $ApiVersion = "cleanv1"
    }
    else
    {
        $ApiVersion = "cleanbeta"
    }
    $rawJson = Invoke-RestMethod -Method Get -Uri "https://metadataexplorerstorage.blob.core.windows.net/`$web/$($ApiVersion).js#search:$($Entity)"
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
        $cmdletParameter = $DefaultParameterSetProperties | Where-Object -FilterScript { $_.Key -eq $property.Name }
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

        $parameterType = ""
        switch ($_.Type)
        {
            "Edm.String"
            {
                $parameterType = "String"
            }
            "Edm.Boolean"
            {
                $parameterType = "Boolean"
            }
            "Edm.Int32"
            {
                $parameterType = "Int32"
            }
            "Edm.Int64"
            {
                $parameterType = "Int64"
            }
            Default
            {
                $parameterType = "String"
            }
        }

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
        $ResourceName = "TeamsChannel", # "DeviceManagementPolicy",

        # Graph Module which shall be used
        [Parameter()]
        [System.String]
        $GraphModule = "Microsoft.Graph.Teams", # "Microsoft.Graph.DeviceManagement",

        # Version of the Graph Module to load
        [Parameter()]
        [System.String]
        $GraphModuleVersion = "1.7.0",

        # CmdLet Noun
        [Parameter()]
        [System.String]
        $GraphModuleCmdLetNoun = "MgTeamChannel", # "MgDeviceManagementDeviceCompliancePolicy",

        # Graph API Version to use.
        [Parameter()]
        [ValidateSet("v1.0", "beta")]
        [System.String]
        $ApiVersion = "v1.0",

        # Path to the new Resource
        [Parameter()]
        [System.String]
        $Path = "c:\temp\newresource"
    )

    Import-Module $GraphModule -RequiredVersion $GraphModuleVersion -ErrorAction Stop

    $commandDetails = Find-MgGraphCommand -Command "Get-$($GraphModuleCmdLetNoun)" -ApiVersion $ApiVersion

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



    $typeInformation = Get-DerivedType -Entity $actualType
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

    $null = New-M365DSCResourceFolder -ResourceName "$($ResourceName)$($selectedODataType.Name)" -Path $Path
    $moduleFilePath = New-M365DSCModuleFile -ResourceName "$($ResourceName)$($selectedODataType.Name)" -Path $Path

    $parameterInformation = Get-ParameterBlockInformation -Properties $typeProperties -DefaultParameterSetProperties $defaultParameterSetProperties
    $parameterString = Get-ParameterBlockStringForModule -ParameterBlockInformation $parameterInformation
    $hashTableMapping = New-M365HashTableMapping -Properties $typeProperties -UseAddtionalProperties $isAdditionalProperty

    Write-TokenReplacement -Token "<ParameterBlock>" -Value $parameterString -FilePath $moduleFilePath

    Write-TokenReplacement -Token "<GetCmdLetName>" -Value "Get-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<NewCmdLetName>" -Value "New-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<SetCmdLetName>" -Value "Set-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<UpdateCmdLetName>" -Value "Update-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<RemoveCmdLetName>" -Value "Remove-$($GraphModuleCmdLetNoun)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<ODataType>" -Value $selectedODataType.Name -FilePath $moduleFilePath

    Write-TokenReplacement -Token "<FilterScript>" -Value "`$_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.$($selectedODataType.Name)' -and ` `$_.displayName -eq `$(`$DisplayName)" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "<HashTableMapping>" -Value $hashTableMapping  -FilePath $moduleFilePath

    # Remove comments
    Write-TokenReplacement -Token "<#ResourceGenerator" -Value "" -FilePath $moduleFilePath
    Write-TokenReplacement -Token "ResourceGenerator#>" -Value "" -FilePath $moduleFilePath


    $schemaFilePath = New-M365DSCSchemaFile -ResourceName "$($ResourceName)$($selectedODataType.Name)" -Path $Path

    $schemaProperties = New-M365SchemaPropertySet -Properties $parameterInformation

    Write-TokenReplacement -Token "<FriendlyName>" -Value "$($ResourceName)$($selectedODataType.Name)" -FilePath $schemaFilePath
    Write-TokenReplacement -Token "<ResourceName>" -Value "$($ResourceName)$($selectedODataType.Name)" -FilePath $schemaFilePath
    Write-TokenReplacement -Token "<Properties>" -Value $schemaProperties -FilePath $schemaFilePath


}

function New-M365SchemaPropertySet
{
    param (
        [Parameter()]
        [Object[]]
        $Properties
    )
    $schemaProperties = ""
    $Properties | ForEach-Object -Process {
        $schemaProperties += "[Write, Description(`"`")] $($_.Type) $($_.Name);`r`n"
    }
    return $schemaProperties
}

function Write-TokenReplacement
{
    param (
        [Parameter()]
        [ValidateSet( "<ParameterBlock>", "<ODataType>", "<GetCmdLetName>", "<SetCmdLetName>", "<NewCmdLetName>", "<RemoveCmdLetName>", "<HashTableMapping>", "<UpdateCmdLetName>", "<FilterScript>", "<FriendlyName>", "<ResourceName>", "<Properties>")]
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
    Copy-Item -Path .\ModuleTemplate.psm1 -Destination $filePath

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
    Copy-Item -Path .\SchemaTemplate.schema.mof -Destination $filePath

    return $filePath
}

function New-M365HashTableMapping
{
    param (
        [Parameter()]
        [Object[]]
        $Properties,
        # Parameter help description
        [Parameter()]
        [System.Boolean]
        $UseAddtionalProperties
    )

    $hashtable = ""
    $Properties | ForEach-Object -Process {
        $parameterName = $_.Name
        $parameterNameFirstLetter = $_.Name.Substring(0, 1)
        $parameterNameFirstLetter = $parameterNameFirstLetter.ToUpper()
        $parameterNameCamelCaseString = $parameterName.Substring(1)
        $parameterName = "$($parameterNameFirstLetter)$($parameterNameCamelCaseString)"

        if ($UseAddtionalProperties)
        {
            $hashtable += "$($parameterName) = `$getValue.AdditionalProperties.$($_.Name) `r`n"
        }
        else
        {
            $hashtable += "$($parameterName) = `$getValue.$($_.Name) `r`n"
        }
    }
    return $hashtable
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
        $parameterBlockOutput += "          $($_.Attribute)`r`n"
        $parameterBlockOutput += "          [System.$($_.Type)]`r`n"
        $parameterBlockOutput += "          `$$($_.Name),`r`n"
        $parameterBlockOutput += "`r`n"
    }
    return $parameterBlockOutput
}

New-M365DSCResource -ResourceName "TeamsChannel" -GraphModule "Microsoft.Graph.Teams" -GraphModuleVersion "1.7.0" -GraphModuleCmdLetNoun "MgTeamChannel"

New-M365DSCResource -ResourceName "DeviceManagementPolicy" -GraphModule "Microsoft.Graph.DeviceManagement" -GraphModuleVersion "1.7.0" -GraphModuleCmdLetNoun "MgDeviceManagementDeviceCompliancePolicy"

New-M365DSCResource -ResourceName "PlannerPlan" -GraphModule "Microsoft.Graph.Planner" -GraphModuleVersion "1.7.0" -GraphModuleCmdLetNoun "MgPlannerPlan"

Export-ModuleMember -Function Get-MgGraphModuleCmdLetDifference, New-M365DSCResourceForGraphCmdLet, New-M365DSCResource
