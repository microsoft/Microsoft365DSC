function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of Azure AD ServicePrincipal"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
                        -InboundParameters $PSBoundParameters

    try 
    {
        if ($null -ne $ObjectID)
        {
            $AADServicePrincipal = Get-AzureADServicePrincipal -ObjectID $ObjectId
        }
    }
    catch 
    {
        Write-Error -Message "Azure AD ServicePrincipal with ObjectID: $($ObjectID) could not be retrieved"
    }

    if($null -eq $AADServicePrincipal)
    {
        $AADServicePrincipal = Get-AzureADServicePrincipal -Filter "AppID eq '$($AppId)'"
    }
    if($null -eq $AADServicePrincipal)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        $result = @{
            AppId                         = $AADServicePrincipal.AppId
            ObjectID                      = $AADServicePrincipal.ObjectId
            DisplayName                   = $AADServicePrincipal.DisplayName
            AlternativeNames              = $AADServicePrincipal.AlternativeNames
            AccountEnabled                = $AADServicePrincipal.AccountEnabled
            AppRoleAssignmentRequired     = $AADServicePrincipal.AppRoleAssignmentRequired
            ErrorUrl                      = $AADServicePrincipal.ErrorUrl
            Homepage                      = $AADServicePrincipal.Homepage
            LogoutUrl                     = $AADServicePrincipal.LogoutUrl
            PublisherName                 = $AADServicePrincipal.PublisherName
            ReplyURLs                     = $AADServicePrincipal.ReplyURLs
            SamlMetadataURL               = $AADServicePrincipal.SamlMetadataURL
            ServicePrincipalNames         = $AADServicePrincipal.ServicePrincipalNames
            ServicePrincipalType          = $AADServicePrincipal.ServicePrincipalType
            Tags                          = $AADServicePrincipal.Tags
            Ensure                        = "Present"
            GlobalAdminAccount            = $GlobalAdminAccount
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
        }
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD ServicePrincipal"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentAADServicePrincipal = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId") | Out-Null
    $currentParameters.Remove("TenantId") | Out-Null
    $currentParameters.Remove("CertificateThumbprint") | Out-Null
    $currentParameters.Remove("GlobalAdminAccount") | Out-Null
    $currentParameters.Remove("Ensure") | Out-Null

    # ServicePrincipal should exist but it doesn't
    if ($Ensure -eq "Present" -and $currentAADServicePrincipal.Ensure -eq "Absent")
    {
        New-AzureADServicePrincipal @currentParameters
    }
    # ServicePrincipal should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Set-AzureADServicePrincipal -ObjectID $currentAADServicePrincipal.ObjectID @currentParameters
    }
    # ServicePrincipal exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Remove-AzureADServicePrincipal -ObjectID $currentAADServicePrincipal.ObjectID
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
        $AppId,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of Azure AD ServicePrincipal"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $dscContent = ''
    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters
    $i = 1
    Write-Host "`r`n" -NoNewLine
    $AADServicePrincipals = Get-AzureADServicePrincipal -All:$true
    foreach($AADServicePrincipal in $AADServicePrincipals)
    {
        Write-Host "    |---[$i/$($AADServicePrincipals.Count)] $($AADServicePrincipal.DisplayName)" -NoNewLine
        $Params = @{
                GlobalAdminAccount            = $GlobalAdminAccount
                ApplicationId                 = $ApplicationId
                TenantId                      = $TenantId
                CertificateThumbprint         = $CertificateThumbprint
                AppID                         = $AADServicePrincipal.AppId
        }
        $Results = Get-TargetResource @Params

        if ($Results.Ensure -eq 'Present')
        {
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
    }
    return $ $dscContent
}

Export-ModuleMember -Function *-TargetResource
