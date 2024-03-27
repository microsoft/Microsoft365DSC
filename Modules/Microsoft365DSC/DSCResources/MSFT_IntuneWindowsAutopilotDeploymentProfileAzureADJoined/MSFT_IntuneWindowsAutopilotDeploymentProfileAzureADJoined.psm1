function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DeviceNameTemplate,

        [Parameter()]
        [ValidateSet('windowsPc', 'surfaceHub2', 'holoLens', 'surfaceHub2S', 'virtualMachine', 'unknownFutureValue')]
        [System.String]
        $DeviceType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnableWhiteGlove,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnrollmentStatusScreenSettings,

        [Parameter()]
        [System.Boolean]
        $ExtractHardwareHash,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        $ManagementServiceAppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OutOfBoxExperienceSettings,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        $ManagedIdentity
    )

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -WindowsAutopilotDeploymentProfileId $Id  -ErrorAction SilentlyContinue `
            | Where-Object -FilterScript {$null -ne $_.DisplayName}

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Windows Autopilot Deployment Profile Azure AD Joined with Id {$Id}"

            if (-Not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile `
                    -Filter "DisplayName eq '$DisplayName'" `
                    -ErrorAction SilentlyContinue `
                    | Where-Object -FilterScript {$null -ne $_.DisplayName}
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Windows Autopilot Deployment Profile Azure AD Joined with DisplayName {$DisplayName}"
            return $nullResult
        }

        if($getValue -is [Array])
        {
            Throw "The DisplayName {$DisplayName} returned multiple policies, make sure DisplayName is unique."
        }

        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Windows Autopilot Deployment Profile Azure AD Joined with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $complexEnrollmentStatusScreenSettings = @{}
        $complexEnrollmentStatusScreenSettings.Add('AllowDeviceUseBeforeProfileAndAppInstallComplete', $getValue.EnrollmentStatusScreenSettings.allowDeviceUseBeforeProfileAndAppInstallComplete)
        $complexEnrollmentStatusScreenSettings.Add('AllowDeviceUseOnInstallFailure', $getValue.EnrollmentStatusScreenSettings.allowDeviceUseOnInstallFailure)
        $complexEnrollmentStatusScreenSettings.Add('AllowLogCollectionOnInstallFailure', $getValue.EnrollmentStatusScreenSettings.allowLogCollectionOnInstallFailure)
        $complexEnrollmentStatusScreenSettings.Add('BlockDeviceSetupRetryByUser', $getValue.EnrollmentStatusScreenSettings.blockDeviceSetupRetryByUser)
        $complexEnrollmentStatusScreenSettings.Add('CustomErrorMessage', $getValue.EnrollmentStatusScreenSettings.customErrorMessage)
        $complexEnrollmentStatusScreenSettings.Add('HideInstallationProgress', $getValue.EnrollmentStatusScreenSettings.hideInstallationProgress)
        $complexEnrollmentStatusScreenSettings.Add('InstallProgressTimeoutInMinutes', $getValue.EnrollmentStatusScreenSettings.installProgressTimeoutInMinutes)
        if ($complexEnrollmentStatusScreenSettings.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexEnrollmentStatusScreenSettings = $null
        }

        $complexOutOfBoxExperienceSettings = @{}
        if ($null -ne $getValue.OutOfBoxExperienceSettings.deviceUsageType)
        {
            $complexOutOfBoxExperienceSettings.Add('DeviceUsageType', $getValue.OutOfBoxExperienceSettings.deviceUsageType.toString())
        }
        $complexOutOfBoxExperienceSettings.Add('HideEscapeLink', $getValue.OutOfBoxExperienceSettings.hideEscapeLink)
        $complexOutOfBoxExperienceSettings.Add('HideEULA', $getValue.OutOfBoxExperienceSettings.hideEULA)
        $complexOutOfBoxExperienceSettings.Add('HidePrivacySettings', $getValue.OutOfBoxExperienceSettings.hidePrivacySettings)
        $complexOutOfBoxExperienceSettings.Add('SkipKeyboardSelectionPage', $getValue.OutOfBoxExperienceSettings.skipKeyboardSelectionPage)
        if ($null -ne $getValue.OutOfBoxExperienceSettings.userType)
        {
            $complexOutOfBoxExperienceSettings.Add('UserType', $getValue.OutOfBoxExperienceSettings.userType.toString())
        }
        if ($complexOutOfBoxExperienceSettings.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexOutOfBoxExperienceSettings = $null
        }
        #endregion

        #region resource generator code
        $enumDeviceType = $null
        if ($null -ne $getValue.DeviceType)
        {
            $enumDeviceType = $getValue.DeviceType.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            Description                    = $getValue.Description
            DeviceNameTemplate             = $getValue.DeviceNameTemplate
            DeviceType                     = $enumDeviceType
            DisplayName                    = $getValue.DisplayName
            EnableWhiteGlove               = $getValue.EnableWhiteGlove
            EnrollmentStatusScreenSettings = $complexEnrollmentStatusScreenSettings
            ExtractHardwareHash            = $getValue.ExtractHardwareHash
            Language                       = $getValue.Language
            ManagementServiceAppId         = $getValue.ManagementServiceAppId
            OutOfBoxExperienceSettings     = $complexOutOfBoxExperienceSettings
            Id                             = $getValue.Id
            Ensure                         = 'Present'
            Credential                     = $Credential
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            ApplicationSecret              = $ApplicationSecret
            CertificateThumbprint          = $CertificateThumbprint
            Managedidentity                = $ManagedIdentity.IsPresent
            #endregion
        }

        $rawAssignments = @()
        $rawAssignments =  Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment -WindowsAutopilotDeploymentProfileId $Id -All
        $assignmentResult = @()
        if($null -ne $rawAssignments -and $rawAssignments.count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $rawAssignments -IncludeDeviceFilter $false
        }
        $results.Add('Assignments', $assignmentResult)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DeviceNameTemplate,

        [Parameter()]
        [ValidateSet('windowsPc', 'surfaceHub2', 'holoLens', 'surfaceHub2S', 'virtualMachine', 'unknownFutureValue')]
        [System.String]
        $DeviceType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnableWhiteGlove,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnrollmentStatusScreenSettings,

        [Parameter()]
        [System.Boolean]
        $ExtractHardwareHash,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        $ManagementServiceAppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OutOfBoxExperienceSettings,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion
        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        $ManagedIdentity
    )

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
    $PSBoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Windows Autopilot Deployment Profile Azure AD Joined with DisplayName {$DisplayName}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
        }
        #region resource generator code
        $CreateParameters.Add("@odata.type", "#microsoft.graph.azureADWindowsAutopilotDeploymentProfile")
        $policy = New-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -BodyParameter $CreateParameters
        #endregion

        #region new Intune assignment management
        $intuneAssignments = @()
        if($null -ne $Assignments -and $Assignments.count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        foreach ($assignment in $intuneAssignments)
        {
            New-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment `
                -WindowsAutopilotDeploymentProfileId $policy.id `
                -BodyParameter $assignment
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Windows Autopilot Deployment Profile Azure AD Joined with Id {$($currentInstance.Id)}"
        $PSBoundParameters.Remove('Assignments') | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
        }
        #region resource generator code
        $UpdateParameters.Add("@odata.type", "#microsoft.graph.azureADWindowsAutopilotDeploymentProfile")
        Update-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile  `
            -WindowsAutopilotDeploymentProfileId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion

        #region new Intune assignment management
        $currentAssignments = @()
        $currentAssignments += Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment -WindowsAutopilotDeploymentProfileId $currentInstance.id

        $intuneAssignments = @()
        if($null -ne $Assignments -and $Assignments.count -gt 0)
        {
            $intuneAssignments += ConvertTo-IntunePolicyAssignment -Assignments $Assignments
        }
        foreach ($assignment in $intuneAssignments)
        {
            if ( $null -eq ($currentAssignments | Where-Object { $_.Target.AdditionalProperties.groupId -eq $assignment.Target.groupId -and $_.Target.AdditionalProperties."@odata.type" -eq $assignment.Target.'@odata.type' }))
            {
                New-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment `
                    -WindowsAutopilotDeploymentProfileId $currentInstance.id `
                    -BodyParameter $assignment
            }
            else
            {
                $currentAssignments = $currentAssignments | Where-Object { -not($_.Target.AdditionalProperties.groupId -eq $assignment.Target.groupId -and $_.Target.AdditionalProperties."@odata.type" -eq $assignment.Target.'@odata.type') }
            }
        }
        if($currentAssignments.count -gt 0)
        {
            foreach ($assignment in $currentAssignments)
            {
                Remove-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment `
                    -WindowsAutopilotDeploymentProfileId $currentInstance.Id `
                    -WindowsAutopilotDeploymentProfileAssignmentId $assignment.Id
            }
        }
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Windows Autopilot Deployment Profile Azure AD Joined with Id {$($currentInstance.Id)}"
        $currentAssignments = Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment -WindowsAutopilotDeploymentProfileId $currentInstance.Id -All
        foreach ($assignment in $currentAssignments)
        {
            Remove-MgBetaDeviceManagementWindowsAutopilotDeploymentProfileAssignment `
                -WindowsAutopilotDeploymentProfileId $currentInstance.Id `
                -WindowsAutopilotDeploymentProfileAssignmentId $assignment.Id
        }
        #region resource generator code
        Remove-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -WindowsAutopilotDeploymentProfileId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DeviceNameTemplate,

        [Parameter()]
        [ValidateSet('windowsPc', 'surfaceHub2', 'holoLens', 'surfaceHub2S', 'virtualMachine', 'unknownFutureValue')]
        [System.String]
        $DeviceType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnableWhiteGlove,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $EnrollmentStatusScreenSettings,

        [Parameter()]
        [System.Boolean]
        $ExtractHardwareHash,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        $ManagementServiceAppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $OutOfBoxExperienceSettings,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        $ManagedIdentity
    )

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

    Write-Verbose -Message "Testing configuration of the Intune Windows Autopilot Deployment Profile Azure AD Joined with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

                if( $key -eq "Assignments")
                {
                    $testResult = $source.count -eq $target.count
                    if (-Not $testResult) { break }
                    foreach ($assignment in $source)
                    {
                        if ($assignment.dataType -like '*GroupAssignmentTarget')
                        {
                            $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType -and $_.groupId -eq $assignment.groupId})
                            #Using assignment groupDisplayName only if the groupId is not found in the directory otherwise groupId should be the key
                            if (-not $testResult)
                            {
                                $groupNotFound =  $null -eq (Get-MgGroup -GroupId ($assignment.groupId) -ErrorAction SilentlyContinue)
                            }
                            if (-not $testResult -and $groupNotFound)
                            {
                                $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType -and $_.groupDisplayName -eq $assignment.groupDisplayName})
                            }
                        }
                        else
                        {
                            $testResult = $null -ne ($target | Where-Object {$_.dataType -eq $assignment.DataType})
                        }
                        if (-Not $testResult) { break }
                    }
                    if (-Not $testResult) { break }
                }
                if (-Not $testResult) { break }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        $ManagedIdentity
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
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile `
            -All `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.azureADWindowsAutopilotDeploymentProfile' `
        }
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.EnrollmentStatusScreenSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.EnrollmentStatusScreenSettings `
                    -CIMInstanceName 'MicrosoftGraphwindowsEnrollmentStatusScreenSettings1'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.EnrollmentStatusScreenSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('EnrollmentStatusScreenSettings') | Out-Null
                }
            }
            if ($null -ne $Results.OutOfBoxExperienceSettings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.OutOfBoxExperienceSettings `
                    -CIMInstanceName 'MicrosoftGraphoutOfBoxExperienceSettings1'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.OutOfBoxExperienceSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('OutOfBoxExperienceSettings') | Out-Null
                }
            }
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($Results.EnrollmentStatusScreenSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'EnrollmentStatusScreenSettings' -IsCIMArray:$False
            }
            if ($Results.OutOfBoxExperienceSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'OutOfBoxExperienceSettings' -IsCIMArray:$False
            }
            if ($Results.Assignments)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Assignments' -IsCIMArray:$true
            }
            #removing trailing commas and semi colons between items of an array of cim instances added by Convert-DSCStringParamToVariable
            $currentDSCBlock = $currentDSCBlock.replace("    ,`r`n" , "    `r`n" )
            $currentDSCBlock = $currentDSCBlock.replace("`r`n;`r`n" , "`r`n" )
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or `
        $_.Exception -like "*Request not applicable to target tenant*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
