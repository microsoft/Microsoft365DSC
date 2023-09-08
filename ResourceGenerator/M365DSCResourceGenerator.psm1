
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
        [System.String]
        $DateFormat="o",

        # Use this switch with caution.
        # Navigation Properties could cause the DRG to enter an infinite loop
        # Navigation Properties are the properties refered as Relationships in the Graph REST API documentation.
        # Only include if it contains a property which is NOT read-only.
        [Parameter()]
        [System.Boolean]
        $IncludeNavigationProperties=$false,

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

    $graphWorkloads=@('MicrosoftGraph','Intune')
    if ($Workload -in $graphWorkloads)
    {
        $Global:CIMInstancesAlreadyFound = @()
        $GetcmdletName = "Get-$CmdLetNoun"
        $commandDetails = Find-MgGraphCommand -Command $GetcmdletName -ApiVersion $APIVersion -ErrorAction SilentlyContinue
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

        $cmdletFound = Get-Command $GetcmdletName -ErrorAction SilentlyContinue
        $GraphModule = $cmdletFound.ModuleName
        Import-Module $GraphModule -ErrorAction Stop
        $commandDetails = Find-MgGraphCommand -Command $GetcmdletName -ApiVersion $ApiVersion

        $cmdletCommandDetails = Get-Command -Name "$($CmdLetVerb)-$($CmdLetNoun)" -Module $GraphModule
        $defaultParameterSet = $cmdletCommandDetails.ParameterSets | Where-Object -FilterScript { $_.IsDefault -eq $true }

        $defaultParameterSetProperties = $defaultParameterSet.Parameters
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

        $cmdletDefinition = Get-CmdletDefinition -Entity $actualType `
            -APIVersion $ApiVersion

        #Check if the actual type returns multiple type of policies
        $policyTypes=($cmdletDefinition.EntityType|Where-Object -FilterScript {$_.basetype -like "*$actualType"}).Name
        if ($null -ne $policyTypes -and $policyTypes.GetType().Name -like '*[[\]]')
        {
            if ([String]::IsNullOrEmpty($AdditionalPropertiesType))
            {
                $policyTypeChoices = @()
                for ($i = 0; $i -lt $policyTypes.Count; $i++)
                {
                    $policyTypeChoices += [System.Management.Automation.Host.ChoiceDescription]("$($policyTypes[$i])")
                }
                $typeChoice = $host.UI.PromptForChoice('Additional Type Information', 'Please select an addtional type', $policyTypeChoices, 0) + 1


                $selectedODataType = $policyTypes[$typeChoice - 1]
            }
            else
            {
                $selectedODataType = $policyTypes | Where-Object -FilterScript { $_ -eq $AdditionalPropertiesType }
                if ([String]::IsNullOrEmpty($selectedODataType))
                {
                    $selectedODataType = $AdditionalPropertiesType
                }
            }
            $isAdditionalProperty = $true
        }
        else
        {
            $selectedODataType = $actualType
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

        $global:ComplexList=@()
        $cimClasses = Get-Microsoft365DSCModuleCimClass -ResourceName $ResourceName
        $global:searchedEntity = $selectedODataType
        $typeProperties = Get-TypeProperties `
            -CmdletDefinition $cmdletDefinition `
            -Entity $selectedODataType `
            -IncludeNavigationProperties $IncludeNavigationProperties `
            -CimClasses $cimClasses `
            -Workload $Workload
        $global:ComplexList = $null
        $global:searchedEntity = $null
        [Hashtable[]]$parameterInformation = Get-ParameterBlockInformation `
            -Properties $typeProperties `
            -DefaultParameterSetProperties $defaultParameterSetProperties

        #retrieve assignment details
        if ($Workload -in @('Intune', 'MicrosoftGraph'))
        {
            $repository=($commandDetails|where-Object -filterScript {$_.variants -eq 'List'}).URI
            $repository=$repository.Substring(1,($repository.Length - 1))
            $assignmentCmdlet=Get-Command ($cmdletFound.Name+'Assignment') -Module $GraphModule -ErrorAction SilentlyContinue
            $assignmentCmdletNoun = $assignmentCmdlet.Noun
            $assignmentKey = (($assignmentCmdlet.ParameterSets|where-Object -filterScript {$_.Name -eq 'List'}).Parameters | where-Object -filterScript {$_.IsMandatory}).Name
            if (-not [String]::IsNullOrWhiteSpace($repository) `
                -and -not [String]::IsNullOrWhiteSpace($assignmentCmdletNoun) `
                -and -not [String]::IsNullOrWhiteSpace($assignmentKey))
            {
                $addIntuneAssignments = $true
                $ParametersToSkip += 'Assignments'
            }
        }
        $parameterInformation = $parameterInformation | Where-Object -FilterScript {$_.Name -notin $ParametersToSkip}

        $script:DiscoveredComplexTypes = @()

        [Array]$CimInstances = $parameterInformation | Where-Object -FilterScript { $_.IsComplexType }

        $script:DiscoveredComplexTypes = $null

        $Global:AlreadyFoundInstances = @()

        $CimInstancesSchemaContent = ''
        if ($null -ne $CimInstances)
        {
            foreach ($CimInstance in $CimInstances)
            {
                $CimInstancesSchemaContent += Get-M365DSCDRGCimInstancesSchemaStringContent `
                    -CIMInstance $CimInstance `
                    -Workload $Workload
            }
        }

        $Global:AlreadyFoundInstances = $null

        $parameterString = Get-ParameterBlockStringForModule -ParameterBlockInformation $parameterInformation
        $hashtableResults = New-M365HashTableMapping -Properties $parameterInformation `
            -DefaultParameterSetProperties $defaultParameterSetProperties `
            -GraphNoun $CmdLetNoun `
            -Workload $Workload `
            -DateFormat $DateFormat
        $hashTableMapping = $hashtableResults.StringContent

        #region UnitTests
        $fakeValues = Get-M365DSCFakeValues `
            -ParametersInformation $parameterInformation `
            -IntroduceDrift $false `
            -Workload $Workload `
            -AdditionalPropertiesType $selectedODataType `
            -DateFormat $DateFormat
        $targetResourceFakeValues = Get-M365DSCFakeValues `
            -ParametersInformation $parameterInformation `
            -IntroduceDrift $false `
            -Workload $Workload `
            -IsGetTargetResource $true `
            -DateFormat $DateFormat

        $fakeValuesString = Get-M365DSCHashAsString -Values $fakeValues
        $targetResourceFakeValuesString = Get-M365DSCHashAsString -Values $targetResourceFakeValues -Space '                    '
        $assignmentMock = ''
        if ($addIntuneAssignments)
        {
            $assignmentMock = "`r`n`r`n            Mock -CommandName Get-$assignmentCmdletNoun -MockWith {`r`n"
            $assignmentMock += "            }`r`n"
        }

        Write-TokenReplacement -Token '<AssignmentMock>' -value $assignmentMock -FilePath $unitTestPath
        Write-TokenReplacement -Token '<FakeValues>' -value $fakeValuesString -FilePath $unitTestPath
        Write-TokenReplacement -Token '<TargetResourceFakeValues>' -value $targetResourceFakeValuesString -FilePath $unitTestPath
        $fakeValues2 = $fakeValues
        $fakeValuesString2 = Get-M365DSCHashAsString -Values $fakeValues2 -isCmdletCall $true
        Write-TokenReplacement -Token '<FakeValues2>' -value $fakeValuesString2 -FilePath $unitTestPath

        $fakeDriftValues = Get-M365DSCFakeValues -ParametersInformation $parameterInformation `
            -IntroduceDrift $true `
            -isCmdletCall $true `
            -AdditionalPropertiesType $AdditionalPropertiesType `
            -Workload $Workload `
            -DateFormat $DateFormat
        $fakeDriftValuesString = Get-M365DSCHashAsString -Values $fakeDriftValues -isCmdletCall $true
        Write-TokenReplacement -Token '<DriftValues>' -value $fakeDriftValuesString -FilePath $unitTestPath
        Write-TokenReplacement -Token '<ResourceName>' -value $ResourceName -FilePath $unitTestPath

        Write-TokenReplacement -Token '<GetCmdletName>' -value $GetcmdletName -FilePath $unitTestPath
        $updateVerb='Update'
        $updateCmdlet=Find-MgGraphCommand -Command "$updateVerb-$CmdLetNoun" -ApiVersion $ApiVersion -errorAction SilentlyContinue
        if ($null -eq $updateCmdlet)
        {
            $updateVerb='Set'
        }
        Write-TokenReplacement -Token '<SetCmdletName>' -value "$updateVerb-$($CmdLetNoun)" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<RemoveCmdletName>' -value "Remove-$($CmdLetNoun)" -FilePath $unitTestPath
        Write-TokenReplacement -Token '<NewCmdletName>' -value "New-$($CmdLetNoun)" -FilePath $unitTestPath
        Update-Microsoft365StubFile -CmdletNoun $CmdLetNoun
        if ($addIntuneAssignments)
        {
            Update-Microsoft365StubFile -CmdletNoun $assignmentCmdletNoun
        }
        #endregion
        #region Module
        $platforms = @{
            'Windows10' = 'for Windows10'
            'Android' = 'for Android'
            'Mac O S' = 'for macOS'
            'I O S' = 'for iOS'
            'A A D' = 'Azure AD'
        }
        $resourceDescription = ($ResourceName -split '_')[0] -creplace '(?<=\w)([A-Z])', ' $1'
        foreach ($platform in $platforms.keys)
        {
            if ($resourceDescription -like "*$platform*")
            {
                $resourceDescription = $resourceDescription.replace($platform, $platforms.$platform)
            }
            $resourceDescription = $resourceDescription.Replace('Azure A D','Azure AD')
        }

        $getCmdlet = Get-Command -Name "Get-$($CmdLetNoun)" -Module $GraphModule
        $getDefaultParameterSet = $getCmdlet.ParameterSets | Where-Object -FilterScript { $_.Name -eq 'Get' }
        $getKeyIdentifier = ($getDefaultParameterSet.Parameters | Where-Object -FilterScript { $_.IsMandatory }).Name

        if ([String]::isNullOrEmpty($getKeyIdentifier))
        {
            $getDefaultParameterSet = $getCmdlet.ParameterSets | Where-Object -FilterScript { $_.IsDefault }
            $getKeyIdentifier = ($getDefaultParameterSet.Parameters | Where-Object -FilterScript { $_.IsMandatory }).Name
        }

        $primaryKey = ''
        $alternativeKey = ''
        if ($typeProperties.Name -contains 'id')
        {
            $primaryKey = 'Id'
            $alternativeKey = 'DisplayName'
            if ($typeProperties.Name -contains 'name')
            {
                $alternativeKey = 'Name'
            }
        }

        if ($null -ne $getKeyIdentifier )
        {
            $getParameterString = [System.Text.StringBuilder]::New()
            foreach ($key in $getKeyIdentifier )
            {
                if ($getKeyIdentifier.Count -gt 1)
                {
                    $getParameterString.append("```r`n") |out-null
                    $getParameterString.append("            ") |out-null
                }
                $keyValue = $key
                if ($key -eq "$($actualtype)Id")
                {
                    $keyValue = $primaryKey
                }
                $getParameterString.append("-$key `$$keyValue ") |out-null
            }
            [String]$getKeyIdentifier = $getParameterString.ToString()
        }

        $getDefaultParameterSet = $getCmdlet.ParameterSets | Where-Object -FilterScript { $_.Name -eq 'List' }
        $getListIdentifier =$getDefaultParameterSet.Parameters.Name
        $getAlternativeFilterString = [System.Text.StringBuilder]::New()
        if ($getListIdentifier -contains 'Filter')
        {
            $getAlternativeFilterString.appendline("                    -Filter `"$alternativeKey eq '`$$alternativeKey'`" ``")|out-null
            $getAlternativeFilterString.appendline("                    -ErrorAction SilentlyContinue | Where-Object ``")|out-null
            $getAlternativeFilterString.appendline("                    -FilterScript { ``")|out-null
            $getAlternativeFilterString.appendline("                        `$_.AdditionalProperties.'@odata.type' -eq `"`#microsoft.graph.$SelectedODataType`" ``")|out-null
            $getAlternativeFilterString.append("                    }")|out-null
        }
        else
        {
            $getAlternativeFilterString.appendline("                    -ErrorAction SilentlyContinue | Where-Object ``")|out-null
            $getAlternativeFilterString.appendline("                    -FilterScript { ``")|out-null
            $getAlternativeFilterString.appendline("                        `$_.$alternativeKey -eq `"`$(`$$alternativeKey)`" ``")|out-null
            $getAlternativeFilterString.appendline("                        -and `$_.AdditionalProperties.'@odata.type' -eq `"`#microsoft.graph.$SelectedODataType`" ``")|out-null
            $getAlternativeFilterString.append("                    }")|out-null
        }
        Write-TokenReplacement -Token '<AlternativeFilter>' -Value $getAlternativeFilterString.ToString() -FilePath $moduleFilePath

        Write-TokenReplacement -Token '<ParameterBlock>' -Value $parameterString -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#Workload#>' -Value $Workload -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#APIVersion#>' -Value $ApiVersion -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<PrimaryKey>' -Value $primaryKey -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<getKeyIdentifier>' -Value $getKeyIdentifier  -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<GetCmdLetName>' -Value "Get-$($CmdLetNoun)" -FilePath $moduleFilePath

        $complexTypeConstructor=""
        if (-Not [String]::IsNullOrEmpty($hashtableResults.ComplexTypeConstructor))
        {
            $complexTypeConstructor = $hashtableResults.ComplexTypeConstructor
            $complexTypeConstructor = "`r`n        #region resource generator code`r`n" + $complexTypeConstructor
            $complexTypeConstructor = $complexTypeConstructor.Substring(0, $complexTypeConstructor.Length -2)
            $complexTypeConstructor = $complexTypeConstructor + "        #endregion`r`n"
        }
        Write-TokenReplacement -Token '<ComplexTypeConstructor>' -Value $complexTypeConstructor -FilePath $moduleFilePath

        $enumTypeConstructor=""
        if (-Not [String]::IsNullOrEmpty($hashtableResults.EnumTypeConstructor))
        {
            $enumTypeConstructor = $hashtableResults.EnumTypeConstructor
            $enumTypeConstructor = "`r`n        #region resource generator code`r`n" + $enumTypeConstructor
            $enumTypeConstructor = $enumTypeConstructor.Substring(0, $enumTypeConstructor.Length -2)
            $enumTypeConstructor = $enumTypeConstructor + "        #endregion`r`n"
        }
        Write-TokenReplacement -Token '<EnumTypeConstructor>' -Value $enumTypeConstructor -FilePath $moduleFilePath

        $dateTypeConstructor=""
        if (-Not [String]::IsNullOrEmpty($hashtableResults.DateTypeConstructor))
        {
            $dateTypeConstructor = $hashtableResults.DateTypeConstructor
            $dateTypeConstructor = "`r`n        #region resource generator code`r`n" + $dateTypeConstructor
            $dateTypeConstructor = $dateTypeConstructor.Substring(0, $dateTypeConstructor.Length -2)
            $dateTypeConstructor = $dateTypeConstructor + "        #endregion`r`n"
        }
        Write-TokenReplacement -Token '<DateTypeConstructor>' -Value $dateTypeConstructor -FilePath $moduleFilePath

        $timeTypeConstructor=""
        if (-Not [String]::IsNullOrEmpty($hashtableResults.TimeTypeConstructor))
        {
            $timeTypeConstructor = $hashtableResults.TimeTypeConstructor
            $timeTypeConstructor = "`r`n        #region resource generator code`r`n" + $timeTypeConstructor
            $timeTypeConstructor = $timeTypeConstructor.Substring(0, $timeTypeConstructor.Length -2)
            $timeTypeConstructor = $timeTypeConstructor + "        #endregion`r`n"
        }
        Write-TokenReplacement -Token '<TimeTypeConstructor>' -Value $timeTypeConstructor -FilePath $moduleFilePath


        $newCmdlet = Get-Command -Name "New-$($CmdLetNoun)"
        $newDefaultParameterSet = $newCmdlet.ParameterSets | Where-Object -FilterScript { $_.Name -eq 'Create' }
        [Array]$newKeyIdentifier = ($newDefaultParameterSet.Parameters | Where-Object -FilterScript { $_.IsMandatory }).Name

        if ($null -ne $newKeyIdentifier )
        {
            $newParameterString = [System.Text.StringBuilder]::New()
            foreach ($key in $newKeyIdentifier )
            {
                if ($newKeyIdentifier.Count -gt 1)
                {
                    $newParameterString.append(" ```r`n") |out-null
                    $newParameterString.append("            ") |out-null
                }
                $keyValue = $key
                if ($key -eq 'BodyParameter')
                {
                    $keyValue = 'CreateParameters'
                }
                $newParameterString.append("-$key `$$keyValue") |out-null
            }
            [String]$newKeyIdentifier = $newParameterString.ToString()
        }
        $odataType=$null
        if ($true)#$isAdditionalProperty)
        {
            $odataType="        `$CreateParameters.Add(`"@odata.type`", `"#microsoft.graph.$SelectedODataType`")`r`n"
        }
        Write-TokenReplacement -Token '<NewDataType>' -Value "$odataType" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#NewKeyIdentifier#>' -Value $newKeyIdentifier -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<NewCmdLetName>' -Value "New-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<SetCmdLetName>' -Value "Set-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<RemoveCmdLetName>' -Value "Remove-$($CmdLetNoun)" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<ResourceDescription>' -Value $resourceDescription -FilePath $moduleFilePath

        Write-TokenReplacement -Token '<FilterKey>' -Value $alternativeKey -FilePath $moduleFilePath
        $exportGetCommand = [System.Text.StringBuilder]::New()
        $exportGetCommand.AppendLine("        [array]`$getValue = Get-$CmdLetNoun ``") |out-null
        if ($getDefaultParameterSet.Parameters.Name -contains "All")
        {
            $exportGetCommand.AppendLine("            -All ``")|out-null
        }
        if ($isAdditionalProperty)
        {
            $exportGetCommand.AppendLine("            -ErrorAction Stop | Where-Object ``")|out-null
            $exportGetCommand.AppendLine("            -FilterScript { ``")|out-null
            $exportGetCommand.AppendLine("                `$_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.$($selectedODataType)' ``")|out-null
            $exportGetCommand.AppendLine("            }")|out-null
        }
        else
        {
            $exportGetCommand.AppendLine("            -ErrorAction Stop")|out-null
        }

        $trailingCharRemoval=""
        if ($cimInstances.count -gt 0)
        {
            $trailingCharRemoval=@'
'@
        }
        $requiredKey = ''
        if (-not [String]::IsNullOrEmpty($alternativeKey))
        {
            $requiredKey = "`r`n                DisplayName           =  `$config.DisplayName"
        }
        Write-TokenReplacement -Token '<exportGetCommand>' -Value $exportGetCommand.ToString() -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<RequiredKey>' -Value $requiredKey -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<HashTableMapping>' -Value $hashTableMapping -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#ComplexTypeContent#>' -Value $hashtableResults.ComplexTypeContent -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#ConvertComplexToString#>' -Value $hashtableResults.ConvertToString -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#ConvertComplexToVariable#>' -Value $hashtableResults.ConvertToVariable -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#TrailingCharRemoval#>' -Value $trailingCharRemoval -FilePath $moduleFilePath

        $updateVerb='Update'
        $updateCmdlet=Find-MgGraphCommand -Command "$updateVerb-$CmdLetNoun" -ApiVersion $ApiVersion -errorAction SilentlyContinue
        if ($null -eq $updateCmdlet)
        {
            $updateVerb='Set'
        }
        $updateCmdlet = Get-Command -Name "$updateVerb-$CmdLetNoun"
        $updateDefaultParameterSet = $updateCmdlet.ParameterSets | Where-Object -FilterScript { $_.Name -eq "$updateVerb" }
        [Array]$updateKeyIdentifier = ($updateDefaultParameterSet.Parameters | Where-Object -FilterScript { $_.IsMandatory }).Name

        if ($null -ne $updateKeyIdentifier )
        {
            $updateParameterString = [System.Text.StringBuilder]::New()
            foreach ($key in $updateKeyIdentifier )
            {
                if ($updateKeyIdentifier.Count -gt 1)
                {
                    $updateParameterString.append(" ```r`n") |out-null
                    $updateParameterString.append("            ") |out-null
                }
                $keyValue = $key
                if ($key -eq 'BodyParameter')
                {
                    $keyValue = 'UpdateParameters'
                }
                if ($key -eq "$($actualtype)Id")
                {
                    $keyValue = 'currentInstance.'+$primaryKey
                }
                $updateParameterString.append("-$key `$$keyValue") |out-null
            }
            [String]$updateKeyIdentifier = $updateParameterString.ToString()
        }
        $odataType=$null
        if ($true)#$isAdditionalProperty)
        {
            $odataType="        `$UpdateParameters.Add(`"@odata.type`", `"#microsoft.graph.$SelectedODataType`")`r`n"
        }
        Write-TokenReplacement -Token '<UpdateDataType>' -Value "$odataType" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<UpdateCmdLetName>' -Value "$updateVerb-$CmdLetNoun" -FilePath $moduleFilePath
        Write-TokenReplacement -Token '<#UpdateKeyIdentifier#>' -Value $updateKeyIdentifier -FilePath $moduleFilePath

        $removeCmdlet = Get-Command -Name "Remove-$($CmdLetNoun)"
        $removeDefaultParameterSet = $removeCmdlet.ParameterSets | Where-Object -FilterScript { $_.Name -eq 'Delete' }
        [Array]$removeKeyIdentifier = ($removeDefaultParameterSet.Parameters | Where-Object -FilterScript { $_.IsMandatory }).Name

        if ($null -ne $removeKeyIdentifier )
        {
            $removeParameterString = [System.Text.StringBuilder]::New()
            foreach ($key in $removeKeyIdentifier )
            {
                if ($removeKeyIdentifier.Count -gt 1)
                {
                    $removeParameterString.append(" ```r`n") |out-null
                    $removeParameterString.append("            ") |out-null
                }
                $keyValue = $key
                if ($removeKeyIdentifier.Count -eq 1)
                {
                    $keyValue='currentInstance.'+$primaryKey
                }
                $removeParameterString.append("-$key `$$keyValue") |out-null
            }
            [String]$removeKeyIdentifier = $removeParameterString.ToString()
        }

        Write-TokenReplacement -Token '<#removeKeyIdentifier#>' -Value $removeKeyIdentifier -FilePath $moduleFilePath

        #Intune Assignments
        if ($addIntuneAssignments -and -not [String]::IsNullOrEmpty($repository))
        {
            $AssignmentsParam += "        [Parameter()]`r`n"
            $AssignmentsParam += "        [Microsoft.Management.Infrastructure.CimInstance[]]`r`n"
            $AssignmentsParam += "        `$Assignments,`r`n"

            $AssignmentsGet += "        `$assignmentsValues = Get-$($assignmentCmdLetNoun) -$($assignmentKey) `$$primaryKey`r`n"
            $AssignmentsGet += "        `$assignmentResult = @()`r`n"
            $AssignmentsGet += "        foreach (`$assignmentEntry in `$AssignmentsValues)`r`n"
            $AssignmentsGet += "        {`r`n"
            $AssignmentsGet += "            `$assignmentValue = @{`r`n"
            $AssignmentsGet += "                dataType = `$assignmentEntry.Target.AdditionalProperties.'@odata.type'`r`n"
            $AssignmentsGet += "                deviceAndAppManagementAssignmentFilterType = `$(if (`$null -ne `$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType)`r`n"
            $AssignmentsGet += "                    {`$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterType.ToString()})`r`n"
            $AssignmentsGet += "                deviceAndAppManagementAssignmentFilterId = `$assignmentEntry.Target.DeviceAndAppManagementAssignmentFilterId`r`n"
            $AssignmentsGet += "                groupId = `$assignmentEntry.Target.AdditionalProperties.groupId`r`n"
            $AssignmentsGet += "            }`r`n"
            $AssignmentsGet += "            `$assignmentResult += `$assignmentValue`r`n"
            $AssignmentsGet += "        }`r`n"
            $AssignmentsGet += "        `$results.Add('Assignments', `$assignmentResult)`r`n"

            $AssignmentsRemove += "        `$BoundParameters.Remove(`"Assignments`") | Out-Null`r`n"

            $AssignmentsNew += "        `$assignmentsHash = @()`r`n"
            $AssignmentsNew += "        foreach (`$assignment in `$Assignments)`r`n"
            $AssignmentsNew += "        {`r`n"
            $AssignmentsNew += "            `$assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject `$Assignment`r`n"
            $AssignmentsNew += "        }`r`n"
            $AssignmentsNew += "`r`n"
            $AssignmentsNew += "        if (`$policy.id)`r`n"
            $AssignmentsNew += "        {`r`n"
            $AssignmentsNew += "            Update-DeviceConfigurationPolicyAssignment -DeviceConfigurationPolicyId  `$policy.id ```r`n"
            $AssignmentsNew += "                -Targets `$assignmentsHash ```r`n"
            $AssignmentsNew += "                -Repository '$repository'`r`n"
            $AssignmentsNew += "        }`r`n"

            $AssignmentsUpdate += "        `$assignmentsHash = @()`r`n"
            $AssignmentsUpdate += "        foreach (`$assignment in `$Assignments)`r`n"
            $AssignmentsUpdate += "        {`r`n"
            $AssignmentsUpdate += "            `$assignmentsHash += Get-M365DSCDRGComplexTypeToHashtable -ComplexObject `$Assignment`r`n"
            $AssignmentsUpdate += "        }`r`n"
            $AssignmentsUpdate += "        Update-DeviceConfigurationPolicyAssignment ```r`n"
            $AssignmentsUpdate += "            -DeviceConfigurationPolicyId `$currentInstance.id ```r`n"
            $AssignmentsUpdate += "            -Targets `$assignmentsHash ```r`n"
            $AssignmentsUpdate += "            -Repository '$repository'`r`n"

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
            if (`$Results.Assignments)
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
                `$currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock `$currentDSCBlock -ParameterName "Assignments" -isCIMArray:`$true
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
        #endregion
        #region Schema
        $schemaFilePath = New-M365DSCSchemaFile -ResourceName $ResourceName -Path $Path
        $schemaProperties = New-M365SchemaPropertySet -Properties $parameterInformation `
            -Workload $Workload

        Write-TokenReplacement -Token '<AssignmentsCIM>' -Value $AssignmentsCIM -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<AssignmentsProperty>' -Value $AssignmentsProperty -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<CIMInstances>' -Value $CimInstancesSchemaContent -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<FriendlyName>' -Value $ResourceName -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<ResourceName>' -Value $ResourceName -FilePath $schemaFilePath
        Write-TokenReplacement -Token '<Properties>' -Value $schemaProperties -FilePath $schemaFilePath
        #endregion
        #region Settings
        $resourcePermissions = (get-M365DSCResourcePermission `
            -Workload $Workload `
            -CmdLetNoun $CmdLetNoun `
            -ApiVersion $ApiVersion `
            -UpdateVerb $updateVerb).permissions | ConvertTo-Json -Depth 20
        $resourcePermissions = '    ' + $resourcePermissions
        Write-TokenReplacement -Token '<ResourceFriendlyName>' -Value $ResourceName -FilePath $settingsFilePath
        Write-TokenReplacement -Token '<ResourceDescription>' -Value $resourceDescription -FilePath $settingsFilePath
        Write-TokenReplacement -Token '<ResourcePermissions>' -Value $ResourcePermissions -FilePath $settingsFilePath
        #endregion
        #region ReadMe
        Write-TokenReplacement -Token '<ResourceFriendlyName>' -Value $ResourceName -FilePath $readmeFilePath
        Write-TokenReplacement -Token '<ResourceDescription>' -Value $resourceDescription -FilePath $readmeFilePath
        #endregion
        #region Examples
        if ($null -ne $Credential)
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
                if ([System.String]::IsNullOrEmpty($primaryKey) -or $property.Name -eq 'Identity')
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
                    if ($key -ne $primaryKey)
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
                    if ($key -ne $primaryKey)
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
                    if ($key -ne $primaryKey)
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
                    if ($key -ne $primaryKey)
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

        #region Generate Examples
        $exportPath = Join-Path -Path $env:temp -ChildPath $ResourceName
        Export-M365DSCConfiguration -Credential $Credential `
            -Components $ResourceName -Path $exportPath `
            -FileName "$ResourceName.ps1" `
            -ConfigurationName 'Example' | Out-Null

        $exportedFilePath = Join-Path -Path $exportPath -ChildPath "$ResourceName.ps1"
        $exportContent = Get-Content $exportedFilePath -Raw
        $start = $exportContent.IndexOf("`r`n        $ResourceName ")
        $end = $exportContent.IndexOf("`r`n        }", $start)
        $start = $exportContent.IndexOf("{", $start) + 1
        $exampleContent = $exportContent.Substring($start, $end-$start)

        $exampleFileFullPath = "$ExampleFilePath\$ResourceName\1-$ResourceName-Example.psm1"
        $folderPath = "$ExampleFilePath\$ResourceName"
        New-Item $folderPath -ItemType Directory -Force | Out-Null
        $templatePath = '.\Example.Template.ps1'
        Copy-Item -Path $templatePath -Destination $exampleFileFullPath -Force

        Write-TokenReplacement -Token '<FakeValues>' -Value $exampleContent -FilePath $exampleFileFullPath
        Write-TokenReplacement -Token '<ResourceName>' -Value $ResourceName -FilePath $exampleFileFullPath
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
        $Uri='https://raw.githubusercontent.com/microsoftgraph/msgraph-metadata/master/clean_v10_metadata/cleanMetadataWithDescriptionsAndAnnotationsv1.0.xml'
    }
    else
    {
        $Uri='https://raw.githubusercontent.com/microsoftgraph/msgraph-metadata/master/clean_beta_metadata/cleanMetadataWithDescriptionsAndAnnotationsbeta.xml'
    }

    $metadata=([XML](Invoke-RestMethod  -Uri $Uri)).Edmx.DataServices.schema
    return $metadata
}

