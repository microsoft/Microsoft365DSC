function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.Boolean]
        $DisallowAadGuestUserAccess,

        [Parameter()]
        [System.Boolean]
        $DisallowOAuthAuthentication,

        [Parameter()]
        [System.Boolean]
        $DisallowSecureShell,

        [Parameter()]
        [System.Boolean]
        $LogAuditEvents,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousAccess,

        [Parameter()]
        [System.Boolean]
        $ArtifactsExternalPackageProtectionToken,

        [Parameter()]
        [System.Boolean]
        $EnforceAADConditionalAccess,

        [Parameter()]
        [System.Boolean]
        $AllowTeamAdminsInvitationsAccessToken,

        [Parameter()]
        [System.Boolean]
        $AllowRequestAccessToken,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    New-M365DSCConnection -Workload 'AzureDevOPS' `
        -InboundParameters $PSBoundParameters | Out-Null

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
    try
    {
        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.DisallowAadGuestUserAccess?defaultValue"
        $DisallowAadGuestUserAccessValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.DisallowOAuthAuthentication?defaultValue"
        $DisallowOAuthAuthenticationValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.DisallowSecureShell?defaultValue"
        $DisallowSecureShellValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.LogAuditEvents?defaultValue"
        $LogAuditEventsValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.AllowAnonymousAccess?defaultValue"
        $AllowAnonymousAccessValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.ArtifactsExternalPackageProtectionToken?defaultValue"
        $ArtifactsExternalPackageProtectionTokenValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.EnforceAADConditionalAccess?defaultValue"
        $EnforceAADConditionalAccessValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.AllowTeamAdminsInvitationsAccessToken?defaultValue"
        $AllowTeamAdminsInvitationsAccessTokenValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.AllowRequestAccessToken?defaultValue"
        $AllowRequestAccessTokenValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

        $results = @{
            DisallowAadGuestUserAccess              = [Boolean]::Parse($DisallowAadGuestUserAccessValue)
            DisallowOAuthAuthentication             = [Boolean]::Parse($DisallowOAuthAuthenticationValue)
            DisallowSecureShell                     = [Boolean]::Parse($DisallowSecureShellValue)
            LogAuditEvents                          = [Boolean]::Parse($LogAuditEventsValue)
            AllowAnonymousAccess                    = [Boolean]::Parse($AllowAnonymousAccessValue)
            ArtifactsExternalPackageProtectionToken = [Boolean]::Parse($ArtifactsExternalPackageProtectionTokenValue)
            EnforceAADConditionalAccess             = [Boolean]::Parse($EnforceAADConditionalAccessValue)
            AllowTeamAdminsInvitationsAccessToken   = [Boolean]::Parse($AllowTeamAdminsInvitationsAccessTokenValue)
            AllowRequestAccessToken                 = [Boolean]::Parse($AllowRequestAccessTokenValue)
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            CertificateThumbprint                   = $CertificateThumbprint
            ManagedIdentity                         = $ManagedIdentity.IsPresent
            AccessTokens                            = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.Boolean]
        $DisallowAadGuestUserAccess,

        [Parameter()]
        [System.Boolean]
        $DisallowOAuthAuthentication,

        [Parameter()]
        [System.Boolean]
        $DisallowSecureShell,

        [Parameter()]
        [System.Boolean]
        $LogAuditEvents,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousAccess,

        [Parameter()]
        [System.Boolean]
        $ArtifactsExternalPackageProtectionToken,

        [Parameter()]
        [System.Boolean]
        $EnforceAADConditionalAccess,

        [Parameter()]
        [System.Boolean]
        $AllowTeamAdminsInvitationsAccessToken,

        [Parameter()]
        [System.Boolean]
        $AllowRequestAccessToken,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    New-M365DSCConnection -Workload 'AzureDevOPS' `
        -InboundParameters $PSBoundParameters | Out-Null

    if ($PSBoundParameters.ContainsKey('DisallowAadGuestUserAccess'))
    {
        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.DisallowAadGuestUserAccess"
        $body = @{
            path = '/value'
            value = $DisallowAadGuestUserAccess
        }
        DisallowAadGuestUserAccessValue = Invoke-M365DSCAzureDevOPSWebRequest -uri $uri -Method 'PATCH'
    }
<#
    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.DisallowOAuthAuthentication?defaultValue"
    $DisallowOAuthAuthenticationValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.DisallowSecureShell?defaultValue"
    $DisallowSecureShellValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.LogAuditEvents?defaultValue"
    $LogAuditEventsValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.AllowAnonymousAccess?defaultValue"
    $AllowAnonymousAccessValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.ArtifactsExternalPackageProtectionToken?defaultValue"
    $ArtifactsExternalPackageProtectionTokenValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.EnforceAADConditionalAccess?defaultValue"
    $EnforceAADConditionalAccessValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.AllowTeamAdminsInvitationsAccessToken?defaultValue"
    $AllowTeamAdminsInvitationsAccessTokenValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value

    $uri = "https://dev.azure.com/$($OrganizationName)/_apis/OrganizationPolicy/Policies/Policy.AllowRequestAccessToken?defaultValue"
    $AllowRequestAccessTokenValue = (Invoke-M365DSCAzureDevOPSWebRequest -uri $uri).Value#>
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.Boolean]
        $DisallowAadGuestUserAccess,

        [Parameter()]
        [System.Boolean]
        $DisallowOAuthAuthentication,

        [Parameter()]
        [System.Boolean]
        $DisallowSecureShell,

        [Parameter()]
        [System.Boolean]
        $LogAuditEvents,

        [Parameter()]
        [System.Boolean]
        $AllowAnonymousAccess,

        [Parameter()]
        [System.Boolean]
        $ArtifactsExternalPackageProtectionToken,

        [Parameter()]
        [System.Boolean]
        $EnforceAADConditionalAccess,

        [Parameter()]
        [System.Boolean]
        $AllowTeamAdminsInvitationsAccessToken,

        [Parameter()]
        [System.Boolean]
        $AllowRequestAccessToken,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'AzureDevOPS' `
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
        $Script:ExportMode = $true

        $profile = Invoke-M365DSCAzureDevOPSWebRequest -Uri 'https://app.vssps.visualstudio.com/_apis/profile/profiles/me?api-version=5.1'
        $accounts = Invoke-M365DSCAzureDevOPSWebRequest -Uri "https://app.vssps.visualstudio.com/_apis/accounts?api-version=7.1-preview.1&memberId=$($profile.id)"

        $i = 1
        $dscContent = ''
        if ($accounts.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        $accounts = @{
            accountName = 'O365DSC-Dev'
        }
        foreach ($organization in $accounts.accountName)
        {

            $displayedKey = $organization
            Write-Host "    |---[$i/$($accounts.accountName.Count)] $displayedKey" -NoNewline
            $params = @{
                OrganizationName      = $organization
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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
