Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOAccessControlSettings'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.UInt32]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.Boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.UInt32]
        $EmailAttestationReAuthDays,

        [Parameter()]
        [System.Boolean]
        $EnableRestrictedAccessControl,

        [Parameter()]
        [ValidateSet('AllowFullAccess', 'AllowLimitedAccess', 'BlockAccess', 'ProtectionLevel')]
        [System.String]
        $ConditionalAccessPolicy,

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

    Write-Verbose -Message 'Getting configuration of SharePoint Online Access Control Settings'

    try
    {
        if ($null -eq $Script:exportedInstance)
        {
            $null = New-M365DSCConnection -Workload 'PnP' `
                -InboundParameters $PSBoundParameters

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

            $SPOAccessControlSettings = Get-PnPTenant -ErrorAction Stop
        }
        else
        {
            $SPOAccessControlSettings = $Script:exportedInstance
        }

        return @{
            IsSingleInstance              = 'Yes'
            ConditionalAccessPolicy       = $SPOAccessControlSettings.ConditionalAccessPolicy
            DisplayStartASiteOption       = $SPOAccessControlSettings.DisplayStartASiteOption
            StartASiteFormUrl             = $SPOAccessControlSettings.StartASiteFormUrl
            IPAddressEnforcement          = $SPOAccessControlSettings.IPAddressEnforcement
            IPAddressAllowList            = $SPOAccessControlSettings.IPAddressAllowList
            IPAddressWACTokenLifetime     = $SPOAccessControlSettings.IPAddressWACTokenLifetime
            DisallowInfectedFileDownload  = $SPOAccessControlSettings.DisallowInfectedFileDownload
            ExternalServicesEnabled       = $SPOAccessControlSettings.ExternalServicesEnabled
            EmailAttestationRequired      = $SPOAccessControlSettings.EmailAttestationRequired
            EmailAttestationReAuthDays    = $SPOAccessControlSettings.EmailAttestationReAuthDays
            EnableRestrictedAccessControl = $SPOAccessControlSettings.RestrictedAccessControl
            Credential                    = $Credential
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            ApplicationSecret             = $ApplicationSecret
            CertificateThumbprint         = $CertificateThumbprint
            CertificatePath               = $CertificatePath
            CertificatePassword           = $CertificatePassword
            ManagedIdentity               = $ManagedIdentity.IsPresent
            Ensure                        = 'Present'
            AccessTokens                  = $AccessTokens
        }
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
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.UInt32]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.Boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.UInt32]
        $EmailAttestationReAuthDays,

        [Parameter()]
        [System.Boolean]
        $EnableRestrictedAccessControl,

        [Parameter()]
        [ValidateSet('AllowFullAccess', 'AllowLimitedAccess', 'BlockAccess', 'ProtectionLevel')]
        [System.String]
        $ConditionalAccessPolicy,

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

    Write-Verbose -Message 'Setting configuration of SharePoint Online Access Control Settings'

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

    $null = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    $CurrentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $CurrentParameters.Remove('IsSingleInstance') | Out-Null

    if ($IPAddressAllowList -eq '')
    {
        Write-Verbose -Message 'The IPAddressAllowList is not configured, for that the IPAddressEnforcement parameter can not be set and will be removed'
        $CurrentParameters.Remove('IPAddressEnforcement')
        $CurrentParameters.Remove('IPAddressAllowList')
    }

    $EnableRestrictedAccessControlValue = $null
    if ($null -ne $EnableRestrictedAccessControl)
    {
        $EnableRestrictedAccessControlValue = $EnableRestrictedAccessControl
        $CurrentParameters.Remove('EnableRestrictedAccessControl') | Out-Null
    }

    Set-PnPTenant @CurrentParameters | Out-Null

    try
    {
        Set-PnPTenant -EnableRestrictedAccessControl $EnableRestrictedAccessControlValue -ErrorAction Stop | Out-Null
    }
    catch
    {
        if ($_.ErrorDetails.Message.Contains("This operation can't be performed as the tenant doesn't have the required license"))
        {
            Write-Warning -Message "The tenant doesn't have the required license to configure Restrcited Access Control."
        }
        else
        {
            Write-Error $_.ErrorDetails.Message
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $DisplayStartASiteOption,

        [Parameter()]
        [System.String]
        $StartASiteFormUrl,

        [Parameter()]
        [System.Boolean]
        $IPAddressEnforcement,

        [Parameter()]
        [System.String]
        $IPAddressAllowList,

        [Parameter()]
        [System.UInt32]
        $IPAddressWACTokenLifetime,

        [Parameter()]
        [System.Boolean]
        $DisallowInfectedFileDownload,

        [Parameter()]
        [System.Boolean]
        $ExternalServicesEnabled,

        [Parameter()]
        [System.Boolean]
        $EmailAttestationRequired,

        [Parameter()]
        [System.UInt32]
        $EmailAttestationReAuthDays,

        [Parameter()]
        [System.Boolean]
        $EnableRestrictedAccessControl,

        [Parameter()]
        [ValidateSet('AllowFullAccess', 'AllowLimitedAccess', 'BlockAccess', 'ProtectionLevel')]
        [System.String]
        $ConditionalAccessPolicy,

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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
            -InboundParameters $PSBoundParameters

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

        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Script:exportedInstance = Get-PnPTenant -ErrorAction Stop

        $Params = @{
            IsSingleInstance      = 'Yes'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
            ApplicationSecret     = $ApplicationSecret
            AccessTokens          = $AccessTokens
        }

        $dscContent = [System.Text.StringBuilder]::new()
        $Results = Get-TargetResource @Params
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        [void]$dscContent.Append($currentDSCBlock)
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