# Retrieve all properties from metadata schema
function Get-TypeProperties
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $CmdletDefinition,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Entity,

        [Parameter()]
        [System.Boolean]
        $IncludeNavigationProperties=$false,

        [Parameter()]
        [System.String[]]
        $CimClasses,

        [Parameter()]
        [System.String]
        $Workload,

        [Parameter()]
        [System.String]
        $ParentPropertyName=""
    )

    $namespace=$CmdletDefinition|Where-Object -FilterScript {$_.EntityType.Name -contains $Entity}
    if ($null -eq $namespace)
    {
        $namespace=$CmdletDefinition|Where-Object -FilterScript {$_.ComplexType.Name -contains $Entity}
    }
    $properties=@()
    $baseType=$Entity
    #Get all properties for the entity or complex
    do
    {
        $isComplex=$false
        $entityType=$namespace.EntityType|Where-Object -FilterScript{$_.Name -eq $baseType}
        $isAbstract=$false
        if ($entityType.Abstract -eq 'True')
        {
            $isAbstract=$true
        }
        if ($null -eq $entityType)
        {
            $isComplex=$true
            $entityType=$namespace.ComplexType|Where-Object -FilterScript{$_.Name -eq $baseType}
            #if ($entityType.Abstract -eq 'true')
            if ($null -eq $entityType.BaseType)
            {
                $isAbstract=$true
            }
        }

        if ($null -ne $entityType.Property)
        {
            $rawProperties=$entityType.Property
            foreach ($property in $rawProperties)
            {
                $IsRootProperty=$false
                if (($entityType.BaseType -eq "graph.Entity") -or ($entityType.Name -eq "entity") -or ($isAbstract -and $entityType.Name -eq $global:searchedEntity))
                {
                    $IsRootProperty=$true
                }

                $myProperty = @{}
                $myProperty.Add('Name',$property.Name)
                $myProperty.Add('Type',$property.Type)
                $myProperty.Add('IsRootProperty',$IsRootProperty)
                $myProperty.Add('ParentType',$entityType.Name)
                $description = ''
                if (-not [String]::IsNullOrWhiteSpace($property.Annotation.String))
                {
                    $description =$property.Annotation.String.replace('"',"'")
                    $description =$description -replace '[^\p{L}\p{Nd}/(/}/_ -.,=:)'']', ''
                }
                else
                {
                    $annotation = $CmdletDefinition.Annotations | where-object -FilterScript {$_.Target -like "microsoft.graph.$($property.ParentNode.Name)/$($property.Name)" }
                    if (-not [String]::IsNullOrWhiteSpace($annotation.Annotation.String))
                    {
                        $description =$annotation.Annotation.String.replace('"',"'")
                        $description =$description -replace '[^\p{L}\p{Nd}/(/}/_ -.,=:)'']', ''

                    }
                }
                $myProperty.Add('Description', $description)


                $properties+=$myProperty
            }
        }
        if ($isComplex)
        {
            $abstractType=$namespace.ComplexType|Where-Object -FilterScript {$_.BaseType -eq "graph.$baseType"}

            foreach ($subType in $abstractType)
            {
                $rawProperties=$subType.Property
                foreach ($property in $rawProperties)
                {
                    $IsRootProperty=$false
                    if ($entityType.BaseType -eq "graph.Entity" -or $entityType.Name -eq "entity" )
                    {
                        $IsRootProperty=$true
                    }

                    if ($property.Name -notin ($properties.Name))
                    {
                        $myProperty = @{}
                        $myProperty.Add('Name',$property.Name)
                        $myProperty.Add('Type',$property.Type)
                        $myProperty.Add('IsRootProperty',$false)
                        $myProperty.Add('ParentType',$entityType.Name)
                        $description = ''
                        if (-not [String]::IsNullOrWhiteSpace($property.Annotation.String))
                        {
                            $description =$property.Annotation.String.replace('"',"'")
                            $description =$description -replace '[^\p{L}\p{Nd}/(/}/_ -.,=:)'']', ''
                        }
                        else
                        {
                            $annotation = $CmdletDefinition.Annotations | where-object -FilterScript {$_.Target -like "microsoft.graph.$($property.ParentNode.Name)/$($property.Name)" }
                            if (-not [String]::IsNullOrWhiteSpace($annotation.Annotation.String))
                            {
                                $description =$annotation.Annotation.String.replace('"',"'")
                                $description =$description -replace '[^\p{L}\p{Nd}/(/}/_ -.,=:)'']', ''
                            }
                        }
                        $myProperty.Add('Description', $description)

                        $properties+=$myProperty
                    }
                }
            }

            if (([Array]$abstractType.Name).Count -gt 0)
            {
                $myProperty = @{}
                $myProperty.Add('Name','@odata.type')
                $myProperty.Add('Type','Custom.Enum')
                $myProperty.Add('Members',$abstractType.Name)
                $myProperty.Add('IsRootProperty',$false)
                $myProperty.Add('Description','The type of the entity.')
                $myProperty.Add('ParentType',$entityType.Name)

                $properties+=$myProperty
            }
        }

        if ($IncludeNavigationProperties -and $null -ne $entityType.NavigationProperty)
        {
            $rawProperties=$entityType.NavigationProperty
            foreach ($property in $rawProperties)
            {
                $IsRootProperty=$false
                if ($entityType.BaseType -eq "graph.Entity" -or $entityType.Name -eq "entity" )
                {
                    $IsRootProperty=$true
                }

                $myProperty = @{}
                $myProperty.Add('Name',$property.Name)
                $myProperty.Add('Type',$property.Type)
                $myProperty.Add('IsNavigationProperty', $true)
                $myProperty.Add('IsRootProperty',$IsRootProperty)
                $myProperty.Add('ParentType',$entityType.Name)
                $myProperty.Add('Description', $property.Annotation.String.replace('"',"'"))

                $properties+=$myProperty
            }
        }

        $baseType=$null
        if (-not [String]::IsNullOrEmpty($entityType.BaseType))
        {
            $baseType=$entityType.BaseType.replace('graph.','')
        }
    }
    while($null -ne $baseType)
    # Enrich properties
    $result=@()
    foreach ($property in $properties)
    {
        $derivedType=$property.Type
        #Array
        $isArray=$false
        $isEnum=$false
        if ($derivedType -eq 'Custom.Enum')
        {
            $isEnum=$true
        }
        $isComplex=$false

        if ($derivedType -like "Collection(*)")
        {
            $isArray=$true
            $derivedType=$derivedType.Replace('Collection(','').replace(')','')
        }

        $property.Add('IsArray',$isArray)

        #}

        #DerivedType
        if ($derivedType -like ('graph.*'))
        {
            $derivedType=$derivedType.Replace('graph.','')
            #Enum
            if ($derivedType -in $namespace.EnumType.Name)
            {
                $isEnum=$true
                $enumType=$namespace.EnumType | where-Object -FilterScript {$_.Name -eq $derivedType}
                $property.Add('Members',$enumType.Member.Name)

            }

            #Complex
            if (($derivedType -in $namespace.ComplexType.Name) -or ($property.IsNavigationProperty))
            {
                $complexName=$ParentPropertyName+"-"+$property.Name+"-"+$property.Type
                $isComplex=$true

                if ($complexName -notin $global:ComplexList)
                {
                    if ($ParentPropertyName -ne "")
                    {
                        $global:ComplexList+= $complexName
                    }
                    $nestedProperties = Get-TypeProperties `
                        -CmdletDefinition $CmdletDefinition `
                        -Entity $derivedType `
                        -CimClasses $CimClasses `
                        -Workload $Workload `
                        -ParentPropertyName $property.Name
                    $property.Add('Properties', $nestedProperties)
                }
            }
        }
        if ($derivedType -like ('Edm.*'))
        {
            $derivedType=$derivedType.Replace('Edm','System')
            if ($derivedType -like ('*.TimeOfDay'))
            {
                $derivedType='System.TimeSpan'
            }
            if ($derivedType -like ('*.Date'))
            {
                $derivedType='System.DateTime'
            }
        }

        if ($cimClasses -contains "MSFT_$Workload$derivedType")
        {
            $cimCounter = ([Array]($CimClasses | where-object {$_ -like "MSFT_$Workload$derivedType*"})).count
            $derivedType += $cimCounter.ToString()
        }

        if ($isEnum)
        {
            $derivedType='System.String'
        }
        $property.Add('DerivedType', $derivedType)
        $property.Add('IsComplexType', $isComplex)
        $property.Add('IsEnumType', $isEnum)

        $result+=$property
    }
    return $result
}
function Get-Microsoft365DSCModuleCimClass
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter()]
        [System.String]
        $ResourceName
    )

    import-module Microsoft365DSC -Force
    $modulePath = Split-Path -Path (get-module microsoft365dsc).Path
    $resourcesPath = "$modulePath\DSCResources\*\*.mof"
    $resources = (Get-ChildItem $resourcesPath).FullName
    $resources = $resources | Where-Object -FilterScript {$_ -notlike "*MSFT_$ResourceName.schema.mof"}
    $cimClasses = @()
    foreach ($resource in $resources)
    {
        $text = Get-Content $resource

        foreach ($line in $text)
        {
            if ($line -like "class MSFT_*")
            {
                $class = $line.replace("class ","").replace("Class ","")
                if ($line -like "*:*")
                {
                    $class = $class.split(":")[0].trim()
                }
                if ($class -notin $cimClasses)
                {
                    $cimClasses += $class
                }
            }
        }
    }
    return $cimClasses
}

function Get-StringFirstCharacterToUpper
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    return $Value.Substring(0,1).ToUpper() + $Value.Substring(1,$Value.length-1)
}

function Get-StringFirstCharacterToLower
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Value
    )

    return $Value.Substring(0,1).ToLower() + $Value.Substring(1,$Value.length-1)
}

function Get-ComplexTypeConstructorToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({$_.IsComplexType})]
        $Property,

        [Parameter()]
        [System.String]
        $ParentPropertyName,

        [Parameter()]
        [System.String]
        $ParentPropertyValuePath,

        [Parameter()]
        [System.String]
        $IsParentFromAdditionalProperties=$False,

        [Parameter()]
        [System.Int32]
        $IndentCount=0,

        [Parameter()]
        [System.String]
        $DateFormat,

        [Parameter()]
        [System.Boolean]
        $IsNested=$false
    )

    $complexString = [System.Text.StringBuilder]::New()
    $indent="    "
    $spacing = $indent * $IndentCount
    $propertyName = Get-StringFirstCharacterToUpper -Value $Property.Name
    $returnPropertyName= "complex"+ $propertyName
    $tempPropertyName=$returnPropertyName

    $valuePrefix = "getValue."
    $referencePrefix = "getValue."
    if ($isNested)
    {
        #$valuePrefix = "`$current$propertyName."
        $valuePrefix = "$ParentPropertyValuePath"
        $referencePrefix = "$ParentPropertyValuePath"

    }

    $loopPropertyName= $Property.Name
    if ($isParentfromAdditionalProperties)
    {
        $loopPropertyName=Get-StringFirstCharacterToLower -Value $loopPropertyName
    }
    if ($Property.IsRootProperty -eq $false -and -not $IsNested)
    {
        $loopPropertyName=Get-StringFirstCharacterToLower -Value $Property.Name
        $propertyName = Get-StringFirstCharacterToLower -Value $Property.Name
        $valuePrefix += "AdditionalProperties."
        $referencePrefix += "AdditionalProperties."
    }
    $referencePrefix += "$propertyName."

    if ($property.IsArray)
    {
        $tempPropertyName="my$propertyName"
        if ($isNested)
        {
            $valuePrefix=$ParentPropertyValuePath
            if ($null -eq $valuePrefix)
            {
                $propRoot=$ParentPropertyName.replace("my","")
                $valuePrefix="current$propRoot."
                #if ($property.IsRootProperty -eq $false -and -not $IsNested)
                #{
                #    $valuePrefix += "AdditionalProperties."
                #}
            }
        }
        $iterationPropertyName="current$propertyName"
        $complexString.appendLine($spacing + "`$$returnPropertyName" + " = @()") | Out-Null
        $complexString.appendLine($spacing + "foreach (`$$iterationPropertyName in `$$valuePrefix" + $loopPropertyName + ")" ) | Out-Null
        $complexString.appendLine($spacing + "{" ) | Out-Null
        $IndentCount ++
        $spacing = $indent * $IndentCount
    }

    $complexString.appendLine($spacing + "`$$tempPropertyName" + " = @{}") | Out-Null

    foreach ($nestedProperty in $property.Properties)
    {
        $nestedPropertyName = Get-StringFirstCharacterToUpper -Value $nestedProperty.Name
        if ($nestedPropertyName -eq '@odata.type')
        {
            $nestedPropertyName = 'odataType'
        }
        $valuePrefix = "getValue."
        if ($Property.IsArray)
        {
            $valuePrefix = "$iterationPropertyName."
            $referencePrefix = "$iterationPropertyName."
        }
        if ($isNested -and -not $Property.IsArray)
        {
            $propRoot=$ParentPropertyName.replace("my","")
            #$valuePrefix = "current$propRoot."
            $valuePrefix = "$referencePrefix"

            #$recallProperty=''
            if ($isParentfromAdditionalProperties)
            {
                #$recallProperty=Get-StringFirstCharacterToLower -Value $propertyName
                $referencePrefixElements = @()
                foreach ($elt in ($referencePrefix.split('.') | where-object {-not [String]::IsNullOrWhiteSpace($_)}))
                {
                    $referencePrefixElements += Get-StringFirstCharacterToLower -Value $elt
                    #$referencePrefix = "$valuePrefix$recallProperty."
                }
                $referencePrefix = ($referencePrefixElements -join '.') + '.'
                $valuePrefix = $referencePrefix
            }
            #$valuePrefix += "."
        }
        $AssignedPropertyName = $nestedProperty.Name
        if ($nestedProperty.IsRootProperty -eq $false -and -not $IsNested)
        {
            $valuePrefix += "AdditionalProperties."
        }

        if ($nestedProperty.IsRootProperty -eq $false -or $IsParentFromAdditionalProperties)
        {
            $AssignedPropertyName = Get-StringFirstCharacterToLower -Value $nestedProperty.Name
        }

        if ($AssignedPropertyName.contains("@"))
        {
            $AssignedPropertyName="'$AssignedPropertyName'"
        }
        if ((-not $isNested) -and (-not $Property.IsArray) -and ([String]::IsNullOrWhiteSpace($ParentPropertyValuePath)))
        {
            $valuePrefix += "$propertyName."
        }
        if ($nestedProperty.IsComplexType)
        {
            $complexName=$Property.Name+"-"+$nestedProperty.Type

            #if ($complexName -notin $global:ComplexList)
            #{

                $global:ComplexList+= $complexName
                $nestedString = ''
                $nestedString = Get-ComplexTypeConstructorToString `
                    -Property $nestedProperty `
                    -IndentCount $IndentCount `
                    -IsNested $true `
                    -ParentPropertyName $tempPropertyName `
                    -ParentPropertyValuePath $referencePrefix `
                    -IsParentFromAdditionalProperties $(if ($isNested) {$isParentfromAdditionalProperties} else {-not $Property.IsRootProperty})
                    #-IsParentFromAdditionalProperties (-not $Property.IsRootProperty)

                $complexString.append($nestedString ) | Out-Null

            #}
        }
        else
        {

            if ($nestedProperty.Type -like "*.Date*")
            {
                $nestedPropertyType=$nestedProperty.Type.split(".")|select-object -last 1
                if ($isNested)
                {
                    $complexString.appendLine($spacing + "if (`$null -ne `$$valuePrefix$AssignedPropertyName)" ) | Out-Null
                }
                else
                {
                    $complexString.appendLine($spacing + "if (`$null -ne `$$referencePrefix$AssignedPropertyName)" ) | Out-Null
                }

                $complexString.appendLine($spacing + "{" ) | Out-Null
                $IndentCount ++
                $spacing = $indent * $IndentCount
                $AssignedPropertyName += ").ToString('$DateFormat')"
                if ($isNested)
                {
                    $complexString.appendLine($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', ([$nestedPropertyType]`$$valuePrefix$AssignedPropertyName)" ) | Out-Null
                }
                else
                {
                    $complexString.appendLine($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', ([$nestedPropertyType]`$$referencePrefix$AssignedPropertyName)" ) | Out-Null
                }
                $IndentCount --
                $spacing = $indent * $IndentCount
                $complexString.appendLine($spacing + "}" ) | Out-Null

            }
            elseif ($nestedProperty.Type -like "*.Time*")
            {
                $nestedPropertyType=$nestedProperty.Type.split(".")|select-object -last 1
                if ($isNested)
                {
                    $complexString.appendLine($spacing + "if (`$null -ne `$$valuePrefix$AssignedPropertyName)" ) | Out-Null
                }
                else
                {
                    $complexString.appendLine($spacing + "if (`$null -ne `$$referencePrefix$AssignedPropertyName)" ) | Out-Null
                }
                $complexString.appendLine($spacing + "{" ) | Out-Null
                $IndentCount ++
                $spacing = $indent * $IndentCount
                $AssignedPropertyName += ").ToString()"
                if ($isNested)
                {
                    $complexString.appendLine($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', ([$nestedPropertyType]`$$valuePrefix$AssignedPropertyName)" ) | Out-Null
                }
                else
                {
                    $complexString.appendLine($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', ([$nestedPropertyType]`$$referencePrefix$AssignedPropertyName)" ) | Out-Null
                }
                $IndentCount --
                $spacing = $indent * $IndentCount
                $complexString.appendLine($spacing + "}" ) | Out-Null

            }
            else
            {

                if ($nestedProperty.IsEnumType)
                {
                    if ($isNested)
                    {
                        $complexString.appendLine($spacing + "if (`$null -ne `$$valuePrefix$AssignedPropertyName)" ) | Out-Null
                    }
                    else
                    {
                        $complexString.appendLine($spacing + "if (`$null -ne `$$referencePrefix$AssignedPropertyName)" ) | Out-Null
                    }
                    $complexString.appendLine($spacing + "{" ) | Out-Null
                    $IndentCount ++
                    $spacing = $indent * $IndentCount
                    if ($isNested)
                    {
                        $complexString.append($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', `$$valuePrefix$AssignedPropertyName.toString()" ) | Out-Null
                    }
                    else
                    {
                        $complexString.append($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', `$$referencePrefix$AssignedPropertyName.toString()" ) | Out-Null
                    }
                    $complexString.append(")`r`n" ) | Out-Null
                    $IndentCount --
                    $spacing = $indent * $IndentCount
                    $complexString.appendLine($spacing + "}" ) | Out-Null
                }
                else
                {
                    if ($isNested)
                    {
                        $complexString.appendLine($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', `$$valuePrefix$AssignedPropertyName)" ) | Out-Null
                    }
                    else
                    {
                        $complexString.appendLine($spacing + "`$$tempPropertyName.Add('" +  $nestedPropertyName + "', `$$referencePrefix$AssignedPropertyName)" ) | Out-Null
                    }
                }

            }
        }
    }

    if ($property.IsArray)
    {
        $complexString.appendLine($spacing + "if (`$$tempPropertyName.values.Where({`$null -ne `$_}).count -gt 0)" ) | Out-Null
        $complexString.appendLine($spacing + "{" ) | Out-Null
        $IndentCount ++
        $spacing = $indent * $IndentCount
        $complexString.appendLine($spacing + "`$$returnPropertyName += `$$tempPropertyName" ) | Out-Null
        $IndentCount --
        $spacing = $indent * $IndentCount
        $complexString.appendLine($spacing + "}" ) | Out-Null
        $IndentCount --
        $spacing = $indent * $IndentCount
        $complexString.appendLine($spacing + "}" ) | Out-Null
        if ($IsNested)
        {
            $complexString.appendLine($spacing + "`$$ParentPropertyName" +".Add('$propertyName',`$$returnPropertyName" +")" ) | Out-Null
        }
    }
    else
    {
        $complexString.appendLine($spacing + "if (`$$tempPropertyName.values.Where({`$null -ne `$_}).count -eq 0)" ) | Out-Null
        $complexString.appendLine($spacing + "{" ) | Out-Null
        $IndentCount ++
        $spacing = $indent * $IndentCount
        $complexString.appendLine($spacing + "`$$returnPropertyName = `$null" ) | Out-Null
        $IndentCount --
        $spacing = $indent * $IndentCount
        $complexString.appendLine($spacing + "}" ) | Out-Null
        if ($IsNested)
        {
            $complexString.appendLine($spacing + "`$$ParentPropertyName" +".Add('$propertyName',`$$returnPropertyName" +")" ) | Out-Null
        }
    }

    return [String]($complexString.toString())
}

function Get-DateTypeConstructorToString
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({$_.Type -like "System.Date*"})]
        $Property,

        [Parameter()]
        [System.String]
        $ParentPropertyName,

        [Parameter()]
        [System.Int32]
        $IndentCount=0,

        [Parameter()]
        [System.String]
        $DateFormat,

        [Parameter()]
        [System.Boolean]
        $IsNested=$false
    )

    $dateString = [System.Text.StringBuilder]::New()
    $indent="    "
    $spacing = $indent * $IndentCount

    $valuePrefix = "getValue."
    $propertyName = Get-StringFirstCharacterToUpper -Value $Property.Name
    $returnPropertyName= "date"+ $propertyName
    $propertyType=$Property.Type.split(".")|select-object -last 1


    if ($Property.IsRootProperty -eq $false)
    {
        $propertyName = Get-StringFirstCharacterToLower -Value $Property.Name
        $valuePrefix += "AdditionalProperties."
    }

    if ($property.IsArray)
    {
        $dateString.appendLine($spacing + "`$$returnPropertyName" + " = @()") | Out-Null
        $dateString.appendLine($spacing + "foreach (`$current$propertyName in `$$valuePrefix$PropertyName)" ) | Out-Null
        $dateString.appendLine($spacing + "{" ) | Out-Null
        $IndentCount ++
        $spacing = $indent * $IndentCount
        $dateString.appendLine($spacing + "`$$returnPropertyName += ([$propertyType]`$current$propertyName).ToString('$DateFormat')") | Out-Null
        $IndentCount --
        $spacing = $indent * $IndentCount
        $dateString.appendLine($spacing + "}" ) | Out-Null
    }
    else
    {
        $dateString.appendLine($spacing + "`$$returnPropertyName" + " = `$null") | Out-Null
        $dateString.appendLine($spacing + "if (`$null -ne `$$valuePrefix$PropertyName)" ) | Out-Null
        $dateString.appendLine($spacing + "{" ) | Out-Null
        $IndentCount ++
        $spacing = $indent * $IndentCount
        $dateString.appendLine($spacing + "`$$returnPropertyName = ([$propertyType]`$$valuePrefix$PropertyName).ToString('$DateFormat')") | Out-Null
        $IndentCount --
        $spacing = $indent * $IndentCount
        $dateString.appendLine($spacing + "}" ) | Out-Null
    }

    return $dateString.ToString()

}
function Get-TimeTypeConstructorToString
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({$_.Type -like "System.Time*"})]
        $Property,

        [Parameter()]
        [System.String]
        $ParentPropertyName,

        [Parameter()]
        [System.Int32]
        $IndentCount=0,

        [Parameter()]
        [System.String]
        $DateFormat,

        [Parameter()]
        [System.Boolean]
        $IsNested=$false
    )

    $timeString = [System.Text.StringBuilder]::New()
    $indent="    "
    $spacing = $indent * $IndentCount

    $valuePrefix = "getValue."
    $propertyName = Get-StringFirstCharacterToUpper -Value $Property.Name
    $returnPropertyName= "time"+ $propertyName
    $propertyType=$Property.Type.split(".")|select-object -last 1


    if ($Property.IsRootProperty -eq $false)
    {
        $propertyName = Get-StringFirstCharacterToLower -Value $Property.Name
        $valuePrefix += "AdditionalProperties."
    }

    if ($property.IsArray)
    {
        $timeString.appendLine($spacing + "`$$returnPropertyName" + " = @()") | Out-Null
        $timeString.appendLine($spacing + "foreach (`$current$propertyName in `$$valuePrefix$PropertyName)" ) | Out-Null
        $timeString.appendLine($spacing + "{" ) | Out-Null
        $IndentCount ++
        $spacing = $indent * $IndentCount
        $timeString.appendLine($spacing + "`$$returnPropertyName += ([$propertyType]`$current$propertyName).ToString()") | Out-Null
        $IndentCount --
        $spacing = $indent * $IndentCount
        $timeString.appendLine($spacing + "}" ) | Out-Null
    }
    else
    {
        $timeString.appendLine($spacing + "`$$returnPropertyName" + " = `$null") | Out-Null
        $timeString.appendLine($spacing + "if (`$null -ne `$$valuePrefix$PropertyName)" ) | Out-Null
        $timeString.appendLine($spacing + "{" ) | Out-Null
        $IndentCount ++
        $spacing = $indent * $IndentCount
        $timeString.appendLine($spacing + "`$$returnPropertyName = ([$propertyType]`$$valuePrefix$PropertyName).ToString()") | Out-Null
        $IndentCount --
        $spacing = $indent * $IndentCount
        $timeString.appendLine($spacing + "}" ) | Out-Null
    }

    return $timeString.ToString()

}
function Get-EnumTypeConstructorToString
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({$_.IsEnumType})]
        $Property,

        [Parameter()]
        [System.String]
        $ParentPropertyName,

        [Parameter()]
        [System.Int32]
        $IndentCount=0,

        [Parameter()]
        [System.String]
        $DateFormat
    )

    $enumString = [System.Text.StringBuilder]::New()
    $indent="    "
    $spacing = $indent * $IndentCount

    $valuePrefix = "getValue."
    $propertyName = Get-StringFirstCharacterToUpper -Value $Property.Name
    $returnPropertyName= "enum"+ $propertyName

    if ($Property.IsRootProperty -eq $false)
    {
        $propertyName = Get-StringFirstCharacterToLower -Value $Property.Name
        $valuePrefix += "AdditionalProperties."
    }

    $enumString.appendLine($spacing + "`$$returnPropertyName" + " = `$null") | Out-Null
    $enumString.appendLine($spacing + "if (`$null -ne `$$valuePrefix$PropertyName)" ) | Out-Null
    $enumString.appendLine($spacing + "{" ) | Out-Null
    $IndentCount ++
    $spacing = $indent * $IndentCount
    $enumString.appendLine($spacing + "`$$returnPropertyName = `$$valuePrefix$PropertyName.ToString()") | Out-Null
    $IndentCount --
    $spacing = $indent * $IndentCount
    $enumString.appendLine($spacing + "}" ) | Out-Null

    return $enumString.ToString()

}
function Get-ParameterBlockInformation
{
    [OutputType([Hashtable[]])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [Object[]]
        $Properties,

        [Parameter()]
        [System.Object]
        $DefaultParameterSetProperties
    )

    $parameterBlock = @()

    foreach ($property in $Properties)
    {
        $isMandatory = $false
        # Replace this one with the proper mandatory key value
        $cmdletParameter = $DefaultParameterSetProperties | Where-Object -FilterScript { $_.Name -eq $property.Name }
        if (($null -ne $cmdletParameter `
                -and $cmdletParameter.IsMandatory -eq $true) `
            -or $property.Name -eq 'Id' -or $property.Name -eq 'DisplayName')
        {
            $isMandatory = $true
            $parameterAttribute = "[Parameter(Mandatory = `$true)]"
        }
        else
        {
            $parameterAttribute = '[Parameter()]'
        }

        $parameterName = $property.Name
        $parameterNameFirstLetter = $parameterName.Substring(0, 1)
        $parameterNameFirstLetter = $parameterNameFirstLetter.ToUpper()
        $parameterNameCamelCaseString = $parameterName.Substring(1)
        $parameterName = "$($parameterNameFirstLetter)$($parameterNameCamelCaseString)"

        $myParam = @{
            IsMandatory     = $isMandatory
            Attribute       = $parameterAttribute
            Type            = $property.DerivedType
            Name            = $parameterName
            Description     = $property.Description
            IsArray         = $property.IsArray
            IsComplexType   = $property.IsComplexType
            IsEnumType      = $property.IsEnumType
            IsRootProperty  = $property.IsRootProperty
            ParentType      = $property.ParentType
        }
        if ($property.IsEnumType)
        {
            $myParam.add('Members', $property.Members)
        }
        if ($property.IsComplexType)
        {
            $myParam.add('Properties', (Get-ParameterBlockInformation `
                    -Properties $property.Properties `
                    -DefaultParameterSetProperties $DefaultParameterSetProperties))
        }

        $parameterBlock+=$myParam
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
    switch  -Wildcard  ($Type.ToLower())
    {
        '*.string'
        {
            $parameterType = 'String'
        }
        '*.datetime'
        {
            $parameterType = 'String'
        }
        '*.boolean'
        {
            $parameterType = 'Boolean'
        }
        '*.int32'
        {
            $parameterType = 'UInt32'
        }
        '*.int64'
        {
            $parameterType = 'UInt64'
        }
        Default
        {
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
        $IsGetTargetResource = $false,

        [Parameter()]
        [System.Boolean]
        $IsParentFromAdditionalProperties = $false,

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
        $Workload,

        [Parameter()]
        [System.String]
        $DateFormat="o"
    )

    $result = @{}
    $parameters = $parametersInformation
    $additionalProperties = @{}

    foreach ($parameter in $parameters)
    {

        if ($null -ne (Get-Variable hashValue -ErrorAction SilentlyContinue))
        {
            try
            {
                clear-variable hashValue -force
            }
            catch {}
        }
        $parameterName = $parameter.Name
        if ($parameter.Name -eq "@odata.type" -and $IsGetTargetResource)
        {
            $parameterName = 'odataType'
        }
        if ($parameter.IsComplexType)
        {
            [hashtable]$hashValue = @{}
            $propertyType = $workload + $parameter.Type
            if ($IsGetTargetResource)
            {
                $propertyType = "MSFT_$propertyType"
                $hashValue.add('CIMType', $propertyType)
            }
            if (-not $isRecursive)
            {
                $IsParentFromAdditionalProperties=$false
                if (-not $parameter.IsRootProperty)
                {
                    $IsParentFromAdditionalProperties=$true
                }
            }
            $hashValue.add('isArray', $parameter.IsArray)
            $nestedProperties = @()
            if ($null -ne $parameter.Properties)
            {
                $nestedProperties = Get-M365DSCFakeValues -ParametersInformation $parameter.Properties `
                    -Workload $Workload `
                    -isCmdletCall $isCmdletCall `
                    -isRecursive $true `
                    -IntroduceDrift $IntroduceDrift `
                    -IsGetTargetResource $IsGetTargetResource `
                    -IsParentFromAdditionalProperties $IsParentFromAdditionalProperties
            }
            $hashValue.add('Properties', $nestedProperties)
            $hashValue.add('Name', $parameterName)
        }
        else
        {
            switch -Wildcard ($parameter.Type)
            {
                '*.String'
                {
                    [String]$hashValue = ''
                    $fakeValue = 'FakeStringValue'
                    if ($parameter.Members)
                    {
                        $fakeValue = $parameter.Members[0]
                        if ($parameter.Name -eq "@odata.type")
                        {
                            $fakeValue = "#microsoft.graph." + $parameter.Members[0]
                        }
                    }
                    $hashValue = $fakeValue
                    if ($parameter.IsArray)
                    {
                        [string[]]$hashValue = @($fakeValue)
                    }
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
                    [Array]$hashValue = @($fakeValue1, $fakeValue2)
                    if ($IntroduceDrift)
                    {
                        $hashValue = @($fakeValue1)
                    }
                    break
                }
                '*.Int32'
                {
                    [Int32]$hashValue = 25
                    if ($IntroduceDrift)
                    {
                        $hashValue = 7
                    }
                    break
                }
                '*.Boolean'
                {
                    [Boolean]$hashValue = $true
                    if ($IntroduceDrift)
                    {
                        $hashValue = $false
                    }
                    break
                }
                '*.DateTime'
                {
                    [String]$hashValue = ''
                    $fakeValue = ([DateTime]"2023-01-01T00:00:00").toString("$DateFormat")
                    $hashValue = $fakeValue
                    break
                }
                '*.DateTimeOffset'
                {
                    [String]$hashValue = ''
                    $fakeValue = ([DateTimeOffset]"2023-01-01T00:00:00").toString("$DateFormat")
                    $hashValue = $fakeValue
                    break
                }
                '*.Time*'
                {
                    [String]$hashValue = ''
                    $fakeValue = [Datetime]::Parse("00:00:00").TimeOfDay.toString()
                    $hashValue = $fakeValue
                    break
                }
            }
        }

        if ($hashValue)
        {
            if ((-Not $parameter.IsRootProperty ) -and -not $IsGetTargetResource -and -not $isRecursive)
            {
                $parameterName = Get-StringFirstCharacterToLower -Value $parameterName
                $additionalProperties.Add($parameterName, $hashValue)
            }
            else
            {
                if ($IsParentFromAdditionalProperties)
                {
                    $parameterName = Get-StringFirstCharacterToLower -Value $parameterName
                }
                write-host -ForegroundColor Yellow $parameterName
                $result.Add($parameterName, $hashValue)
            }
        }
    }
    if (-not [String]::isNullorEmpty($AdditionalPropertiesType))
    {
        $additionalProperties.Add('@odata.type', '#microsoft.graph.' + $AdditionalPropertiesType)
    }

    if ($additionalProperties.count -gt 0)
    {
        $result.Add('AdditionalProperties', $additionalProperties)
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
                #read-host -Prompt ($Values.$Key|fl *|out-string)
                $extraSpace = ''
                $line = "$Space$extraSpace$key = "
                if ($Values.$Key.isArray)
                {
                    if ($Values.$Key.CIMType)
                    {
                        $line += "[CimInstance[]]"
                    }
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
                    $sb.Append($propLine) | Out-Null
                }
                else
                {
                    $sb.Append((Get-M365DSCHashAsString -Values $Values.$key -Space "$Space    " -isCmdletCall $isCmdletCall)) | Out-Null
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
        $CmdLetNoun,

        [Parameter()]
        [System.String]
        $UpdateVerb='Update',

        [Parameter()]
        [ValidateSet('v1.0','beta')]
        [System.String]
        $APIVersion='v1.0'
    )

    $readPermissionsNames = (Find-MgGraphCommand -Command "Get-$CmdLetNoun" -ApiVersion $ApiVersion| Select-Object -First 1 -ExpandProperty Permissions).Name
    $leastReadPermissions = @()

    foreach ($permission in $readPermissionsNames)
    {
        $splitPermission = $permission.Split('.')
        if ($splitPermission[1] -eq 'ReadWrite')
        {
            if ($readPermissionsNames -notcontains "$($splitPermission[0]).Read.$($splitPermission[2])")
            {
                $leastReadPermissions += $permission
            }
        }
        else
        {
            $leastReadPermissions += $permission
        }
    }

    $updatePermissionsNames = (Find-MgGraphCommand -Command "$UpdateVerb-$CmdLetNoun" -ApiVersion $ApiVersion | Select-Object -First 1 -ExpandProperty Permissions).Name

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
    foreach ($permission in $leastReadPermissions)
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
        #[System.Object[]]
        [Hashtable]
        $CIMInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Workload
    )

    $stringResult = ''
    $cimInstanceType = Get-StringFirstCharacterToUpper -Value $cimInstance.Type
    if ($cimInstanceType -notin $Global:AlreadyFoundInstances)
    {
        $stringResult += "[ClassVersion(`"1.0.0`")]`r`n"
        $stringResult += 'class MSFT_' + $Workload + $cimInstanceType + "`r`n"
        $stringResult += "{`r`n"

        $nestedResults = ''
        foreach ($property in $cimInstance.Properties)
        {
            $newNestedCimToBeAdded = $false
            $propertyType = Get-StringFirstCharacterToUpper -Value $property.Type

            if ($property.IsComplexType)
            {
                if ($propertyType -notin $Global:AlreadyFoundInstances)
                {
                    $Global:AlreadyFoundInstances += $cimInstanceType

                    $newNestedCimToBeAdded = $true
                    #$Global:AlreadyFoundInstances += $propertyType

                    $nestedResult = Get-M365DSCDRGCimInstancesSchemaStringContent `
                    -CIMInstance $property `
                    -Workload $Workload
                }
                $stringResult += "    [Write, Description(`"$($property.Description)`"), EmbeddedInstance(`"MSFT_$Workload$($propertyType)`")] String $($property.Name)"
                if ($property.IsArray)
                {
                    $stringResult += '[]'
                }
                $stringResult += ";`r`n"
            }
            else
            {

                $propertyType = Get-M365DSCDRGParameterTypeForSchema -Type $property.Type
                $propertySet = ''
                if ($property.IsEnumType)
                {
                    $mySet = ''
                    foreach ($member in $property.Members)
                    {
                        if ($property.Name -eq "@odata.type")
                        {
                            $member="#microsoft.graph."+$member
                        }
                        $mySet += "`"" + $member + "`","
                    }
                    $mySet = $mySet.Substring(0, $mySet.Length - 1)
                    $propertySet = ", ValueMap{$mySet}, Values{$mySet}"
                }
                $propertyName = $property.Name
                if ($property.Name -eq "@odata.type")
                {
                    $propertyName="odataType"
                }
                $stringResult += "    [Write, Description(`"$($property.Description)`")$propertySet] $($propertyType) $($propertyName)"
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
        if ($cimInstanceType -notin $Global:AlreadyFoundInstances)
        {
            $Global:AlreadyFoundInstances += $cimInstanceType
        }
    }

    return $stringResult
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
            if ($_.IsComplexType)
            {
                $propertyType = $_.Type -replace 'microsoft.graph.powershell.models.', ''
                $propertyType = $propertyType -replace 'imicrosoftgraph', ''
                $propertyType = $Workload + $propertyType
                $propertyType = $propertyType -replace '[[\]]', ''
                $schemaProperties += "    [Write, Description(`"$($_.Description)`"), EmbeddedInstance(`"MSFT_$propertyType`")] String $($_.Name)"
                if ($_.IsArray)
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
                $permission = "Write"
                if ($_.Name -eq "Id")
                {
                    $permission = "Key"
                }
                if ($_.Name -eq "DisplayName")
                {
                    $permission = "Required"
                }
                $schemaProperties += "    [$permission, Description(`"$($_.Description)`")$propertySet] $($propertyType) $($_.Name)"
                if ($_.IsArray)
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
    if ($workload -in @('MicrosoftGraph','Intune'))
    {
        Copy-Item -Path .\Module.Template.psm1 -Destination $filePath -Force
    }
    else
    {
        Copy-Item -Path .\Module.Workloads.Template.psm1 -Destination $filePath -Force
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

    $exportPath = Join-Path -Path $env:temp -ChildPath $ResourceName
    Export-M365DSCConfiguration `
        -Credential $Credential `
        -Components $ResourceName `
        -Path $exportPath `
        -FileName "$ResourceName.ps1" `
        -ConfigurationName 'Example' | Out-Null

    $exportedFilePath = Join-Path -Path $exportPath -ChildPath "$ResourceName.ps1"
    $exportContent = Get-Content $exportedFilePath -Raw
    $start = $exportContent.IndexOf("`r`n        $ResourceName ")
    $end = $exportContent.IndexOf("`r`n        }", $start)
    $start = $exportContent.IndexOf("{", $start) + 1
    $exampleContent = $exportContent.Substring($start, $end-$start)

    $exampleFileFullPath = "$Path\$ResourceName\1-$ResourceName-Example.ps1"
    $folderPath = "$Path\$ResourceName"
    New-Item $folderPath -ItemType Directory -Force | Out-Null
    $templatePath = '.\Example.Template.ps1'
    Copy-Item -Path $templatePath -Destination $exampleFileFullPath -Force

    Write-TokenReplacement -Token '<FakeValues>' -Value $exampleContent -FilePath $exampleFileFullPath
    Write-TokenReplacement -Token '<ResourceName>' -Value $ResourceName -FilePath $exampleFileFullPath
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
    if ($Workload -in @('MicrosoftGraph','Intune'))
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

function Get-ComplexTypeMapping
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter()]
        $Property,

        [Parameter()]
        [System.String]
        $Workload
    )
        $complexMapping = @()
        $propertyType = Get-StringFirstCharacterToUpper -Value $Property.Type
        $isRequired=$false
        if ($property.Description -like "* Required.*")
        {
            $isRequired=$true
        }
        $map=@{
            Name = $Property.Name
            CimInstanceName = $Workload+ $PropertyType
            IsRequired = $isRequired
        }
        $complexMapping += $map
        foreach ($nestedProperty in $property.Properties)
        {

            if ($nestedProperty.IsComplexType)
            {
                $complexMapping += Get-ComplexTypeMapping -Property $nestedProperty -Workload $Workload
            }
        }
        return $complexMapping
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

        [Parameter()]
        [System.String]
        $DateFormat,

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
    $complexTypeConstructor = [System.Text.StringBuilder]::New()
    $enumTypeConstructor = [System.Text.StringBuilder]::New()
    $dateTypeConstructor = [System.Text.StringBuilder]::New()
    $timeTypeConstructor = [System.Text.StringBuilder]::New()

    $biggestParamaterLength = 'CertificateThumbprint'.length
    foreach ($property in $properties.Name)
    {
        If ($property.length -gt $biggestParamaterLength)
        {
            $biggestParamaterLength = $property.length
        }
    }

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

            if ($property.IsComplexType)
            {
                $CimInstanceName = $paramType -replace 'Microsoft.Graph.PowerShell.Models.IMicrosoftGraph', ''
                $CimInstanceName = $CimInstanceName -replace '[[\]]', ''
                $CimInstanceName = $Workload + $CimInstanceName
                $global:ComplexList = @()
                $complexTypeConstructor.appendLine((Get-ComplexTypeConstructorToString -Property $property -IndentCount 2 -DateFormat $DateFormat))
                $global:ComplexList = $null
                [Array]$complexMapping = Get-ComplexTypeMapping -Property $property -Workload $Workload
                $complexMappingString = [System.Text.StringBuilder]::New()
                if ($complexMapping.count -gt 1)
                {
                    $complexMappingString.appendLine("                `$complexMapping = @(") | out-null
                    foreach ($map in $complexMapping)
                    {
                        $complexMappingString.appendLine("                    @{")| out-null
                        $complexMappingString.appendLine("                        Name = '" + $map.Name + "'")| out-null
                        $complexMappingString.appendLine("                        CimInstanceName = '" + $map.CimInstanceName + "'")| out-null
                        $complexMappingString.appendLine("                        IsRequired = `$" + $map.IsRequired.ToString())| out-null
                        $complexMappingString.appendLine("                    }")| out-null
                    }
                    $complexMappingString.appendLine("                )")| out-null
                }

                $convertToString += "            if (`$null -ne `$Results.$parameterName)`r`n"
                $convertToString += "            {`r`n"
                if (-Not ([String]::IsNullOrEmpty($complexMappingString.toString())))
                {
                    $convertToString += $complexMappingString.toString()
                }
                $convertToString += "                `$complexTypeStringResult = Get-M365DSCDRGComplexTypeToString ```r`n"
                $convertToString += "                    -ComplexObject `$Results.$parameterName ```r`n"
                $convertToString += "                    -CIMInstanceName '$CimInstanceName'"
                if (-Not ([String]::IsNullOrEmpty($complexMappingString.toString())))
                {
                    $convertToString += " ```r`n"
                    $convertToString += "                    -ComplexTypeMapping `$complexMapping`r`n"
                }
                $convertToString += "`r`n"
                $convertToString += "                if (-Not [String]::IsNullOrWhiteSpace(`$complexTypeStringResult))`r`n"
                $convertToString += "                {`r`n"
                $convertToString += "                    `$Results.$parameterName = `$complexTypeStringResult`r`n"
                $convertToString += "                }`r`n"
                $convertToString += "                else`r`n"
                $convertToString += "                {`r`n"
                $convertToString += "                    `$Results.Remove('$parameterName') | Out-Null`r`n"
                $convertToString += "                }`r`n"
                $convertToString += "            }`r`n"

                $convertToVariable += "            if (`$Results.$parameterName)`r`n"
                $convertToVariable += "            {`r`n"
                $convertToVariable += "                `$currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock `$currentDSCBlock -ParameterName `"$parameterName`" -isCIMArray:`$$($property.IsArray)`r`n"
                $convertToVariable += "            }`r`n"


            }
            if ($property.IsEnumType)
            {
                $enumTypeConstructor.appendLine((Get-EnumTypeConstructorToString -Property $property -IndentCount 2 -DateFormat $DateFormat))
            }
            if ($property.Type -like "System.Date*")
            {
                $dateTypeConstructor.appendLine((Get-DateTypeConstructorToString -Property $property -IndentCount 2 -DateFormat $DateFormat))
            }
            if ($property.Type -like "System.Time*")
            {
                $timeTypeConstructor.appendLine((Get-TimeTypeConstructorToString -Property $property -IndentCount 2 -DateFormat $DateFormat))
            }

            $spacing = $biggestParamaterLength - $property.Name.length
            $propertyName = Get-StringFirstCharacterToUpper -Value $property.Name
            $hashtable += "            $($parameterName + (' ' * $spacing) ) = "
            if ($property.IsComplexType)
            {
                $hashtable += "`$complex$propertyName`r`n"
            }
            elseif ($property.Type -like "System.Date*")
            {
                $hashtable += "`$date$propertyName`r`n"
            }
            elseif ($property.Type -like "System.Time*")
            {
                $hashtable += "`$time$propertyName`r`n"
            }
            elseif ($property.IsEnumType)
            {
                $hashtable += "`$enum$propertyName`r`n"
            }
            else
            {
                $propertyPrefix="`$getValue."
                if ($property.IsRootProperty -eq $false)
                {
                    $propertyName = Get-StringFirstCharacterToLower -Value $property.Name
                    $propertyPrefix += "AdditionalProperties."
                }

                $hashtable += "$propertyPrefix$propertyName"
                $hashtable += "`r`n"
            }
        }
    }

    $defaultKeys=@(
        'Ensure'
        'Credential'
        'ApplicationId'
        'TenantId'
        'ApplicationSecret'
        'CertificateThumbprint'
        'Managedidentity'
    )
    foreach ($key in $defaultKeys)
    {
        $keyValue = "`$$key"
        if ($key -eq 'Ensure')
        {
            $keyValue = "'Present'"
        }
        if ($key -eq 'ManagedIdentity')
        {
            $keyValue = '$ManagedIdentity.IsPresent'
        }

        $spacing = $biggestParamaterLength - $key.length
        $hashtable += "            $($key + ' ' * $spacing) = $keyValue`r`n"
    }
    $results.Add('ConvertToVariable', $convertToVariable)
    $results.Add('ComplexTypeConstructor', $complexTypeConstructor.ToString())
    $results.Add('EnumTypeConstructor', $enumTypeConstructor.ToString())
    $results.Add('DateTypeConstructor', $dateTypeConstructor.ToString())
    $results.Add('TimeTypeConstructor', $timeTypeConstructor.ToString())
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
            $propertyType = $_.Type
            if ($_.IsComplexType)
            {
                $parameterBlockOutput += '        [Microsoft.Management.Infrastructure.CimInstance'
            }
            elseif ($propertyType.ToLower() -eq 'system.management.automation.switchparameter')
            {
                $parameterBlockOutput += '        [System.Boolean'
            }
            elseif ($propertyType.ToLower() -like 'system.date*')
            {
                $parameterBlockOutput += '        [System.String'
            }
            elseif ($propertyType.ToLower() -like 'system.binary*')
            {
                $parameterBlockOutput += '        [System.String'
            }
            else
            {
                $parameterBlockOutput += "        [$($_.Type.replace('[]',''))"
            }
            if ($_.IsArray)
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
function Get-ResourceStub
{
    param (
        [Parameter()]
        [System.String]
        $CmdletNoun
    )

    $parametersToSkip=@(
        'InformationVariable'
        'WhatIf'
        'WarningVariable'
        'OutVariable'
        'ErrorVariable'
        'WarningAction'
        'ErrorAction'
        'Debug'
        'Verbose'
        'IfMatch'
        'OutBuffer'
        'InformationAction'
        'PipelineVariable'
    )
    $stub=[System.Text.StringBuilder]::New()
    $version= (get-Command -Noun $cmdletNoun | select-object -Unique Version | Sort-Object -Descending | Select-Object -First 1).Version.toString()
    $commands = get-Command -Noun $cmdletNoun |where-object { $_.Version -eq $version }
    foreach ($command in $commands)
    {
        $command= get-Command -Name $command.Name |where-object { $_.Version -eq $version }
        $stub.AppendLine("function $($command.Name)")|out-null
        $stub.AppendLine("{")|out-null
        $stub.AppendLine("    [CmdletBinding()]")|out-null
        $stub.AppendLine("    param")|out-null
        $stub.AppendLine("    (")|out-null
        $parameters = $command.Parameters
        $i=0
        $keys= ($parameters.keys)  | where-object { $_ -notin $parametersToSkip }
        $keyCount = $keys.count
        foreach ($key in $keys)
        {
            $stub.AppendLine("        [Parameter()]")|out-null

            $name = ($parameters.$key).Name
            $type = ($parameters.$key).ParameterType.toString()
            $isArray = $false
            if ($type -like "*[[\]]")
            {
                $isArray = $true
            }

            if ($type -notlike "System.*")
            {
                $type = "PSObject"
                if ($isArray)
                {
                    $type += "[]"
                }
            }
            $stub.AppendLine("        [$type]")|out-null
            $stub.Append("        `$$name")|out-null
            if ($i -lt $keyCount -1 )
            {
                $stub.Append(",`r`n")|out-null
            }
            $stub.Append("`r`n")|out-null
            $i++
        }
        $stub.AppendLine("    )")|out-null
        $stub.AppendLine("}`r`n")|out-null
    }

    $stub.toString()
}

function Update-Microsoft365StubFile
{
    param (
        [Parameter()]
        [System.String]
        $CmdletNoun
    )

    try
    {
        $M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                            -ChildPath "..\Tests\Unit" `
                            -Resolve
        $filePath=(Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\Stubs\Microsoft365.psm1" `
        -Resolve)

        $content = Get-Content -Path $FilePath
        if (($content|select-string -pattern "function Get-$CmdletNoun$").count -eq 0)
        {
            $content += "#region $CmdletNoun`r`n" + (Get-ResourceStub -CmdletNoun $CmdletNoun) + "#endregion`r`n"
            Set-Content -Path $FilePath -Value $content
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error Updating Stub File:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source)
        Write-Error $_
    }
}
Export-ModuleMember -Function Get-MgGraphModuleCmdLetDifference, New-M365DSCResourceForGraphCmdLet, New-M365DSCResource, *
