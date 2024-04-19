function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthActiveSync,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthAutodiscover,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthImap,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthMapi,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthOfflineAddressBook,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthOutlookService,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthPop,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthPowerShell,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthReportingWebServices,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthRpc,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthSmtp,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthWebServices,

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

    Write-Verbose -Message "Getting Authentication Policy configuration for $Identity"
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
        try
        {
            $AllAuthenticationPolicies = Get-AuthenticationPolicy -ErrorAction Stop
        }
        catch
        {
            if ($_.Exception -like "The operation couldn't be performed because object*")
            {
                Write-Verbose 'Could not obtain Authentication Policies for Tenant'
                return $nullReturn
            }
        }

        $AuthenticationPolicy = $AllAuthenticationPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }

        if ($null -eq $AuthenticationPolicy)
        {
            Write-Verbose -Message "Authentication Policy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity                           = $AuthenticationPolicy.Identity
                AllowBasicAuthActiveSync           = $AuthenticationPolicy.AllowBasicAuthActiveSync
                AllowBasicAuthAutodiscover         = $AuthenticationPolicy.AllowBasicAuthAutodiscover
                AllowBasicAuthImap                 = $AuthenticationPolicy.AllowBasicAuthImap
                AllowBasicAuthMapi                 = $AuthenticationPolicy.AllowBasicAuthMapi
                AllowBasicAuthOfflineAddressBook   = $AuthenticationPolicy.AllowBasicAuthOfflineAddressBook
                AllowBasicAuthOutlookService       = $AuthenticationPolicy.AllowBasicAuthOutlookService
                AllowBasicAuthPop                  = $AuthenticationPolicy.AllowBasicAuthPop
                AllowBasicAuthPowerShell           = $AuthenticationPolicy.AllowBasicAuthPowerShell
                AllowBasicAuthReportingWebServices = $AuthenticationPolicy.AllowBasicAuthReportingWebServices
                AllowBasicAuthRpc                  = $AuthenticationPolicy.AllowBasicAuthRpc
                AllowBasicAuthSmtp                 = $AuthenticationPolicy.AllowBasicAuthSmtp
                AllowBasicAuthWebServices          = $AuthenticationPolicy.AllowBasicAuthWebServices
                Ensure                             = 'Present'
                Credential                         = $Credential
                ApplicationId                      = $ApplicationId
                CertificateThumbprint              = $CertificateThumbprint
                CertificatePath                    = $CertificatePath
                CertificatePassword                = $CertificatePassword
                Managedidentity                    = $ManagedIdentity.IsPresent
                TenantId                           = $TenantId
                AccessTokens                       = $AccessTokens
            }

            Write-Verbose -Message "Found Authentication Policy $($Identity)"
            return $result
        }
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthActiveSync,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthAutodiscover,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthImap,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthMapi,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthOfflineAddressBook,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthOutlookService,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthPop,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthPowerShell,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthReportingWebServices,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthRpc,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthSmtp,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthWebServices,

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

    Write-Verbose -Message "Setting Authentication Policy configuration for $Identity"

    $currentAuthenticationPolicyConfig = Get-TargetResource @PSBoundParameters

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewAuthenticationPolicyParams = @{
        AllowBasicAuthActiveSync           = $AllowBasicAuthActiveSync
        AllowBasicAuthAutodiscover         = $AllowBasicAuthAutodiscover
        AllowBasicAuthImap                 = $AllowBasicAuthImap
        AllowBasicAuthMapi                 = $AllowBasicAuthMapi
        AllowBasicAuthOfflineAddressBook   = $AllowBasicAuthOfflineAddressBook
        AllowBasicAuthOutlookService       = $AllowBasicAuthOutlookService
        AllowBasicAuthPop                  = $AllowBasicAuthPop
        AllowBasicAuthPowerShell           = $AllowBasicAuthPowerShell
        AllowBasicAuthReportingWebServices = $AllowBasicAuthReportingWebServices
        AllowBasicAuthRpc                  = $AllowBasicAuthRpc
        AllowBasicAuthSmtp                 = $AllowBasicAuthSmtp
        AllowBasicAuthWebServices          = $AllowBasicAuthWebServices
    }

    # CASE: Authentication Policy doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentAuthenticationPolicyConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Authentication Policy '$($Identity)' does not exist but it should. Create and configure it."
        New-AuthenticationPolicy -Name $Identity @NewAuthenticationPolicyParams | Out-Null
    }
    # CASE: Authentication Policy exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentAuthenticationPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Authentication Policy '$($Identity)' exists but it shouldn't. Remove it."
        Remove-AuthenticationPolicy -Identity $Identity -Confirm:$false
    }
    # CASE: Authentication Policy exists and it should, but has different values than the desired one
    elseif ($Ensure -eq 'Present' -and $currentAuthenticationPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Authentication Policy '$($Identity)' exists. Updating settings."
        Set-AuthenticationPolicy -Identity $Identity @NewAuthenticationPolicyParams | Out-Null
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
        $Identity,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthActiveSync,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthAutodiscover,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthImap,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthMapi,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthOfflineAddressBook,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthOutlookService,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthPop,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthPowerShell,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthReportingWebServices,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthRpc,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthSmtp,

        [Parameter()]
        [System.Boolean]
        $AllowBasicAuthWebServices,

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

    Write-Verbose -Message "Testing Authentication Policy configuration for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

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
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        try
        {
            [array]$AllAuthenticationPolicies = Get-AuthenticationPolicy -ErrorAction SilentlyContinue
        }
        catch
        {
            if ($_.Exception -like "*The operation couldn't be performed because object*")
            {
                Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for Authentication Policies"
                return ''
            }
            throw $_
        }

        $dscContent = ''
        if ($AllAuthenticationPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($AuthenticationPolicy in $AllAuthenticationPolicies)
        {
            Write-Host "    |---[$i/$($AllAuthenticationPolicies.Count)] $($AuthenticationPolicy.Identity)" -NoNewline

            $Params = @{
                Identity              = $AuthenticationPolicy.Identity
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
            $i++
        }
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
