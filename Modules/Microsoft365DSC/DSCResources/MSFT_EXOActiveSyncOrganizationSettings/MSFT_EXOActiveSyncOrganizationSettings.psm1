Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOActiveSyncOrganizationSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $DefaultAccessLevel,

        [Parameter()]
        [System.String]
        $TenantAdminPreference,

        [Parameter()]
        [System.String]
        $UserMailInsert,

        [Parameter()]
        [System.Boolean]
        $AllowAccessForUnSupportedPlatform,

        [Parameter()]
        [System.Boolean]
        $EnableMobileMailboxPolicyWhenCAInplace,

        [Parameter()]
        [System.Boolean]
        $AllowRMSSupportForUnenlightenedApps,

        [Parameter()]
        [System.String[]]
        $AdminMailRecipients,

        [Parameter()]
        [System.String]
        $OtaNotificationMailInsert,

        [Parameter()]
        [System.String]
        $DeviceFiltering,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $IsIntuneManaged,

        [Parameter()]
        [System.Boolean]
        $HasAzurePremiumSubscription,

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
    Write-Verbose -Message 'Getting EXO ActiveSync Organization Settings'

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $ActiveSyncOrgSettings = Get-ActiveSyncOrganizationSettings -ErrorAction Stop

        $result = @{
            IsSingleInstance                        = 'Yes'
            DefaultAccessLevel                      = $ActiveSyncOrgSettings.DefaultAccessLevel
            TenantAdminPreference                   = $ActiveSyncOrgSettings.TenantAdminPreference
            UserMailInsert                          = $ActiveSyncOrgSettings.UserMailInsert
            AllowAccessForUnSupportedPlatform       = $ActiveSyncOrgSettings.AllowAccessForUnSupportedPlatform
            EnableMobileMailboxPolicyWhenCAInplace  = $ActiveSyncOrgSettings.EnableMobileMailboxPolicyWhenCAInplace
            AllowRMSSupportForUnenlightenedApps     = $ActiveSyncOrgSettings.AllowRMSSupportForUnenlightenedApps
            AdminMailRecipients                     = $ActiveSyncOrgSettings.AdminMailRecipients
            OtaNotificationMailInsert               = $ActiveSyncOrgSettings.OtaNotificationMailInsert
            DeviceFiltering                         = $ActiveSyncOrgSettings.DeviceFiltering
            Identity                                = $ActiveSyncOrgSettings.Identity
            IsIntuneManaged                         = $ActiveSyncOrgSettings.IsIntuneManaged
            HasAzurePremiumSubscription             = $ActiveSyncOrgSettings.HasAzurePremiumSubscription
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            CertificateThumbprint                   = $CertificateThumbprint
            CertificatePath                         = $CertificatePath
            CertificatePassword                     = $CertificatePassword
            Managedidentity                         = $ManagedIdentity.IsPresent
            TenantId                                = $TenantId
            AccessTokens                            = $AccessTokens
        }

        Write-Verbose -Message 'Found ActiveSync Organization Settings config '
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $DefaultAccessLevel,

        [Parameter()]
        [System.String]
        $TenantAdminPreference,

        [Parameter()]
        [System.String]
        $UserMailInsert,

        [Parameter()]
        [System.Boolean]
        $AllowAccessForUnSupportedPlatform,

        [Parameter()]
        [System.Boolean]
        $EnableMobileMailboxPolicyWhenCAInplace,

        [Parameter()]
        [System.Boolean]
        $AllowRMSSupportForUnenlightenedApps,

        [Parameter()]
        [System.String[]]
        $AdminMailRecipients,

        [Parameter()]
        [System.String]
        $OtaNotificationMailInsert,

        [Parameter()]
        [System.String]
        $DeviceFiltering,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $IsIntuneManaged,

        [Parameter()]
        [System.Boolean]
        $HasAzurePremiumSubscription,

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
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message 'Setting configuration of ActiveSync Organization Settings'

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $ActiveSyncOrgSettingsParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    #removing params that cannot be set.
    $ActiveSyncOrgSettingsParams.Remove('IsSingleInstance') | Out-Null
    $ActiveSyncOrgSettingsParams.Remove('Identity') | Out-Null
    $ActiveSyncOrgSettingsParams.Remove('IsIntuneManaged') | Out-Null
    $ActiveSyncOrgSettingsParams.Remove('HasAzurePremiumSubscription') | Out-Null

    if ($Null -ne $ActiveSyncOrgSettingsParams -and $ActiveSyncOrgSettingsParams.Count -gt 0)
    {
        Write-Verbose -Message "Setting ActiveSync Organization Settings with values: $(Convert-M365DscHashtableToString -Hashtable $ActiveSyncOrgSettingsParams)"
        Set-ActiveSyncOrganizationSettings @ActiveSyncOrgSettingsParams

        Write-Verbose -Message 'ActiveSync Organization Settings updated successfully'
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $DefaultAccessLevel,

        [Parameter()]
        [System.String]
        $TenantAdminPreference,

        [Parameter()]
        [System.String]
        $UserMailInsert,

        [Parameter()]
        [System.Boolean]
        $AllowAccessForUnSupportedPlatform,

        [Parameter()]
        [System.Boolean]
        $EnableMobileMailboxPolicyWhenCAInplace,

        [Parameter()]
        [System.Boolean]
        $AllowRMSSupportForUnenlightenedApps,

        [Parameter()]
        [System.String[]]
        $AdminMailRecipients,

        [Parameter()]
        [System.String]
        $OtaNotificationMailInsert,

        [Parameter()]
        [System.String]
        $DeviceFiltering,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $IsIntuneManaged,

        [Parameter()]
        [System.Boolean]
        $HasAzurePremiumSubscription,

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
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message 'Testing configuration of ActiveSync Organization Settings'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null
    $ValuesToCheck.Remove('AccessTokens') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

    return $TestResult
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
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' -InboundParameters $PSBoundParameters -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data

    #endregion
    try
    {
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $ActiveSyncOrgSettings = Get-ActiveSyncOrganizationSettings -ErrorAction Stop
        $dscContent = ''
        Write-M365DSCHost -Message "`r`n" -DeferWrite

        Write-M365DSCHost -Message  "    |---[1/1] $($ActiveSyncOrgSettings.Identity)" -DeferWrite

        $Params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            Managedidentity       = $ManagedIdentity.IsPresent
            CertificatePath       = $CertificatePath
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}
Export-ModuleMember -Function *-TargetResource

