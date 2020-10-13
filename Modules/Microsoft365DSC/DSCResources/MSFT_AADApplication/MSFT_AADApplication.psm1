function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.Boolean]
        $PublicClient,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

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

    Write-Verbose -Message "Getting configuration of Azure AD Application"
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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        try
        {
            if ($null -ne $ObjectID)
            {
                $AADApp = Get-AzureADApplication -ObjectID $ObjectId
            }
        }
        catch
        {
            Write-Verbose -Message "Could not retrieve AzureAD Application by Object ID {$ObjectID}"
        }

        if ($null -eq $AADApp)
        {
            $AADApp = Get-AzureADApplication -Filter "DisplayName eq '$($DisplayName)'"
        }
        if($null -ne $AADApp -and $AADApp.Count -gt 1)
        {
            Throw "Multiple AAD Apps with the Displayname $($DisplayName) exist in the tenant. Aborting."
        }
        elseif($null -eq $AADApp)
        {
            return $nullReturn
        }
        else
        {
            $result = @{
                DisplayName                   = $AADApp.DisplayName
                AvailableToOtherTenants       = $AADApp.AvailableToOtherTenants
                GroupMembershipClaims         = $AADApp.GroupMembershipClaims
                Homepage                      = $AADApp.Homepage
                IdentifierUris                = $AADApp.IdentifierUris
                KnownClientApplications       = $AADApp.KnownClientApplications
                LogoutURL                     = $AADApp.LogoutURL
                Oauth2AllowImplicitFlow       = $AADApp.Oauth2AllowImplicitFlow
                Oauth2AllowUrlPathMatching    = $AADApp.Oauth2AllowUrlPathMatching
                Oauth2RequirePostResponse     = $AADApp.Oauth2RequirePostResponse
                PublicClient                  = $AADApp.PublicClient
                ReplyURLs                     = $AADApp.ReplyURLs
                SamlMetadataUrl               = $AADApp.SamlMetadataUrl
                ObjectId                      = $AADApp.ObjectID
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
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.Boolean]
        $PublicClient,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

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

    Write-Verbose -Message "Setting configuration of Azure AD Application"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentAADApp = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("ApplicationId")  | Out-Null
    $currentParameters.Remove("TenantId")  | Out-Null
    $currentParameters.Remove("CertificateThumbprint")  | Out-Null
    $currentParameters.Remove("GlobalAdminAccount")  | Out-Null
    $currentParameters.Remove("Ensure")  | Out-Null

    if($null -ne $KnownClientApplications)
    {
        Write-Verbose -Message "Checking if the known client applications already exist."
        $testedKnownClientApplications = New-Object System.Collections.Generic.List[string]
        foreach($KnownClientApplication in $KnownClientApplications)
        {
            $knownAADApp = $null
            $knownAADApp = Get-AzureADApplication -Filter "AppID eq '$($KnownClientApplication)'"
            if($null -ne $knownAADApp)
            {
                $testedKnownClientApplications.Add($knownAADApp.AppId)
            }
            else
            {
                Write-Verbose -Message "Could not find an existing app with the app ID $($KnownClientApplication)"
            }
        }
        $currentParameters.Remove("KnownClientApplications") | Out-Null
        $currentParameters.Add("KnownClientApplications", $testedKnownClientApplications)
    }

    # App should exist but it doesn't
    if ($Ensure -eq "Present" -and $currentAADApp.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Creating New AzureAD Application {$DisplayName}"
        $currentParameters.Remove("ObjectId") | Out-Null
        New-AzureADApplication @currentParameters
    }
    # App should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADApp.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing AzureAD Application {$DisplayName}"
        $currentParameters.ObjectId = $currentAADApp.ObjectId
        Set-AzureADApplication @currentParameters
    }
    # App exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADApp.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD Application {$DisplayName}"
        Remove-AzureADApplication -ObjectId $currentAADApp.ObjectID
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.Boolean]
        $AvailableToOtherTenants,

        [Parameter()]
        [System.String]
        $GroupMembershipClaims,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String[]]
        $IdentifierUris,

        [Parameter()]
        [System.String[]]
        $KnownClientApplications,

        [Parameter()]
        [System.String]
        $LogoutURL,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowImplicitFlow,

        [Parameter()]
        [System.Boolean]
        $Oauth2AllowUrlPathMatching,

        [Parameter()]
        [System.Boolean]
        $Oauth2RequirePostResponse,

        [Parameter()]
        [System.Boolean]
        $PublicClient,

        [Parameter()]
        [System.String[]]
        $ReplyURLs,

        [Parameter()]
        [System.String]
        $SamlMetadataUrl,

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

    Write-Verbose -Message "Testing configuration of AzureAD Application"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("ObjectId") | Out-Null

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
    try
    {
        $AADApplications = Get-AzureADApplication -ErrorAction Stop
        foreach($AADApp in $AADApplications)
        {
            Write-Host "    |---[$i/$($AADApplications.Count)] $($AADApp.DisplayName)" -NoNewLine
            $Params = @{
                    GlobalAdminAccount            = $GlobalAdminAccount
                    ApplicationId                 = $ApplicationId
                    TenantId                      = $TenantId
                    CertificateThumbprint         = $CertificateThumbprint
                    DisplayName                   = $AADApp.DisplayName
                    ObjectID                      = $AADApp.ObjectID
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
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
