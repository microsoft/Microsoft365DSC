
function New-M365DSCResource
{
    param (
        # Name for the new Resource
        [Parameter()]
        [System.String]
        $ResourceName,

        # Name of the Workload the resource is for.
        [Parameter(Mandatory = $true)]
        [ValidateSet('ExchangeOnline', 'Intune', `
                'SecurityComplianceCenter', 'PnP', 'PowerPlatforms', `
                'MicrosoftTeams', 'MicrosoftGraph')]
        [System.String]
        $Workload,

        # CmdLet Noun
        [Parameter()]
        [System.String]
        $CmdLetNoun,

        # CmdLet Verb
        [Parameter()]
        [System.String]
        $CmdLetVerb = 'New',

        # Path to the new Resource
        [Parameter()]
        [System.String]
        $Path = 'c:\temp\newresource',

        # Path to the new Resource
        [Parameter()]
        [System.String]
        $UnitTestPath = 'c:\temp\newresource',

        # Path to the new Resource
        [Parameter()]
        [System.String]
        $ExampleFilePath = 'c:\temp\newresource',

        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [System.String]
        $APIVersion = 'v1.0',

        [Parameter()]
        [System.String[]]
        $ParametersToSkip = @(),

        [Parameter()]
        [System.String]
        $AdditionalPropertiesType,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    $null = New-M365DSCResourceFolder -ResourceName $ResourceName -Path $Path
    $schemaFilePath = New-M365DSCSchemaFile -ResourceName $ResourceName -Path $Path -Workload $Workload
    $moduleFilePath = New-M365DSCModuleFile -ResourceName $ResourceName -Path $Path -Workload $Workload
    $settingsFilePath = New-M365DSCSettingsFile -ResourceName $ResourceName -Path $Path
    $readmeFilePath = New-M365DSCReadmeFile -ResourceName $ResourceName -Path $Path
    $unitTestPath = New-M365DSCUnitTest -ResourceName $ResourceName -Path $UnitTestPath

    if ($Workload -eq 'MicrosoftGraph')
    {
        $Global:CIMInstancesAlreadyFound = @()
        $GetcmdletName = "Get-$CmdLetNoun"
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

        $cmdletCommandDetails = Get-Command -Name "$($CmdLetVerb)-$($CmdLetNoun)" -Module $GraphModule
        $defaultParameterSet = $cmdletCommandDetails.ParameterSets | Where-Object -FilterScript { $_.IsDefault -eq $true }

        $defaultParameterSetProperties = $defaultParameterSet.Parameters

        # if ([System.String]::IsNullOrEmpty($commandDetails.OutputType) -eq $false) {
        #     Write-Error "There was an error obtaining command information"
        # }

        $outputTypes = $commandDetails | Select-Object OutputType | Get-Unique

        if ($outputTypes.GetType().BaseType.Name -eq 'Array')
        {
            $outputTypeInformationChoices = @()
            for ($i = 0; $i -lt $typeInformation.Count; $i++)
            {
                $outputTypeInformationChoices += [System.Management.Automation.Host.ChoiceDescription]("$($commandDetails[$i].Name)")
            }
            $outputTypeChoice = $host.UI.PromptForChoice('Output Type Selection', 'Please select an output type', $outputTypeInformationChoices, 0) + 1
            $outputType = $outputTypes[$outputTypeChoice - 1].OutputType
        }
        else
        {
            $outputType = $outputTypes.OutputType
        }

        if ($outputType.EndsWith(1))
        {
            $outputType = $outputType -replace '.$'
        }

        $actualType = $outputType.Replace('IMicrosoftGraph', '')

        $context = Get-MgContext
        if ($null -eq $context)
        {
            New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -ProfileName 'v1.0' `
                -InboundParameters @{ `
                    Credential = $Credential `

            } | Out-Null
        }

        Select-MgProfile $APIVersion

        $cmdletDefinition = Get-CmdletDefinition -Entity $actualType `
            -APIVersion $ApiVersion

        $propertiesDefinitions = @()

        $typeInformation = Get-DerivedType -CmdletDefinition $cmdletDefinition -Entity $actualType

        #write-host ($typeInformation|out-string)
        if ($typeInformation.GetType().BaseType.Name -eq 'Array')
        {
            if ([String]::IsNullOrEmpty($AdditionalPropertiesType))
            {
                $typeInformationChoices = @()
                for ($i = 0; $i -lt $typeInformation.Count; $i++)
                {
                    $typeInformationChoices += [System.Management.Automation.Host.ChoiceDescription]("$($typeInformation[$i].Name)")
                }
                $typeChoice = $host.UI.PromptForChoice('Additional Type Information', 'Please select an addtional type', $typeInformationChoices, 0) + 1


                $selectedODataType = $typeInformation[$typeChoice - 1]
            }
            else
            {
                $selectedODataType = $typeInformation | Where-Object -FilterScript { $_.Name -eq $AdditionalPropertiesType }
            }

            #write-host ($selectedODataType | out-string)
            $isAdditionalProperty = $true
        }
        else
        {
            $selectedODataType = $typeInformation
            $isAdditionalProperty = $false
        }

        $addIntuneAssignments = $false
        $AssignmentsParam = ''
        $AssignmentsGet = ''
        $AssignmentsRemove = ''
        $AssignmentsNew = ''
        $AssignmentsUpdate = ''
        $AssignmentsFunctions = ''
        $AssignmentsCIM = ''
        $AssignmentsProperty = ''
        $AssignmentsConvertComplexToString = ''
        $AssignmentsConvertComplexToVariable = ''

        if ($Workload -in ('Intune', 'MicrosoftGraph') -and 'Assignments' -in $selectedODataType.Properties.Name)
        {
            $addIntuneAssignments = $true
            $ParametersToSkip += 'Assignments'
            switch ($actualType)
            {
                'DeviceConfiguration'
                {
                    $repository = 'deviceConfigurations'
                }
            }
        }

        $propertiesDefinitions = Get-PropertiesDefinition -APIVersion $ApiVersion
        $PropertiesDefinitions = $PropertiesDefinitions | Where-Object -FilterScript { $_.id -like "*$($selectedODataType.Name)*" }
        $typeProperties = $selectedODataType.Properties | Where-Object -FilterScript { $_.Name -notin $ParametersToSkip }
        #$typeProperties

        #$defaultParameterSetProperties.name

        $parameterInformation = Get-ParameterBlockInformation -Properties $typeProperties `
            -DefaultParameterSetProperties $defaultParameterSetProperties `
            -PropertiesDefinitions $PropertiesDefinitions
        #write-host ($parameterInformation|out-string)

        $script:DiscoveredComplexTypes = @()
        $CimInstances = Get-M365DSCDRGCimInstances -ResourceName $ResourceName `
            -Properties $parameterInformation `
            -CmdletDefinition $CmdletDefinition `
            -Workload $Workload `
            -PropertiesDefinitions $PropertiesDefinitions

        $script:DiscoveredComplexTypes = $null

        $Global:AlreadyFoundInstances = @()

        $CimInstancesSchemaContent = ''
        if ($CimInstances)
        {
            $CimInstancesSchemaContent = Get-M365DSCDRGCimInstancesSchemaStringContent -CIMInstances $CimInstances `
                -Workload $Workload
        }

        $parameterString = Get-ParameterBlockStringForModule -ParameterBlockInformation $parameterInformation
        $hashtableResults = New-M365HashTableMapping -Properties $parameterInformation `
            -DefaultParameterSetProperties $defaultParameterSetProperties `
            -GraphNoun $CmdLetNoun `
            -Workload $Workload
        $hashTableMapping = $hashtableResults.StringContent

        #region UnitTests
        $fakeValues = Get-M365DSCFakeValues -ParametersInformation $parameterInformation -IntroduceDrift $false -Workload $Workload
        #Write-Host($fakeValues|out-string)
        $fakeValuesString = Get-M365DSCHashAsString -Values $fakeValues
        Write-TokenReplacement -Token '<FakeValues>' -value $fakeValuesString -FilePath $unitTestPath
        $fakeValues2 = $fakeValues
        if ($isAdditionalProperty)
        {
            $fakeValues2 = Get-M365DSCFakeValues -ParametersInformation $parameterInformation `
                -IntroduceDrift $false `
                -isCmdletCall $true `
                -AdditionalPropertiesType $AdditionalPropertiesType `
                -Workload $Workload
        }
        $fakeValuesString2 = Get-M365DSCHashAsString -Values $fakeValues2 -isCmdletCall $true
        Write-TokenReplacement -Token '<FakeValues2>' -value $fakeValuesString2 -FilePath $unitTestPath

        $fakeDriftValues = Get-M365DSCFakeValues -ParametersInformation $parameterInformation `
            -IntroduceDrift $true `
            -isCmdletCall $true `
            -AdditionalPropertiesType $AdditionalPropertiesType `
            -Workload $Workload
        $fakeDriftValuesString = Get-M365DSCHashAsString -Values $fakeDriftValues -isCmdletCall $true
        Write-TokenReplacement -Token '<DriftValues>' -value $fakeDriftValuesString -FilePath $unitTestPath
        Write-TokenReplacement -Token '<ResourceName>' -value $ResourceName -FilePath $unitTestPath

        Write-TokenReplacement -Token '<GetCmdletName>' -value $GetcmdletName -FilePath $unitTestPath
        Write-TokenReplacement -Token '<SetCmdletName>' -value "Set-$($CmdLetNoun)" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<RemoveCmdletName>' -value "Remove-$($CmdLetNoun)" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<NewCmdletName>' -value "New-$($CmdLetNoun)" -FilePath $unitTestPath
        #endregion
        $platforms = @(
            'Windows10'
            'Android'
            'Mac O S'
            'I O S'
        )
        $resourceDescription = ($ResourceName -split '_')[0] -creplace '(?<=\w)([A-Z])', ' $1'
        foreach ($platform in $platforms)
        {
            if ($resourceDescription -like "*$platform")
            {
                $platformName = $platform.replace(' ', '')
                if ($platformName -eq 'IOS')
                {
                    $platformName = 'iOS'
                }
                $resourceDescription = $resourceDescription.replace($platform, "for $($platformName)")
            }
        }

        $resourcePermissions = (get-M365DSCResourcePermission -Workload $Workload -CmdLetNoun $CmdLetNoun).permissions | ConvertTo-Json -Depth 20
        $resourcePermissions = '    ' + $resourcePermissions
        Write-TokenReplacement -Token '<ResourceFriendlyName>' -Value $ResourceName -FilePath $settingsFilePath
        Write-TokenReplacement -Token '<ResourceDescription>' -Value $resourceDescription -FilePath $settingsFilePath
        Write-TokenReplacement -Token '<ResourcePermissions>' -Value $ResourcePermissions -FilePath $settingsFilePath

        Write-TokenReplacement -Token '<ResourceFriendlyName>' -Value $ResourceName -FilePath $readmeFilePath
        Write-TokenReplacement -Token '<ResourceDescription>' -Value $resourceDescription -FilePath $readmeFilePath

        $getCmdlet = Get-Command -Name "Get-$($CmdLetNoun)" -Module $GraphModule
        $getDefaultParameterSet = $getCmdlet.ParameterSets | Where-Object -FilterScript { $_.Name -eq 'Get' }
        $getKeyIdentifier = ($getDefaultParameterSet.Parameters | Where-Object -FilterScript { $_.IsMandatory }).Name
        if ([String]::isNullOrEmpty($getKeyIdentifier))
        {
            $getKeyIdentifier = $typeProperties[0].Name
        }

        Write-TokenReplacement -Token '<ParameterBlock>' -Value $parameterString -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<PrimaryKey>' -Value $typeProperties[0].Name  -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<getKeyIdentifier>' -Value $getKeyIdentifier  -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<GetCmdLetName>' -Value "Get-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<NewCmdLetName>' -Value "New-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<SetCmdLetName>' -Value "Set-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<UpdateCmdLetName>' -Value "Update-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<RemoveCmdLetName>' -Value "Remove-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<ODataType>' -Value $selectedODataType.Name -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<additionalProperties>' -Value $hashtableResults.addtionalProperties -FilePath $moduleFilePath


        Write-TokenReplacement -Token '<FilterScript>' -Value 'DisplayName' -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<FilterScriptShort>' -Value "`$_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.$($selectedODataType.Name)' " -FilePath $moduleFilePath
        $NonIntuneResource = ''
        if (-not $isAdditionalProperty)
        {
            $NonIntuneResource = @"
            if (-not `$getValue)
            {
                [array]`$getValue = Get-$CmdLetNoun `
                    -ErrorAction Stop
            }
"@
        }

        Write-TokenReplacement -Token '<NonIntuneResource>' -Value $NonIntuneResource -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<HashTableMapping>' -Value $hashTableMapping -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#ComplexTypeContent#>' -Value $hashtableResults.ComplexTypeContent -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#ConvertComplexToString#>' -Value $hashtableResults.ConvertToString -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#ConvertComplexToVariable#>' -Value $hashtableResults.ConvertToVariable -FilePath $moduleFilePath

        $updateCmdlet = Get-Command -Name "Update-$($CmdLetNoun)" -Module $GraphModule
        $updateDefaultParameterSet = $updateCmdlet.ParameterSets | Where-Object -FilterScript { $_.IsDefault }
        $updateKeyIdentifier = $updateDefaultParameterSet.Parameters | Where-Object -FilterScript { $_.IsMandatory }
        Write-TokenReplacement -Token '<#UpdateKeyIdentifier#>' -Value $UpdateKeyIdentifier.Name -FilePath $moduleFilePath
        #Intune Assignments

        if ($addIntuneAssignments -and -not [String]::IsNullOrEmpty($repository))
        {
            $AssignmentsParam += "        [Parameter()]`r`n"
            $AssignmentsParam += "        [Microsoft.Management.Infrastructure.CimInstance[]]`r`n"
            $AssignmentsParam += "        `$Assignments,`r`n"

            $AssignmentsGet += "        `$assignmentsValues=Get-$($CmdLetNoun)Assignment -$($UpdateKeyIdentifier.Name) `$getValue.Id`r`n"
            $AssignmentsGet += "        `$assignmentResult = @()`r`n"
            $AssignmentsGet += "        foreach (`$assignmentEntry in `$AssignmentsValues)`r`n"
            $AssignmentsGet += "        {`r`n"
            $AssignmentsGet += "            `$assignmentValue = @{`r`n"
            $AssignmentsGet += "                dataType = `$assignmentEntry.Target.AdditionalProperties.'@odata.type'`r`n"
            $AssignmentsGet += "                deviceAndAppManagementAssignmentFilterType = `$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()`r`n"
            $AssignmentsGet += "                deviceAndAppManagementAssignmentFilterId = `$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId`r`n"
            $AssignmentsGet += "                groupId = `$assignmentEntry.Target.AdditionalProperties.groupId`r`n"
            $AssignmentsGet += "            }`r`n"
            $AssignmentsGet += "            `$assignmentResult += `$assignmentValue`r`n"
            $AssignmentsGet += "        }`r`n"
            $AssignmentsGet += "        `$results.Add('Assignments', `$assignmentResult)`r`n"

            $AssignmentsRemove += "        `$PSBoundParameters.Remove(`"Assignments`") | Out-Null`r`n"

            $AssignmentsNew += "        `$assignmentsHash=@()`r`n"
            $AssignmentsNew += "        foreach(`$assignment in `$Assignments)`r`n"
            $AssignmentsNew += "        {`r`n"
            $AssignmentsNew += "            `$assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject `$Assignment`r`n"
            $AssignmentsNew += "        }`r`n"
            $AssignmentsNew += "`r`n"
            $AssignmentsNew += "        if(`$policy.id)"
            $AssignmentsNew += "        {`r`n"
            $AssignmentsNew += "            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  `$policy.id ```r`n"
            $AssignmentsNew += "                -Targets `$assignmentsHash ```r`n"
            $AssignmentsNew += "                -Repository $repository`r`n"
            $AssignmentsNew += "        }`r`n"

            $AssignmentsUpdate += "        `$assignmentsHash=@()`r`n"
            $AssignmentsUpdate += "        foreach(`$assignment in `$Assignments)`r`n"
            $AssignmentsUpdate += "        {`r`n"
            $AssignmentsUpdate += "            `$assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject `$Assignment`r`n"
            $AssignmentsUpdate += "        }`r`n"
            $AssignmentsUpdate += "        Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId `$currentInstance.id ```r`n"
            $AssignmentsUpdate += "            -Targets `$assignmentsHash ```r`n"
            $AssignmentsUpdate += "            -Repository $repository`r`n"

            $AssignmentsFunctions = @"
    function Update-DeviceConfigurationPolicyAssignment
    {
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable])]
        param (
            [Parameter(Mandatory = 'true')]
            [System.String]
            `$DeviceConfigurationPolicyId,

            [Parameter()]
            [Array]
            `$Targets,

            [Parameter()]
            [ValidateSet('deviceCompliancePolicies','intents','configurationPolicies','deviceConfigurations')]
            [System.String]
            `$Repository='configurationPolicies',

            [Parameter()]
            [ValidateSet('v1.0','beta')]
            [System.String]
            `$APIVersion='beta'
        )
        try
        {
            `$deviceManagementPolicyAssignments=@()

            `$Uri="https://graph.microsoft.com/`$APIVersion/deviceManagement/`$Repository/`$DeviceConfigurationPolicyId/assign"

            foreach(`$target in `$targets)
            {
                `$formattedTarget=@{"@odata.type"=`$target.dataType}
                if(`$target.groupId)
                {
                    `$formattedTarget.Add('groupId',`$target.groupId)
                }
                if(`$target.collectionId)
                {
                    `$formattedTarget.Add('collectionId',`$target.collectionId)
                }
                if(`$target.deviceAndAppManagementAssignmentFilterType)
                {
                    `$formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',`$target.deviceAndAppManagementAssignmentFilterType)
                }
                if(`$target.deviceAndAppManagementAssignmentFilterId)
                {
                    `$formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',`$target.deviceAndAppManagementAssignmentFilterId)
                }
                `$deviceManagementPolicyAssignments+=@{'target'= `$formattedTarget}
            }
            `$body=@{'assignments'=`$deviceManagementPolicyAssignments}|ConvertTo-Json -Depth 20
            #write-verbose -Message `$body
            Invoke-MgGraphRequest -Method POST -Uri `$Uri -Body `$body -ErrorAction Stop

        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error updating data:' `
                -Exception `$_ `
                -Source `$(`$MyInvocation.MyCommand.Source) `
                -TenantId `$TenantId `
                -Credential `$Credential

            return `$null
        }


    }
"@

            $AssignmentsCIM = @'
    [ClassVersion("1.0.0.0")]
    class MSFT_DeviceManagementConfigurationPolicyAssignments
    {
        [Write, Description("The type of the target assignment."), ValueMap{"#microsoft.graph.groupAssignmentTarget","#microsoft.graph.allLicensedUsersAssignmentTarget","#microsoft.graph.allDevicesAssignmentTarget","#microsoft.graph.exclusionGroupAssignmentTarget","#microsoft.graph.configurationManagerCollectionAssignmentTarget"}, Values{"#microsoft.graph.groupAssignmentTarget","#microsoft.graph.allLicensedUsersAssignmentTarget","#microsoft.graph.allDevicesAssignmentTarget","#microsoft.graph.exclusionGroupAssignmentTarget","#microsoft.graph.configurationManagerCollectionAssignmentTarget"}] String dataType;
        [Write, Description("The type of filter of the target assignment i.e. Exclude or Include. Possible values are:none, include, exclude."), ValueMap{"none","include","exclude"}, Values{"none","include","exclude"}] String deviceAndAppManagementAssignmentFilterType;
        [Write, Description("The Id of the filter for the target assignment.")] String deviceAndAppManagementAssignmentFilterId;
        [Write, Description("The group Id that is the target of the assignment.")] String groupId;
        [Write, Description("The collection Id that is the target of the assignment.(ConfigMgr)")] String collectionId;
    };
'@
            $AssignmentsProperty = "    [Write, Description(`"Represents the assignment to the Intune policy.`"), EmbeddedInstance(`"MSFT_DeviceManagementConfigurationPolicyAssignments`")] String Assignments[];`r`n"
            $AssignmentsConvertComplexToString = @"
            if(`$Results.Assignments)
            {
                `$complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject `$Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if (`$complexTypeStringResult)
                {
                    `$Results.Assignments = `$complexTypeStringResult
                }
                else
                {
                    `$Results.Remove('Assignments') | Out-Null
                }
            }
"@
            $AssignmentsConvertComplexToVariable = @"
            if (`$Results.Assignments)
            {
                `$isCIMArray=`$false
                if(`$Results.Assignments.getType().Fullname -like "*[[\]]")
                {
                    `$isCIMArray=`$true
                }
                `$currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock `$currentDSCBlock -ParameterName "Assignments" -isCIMArray:`$isCIMArray
            }
"@
        }
        Write-TokenReplacement -Token '<AssignmentsParam>' -Value $AssignmentsParam -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#AssignmentsGet#>' -Value $AssignmentsGet -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#AssignmentsRemove#>' -Value $AssignmentsRemove -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#AssignmentsNew#>' -Value $AssignmentsNew -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#AssignmentsUpdate#>' -Value $AssignmentsUpdate -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#AssignmentsFunctions#>' -Value $AssignmentsFunctions -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#AssignmentsConvertComplexToString#>' -Value $AssignmentsConvertComplexToString -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#AssignmentsConvertComplexToVariable#>' -Value $AssignmentsConvertComplexToVariable -FilePath $moduleFilePath

        # Remove comments
        Write-TokenReplacement -Token '<#ResourceGenerator' -Value '' -FilePath $moduleFilePath
        Write-TokenReplacement -Token 'ResourceGenerator#>' -Value '' -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#APIVersion#>' -Value $ApiVersion -FilePath $moduleFilePath

        $schemaFilePath = New-M365DSCSchemaFile -ResourceName $ResourceName -Path $Path
        $schemaProperties = New-M365SchemaPropertySet -Properties $parameterInformation `
            -Workload $Workload

        Write-TokenReplacement -Token '<AssignmentsCIM>' -Value $AssignmentsCIM -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<AssignmentsProperty>' -Value $AssignmentsProperty -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<CIMInstances>' -Value $CimInstancesSchemaContent -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<FriendlyName>' -Value $ResourceName -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<ResourceName>' -Value $ResourceName -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<Properties>' -Value $schemaProperties -FilePath $schemaFilePath

        #region Generate Examples
        if ($null -ne $Credential -and $generateExample)
        {
            Import-Module Microsoft365DSC -Force
            New-M365DSCExampleFile -ResourceName $ResourceName `
                -Path $ExampleFilePath `
                -Credential $Credential
        }
        #endregion
    }
    else
    {
        $ParametersToFilterOut = @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable', 'WhatIf', 'Confirm')
        $cmdlet = Get-Command ($cmdletVerb + "-" + $cmdletNoun)

        $defaultParameterSetProperties = $cmdlet.ParameterSets | Where-Object -FilterScript {$_.IsDefault}
        $properties = $defaultParameterSetProperties.Parameters | Where-Object -FilterScript {-not $ParametersToFilterOut.Contains($_.Name) -and -not $_.Name.StartsWith('MsftInternal')}

        #region Get longuest parametername
        $longuestParameterName = ("CertificateThumbprint").Length
        foreach ($property in $properties)
        {
            if ($property.Name.Length -gt $longuestParameterName)
            {
                $longuestParameterName = $property.Name.Length
            }
        }
        #endregion

        #region Get ParameterBlock
        $primaryKey = ''
        $paramContent = [System.Text.StringBuilder]::New()
        $returnContent = [System.Text.StringBuilder]::New()
        $exportAuthContent = [System.Text.StringBuilder]::New()
        $mofSchemaContent = [System.Text.StringBuilder]::New()
        $fakeValues = @{}
        foreach ($property in $properties)
        {
            $propertyTypeMOF = $property.ParameterType.Name
            switch($property.ParameterType.Name)
            {
                "Int64"
                {
                    $propertyTypeMOF = 'UInt64'
                }
                "Int32"
                {
                    $propertyTypeMOF = 'UInt32'
                }
            }
            if ($property.IsMandatory)
            {
                if ([System.String]::IsNullOrEmpty($primaryKey))
                {
                    $primaryKey = $property.Name
                }
                $paramContent.AppendLine("        [Parameter(Mandatory = `$true)]") | Out-Null
                $mofSchemaContent.AppendLine("    [Key, Description(`"$($property.Description)`")] $propertyTypeMOF $($property.Name);") | Out-Null
            }
            else
            {
                $paramContent.AppendLine("        [Parameter()]") | Out-Null
                $mofSchemaContent.AppendLine("    [Write, Description(`"$($property.Description)`")] $propertyTypeMOF $($property.Name);") | Out-Null
            }

            $fakeValues.Add($property.Name, (Get-M365DSCDRGFakeValueForParameter -ParameterType $property.ParameterType.Name))

            $spacingRequired = " "
            for ($i = 0; $i -lt ($longuestParameterName - $property.Name.Length); $i++)
            {
                $spacingRequired += " "
            }

            $returnContent.AppendLine("            $($property.Name)$spacingRequired= `$instance.$($property.Name)") | Out-Null

            $paramContent.AppendLine("        [$($property.ParameterType.FullName)]") | Out-Null
            $paramContent.AppendLine("        `$$($property.Name),`r`n") | Out-Null
        }

        # Ensure
        $spacingRequired = " "
        for ($i = 0; $i -lt ($longuestParameterName - ("Ensure").Length); $i++)
        {
            $spacingRequired += " "
        }
        $returnContent.AppendLine("            Ensure$spacingRequired= 'Present'") | Out-Null

        $paramContent.AppendLine("        [Parameter()]") | Out-Null
        $paramContent.AppendLine("        [ValidateSet('Present', 'Absent')]") | Out-Null
        $paramContent.AppendLine("        [System.String]") | Out-Null
        $paramContent.AppendLine("        `$Ensure,`r`n") | Out-Null

        $mofSchemaContent.AppendLine("    [Write, Description(`"Present ensures the instance exists, absent ensures it is removed.`"), ValueMap{`"Present`",`"Absent`"}, Values{`"Present`",`"Absent`"}] string Ensure;") | Out-Null

        # Credential
        $spacingRequired = " "
        for ($i = 0; $i -lt ($longuestParameterName - ("Credential").Length); $i++)
        {
            $spacingRequired += " "
        }
        $returnContent.AppendLine("            Credential$spacingRequired= `$Credential") | Out-Null

        $paramContent.AppendLine("        [Parameter()]") | Out-Null
        $paramContent.AppendLine("        [System.Management.Automation.PSCredential]") | Out-Null
        $paramContent.AppendLine("        `$Credential,`r`n") | Out-Null

        $mofSchemaContent.AppendLine("    [Write, Description(`"Credentials of the workload's Admin`"), EmbeddedInstance(`"MSFT_Credential`")] string Credential;") | Out-Null

        if ($Workload -ne 'SecurityAndCompliance')
        {
            # Application Id
            $spacingRequired = " "
            for ($i = 0; $i -lt ($longuestParameterName - ("ApplicationId").Length); $i++)
            {
                $spacingRequired += " "
            }
            $returnContent.AppendLine("            ApplicationId$spacingRequired= `$ApplicationId") | Out-Null

            $paramContent.AppendLine("        [Parameter()]") | Out-Null
            $paramContent.AppendLine("        [System.String]") | Out-Null
            $paramContent.AppendLine("        `$ApplicationId,`r`n") | Out-Null

            $exportAuthContent.AppendLine("                ApplicationId = `$ApplicationId") | Out-Null

            $mofSchemaContent.AppendLine("    [Write, Description(`"Id of the Azure Active Directory application to authenticate with.`")] String ApplicationId;") | Out-Null

            # Tenant Id
            $spacingRequired = " "
            for ($i = 0; $i -lt ($longuestParameterName - ("TenantId").Length); $i++)
            {
                $spacingRequired += " "
            }
            $returnContent.AppendLine("            TenantId$spacingRequired= `$TenantId") | Out-Null

            $paramContent.AppendLine("        [Parameter()]") | Out-Null
            $paramContent.AppendLine("        [System.String]") | Out-Null
            $paramContent.AppendLine("        `$TenantId,`r`n") | Out-Null

            $exportAuthContent.AppendLine("                TenantId = `$TenantId") | Out-Null

            $mofSchemaContent.AppendLine("    [Write, Description(`"Id of the Azure Active Directory tenant used for authentication.`")] String TenantId;") | Out-Null

            # CertificateThumbprint
            $spacingRequired = " "
            for ($i = 0; $i -lt ($longuestParameterName - ("CertificateThumbprint").Length); $i++)
            {
                $spacingRequired += " "
            }
            $returnContent.AppendLine("            CertificateThumbprint$spacingRequired= `$CertificateThumbprint") | Out-Null

            $paramContent.AppendLine("        [Parameter()]") | Out-Null
            $paramContent.AppendLine("        [System.String]") | Out-Null
            $paramContent.AppendLine("        `$CertificateThumbprint,`r`n") | Out-Null

            $exportAuthContent.AppendLine("                CertificateThumbprint = `$CertificateThumbprint") | Out-Null

            $mofSchemaContent.AppendLine("    [Write, Description(`"Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication.`")] String CertificateThumbprint;") | Out-Null

            if ($workload -ne 'MicrosoftTeams')
            {
                # ApplicationSecret
                $spacingRequired = " "
                for ($i = 0; $i -lt ($longuestParameterName - ("ApplicationSecret").Length); $i++)
                {
                    $spacingRequired += " "
                }
                $returnContent.AppendLine("            ApplicationSecret$spacingRequired= `$ApplicationSecret") | Out-Null
                $paramContent.AppendLine("        [Parameter()]") | Out-Null
                $paramContent.AppendLine("        [System.Management.Automation.PSCredential]") | Out-Null
                $paramContent.AppendLine("        `$ApplicationSecret,`r`n") | Out-Null

                $exportAuthContent.AppendLine("                ApplicationSecret = `$ApplicationSecret") | Out-Null

                $mofSchemaContent.AppendLine("    [Write, Description(`"Secret of the Azure Active Directory tenant used for authentication.`"), EmbeddedInstance(`"MSFT_Credential`")] String ApplicationSecret;") | Out-Null
            }
        }

        $parameterBlock = $paramContent.ToString()
        $parameterBlock = $parameterBlock.Remove($parameterBlock.Length -5, 5) # remove trailing comma
        Write-TokenReplacement -Token '<ParameterBlock>' -Value $parameterBlock -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<ExportAuth>' -Value $exportAuthContent.ToString() -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<HashTableMapping>' -Value $returnContent.ToString() -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<PrimaryKey>' -Value $primaryKey  -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<NewCmdLetName>' -Value "New-$cmdletNoun"  -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<UpdateCmdLetName>' -Value "Set-$cmdletNoun"  -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<RemoveCmdLetName>' -Value "Remove-$cmdletNoun" -FilePath $moduleFilePath
        #endregion

        #region GetKeyIdentifier
        $cmdlet = Get-Command $('Get-' + $cmdletNoun)
        $defaultParameterSetProperties = $cmdlet.ParameterSets | Where-Object -FilterScript {$_.IsDefault}
        Write-TokenReplacement -Token '<getKeyIdentifier>' -Value $defaultParameterSetProperties[0].Name -FilePath $moduleFilePath
        #endregion

        Write-TokenReplacement -Token '<GetCmdLetName>' -Value "Get-$cmdletNoun" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#Workload#>' -Value $Workload -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<AssignmentsParam>' -Value '' -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<Properties>' -Value $mofSchemaContent -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<ResourceName>' -Value $ResourceName -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<CIMInstances>' -Value '' -FilePath $schemaFilePath

        #region Readme & Settings
        $cmdName = "New-$cmdletNoun"
        $cmdletInfo = & $cmdName -?
        $synopsis = $cmdletInfo.Synopsis.Replace('cmdlet', 'resource')
        Write-TokenReplacement -Token '<ResourceFriendlyName>' -Value $ResourceName -FilePath $readmeFilePath
        Write-TokenReplacement -Token '<ResourceDescription>' -Value $synopsis -FilePath $readmeFilePath
        Write-TokenReplacement -Token '<ResourceFriendlyName>' -Value $ResourceName -FilePath $settingsFilePath
        Write-TokenReplacement -Token '<ResourceDescription>' -Value $synopsis -FilePath $settingsFilePath
        Write-TokenReplacement -Token '<ResourcePermissions>' -Value '[]' -FilePath $settingsFilePath
        #endregion

        #region UnitTests
        $fakeValuesString = [System.Text.StringBuilder]::New()
        $fakeValuesDriftString = [System.Text.StringBuilder]::New()

        $numberOfProperties = $fakeValues.Keys.Count
        $currentKeyIndex = 1
        foreach ($key in $fakeValues.Keys)
        {
            $spacingRequired = ' '

            for ($i = 0; $i -lt ($longuestParameterName - $key.Length); $i++)
            {
                $spacingRequired += " "
            }

            $propertyValue = $null
            $propertyDriftValue = $null
            switch ($fakeValues.$key.GetType().Name)
            {
                "String"
                {
                    $propertyValue = "`"$($fakeValues.$key)`""
                    if ($currentKeyIndex -eq $numberOfProperties)
                    {
                        $propertyDriftValue = "`"" + (Get-M365DSCDRGFakeValueForParameter -ParameterType 'String' `
                            -Drift:$true) + "`""
                    }
                    else
                    {
                        $propertyDriftValue = $propertyValue
                    }
                }
                "Boolean"
                {
                    $propertyValue = "`$$($fakeValues.$key)"
                    if ($currentKeyIndex -eq $numberOfProperties)
                    {
                        $propertyDriftValue = "`$" + (Get-M365DSCDRGFakeValueForParameter -ParameterType 'Boolean' `
                            -Drift:$true)
                    }
                    else
                    {
                        $propertyDriftValue = $propertyValue
                    }
                }
                "Int32"
                {
                    $propertyValue = $fakeValues.$key.ToString()
                    if ($currentKeyIndex -eq $numberOfProperties)
                    {
                        $propertyDriftValue = (Get-M365DSCDRGFakeValueForParameter -ParameterType 'Int32' `
                            -Drift:$true)
                    }
                    else
                    {
                        $propertyDriftValue = $propertyValue
                    }
                }
                "Int64"
                {
                    $propertyValue = $fakeValues.$key.ToString()
                    if ($currentKeyIndex -eq $numberOfProperties)
                    {
                        $propertyDriftValue = (Get-M365DSCDRGFakeValueForParameter -ParameterType 'Int64' `
                            -Drift:$true)
                    }
                    else
                    {
                        $propertyDriftValue = $propertyValue
                    }
                }
            }

            $fakeValuesString.AppendLine("#$#$key$spacingRequired= $propertyValue") | Out-Null
            $fakeValuesDriftString.AppendLine("#$#$key$spacingRequired= $propertyDriftValue") | Out-Null

            $currentKeyIndex++
        }
        Write-TokenReplacement -Token '<ResourceName>' -Value $ResourceName -FilePath $unitTestPath
        Write-TokenReplacement -Token '<GetCmdletName>' -Value "Get-$cmdletNoun" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<SetCmdletName>' -Value "Set-$cmdletNoun" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<NewCmdletName>' -Value "New-$cmdletNoun" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<RemoveCmdletName>' -Value "Remove-$cmdletNoun" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<FakeValues>' -Value $fakeValuesString.ToString().Replace('#$#', '                    ') -FilePath $unitTestPath
        Write-TokenReplacement -Token '<DriftValues>' -Value $fakeValuesDriftString.ToString().Replace('#$#', '                    ') -FilePath $unitTestPath
        #endregion
    }
}

function Get-MgGraphModuleCmdLetDifference
{
    $modules = Get-Module -Name Microsoft.Graph.* -ListAvailable | Sort-Object -Property Name, Version | Out-GridView -PassThru

    if ($modules.Count -eq 0)
    {
        Write-Host '[ERROR] No module selected!' -ForegroundColor Red
        return
    }

    if (($modules.Name | Sort-Object | Select-Object -Unique).Count -ne 1 -or $modules.Count -ne 2)
    {
        Write-Host '[ERROR] Please select two versions of the same module' -ForegroundColor Red
        return
    }

    [array]$exportedKeysModule1 = $modules[0].ExportedCommands.Keys
    [array]$exportedKeysModule2 = $modules[1].ExportedCommands.Keys

    $diffs = Compare-Object -ReferenceObject $exportedKeysModule1 -DifferenceObject $exportedKeysModule2
    foreach ($diff in $diffs)
    {
        switch ($diff.SideIndicator)
        {
            '=>'
            {
                Write-Host "Cmdlet '$($diff.InputObject)' is new in $($modules[1].Name) v$($modules[1].Version)" -ForegroundColor Green
            }
            '<='
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
        $commands = (Get-Command -Module $module.Name -Verb Get | Where-Object -FilterScript { $_.CommandType -eq 'Function' }).Noun

        $commands = Get-Command -Module $module.Name
        $nouns = $commands.Noun | Sort-Object | Select-Object -Unique

        foreach ($noun in $nouns)
        {
            Write-Verbose -Message "- $($noun)"

            $nounCommands = $commands | Where-Object { $_.Noun -eq $noun }
            if ($nounCommands.Verb -notcontains 'Get' -or `
                    $nounCommands.Verb -notcontains 'Update' -or `
                    $nounCommands.Verb -notcontains 'New')
            {
                Write-Verbose '  [SKIPPING] Noun does not have Get, New and/or Update method' -ForegroundColor Magenta
                continue
            }

            $shortNoun = $noun.Substring(2, $noun.Length - 2)
            New-M365DSCResource -ResourceName $shortNoun -GraphModule $module.Name -GraphModuleVersion $module.Version -CmdLetNoun $noun
        }
    }
}

function Get-CmdletDefinition
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

    if ($ApiVersion -eq 'v1.0')
    {
        $Version = 'cleanv1'
    }
    else
    {
        $Version = 'cleanbeta'
    }

    $rawJson = Invoke-RestMethod -Method Get -Uri "https://metadataexplorerstorage.blob.core.windows.net/`$web/$($Version).js#search:$($Entity)"
    # Clean JSON
    $cleanJsonString = $rawJson.TrimStart('const json = ')
    $cleanJsonString = $CleanJsonString -replace ',}', '}'
    $cleanJsonString = $CleanJsonString -replace ': ]', ': []'
    $targetIndex = $cleanJsonString.IndexOf(';')
    $cleanJsonString = $cleanJsonString.Remove($targetIndex)
    $cmdletDefinition = $cleanJsonString | ConvertFrom-Json

    return $cmdletDefinition
}
function Get-PropertiesDefinition
{
    param (
        [Parameter()]
        [ValidateSet('v1.0', 'beta')]
        [string]
        $APIVersion
    )

    $Uri = "https://graph.microsoft.com/$APIVersion/deviceManagement/settingDefinitions"
    $settingDefinitions = Invoke-MgGraphRequest -Method GET -Uri $Uri


    return $settingDefinitions.value
}
function Get-DerivedType
{
    param (
        [Parameter(Mandatory = $true)]
        $CmdletDefinition,

        [Parameter(Mandatory = $true)]
        [string]
        $Entity
    )

    $enumTypes = $CmdletDefinition | Where-Object -FilterScript { $_.ItemType -eq 'EnumType' }
    $complexTypes = $CmdletDefinition | Where-Object -FilterScript { $_.ItemType -eq 'complexType' }

    $returnValue = $CmdletDefinition | Where-Object -FilterScript { $_.BaseType -eq $Entity }
    # Multiple Result

    if ($null -eq $returnValue)
    {
        $returnValue = $CmdletDefinition | Where-Object -FilterScript { $_.Name -eq $Entity }
        # One Result
    }

    #Retrieve enumType details for each parameters
    foreach ($property in $returnValue.Properties)
    {
        $propertyType = $property.type.replace('C(', '').replace(')', '')
        if ($propertytype -in $enumTypes.Name)
        {
            $enumType = $enumTypes | Where-Object -FilterScript { $_.Name -eq $propertyType }
            Add-Member -InputObject $property -MemberType NoteProperty -Name 'Members' -Value $enumType.Members
            #$property.Type="EnumType"
        }
        if ($propertyType -in $complexTypes.Name)
        {
            $complexType = $complexTypes | Where-Object -FilterScript { $_.Name -eq $propertyType }
            $derivedComplexTypes = $CmdletDefinition | Where-Object -FilterScript { $_.BaseType -eq $propertyType }
            $properties = @()
            if ($derivedComplexTypes)
            {
                foreach ($derivedComplexType in $derivedComplexTypes)
                {
                    if ('odataType' -notin $properties.Name)
                    {
                        $typeProperty = @{
                            'Name'    = 'odataType'
                            'Type'    = 'Edm.String'
                            'Members' = @('#microsoft.graph.' + $derivedComplexType.Name)
                        }
                        $properties += $typeProperty
                    }
                    else
                    {
                        ($properties | Where-Object -FilterScript { $_.Name -eq 'odataType' }).Members += '#microsoft.graph.' + $derivedComplexType.Name

                    }
                    $properties += $derivedComplexTypes.Properties | Where-Object -FilterScript { $_.Name -notin $properties.Name }
                }
            }
            $properties += $complexType.Properties | Where-Object -FilterScript { $_.Name -notin $properties.Name }
            <#if($propertyType -eq 'androidDeviceOwnerGlobalProxy')
            {
                write-host ($propertyType+"`r`n"+($properties|out-string))
            }#>
            Add-Member -InputObject $property -MemberType NoteProperty -Name 'Properties' -Value $properties
            #$property.Type="ComplexType"
        }
    }

    return $returnValue
}

function Get-ComplexTypeDefinition
{
    param (
        [Parameter(Mandatory = $true)]
        $CmdletDefinition,

        [Parameter(Mandatory = $true)]
        [string]
        $ComplexTypeName
    )

    $complexTypeDefinition = $CmdletDefinition | Where-Object -FilterScript { $_.ItemType -eq 'ComplexType' -and $_.Name -eq $ComplexTypeName }
    $derivedComplexTypes = $CmdletDefinition | Where-Object -FilterScript { $_.BaseType -eq $ComplexTypeName }
    $properties = @()
    if ($derivedComplexTypes)
    {
        foreach ($derivedComplexType in $derivedComplexTypes)
        {
            if ('odataType' -notin $properties.Name)
            {
                $typeProperty = @{
                    'Name'    = 'odataType'
                    'Type'    = 'Edm.String'
                    'Members' = @('#microsoft.graph.' + $derivedComplexType.Name)
                }
                $properties += $typeProperty
            }
            else
            {
                        ($properties | Where-Object -FilterScript { $_.Name -eq 'odataType' }).Members += '#microsoft.graph.' + $derivedComplexType.Name
            }
            $properties += $derivedComplexTypes.Properties | Where-Object -FilterScript { $_.Name -notin $properties.Name }
        }
    }
    $properties += $complexTypeDefinition.Properties | Where-Object -FilterScript { $_.Name -notin $properties.Name }

    $result = @()
    foreach ($property in $properties)
    {
        $hashProperty = @{
            'Name'         = $property.Name
            'PropertyType' = Get-M365DSCDRGParameterType -Type $property.Type
        }
        if ($property.Members)
        {
            $hashProperty.add('Members', $property.Members)
        }
        $result += $hashProperty
    }

    return $result
}

function Get-EnumTypeDefinition
{
    param (
        [Parameter(Mandatory = $true)]
        $CmdletDefinition,

        [Parameter(Mandatory = $true)]
        [string]
        $ComplexTypeName
    )

    $enumTypes = $CmdletDefinition | Where-Object -FilterScript { $_.ItemType -eq 'EnumType' }

    $enumType = $enumTypes | Where-Object -FilterScript { $_.Name -eq $ComplexTypeName }
    if ($enumType)
    {
        $result = @{
            'Name'         = $property.Name
            'PropertyType' = 'EnumType'
            'Members'      = $enumType.Members
        }
    }

    return $result
}

function Get-ParameterBlockInformation
{
    param (
        [Parameter()]
        [Object[]]
        $Properties,

        [Parameter()]
        [Object[]]
        $PropertiesDefinitions,

        # Parameter help description
        [Parameter()]
        [System.Object]
        $DefaultParameterSetProperties
    )

    $parameterBlock = New-Object System.Collections.ArrayList

    $Properties | ForEach-Object -Process {
        $property = $_
        #$property.Name
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
            $parameterAttribute = '[Parameter()]'
        }

        <#if ($null -ne $cmdletParameter) {
            $parameterType = Get-M365DSCDRGParameterType -Type $cmdletParameter.ParameterType.ToString()
        }
        else
        {#>
        #write-host ($property|out-string)
        $type = $property.Type

        switch -Wildcard ($type)
        {
            'Edm.*'
            {
                $type = $type.Replace('Edm', 'System')
            }
            'C(*)'
            #Default
            {
                $typeName = $type.replace('C(', '').replace(')', '')

                if ($typeName -like 'edm.*')
                {
                    $type = (Get-M365DSCDRGParameterType -Type $typeName) + '[]'
                }
                elseif ($property.Members)
                {
                    $type = 'System.String[]'

                }
                else
                {
                    try
                    {
                        $typeDefinition = (Invoke-Expression "[Microsoft.Graph.PowerShell.Models.IMicrosoftGraph$typeName]" -ErrorAction Stop)
                    }
                    catch
                    {
                        $typeDefinition = @{'FullName' = "Microsoft.Graph.PowerShell.Models.IMicrosoftGraph$typeName" }
                    }
                    $type = $typeDefinition.Fullname + '[]'
                }
            }
            'EnumType'
            {
                $type = 'System.String'
            }
            'ComplexType'
            {
                $typeName = $property.Name
                try
                {
                    $typeDefinition = (Invoke-Expression "[Microsoft.Graph.PowerShell.Models.IMicrosoftGraph$typeName]" -ErrorAction Stop)
                }
                catch
                {
                    $typeDefinition = @{'FullName' = "Microsoft.Graph.PowerShell.Models.IMicrosoftGraph$typeName" }
                }
                $type = $typeDefinition.Fullname
            }
            Default
            {
                #write-host ($property|out-string) -f Green
                if ($property.Members)
                {
                    $type = 'System.String'

                }
                elseif ($property.Properties)
                {
                    #write-host ($property|out-string) -f Green

                    try
                    {
                        $typeDefinition = (Invoke-Expression "[Microsoft.Graph.PowerShell.Models.IMicrosoftGraph$type]" -ErrorAction Stop)
                    }
                    catch
                    {
                        $typeDefinition = @{'FullName' = "Microsoft.Graph.PowerShell.Models.IMicrosoftGraph$type" }
                    }
                    $type = $typeDefinition.Fullname

                }
                #Temporary for debugging
                else
                {
                    Write-Host ($property | Out-String)
                }

            }
        }
        $parameterType = $null
        if ($type)
        {
            $parameterType = Get-M365DSCDRGParameterType -Type $type
        }
        #}

        $parameterName = $property.Name
        $parameterNameFirstLetter = $parameterName.Substring(0, 1)
        $parameterNameFirstLetter = $parameterNameFirstLetter.ToUpper()
        $parameterNameCamelCaseString = $parameterName.Substring(1)
        $parameterName = "$($parameterNameFirstLetter)$($parameterNameCamelCaseString)"
        $parameterDescription = ($PropertiesDefinitions | Where-Object -FilterScript { $_.id -like "*$parameterName" }).description
        if (-not [String]::IsNullOrEmpty($parameterDescription))
        {

            $parameterDescription = $parameterDescription -replace [regex]::Escape([char]0x201C), "'"
            $parameterDescription = $parameterDescription -replace [regex]::Escape([char]0x201D), "'"
            $parameterDescription = $parameterDescription -replace [regex]::Escape('"'), "'"
            $parameterDescription = $parameterDescription -replace [regex]::Escape([char]0x2019), "'"
            $parameterDescription = $parameterDescription.TrimStart()
            $parameterDescription = $parameterDescription.TrimEnd()
        }

        if ($parameterType)
        {
            $myParam = @{
                IsMandatory = $isMandatory
                Attribute   = $parameterAttribute
                Type        = $parameterType
                Name        = $parameterName
                Description = $parameterDescription
            }
            if ($null -ne $property.Members -and $property.Members.count -gt 0)
            {
                $myParam.add('Members', $property.Members)
            }
            if ($null -ne $property.Properties -and $property.Properties.count -gt 0)
            {
                $myParam.add('Properties', $property.Properties)
            }

            $parameterBlock.Add($myParam) | Out-Null
        }
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
    $parameterType = ''
    switch -Wildcard ($Type.ToLower())
    {
        'system.string'
        {
            $parameterType = 'System.String'
            break;
        }
        'system.datetime'
        {
            $parameterType = 'System.String'
            break;
        }
        'system.boolean'
        {
            $parameterType = 'System.Boolean'
            break;
        }
        'system.management.automation.switchparameter'
        {
            $parameterType = 'System.Boolean'
            break;
        }
        'system.int32'
        {
            $parameterType = 'System.Int32'
            break;
        }
        'system.int64'
        {
            $parameterType = 'System.Int64'
            break;
        }
        'system.string[[\]]'
        {
            $parameterType = 'System.String[]'
            break;
        }
        'system.*'
        {
            $parameterType = $_
            break;
        }
        'edm.*'
        {
            $parameterType = $Type.replace('Edm', 'System')
            break;
        }
        'C(*)'
        {
            $typeName = $Type.replace('C(', '').replace(')', '')
            $parameterType = (Get-M365DSCDRGParameterType -Type $typeName) + '[]'
            break;
        }
        'Microsoft.Graph.PowerShell.*'
        {
            $parameterType = $_
            break;
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
    $parameterType = ''
    switch ($Type.ToLower())
    {
        'system.String'
        {
            $parameterType = 'String'
        }
        'system.datetime'
        {
            $parameterType = 'String'
        }
        'system.boolean'
        {
            $parameterType = 'Boolean'
        }
        'system.int32'
        {
            $parameterType = 'UInt32'
        }
        'system.int64'
        {
            $parameterType = 'UInt64'
        }
        Default
        {
            #write-host -ForegroundColor cyan -object $Type
            $parameterType = 'String'
        }
    }
    return $parameterType
}

function New-M365CmdLetHelper
{
    param(
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

function Get-M365DSCDRGFakeValueForParameter
{
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $ParameterType,

        [Parameter()]
        [System.String[]]
        $ValidateSetValues,

        [Parameter()]
        [System.Boolean]
        $Drift = $false
    )

    switch ($ParameterType)
    {
        "String"
        {
            if ($ValidateSetValues -ne $null -and $ValidateSetValues.Length -gt 0)
            {

            }
            else
            {
                if ($Drift)
                {
                    return "FakeStringValueDrift #Drift"
                }
                return "FakeStringValue"
            }
        }
        "Boolean"
        {
            if ($Drift)
            {
                return $false
            }
            return $true
        }
        "Int32"
        {
            if ($Drift)
            {
                return 2
            }
            return 3
        }
        "Int64"
        {
            if ($Drift)
            {
                return 2
            }
            return 3
        }
    }
}

function Get-M365DSCFakeValues
{
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $ParametersInformation,

        [Parameter()]
        [System.Boolean]
        $IntroduceDrift = $false,

        [Parameter()]
        [System.Boolean]
        $isCmdletCall = $false,

        [Parameter()]
        [System.Boolean]
        $isRecursive = $false,

        [Parameter()]
        [System.String]
        $AdditionalPropertiesType = '',

        [Parameter()]
        [System.String]
        $Workload

    )

    $result = @{}
    $parameters = $parametersInformation
    $additionalProperties = @{}

    if ($isCmdletCall -and -not $isRecursive)
    {
        $excludedFromAdditionalProperties = @(
            'Description'
            'DisplayName'
            'Id'
        )

        $additionalProperties = @{
            '@odata.type' = '#microsoft.graph.' + $AdditionalPropertiesType
        }
        $parameters = $parameters | Where-Object -FilterScript { $_.Name -notin $excludedFromAdditionalProperties }
    }


    foreach ($parameter in $parameters)
    {
        $hashValue = $null
        switch -Wildcard ($parameter.Type)
        {
            '*.String'
            {
                $fakeValue = 'FakeStringValue'
                if ($parameter.Members)
                {
                    $fakeValue = $parameter.Members[0]
                }
                $hashValue = $fakeValue
                break
            }
            '*.String[[\]]'
            {
                $fakeValue1 = 'FakeStringArrayValue1'
                $fakeValue2 = 'FakeStringArrayValue2'
                if ($parameter.Members)
                {
                    $fakeValue1 = $parameter.Members[0]
                    $fakeValue2 = $parameter.Members[1]
                }
                if ($IntroduceDrift)
                {
                    $hashValue = @($fakeValue1)
                }
                else
                {
                    $hashValue = @($fakeValue1, $fakeValue2)
                }
                break
            }
            '*.Int32'
            {
                if ($IntroduceDrift)
                {
                    $hashValue = 7
                }
                else
                {
                    $hashValue = 25
                }
                break
            }
            '*.Boolean'
            {
                if ($IntroduceDrift)
                {
                    $hashValue = $false
                }
                else
                {
                    $hashValue = $true
                }
                break
            }
            'microsoft.graph.powershell.models.imicrosoftgraph*'
            {
                $isArray = $false
                if ($parameter.Type -like '*[[\]]')
                {
                    $isArray = $true
                }

                $hashValue = @{}
                if (-not $isCmdletCall)
                {
                    $propertyType = $parameter.Type -replace 'microsoft.graph.powershell.models.', ''
                    $propertyType = $propertyType -replace 'imicrosoftgraph', ''
                    $propertyType = $propertyType -replace '[[\]]', ''
                    $propertyType = $workload + $propertyType
                    $propertyType = "MSFT_$propertyType"
                    $hashValue.add('CIMType', $propertyType)
                }
                $hashValue.add('isArray', $isArray)

                if ($Null -ne $parameter.Properties)
                {
                    $nestedProperties = Get-M365DSCFakeValues -ParametersInformation $parameter.Properties `
                        -Workload $Workload `
                        -isCmdletCall $isCmdletCall `
                        -isRecursive $true

                    $hashValue.add('Properties', $nestedProperties)
                    $hashValue.add('Name', $parameter.Name)
                }
            }
        }

        if ($hashValue)
        {
            if ($isCmdletCall -and -not $isRecursive)
            {
                $additionalProperties.Add($parameter.Name, $hashValue)
            }
            else
            {
                $result.Add($parameter.Name, $hashValue)
            }
        }
    }

    if ($isCmdletCall)
    {
        if (-not $isRecursive)
        {
            $result.Add('Id', 'FakeStringValue')
            $result.Add('DisplayName', 'FakeStringValue')
            $result.Add('Description', 'FakeStringValue')
            $result.Add('AdditionalProperties', $additionalProperties)
        }
    }

    return $result
}

function Get-M365DSCHashAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Values,

        [Parameter()]
        [System.String]
        $Space = '                        ',

        [Parameter()]
        [System.Boolean]
        $isCmdletCall = $false
    )
    $sb = [System.Text.StringBuilder]::New()
    $keys = $Values.Keys | Sort-Object -Property $_
    foreach ($key in $keys)
    {
        switch ($Values.$key.GetType().Name)
        {
            'String'
            {
                $value = $Values.$key
                if ($key -eq '@odata.type')
                {
                    $key = "'$key'"
                }
                $sb.AppendLine("$Space$key = `"$value`"") | Out-Null
            }

            'Int32'
            {
                $sb.AppendLine("$Space$key = $($Values.$key)") | Out-Null
            }

            'Boolean'
            {
                $sb.AppendLine("$Space$key = `$$($Values.$key)") | Out-Null
            }

            'String[]'
            {
                $stringValue = ''
                foreach ($item in $Values.$key)
                {
                    $stringValue += "`"$item`","
                }
                $stringValue = $stringValue.Substring(0, $stringValue.Length - 1)
                $sb.AppendLine("$Space$key = `@($stringValue)") | Out-Null
            }

            'Hashtable'
            {
                $extraSpace = ''
                $line = "$Space$extraSpace$key ="
                if ($Values.$Key.isArray)
                {
                    $line += "@(`r$space    "
                    $extraSpace = '    '
                }
                if ($Values.$Key.CIMType)
                {
                    $line += "(New-CimInstance -ClassName $($Values.$Key.CIMType) -Property "
                }

                $sb.AppendLine("$line@{") | Out-Null
                if ($Values.$Key.Properties)
                {
                    $propLine = ''
                    foreach ($prop in $Values.$Key.Properties)
                    {
                        if ($isCmdletCall -and $prop.contains('odataType'))
                        {
                            $prop.add('@odata.type', $prop.odataType)
                            $prop.remove('odataType')
                        }
                        $l = (Get-M365DSCHashAsString -Values $prop -Space "$Space$extraSpace    " -isCmdletCall $isCmdletCall)
                        $propLine += $l
                    }
                    $sb.AppendLine($propLine) | Out-Null

                }
                else
                {
                    $sb.AppendLine((Get-M365DSCHashAsString -Values $Values.$key -Space "$Space    " -isCmdletCall $isCmdletCall)) | Out-Null
                }
                $endLine = "$Space$extraSpace}"
                if ($Values.$Key.CIMType )
                {
                    $endLine += ' -ClientOnly)'
                }
                $sb.AppendLine($endLine) | Out-Null
                if ($Values.$Key.isArray)
                {
                    $sb.AppendLine("$space)") | Out-Null
                }
            }
        }
    }
    return $sb.ToString()
}
function Get-M365DSCResourcePermission
{
    param (
        # Name of the Workload the resource is for.
        [Parameter(Mandatory = $true)]
        [ValidateSet('ExchangeOnline', 'Intune', `
                'SecurityComplianceCenter', 'PnP', 'PowerPlatforms', `
                'MicrosoftTeams', 'MicrosoftGraph')]
        [System.String]
        $Workload,

        # CmdLet Noun
        [Parameter()]
        [System.String]
        $CmdLetNoun
    )

    $readPermissionsNames = (Find-MgGraphCommand -Command "Get-$CmdLetNoun" | Select-Object -First 1 -ExpandProperty Permissions).Name
    $updatePermissionsNames = (Find-MgGraphCommand -Command "Update-$CmdLetNoun" | Select-Object -First 1 -ExpandProperty Permissions).Name

    switch ($Workload)
    {
        'Intune'
        {
            $nodeWorkloadName = 'graph'
        }
        'MicrosoftGraph'
        {
            $nodeWorkloadName = 'graph'
        }
    }

    $readPermissions = @()
    foreach ($permission in $readPermissionsNames)
    {
        $readPermissions += @{'name' = $permission }
    }

    $updatePermissions = @()
    foreach ($permission in $updatePermissionsNames)
    {
        $updatePermissions += @{'name' = $permission }
    }

    $delegatedPermissions = @{}
    $delegatedPermissions.add('read', $readPermissions)
    $delegatedPermissions.add('update', $updatePermissions)

    $applicationPermissions = @{}
    $applicationPermissions.add('read', $readPermissions)
    $applicationPermissions.add('update', $updatePermissions)

    $workloadPermissions = @{}
    $workloadPermissions.add('delegated', $delegatedPermissions)
    $workloadPermissions.add('application', $applicationPermissions)

    $permissions = @{}
    $permissions.add($nodeWorkloadName, $workloadPermissions)

    $return = @{'permissions' = $permissions }

    return $return
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
        if (-not $Global:CIMInstancesAlreadyFound.Contains($cimInstance.Name))
        {
            $Global:CIMInstancesAlreadyFound += $cimInstance.Name
            $stringResult += "[ClassVersion(`"1.0.0`")]`r`n"
            $stringResult += 'class MSFT_' + $cimInstance.Name + "`r`n"
            $stringResult += "{`r`n"

            $nestedResults = ''
            foreach ($property in $cimInstance.Properties)
            {
                $newNestedCimToBeAdded = $false
                if ($property.Type.ToString().ToLower().StartsWith('microsoft.graph.powershell.models.') -and `
                        -not $Global:AlreadyFoundInstances.Contains($property.Type))
                {
                    $newNestedCimToBeAdded = $true
                    $Global:AlreadyFoundInstances += $property.Type

                    if ($property.NestedCIM)
                    {
                        $nestedResult = Get-M365DSCDRGCimInstancesSchemaStringContent -CIMInstances $property.NestedCIM `
                            -Workload $Workload
                    }
                    else
                    {
                        $nestedResult = ''
                    }

                    $propertyType = $property.Type -replace 'microsoft.graph.powershell.models.', ''
                    $propertyType = $propertyType -replace 'imicrosoftgraph', ''
                    $propertyType = $propertyType -replace '[[\]]', ''
                    $propertyType = $workload + $propertyType
                    $stringResult += "    [Write, Description(`"$($property.Description)`"), EmbeddedInstance(`"MSFT_$propertyType`")] String $($property.Name)"
                    if ($property.IsArray)
                    {
                        $stringResult += '[]'
                    }
                    $stringResult += ";`r`n"
                }
                elseif (-not $property.Type.StartsWith('microsoft.graph.powershell.models.'))
                {
                    $propertyType = Get-M365DSCDRGParameterTypeForSchema -Type $property.Type
                    $propertySet = ''
                    if ($null -ne $property.Members)
                    {
                        $mySet = ''
                        foreach ($member in $property.Members)
                        {
                            $mySet += "`"" + $member + "`","
                        }
                        $mySet = $mySet.Substring(0, $mySet.Length - 1)
                        $propertySet = ", ValueMap{$mySet}, Values{$mySet}"
                    }

                    $stringResult += "    [Write, Description(`"$($property.Description)`")$propertySet] $($propertyType) $($property.Name)"
                    if ($property.IsArray)
                    {
                        $stringResult += '[]'
                    }
                    $stringResult += ";`r`n"
                }
                if ($newNestedCimToBeAdded)
                {
                    $nestedResults += $nestedResult
                }
            }
            $stringResult += "};`r`n"
            $stringResult += $nestedResults
        }
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
        $Properties,

        [Parameter()]
        $CmdletDefinition,

        [Parameter()]
        $PropertiesDefinitions,

        [Parameter()]
        [System.String[]]
        $DiscoveredComplexTypes = @()
    )

    [Array]$cimInstances = $Properties | Where-Object -FilterScript { $_.Type -like 'Microsoft.Graph.PowerShell.Models.*' }

    $results = @()
    foreach ($cimInstance in $cimInstances)
    {


        $IsArray = $false
        $currentInstance = @{}
        $originalType = $cimInstance.Type
        $cimInstanceName = $cimInstance.Type -replace 'Microsoft.Graph.PowerShell.Models.IMicrosoftGraph', ''
        #$cimInstanceName = $cimInstanceName -replace "IMicrosoftGraph", ""
        if ($cimInstanceName.EndsWith('[]'))
        {
            $IsArray = $true
            $cimInstanceName = $cimInstanceName -replace '[[\]]', ''
            $originalType = $cimInstance.Type.ToString() -replace '[[\]]', ''
        }

        $DiscoveredComplexTypeName = "microsoft.graph.powershell.models.imicrosoftgraph$cimInstanceName"
        if ($DiscoveredComplexTypeName -notin $script:DiscoveredComplexTypes)
        {
            $script:DiscoveredComplexTypes += $DiscoveredComplexTypeName
        }
        $currentInstance.Add('IsArray', $IsArray)

        $cimInstanceName = $Workload + $cimInstanceName
        $currentInstance.Add('Name', $cimInstanceName)

        try
        {
            $objectInstance = Invoke-Expression "[$originalType]" -ErrorAction Stop
        }
        catch
        {
            $objectInstance = $null
        }

        if ($objectInstance)
        {
            #write-host -ForegroundColor DarkRed -Object $objectInstance.name
            $inheritedInstance = $objectInstance.ImplementedInterfaces | Where-Object -FilterScript { $_.Fullname -like 'Microsoft.Graph.PowerShell.Models.*' }
            $declaredProperties = @()
            $declaredProperties += $objectInstance.DeclaredProperties
            $declaredProperties += $inheritedInstance.DeclaredProperties
        }
        else
        {
            $complexTypeName = $cimInstance.Type.replace('microsoft.graph.powershell.models.imicrosoftgraph', '')
            $complexTypeName = $complexTypeName.replace('[]', '')
            $declaredProperties = Get-ComplexTypeDefinition `
                -CmdletDefinition $CmdletDefinition `
                -ComplexTypeName $complexTypeName

            if ($cimInstance.Properties)
            {
                foreach ($property in $cimInstance.Properties)
                {
                    $complexProperty = $CmdletDefinition | Where-Object { ($_.ItemType -in ('enumType', 'complexType')) -and $_.Name -eq $property.Type }
                    if ($complexProperty)
                    {
                        $dProp = $declaredProperties | Where-Object -FilterScript { $_.Name -eq $property.Name }
                        if ($complexProperty.ItemType -eq 'enumType')
                        {
                            $dProp.add('Members', $complexProperty.Members)
                        }
                        else
                        {
                            $dProp.PropertyType = "microsoft.graph.powershell.models.imicrosoftgraph$($property.Type)"
                        }
                    }

                }
            }
        }


        $propertiesValues = @()
        foreach ($declaredProperty in $declaredProperties)
        {
            if (-not [String]::IsNullOrEmpty($declaredProperty.Name))
            {

                $propertyIsArray = $false
                $currentProperty = @{}
                $currentProperty.Add('Name', $declaredProperty.Name)
                $parameterDescription = ($PropertiesDefinitions | Where-Object -FilterScript { $_.id -like "*$($declaredProperty.Name)*" }).description
                if (-not [String]::IsNullOrEmpty($parameterDescription))
                {
                    $parameterDescription = $parameterDescription -replace [regex]::Escape('"'), "'"
                    $parameterDescription = $parameterDescription -replace [regex]::Escape([char]0x2019), "'"
                    $parameterDescription = $parameterDescription.TrimStart()
                    $parameterDescription = $parameterDescription.TrimEnd()
                }
                $currentProperty.Add('Description', $parameterDescription)

                #Renaming Collection type {C(typeName)} to typeName[]
                if ($declaredProperty.propertyType -like 'C(*)')
                {
                    $declaredProperty.propertyType = $declaredProperty.propertyType.Replace('c(', '').replace(')', '')
                    $declaredProperty.propertyType = Get-M365DSCDRGParameterType -Type $declaredProperty.propertyType
                    if ($declaredProperty.propertyType -notlike 'System.*')
                    {
                        $declaredProperty.propertyType = "microsoft.graph.powershell.models.imicrosoftgraph$($declaredProperty.propertyType)"
                    }
                    $declaredProperty.propertyType = $declaredProperty.propertyType + '[]'
                    #write-host -Object ($declaredProperty.name +": "+$declaredProperty.propertyType) -ForegroundColor Red
                }

                #Retrieve Enum members or format Complextype and retrieve  properties from CmdletDefinition
                if ($declaredProperty.propertyType.toString() -notlike 'System.*' -and $declaredProperty.propertyType.toString() -notlike 'microsoft.graph.powershell.models.*')
                {
                    #write-host ($declaredProperty|out-string) -f Yellow

                    $propertyTypeName = $declaredProperty.propertyType.Replace('[]', '')
                    $enum = Get-EnumTypeDefinition -CmdletDefinition $CmdletDefinition -ComplexTypeName $propertyTypeName
                    if ($enum -and -not $declaredProperty.Members)
                    {
                        $declaredProperty.add('Members', $enum.Members)
                    }
                    #write-host -object ($propertyTypeName|out-string ) -f Green

                    $complex = Get-ComplexTypeDefinition `
                        -CmdletDefinition $CmdletDefinition `
                        -ComplexTypeName $propertyTypeName
                    if ($complex)
                    {
                        $declaredProperty.propertyType = $declaredProperty.propertyType.replace($propertyTypeName, "microsoft.graph.powershell.models.imicrosoftgraph$propertyTypeName")
                        $declaredProperty.add('Properties', $complex)
                    }
                    #write-host -object ($complex|out-string ) -f Yellow
                    #write-host -object ($declaredProperty|out-string ) -f Red
                }

                if ($declaredProperty.PropertyType.ToString().EndsWith('[]'))
                {
                    $propertyIsArray = $true
                }
                $currentProperty.Add('IsArray', $propertyIsArray)

                if ($declaredProperty.Members)
                {
                    $currentProperty.Add('Members', $declaredProperty.Members)
                }

                $propertyType = $declaredProperty.PropertyType -replace 'System.Nullable`1', ''
                $propertyType = $propertyType -replace [regex]::escape('['), ''
                $propertyType = $propertyType -replace [regex]::escape(']'), ''
                $propertyType = Get-M365DSCDRGParameterType -Type $propertyType

                if ($propertyType.StartsWith('microsoft.graph.powershell.models.'))
                {
                    if ($script:DiscoveredComplexTypes -notcontains $propertyType)
                    {
                        $subProperties = @{Type = $propertyType }
                        $subProperties.add('Name', $declaredProperty.Name)

                        $subResult = Get-M365DSCDRGCimInstances -Workload $Workload `
                            -ResourceName $ResourceName `
                            -Properties $subProperties `
                            -CmdletDefinition $CmdletDefinition `
                            -DiscoveredComplexTypes $DiscoveredComplexTypes `
                            -PropertiesDefinitions $PropertiesDefinitions
                        $currentProperty.Add('NestedCIM', $subResult)
                    }
                }
                $currentProperty.Add('Type', $propertyType)
                $propertiesValues += $currentProperty
            }
        }
        $currentInstance.Add('Properties', $propertiesValues)
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
    $schemaProperties = ''
    $Properties | ForEach-Object -Process {
        if ($_.Name -ne 'LastModifiedDateTime' -and $_.Name -ne 'CreatedDateTime')
        {
            if ($_.Type.ToString().ToLower().StartsWith('microsoft.graph.powershell.models.'))
            {
                $propertyType = $_.Type -replace 'microsoft.graph.powershell.models.', ''
                $propertyType = $propertyType -replace 'imicrosoftgraph', ''
                $propertyType = $Workload + $propertyType
                $propertyType = $propertyType -replace '[[\]]', ''
                $schemaProperties += "    [Write, Description(`"$($_.Description)`"), EmbeddedInstance(`"MSFT_$propertyType`")] String $($_.Name)"
                if ($_.Type.EndsWith('[]'))
                {
                    $schemaProperties += '[]'
                }
                $schemaProperties += ";`r`n"
            }
            else
            {
                $propertyType = Get-M365DSCDRGParameterTypeForSchema -Type $_.Type
                $propertySet = ''
                if ($null -ne $_.Members)
                {
                    $mySet = ''
                    foreach ($member in $_.Members)
                    {
                        $mySet += "`"" + $member + "`","
                    }
                    $mySet = $mySet.Substring(0, $mySet.Length - 1)
                    $propertySet = ", ValueMap{$mySet}, Values{$mySet}"
                }
                $schemaProperties += "    [Write, Description(`"$($_.Description)`")$propertySet] $($propertyType) $($_.Name)"
                if ($_.Type.EndsWith('[]'))
                {
                    $schemaProperties += '[]'
                }
                $schemaProperties += ";`r`n"
            }
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
        $Path,

        [Parameter()]
        [System.String]
        $Workload = "MicrosoftGraph"
    )
    $filePath = "$Path\MSFT_$ResourceName\MSFT_$($ResourceName).psm1"
    if ($workload -eq 'Microsoft.Graph')
    {
        Copy-Item -Path .\Module.Template.psm1 -Destination $filePath
    }
    else
    {
        Copy-Item -Path .\Module.Workloads.Template.psm1 -Destination $filePath
    }
    return $filePath
}

function New-M365DSCExampleFile
{
    param(
        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $Path
    )
    Export-M365DSCConfiguration -Credential $Credential `
        -Components $ResourceName -Path (Join-Path -Path $Path -ChildPath $ResourceName) `
        -FileName "$ResourceName.ps1" `
        -ConfigurationName 'Example'
    Remove-Item (Join-Path -Path (Join-Path -Path $Path -ChildPath $ResourceName) -ChildPath 'ConfigurationData.psd1')
    Remove-Item (Join-Path -Path (Join-Path -Path $Path -ChildPath $ResourceName) -ChildPath '*.cer')

    # Cleanup
    $unitTestFilePath = Join-Path -Path $Path -ChildPath "$ResourceName/$ResourceName.ps1"
    $sr = [System.IO.StreamReader]::New($unitTestFilePath)
    $sb = [System.Text.StringBuilder]::New()

    while ($line = $sr.ReadLine())
    {
        if (-not $line.StartsWith('#'))
        {
            if ($line.Contains('Import-DscResource '))
            {
                $sb.AppendLine("    Import-DscResource -ModuleName 'Microsoft365DSC'") | Out-Null
            }
            else
            {
                $sb.AppendLine($line) | Out-Null
            }
        }
    }
    $sr.Close()
    $sb.ToString() | Out-File $unitTestFilePath
}
function New-M365DSCUnitTest
{
    param (
        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.String]
        $Path
    )
    $filePath = "$Path\Microsoft365DSC.$($ResourceName).Tests.ps1"
    Copy-Item -Path .\UnitTest.Template.ps1 -Destination $filePath

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
        $Path,

        [Parameter()]
        [System.String]
        $Workload = 'MicrosoftGraph'
    )
    $filePath = "$Path\MSFT_$ResourceName\MSFT_$($ResourceName).schema.mof"
    if ($Workload -eq 'MicrosoftGraph')
    {
        Copy-Item -Path .\Schema.Template.mof -Destination $filePath
    }
    else
    {
        Copy-Item -Path .\Schema.Workloads.Template.mof -Destination $filePath
    }

    return $filePath
}

function New-M365DSCSettingsFile
{
    param (
        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.String]
        $Path
    )
    $filePath = "$Path\MSFT_$ResourceName\settings.json"
    Copy-Item -Path .\settings.template.json -Destination $filePath

    return $filePath
}

function New-M365DSCReadmeFile
{
    param (
        [Parameter()]
        [System.String]
        $ResourceName,

        [Parameter()]
        [System.String]
        $Path
    )
    $filePath = "$Path\MSFT_$ResourceName\readme.md"
    Copy-Item -Path .\readme.template.md -Destination $filePath

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
        [System.Object]
        $DefaultParameterSetProperties
    )

    $newCmdlet = Get-Command "New-$GraphNoun"

    $results = @{}
    $hashtable = ''
    $complexTypeContent = ''
    $convertToString = ''
    $convertToVariable = ''
    $addtionalProperties = ''
    foreach ($property in $properties)
    {
        $cmdletParameter = $DefaultParameterSetProperties | Where-Object -FilterScript { $_.Name -eq $property.Name }
        if ($null -eq $cmdletParameter)
        {
            $UseAddtionalProperties = $true
        }
        if ($property.Name -ne 'CreatedDateTime' -and $property.Name -ne 'LastModifiedDateTime')
        {
            $paramType = $property.Type
            $parameterName = $property.Name

            if ($paramType.ToLower().StartsWith('microsoft.graph.powershell.models.'))
            {
                $CimInstanceName = $paramType -replace 'Microsoft.Graph.PowerShell.Models.IMicrosoftGraph', ''
                $CimInstanceName = $CimInstanceName -replace '[[\]]', ''
                $CimInstanceName = $Workload + $CimInstanceName

                if ($UseAddtionalProperties)
                {
                    $propertyName = $property.Name
                    $propertyNameFirstLetter = $property.Name.Substring(0, 1)
                    $propertyNameFirstLetter = $propertyNameFirstLetter.ToLower()
                    $propertyNameCamelCaseString = $propertyName.Substring(1)
                    $propertyName = "$($propertyNameFirstLetter)$($propertyNameCamelCaseString)"
                    $complexTypeContent += "        if (`$getValue.additionalProperties.$propertyName)`r`n"
                    $complexTypeContent += "        {`r`n"
                    $complexTypeContent += "            `$results.Add(`"$parameterName`", `$getValue.additionalProperties.$propertyName)`r`n"
                    $complexTypeContent += "        }`r`n"
                    $addtionalProperties += "        `"$($property.Name)`"`r`n"
                }
                else
                {
                    $complexTypeContent += "        if (`$getValue.$($property.Name))`r`n"
                    $complexTypeContent += "        {`r`n"
                    $complexTypeContent += "            `$results.Add(`"$parameterName`", (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject `$getValue.$($property.Name)))`r`n"
                    $complexTypeContent += "        }`r`n"
                }



                $convertToString += "        if (`$Results.$parameterName)`r`n"
                $convertToString += "        {`r`n"
                $convertToString += "            `$complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject `$Results.$parameterName -CIMInstanceName $CimInstanceName`r`n"
                $convertToString += "            if (`$complexTypeStringResult)`r`n"
                $convertToString += "            {`r`n"
                $convertToString += "                `$Results.$parameterName = `$complexTypeStringResult`r`n"
                $convertToString += "            }`r`n"
                $convertToString += "            else`r`n"
                $convertToString += "            {`r`n"
                $convertToString += "                `$Results.Remove('$parameterName') | Out-Null`r`n"
                $convertToString += "            }`r`n"
                $convertToString += "        }`r`n"

                $convertToVariable += "        if (`$Results.$parameterName)`r`n"
                $convertToVariable += "        {`r`n"
                $convertToVariable += "            `$isCIMArray=`$false`r`n"
                $convertToVariable += "            if(`$Results.$parameterName.getType().Fullname -like `"*[[\]]`")`r`n"
                $convertToVariable += "            {`r`n"
                $convertToVariable += "                `$isCIMArray=`$true`r`n"
                $convertToVariable += "            }`r`n"
                $convertToVariable += "            `$currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock `$currentDSCBlock -ParameterName `"$parameterName`" -isCIMArray:`$isCIMArray`r`n"
                $convertToVariable += "        }`r`n"


            }
            else
            {
                if ($UseAddtionalProperties)
                {
                    $propertyName = $property.Name
                    $propertyNameFirstLetter = $property.Name.Substring(0, 1)
                    $propertyNameFirstLetter = $propertyNameFirstLetter.ToLower()
                    $propertyNameCamelCaseString = $propertyName.Substring(1)
                    $propertyName = "$($propertyNameFirstLetter)$($propertyNameCamelCaseString)"
                    $hashtable += "            $($parameterName) = `$getValue.AdditionalProperties.$($propertyName) `r`n"
                    $addtionalProperties += "        `"$($property.Name)`"`r`n"
                }
                else
                {
                    $hashtable += "            $($parameterName) = `$getValue.$($property.Name) `r`n"
                }
            }
        }
    }

    $results.Add('ConvertToVariable', $convertToVariable)
    $results.Add('addtionalProperties', $addtionalProperties)
    $results.Add('ConvertToString', $convertToString)
    $results.Add('StringContent', $hashtable)
    $results.Add('ComplexTypeContent', $complexTypeContent)
    return $results
}

function Get-ParameterBlockStringForModule
{
    param (
        [Parameter()]
        [Object[]]
        $ParameterBlockInformation
    )

    $parameterBlockOutput = ''
    $ParameterBlockInformation | ForEach-Object -Process {
        if ($_.Name -ne 'LastModifiedDateTime' -and $_.Name -ne 'CreatedDateTime')
        {
            $parameterBlockOutput += "        $($_.Attribute)`r`n"
            if ($null -ne $_.Members)
            {
                $validateSet = '[ValidateSet('
                foreach ($member in $_.Members)
                {
                    $validateSet += "'" + $member + "',"
                }
                $validateSet = $validateSet.substring(0, $validateSet.length - 1)
                $validateSet += ')]'
                $parameterBlockOutput += "        $($ValidateSet)`r`n"
            }
            $propertyType = $_.Type.ToString()
            if ($propertyType.StartsWith('microsoft.graph.powershell.models.'))
            {
                $parameterBlockOutput += '        [Microsoft.Management.Infrastructure.CimInstance'
            }
            elseif ($propertyType.ToLower() -eq 'system.management.automation.switchparameter')
            {
                $parameterBlockOutput += '        [System.Boolean'
            }
            else
            {
                $parameterBlockOutput += "        [$($_.Type.replace('[]',''))"
            }
            if ($_.Type.ToString().EndsWith('[]'))
            {
                $parameterBlockOutput += '[]'
            }
            $parameterBlockOutput += "]`r`n"
            $parameterBlockOutput += "        `$$($_.Name),`r`n"
            $parameterBlockOutput += "`r`n"
        }
    }
    return $parameterBlockOutput
}

Export-ModuleMember -Function Get-MgGraphModuleCmdLetDifference, New-M365DSCResourceForGraphCmdLet, New-M365DSCResource, *
