Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADAuthenticationMethodPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Int32]
        $ReconfirmationInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RegistrationEnforcement,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ReportSuspiciousActivitySettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SystemCredentialPreferences,
        #endregion

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Authentication Method Policy '$DisplayName'"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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

            $getValue = Get-MgBetaPolicyAuthenticationMethodPolicy -ErrorAction Stop
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        Write-Verbose -Message "An Azure AD Authentication Method Policy was found."

        #region resource generator code
        $complexRegistrationEnforcement = [ordered]@{}
        $complexAuthenticationMethodsRegistrationCampaign = [ordered]@{}
        $complexExcludeTargets = @()
        foreach ($currentExcludeTargets in $getValue.registrationEnforcement.authenticationMethodsRegistrationCampaign.excludeTargets)
        {
            $myExcludeTargets = [ordered]@{}
            if ($null -ne $currentExcludeTargets.targetType)
            {
                $myExcludeTargets.Add('TargetType', $currentExcludeTargets.targetType.ToString())
                if ($myExcludeTargets.TargetType -eq 'Group')
                {
                    $myExcludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $currentExcludeTargets.Id
                    if ($null -eq $myExcludeTargetsDisplayName)
                    {
                        continue
                    }
                    $myExcludeTargets.Add('Id', $myExcludeTargetsDisplayName)
                }
                elseif ($myExcludeTargets.TargetType -eq 'User')
                {
                    $myExcludeTargetsUserPrincipalName = Get-M365DSCUserPrincipalNameById -UserId $currentExcludeTargets.Id
                    if ($null -eq $myExcludeTargetsUserPrincipalName)
                    {
                        continue
                    }
                    $myExcludeTargets.Add('Id', $myExcludeTargetsUserPrincipalName)
                }
            }
            if ($myExcludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexExcludeTargets += $myExcludeTargets
            }
        }
        $complexAuthenticationMethodsRegistrationCampaign.Add('ExcludeTargets', $complexExcludeTargets)
        $complexIncludeTargets = @()
        foreach ($currentIncludeTargets in $getValue.registrationEnforcement.authenticationMethodsRegistrationCampaign.includeTargets)
        {
            $myIncludeTargets = [ordered]@{}
            if ($currentIncludeTargets.id -ne "all_users")
            {
                $myIncludeTargetsDisplayName = $null
                if ($currentIncludeTargets.targetType -eq 'Group')
                {
                    $myIncludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $currentIncludeTargets.Id
                }
                elseif ($currentIncludeTargets.targetType -eq 'User')
                {
                    $myIncludeTargetsDisplayName = Get-M365DSCUserPrincipalNameById -UserId $currentIncludeTargets.Id
                }
                if (-not [System.String]::IsNullOrEmpty($myIncludeTargetsDisplayName))
                {
                    $myIncludeTargets.Add('Id', $myIncludeTargetsDisplayName)
                }
            }
            else
            {
                $myIncludeTargets.Add('Id', $currentIncludeTargets.id)
            }
            $myIncludeTargets.Add('TargetedAuthenticationMethod', $currentIncludeTargets.targetedAuthenticationMethod)
            if ($null -ne $currentIncludeTargets.targetType)
            {
                $myIncludeTargets.Add('TargetType', $currentIncludeTargets.targetType.ToString())
            }
            if ($myIncludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexIncludeTargets += $myIncludeTargets
            }
        }
        $complexAuthenticationMethodsRegistrationCampaign.Add('IncludeTargets', $complexIncludeTargets)
        $complexAuthenticationMethodsRegistrationCampaign.Add('SnoozeDurationInDays', $getValue.registrationEnforcement.authenticationMethodsRegistrationCampaign.snoozeDurationInDays)
        if ($null -ne $getValue.registrationEnforcement.authenticationMethodsRegistrationCampaign.state)
        {
            $complexAuthenticationMethodsRegistrationCampaign.Add('State', $getValue.registrationEnforcement.authenticationMethodsRegistrationCampaign.state.ToString())
        }
        if ($complexAuthenticationMethodsRegistrationCampaign.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexAuthenticationMethodsRegistrationCampaign = $null
        }
        $complexRegistrationEnforcement.Add('AuthenticationMethodsRegistrationCampaign', $complexAuthenticationMethodsRegistrationCampaign)
        if ($complexRegistrationEnforcement.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexRegistrationEnforcement = $null
        }

        $complexReportSuspiciousActivitySettings = [ordered]@{}
        $newComplexIncludeTarget = [ordered]@{}
        if ($getValue.ReportSuspiciousActivitySettings.IncludeTarget.id -ne "all_users")
        {
            $includeTargetDisplayName = $null
            if ($getValue.ReportSuspiciousActivitySettings.IncludeTarget.targetType -eq 'Group')
            {
                $includeTargetDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $getValue.ReportSuspiciousActivitySettings.IncludeTarget.Id
                if ($null -ne $includeTargetDisplayName)
                {
                    $newComplexIncludeTarget.Add('Id', $includeTargetDisplayName)
                }
            }
        }
        else
        {
            $newComplexIncludeTarget.Add('Id', $getValue.ReportSuspiciousActivitySettings.IncludeTarget.id)
        }
        if ($null -ne $getValue.ReportSuspiciousActivitySettings.IncludeTarget.targetType)
        {
            $newComplexIncludeTarget.Add('TargetType', $getValue.ReportSuspiciousActivitySettings.IncludeTarget.targetType.ToString())
        }
        $complexReportSuspiciousActivitySettings.Add('IncludeTarget', $newComplexIncludeTarget)

        if ($null -ne $getValue.ReportSuspiciousActivitySettings.state)
        {
            $complexReportSuspiciousActivitySettings.Add('State', $getValue.ReportSuspiciousActivitySettings.state.ToString())
        }
        if ($null -ne $getValue.ReportSuspiciousActivitySettings.VoiceReportingCode)
        {
            $complexReportSuspiciousActivitySettings.Add('VoiceReportingCode', $getValue.ReportSuspiciousActivitySettings.VoiceReportingCode)
        }
        if ($complexReportSuspiciousActivitySettings.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexReportSuspiciousActivitySettings = $null
        }

        $complexSystemCredentialPreferences = [ordered]@{}
        $complexExcludeTargets = @()
        foreach ($currentExcludeTargets in $getValue.SystemCredentialPreferences.excludeTargets)
        {
            $myExcludeTargets = [ordered]@{}
            if ($currentExcludeTargets.id -ne "all_users")
            {
                if ($currentExcludeTargets.targetType -eq 'Group')
                {
                    $myExcludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $currentExcludeTargets.Id
                    if ($null -eq $myExcludeTargetsDisplayName)
                    {
                        continue
                    }
                    $myExcludeTargets.Add('Id', $myExcludeTargetsDisplayName)
                }
            }
            else
            {
                $myExcludeTargets.Add('Id', $currentExcludeTargets.id)
            }
            if ($null -ne $currentExcludeTargets.targetType)
            {
                $myExcludeTargets.Add('TargetType', $currentExcludeTargets.targetType.ToString())
            }
            if ($myExcludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexExcludeTargets += $myExcludeTargets
            }
        }
        $complexSystemCredentialPreferences.Add('ExcludeTargets', $complexExcludeTargets)
        $complexIncludeTargets = @()
        foreach ($currentIncludeTargets in $getValue.SystemCredentialPreferences.includeTargets)
        {
            $myIncludeTargets = [ordered]@{}
            if ($currentIncludeTargets.id -ne "all_users")
            {
                if ($currentIncludeTargets.targetType -eq 'Group')
                {
                    $myIncludeTargetsDisplayName = Get-M365DSCGroupDisplayNameById -GroupId $currentIncludeTargets.Id
                    if ($null -eq $myIncludeTargetsDisplayName)
                    {
                        continue
                    }
                    $myIncludeTargets.Add('Id', $myIncludeTargetsDisplayName)
                }
            }
            else
            {
                $myIncludeTargets.Add('Id', $currentIncludeTargets.id)
            }
            if ($null -ne $currentIncludeTargets.targetType)
            {
                $myIncludeTargets.Add('TargetType', $currentIncludeTargets.targetType.ToString())
            }
            if ($myIncludeTargets.values.Where({ $null -ne $_ }).Count -gt 0)
            {
                $complexIncludeTargets += $myIncludeTargets
            }
        }
        $complexSystemCredentialPreferences.Add('IncludeTargets', $complexIncludeTargets)
        if ($null -ne $getValue.SystemCredentialPreferences.state)
        {
            $complexSystemCredentialPreferences.Add('State', $getValue.SystemCredentialPreferences.state.ToString())
        }
        if ($complexSystemCredentialPreferences.values.Where({ $null -ne $_ }).Count -eq 0)
        {
            $complexSystemCredentialPreferences = $null
        }
        #endregion

        $results = @{
            #region resource generator code
            ReconfirmationInDays             = $getValue.ReconfirmationInDays
            RegistrationEnforcement          = $complexRegistrationEnforcement
            ReportSuspiciousActivitySettings = $complexReportSuspiciousActivitySettings
            SystemCredentialPreferences      = $complexSystemCredentialPreferences
            IsSingleInstance                 = 'Yes'
            Credential                       = $Credential
            ApplicationId                    = $ApplicationId
            TenantId                         = $TenantId
            ApplicationSecret                = $ApplicationSecret
            CertificateThumbprint            = $CertificateThumbprint
            CertificatePath                  = $CertificatePath
            CertificatePassword              = $CertificatePassword
            ManagedIdentity                  = $ManagedIdentity.IsPresent
            AccessTokens                     = $AccessTokens
            #endregion
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
        #region resource generator code
        [Parameter()]
        [System.Int32]
        $ReconfirmationInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RegistrationEnforcement,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ReportSuspiciousActivitySettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SystemCredentialPreferences,

        #endregion
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of Authentication Method Policy '$DisplayName'"

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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    Write-Verbose -Message "Updating the Azure AD Authentication Method Policy"

    $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $boundParameters
    Update-M365DSCAuthenticationTargets -Targets $updateParameters.RegistrationEnforcement.AuthenticationMethodsRegistrationCampaign.ExcludeTargets
    Update-M365DSCAuthenticationTargets -Targets $updateParameters.RegistrationEnforcement.AuthenticationMethodsRegistrationCampaign.IncludeTargets
    Update-M365DSCAuthenticationTargets -Targets $updateParameters.ReportSuspiciousActivitySettings.IncludeTarget
    Update-M365DSCAuthenticationTargets -Targets $updateParameters.SystemCredentialPreferences.ExcludeTargets
    Update-M365DSCAuthenticationTargets -Targets $updateParameters.SystemCredentialPreferences.IncludeTargets

    #region resource generator code
    $updateParameters.Remove('IsSingleInstance') | Out-Null
    $updateParameters.Add('@odata.type', '#microsoft.graph.AuthenticationMethodsPolicy')
    Update-MgBetaPolicyAuthenticationMethodPolicy -BodyParameter $updateParameters
    #endregion
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.Int32]
        $ReconfirmationInDays,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RegistrationEnforcement,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $ReportSuspiciousActivitySettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $SystemCredentialPreferences,
        #endregion

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        #region resource generator code
        [array]$getValue = Get-MgBetaPolicyAuthenticationMethodPolicy -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName

                Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
                $params = @{
                    IsSingleInstance      = 'Yes'
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
                if ($null -ne $Results.RegistrationEnforcement)
                {
                    $complexMapping = @(
                        @{
                            Name            = 'RegistrationEnforcement'
                            CimInstanceName = 'MicrosoftGraphRegistrationEnforcement'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'AuthenticationMethodsRegistrationCampaign'
                            CimInstanceName = 'MicrosoftGraphAuthenticationMethodsRegistrationCampaign'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'ExcludeTargets'
                            CimInstanceName = 'MicrosoftGraphExcludeTarget'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'IncludeTargets'
                            CimInstanceName = 'MicrosoftGraphAuthenticationMethodsRegistrationCampaignIncludeTarget'
                            IsRequired      = $False
                        }
                    )
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.RegistrationEnforcement `
                        -CIMInstanceName 'MicrosoftGraphregistrationEnforcement' `
                        -ComplexTypeMapping $complexMapping

                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.RegistrationEnforcement = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('RegistrationEnforcement') | Out-Null
                    }
                }

                if ($null -ne $Results.ReportSuspiciousActivitySettings)
                {
                    $complexMapping = @(
                        @{
                            Name            = 'ReportSuspiciousActivitySettings'
                            CimInstanceName = 'MicrosoftGraphReportSuspiciousActivitySettings'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'IncludeTarget'
                            CimInstanceName = 'AADAuthenticationMethodPolicyIncludeTarget'
                            IsRequired      = $False
                        }
                    )
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.ReportSuspiciousActivitySettings `
                        -CIMInstanceName 'MicrosoftGraphreportSuspiciousActivitySettings' `
                        -ComplexTypeMapping $complexMapping

                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.ReportSuspiciousActivitySettings = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('ReportSuspiciousActivitySettings') | Out-Null
                    }
                }

                if ($null -ne $Results.SystemCredentialPreferences)
                {
                    $complexMapping = @(
                        @{
                            Name            = 'SystemCredentialPreferences'
                            CimInstanceName = 'MicrosoftGraphSystemCredentialPreferences'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'ExcludeTargets'
                            CimInstanceName = 'AADAuthenticationMethodPolicyExcludeTarget'
                            IsRequired      = $False
                        }
                        @{
                            Name            = 'IncludeTargets'
                            CimInstanceName = 'AADAuthenticationMethodPolicyIncludeTarget'
                            IsRequired      = $False
                        }
                    )
                    $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                        -ComplexObject $Results.SystemCredentialPreferences `
                        -CIMInstanceName 'MicrosoftGraphsystemCredentialPreferences' `
                        -ComplexTypeMapping $complexMapping

                    if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                    {
                        $Results.SystemCredentialPreferences = $complexTypeStringResult
                    }
                    else
                    {
                        $Results.Remove('SystemCredentialPreferences') | Out-Null
                    }
                }

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential `
                    -NoEscape @('RegistrationEnforcement', 'ReportSuspiciousActivitySettings', 'SystemCredentialPreferences')

                [void]$dscContent.Append($currentDSCBlock)
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
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

Export-ModuleMember -Function *-TargetResource
