function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

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
        [ValidateSet("Disabled","Mandatory","Optional")]
        [System.String]
        $TransportDecryptionSetting,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
    Write-Verbose -Message "Getting IRM Configuration"

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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

        $result = @{
            Identity                                    = $IRMConfiguration.Identity
            AutomaticServiceUpdateEnabled               = $IRMConfiguration.AutomaticServiceUpdateEnabled
            AzureRMSLicensingEnabled                    = $IRMConfiguration.AzureRMSLicensingEnabled
            DecryptAttachmentForEncryptOnly             = $IRMConfiguration.DecryptAttachmentForEncryptOnly
            EDiscoverySuperUserEnabled                  = $IRMConfiguration.EDiscoverySuperUserEnabled
            EnablePdfEncryption                         = $IRMConfiguration.EnablePdfEncryption
            InternalLicensingEnabled                    = $IRMConfiguration.InternalLicensingEnabled
            JournalReportDecryptionEnabled              = $IRMConfiguration.JournalReportDecryptionEnabled
            LicensingLocation                           = $IRMConfiguration.LicensingLocation
            RejectIfRecipientHasNoRights                = $IRMConfiguration.RejectIfRecipientHasNoRights
            RMSOnlineKeySharingLocation                 = $IRMConfiguration.RMSOnlineKeySharingLocation
            SearchEnabled                               = $IRMConfiguration.SearchEnabled
            SimplifiedClientAccessDoNotForwardDisabled  = $IRMConfiguration.SimplifiedClientAccessDoNotForwardDisabled
            SimplifiedClientAccessEnabled               = $IRMConfiguration.SimplifiedClientAccessEnabled
            SimplifiedClientAccessEncryptOnlyDisabled   = $IRMConfiguration.SimplifiedClientAccessEncryptOnlyDisabled
            TransportDecryptionSetting                  = $IRMConfiguration.TransportDecryptionSetting
            Credential                                  = $Credential
            Ensure                                      = 'Present'
            ApplicationId                               = $ApplicationId
            CertificateThumbprint                       = $CertificateThumbprint
            CertificatePath                             = $CertificatePath
            CertificatePassword                         = $CertificatePassword
            TenantId                                    = $TenantId
        }

        Write-Verbose -Message "Found IRM configuration "
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

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
        [ValidateSet("Disabled","Mandatory","Optional")]
        [System.String]
        $TransportDecryptionSetting,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Setting configuration of Resource Configuration"

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
    $IRMConfigurationParams.Remove('Identity') | Out-Null

    if (('Present' -eq $Ensure ) -and ($Null -ne $IRMConfigurationParams))
    {
        Write-Verbose -Message "Setting IRM Configuration with values: $(Convert-M365DscHashtableToString -Hashtable $IRMConfigurationParams)"
        Set-IRMConfiguration  @IRMConfigurationParams -Confirm:$false

        Write-Verbose -Message "IRM Configuration updated successfully"
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Identity,

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
        [ValidateSet("Disabled","Mandatory","Optional")]
        [System.String]
        $TransportDecryptionSetting,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of IRM Configuration "

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
        [System.String]
        $Identity,

        [Parameter()]
        [System.String[]]
        $ResourcePropertySchema,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' -InboundParameters $PSBoundParameters -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data

    #endregion
    try
    {
        $IRMConfiguration = Get-IRMConfiguration -ErrorAction Stop
        $dscContent = ""
        Write-Host "`r`n" -NoNewline

        Write-Host "    |---[1/1] $($IRMConfiguration.Identity)" -NoNewline

        $Params = @{
            Identity              = $IRMConfiguration.Identity
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}
Export-ModuleMember -Function *-TargetResource
