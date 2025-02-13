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
        [System.Boolean]
        $AutomaticServiceUpdateEnabled,

        [Parameter()]
        [System.Boolean]
        $AzureRMSLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $DecryptAttachmentForEncryptOnly,

        [Parameter()]
        [System.Boolean]
        $EDiscoverySuperUserEnabled,

        [Parameter()]
        [System.Boolean]
        $EnablePdfEncryption,

        [Parameter()]
        [System.Boolean]
        $InternalLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $JournalReportDecryptionEnabled,

        [Parameter()]
        [System.Uri[]]
        $LicensingLocation,

        [Parameter()]
        [System.Boolean]
        $RejectIfRecipientHasNoRights,

        [Parameter()]
        [System.Uri]
        $RMSOnlineKeySharingLocation,

        [Parameter()]
        [System.Boolean]
        $SearchEnabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessDoNotForwardDisabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEncryptOnlyDisabled,

        [Parameter()]
        [ValidateSet('Disabled', 'Mandatory', 'Optional')]
        [System.String]
        $TransportDecryptionSetting,

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
    Write-Verbose -Message 'Getting IRM Configuration'

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
        $IRMConfiguration = Get-IRMConfiguration -ErrorAction Stop

        $RMSOnlineKeySharingLocationValue = $null
        if ($IRMConfiguration.RMSOnlineKeySharingLocation)
        {
            $RMSOnlineKeySharingLocationValue = $IRMConfiguration.RMSOnlineKeySharingLocation.ToString()
        }
        $result = @{
            IsSingleInstance                           = 'Yes'
            AutomaticServiceUpdateEnabled              = $IRMConfiguration.AutomaticServiceUpdateEnabled
            AzureRMSLicensingEnabled                   = $IRMConfiguration.AzureRMSLicensingEnabled
            DecryptAttachmentForEncryptOnly            = $IRMConfiguration.DecryptAttachmentForEncryptOnly
            EDiscoverySuperUserEnabled                 = $IRMConfiguration.EDiscoverySuperUserEnabled
            EnablePdfEncryption                        = $IRMConfiguration.EnablePdfEncryption
            InternalLicensingEnabled                   = $IRMConfiguration.InternalLicensingEnabled
            JournalReportDecryptionEnabled             = $IRMConfiguration.JournalReportDecryptionEnabled
            LicensingLocation                          = $IRMConfiguration.LicensingLocation
            RejectIfRecipientHasNoRights               = $IRMConfiguration.RejectIfRecipientHasNoRights
            RMSOnlineKeySharingLocation                = $RMSOnlineKeySharingLocationValue
            SearchEnabled                              = $IRMConfiguration.SearchEnabled
            SimplifiedClientAccessDoNotForwardDisabled = $IRMConfiguration.SimplifiedClientAccessDoNotForwardDisabled
            SimplifiedClientAccessEnabled              = $IRMConfiguration.SimplifiedClientAccessEnabled
            SimplifiedClientAccessEncryptOnlyDisabled  = $IRMConfiguration.SimplifiedClientAccessEncryptOnlyDisabled
            TransportDecryptionSetting                 = $IRMConfiguration.TransportDecryptionSetting
            Credential                                 = $Credential
            Ensure                                     = 'Present'
            ApplicationId                              = $ApplicationId
            CertificateThumbprint                      = $CertificateThumbprint
            CertificatePath                            = $CertificatePath
            CertificatePassword                        = $CertificatePassword
            Managedidentity                            = $ManagedIdentity.IsPresent
            TenantId                                   = $TenantId
            AccessTokens                               = $AccessTokens
        }

        Write-Verbose -Message 'Found IRM configuration '
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
        [System.Boolean]
        $AutomaticServiceUpdateEnabled,

        [Parameter()]
        [System.Boolean]
        $AzureRMSLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $DecryptAttachmentForEncryptOnly,

        [Parameter()]
        [System.Boolean]
        $EDiscoverySuperUserEnabled,

        [Parameter()]
        [System.Boolean]
        $EnablePdfEncryption,

        [Parameter()]
        [System.Boolean]
        $InternalLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $JournalReportDecryptionEnabled,

        [Parameter()]
        [System.Uri[]]
        $LicensingLocation,

        [Parameter()]
        [System.Boolean]
        $RejectIfRecipientHasNoRights,

        [Parameter()]
        [System.Uri]
        $RMSOnlineKeySharingLocation,

        [Parameter()]
        [System.Boolean]
        $SearchEnabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessDoNotForwardDisabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEncryptOnlyDisabled,

        [Parameter()]
        [ValidateSet('Disabled', 'Mandatory', 'Optional')]
        [System.String]
        $TransportDecryptionSetting,

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

    Write-Verbose -Message 'Setting configuration of Resource Configuration'

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $IRMConfigurationParams = [System.Collections.Hashtable]($PSBoundParameters)
    $IRMConfigurationParams.Remove('Ensure') | Out-Null
    $IRMConfigurationParams.Remove('Credential') | Out-Null
    $IRMConfigurationParams.Remove('ApplicationId') | Out-Null
    $IRMConfigurationParams.Remove('TenantId') | Out-Null
    $IRMConfigurationParams.Remove('CertificateThumbprint') | Out-Null
    $IRMConfigurationParams.Remove('CertificatePath') | Out-Null
    $IRMConfigurationParams.Remove('CertificatePassword') | Out-Null
    $IRMConfigurationParams.Remove('ManagedIdentity') | Out-Null
    $IRMConfigurationParams.Remove('IsSingleInstance') | Out-Null
    $IRMConfigurationParams.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and ($Null -ne $IRMConfigurationParams))
    {
        Write-Verbose -Message "Setting IRM Configuration with values: $(Convert-M365DscHashtableToString -Hashtable $IRMConfigurationParams)"
        Set-IRMConfiguration @IRMConfigurationParams -Confirm:$false

        Write-Verbose -Message 'IRM Configuration updated successfully'
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
        [System.Boolean]
        $AutomaticServiceUpdateEnabled,

        [Parameter()]
        [System.Boolean]
        $AzureRMSLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $DecryptAttachmentForEncryptOnly,

        [Parameter()]
        [System.Boolean]
        $EDiscoverySuperUserEnabled,

        [Parameter()]
        [System.Boolean]
        $EnablePdfEncryption,

        [Parameter()]
        [System.Boolean]
        $InternalLicensingEnabled,

        [Parameter()]
        [System.Boolean]
        $JournalReportDecryptionEnabled,

        [Parameter()]
        [System.Uri[]]
        $LicensingLocation,

        [Parameter()]
        [System.Boolean]
        $RejectIfRecipientHasNoRights,

        [Parameter()]
        [System.Uri]
        $RMSOnlineKeySharingLocation,

        [Parameter()]
        [System.Boolean]
        $SearchEnabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessDoNotForwardDisabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEnabled,

        [Parameter()]
        [System.Boolean]
        $SimplifiedClientAccessEncryptOnlyDisabled,

        [Parameter()]
        [ValidateSet('Disabled', 'Mandatory', 'Optional')]
        [System.String]
        $TransportDecryptionSetting,

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

    Write-Verbose -Message 'Testing configuration of IRM Configuration '

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Ensure') | Out-Null

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

        $IRMConfiguration = Get-IRMConfiguration -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline

        Write-Host "    |---[1/1] $($IRMConfiguration.Identity)" -NoNewline

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
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}
Export-ModuleMember -Function *-TargetResource
