Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOAuthenticationPolicy'

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $AuthenticationPolicy = Get-AuthenticationPolicy -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $AuthenticationPolicy)
            {
                Write-Verbose -Message "Authentication Policy $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $AuthenticationPolicy = $Script:exportedInstance
        }

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
            ManagedIdentity                    = $ManagedIdentity.IsPresent
            TenantId                           = $TenantId
            AccessTokens                       = $AccessTokens
        }

        Write-Verbose -Message "Found Authentication Policy $($Identity)"
        return $result
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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
    # Policy cannot be changed so it must be deleted and re-created again
    elseif ($Ensure -eq 'Present' -and $currentAuthenticationPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Authentication Policy '$($Identity)' exists. Updating settings."
        Remove-AuthenticationPolicy -Identity $Identity -Confirm:$false
        New-AuthenticationPolicy -Name $Identity @NewAuthenticationPolicyParams | Out-Null
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
                Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for Authentication Policies"
                return ''
            }
            throw $_
        }

        $dscContent = [System.Text.StringBuilder]::new()
        if ($AllAuthenticationPolicies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($AuthenticationPolicy in $AllAuthenticationPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($AllAuthenticationPolicies.Count)] $($AuthenticationPolicy.Identity)" -DeferWrite

            $Params = @{
                Identity              = $AuthenticationPolicy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $AuthenticationPolicy
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
            $i++
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
