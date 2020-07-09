function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.Boolean]
        $Publish = $true,

        [Parameter()]
        [System.Boolean]
        $Overwrite = $true,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration for app $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        Identity              = ""
        Path                  = $null
        Publish               = $Publish
        Overwrite             = $Overwrite
        Ensure                = "Absent"
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificatePassword   = $CertificatePassword
        CertificatePath       = $CertificatePath
        CertificateThumbprint = $CertificateThumbprint
        GlobalAdminAccount    = $GlobalAdminAccount
    }

    try
    {

        $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters
        $app = Get-PnPApp -Identity $Identity -ErrorAction SilentlyContinue
        if ($null -eq $app)
        {
            Write-Verbose -Message "The specified app wasn't found."
            return $nullReturn
        }

        return @{
            Identity              = $app.Title
            Path                  = $Path
            Publish               = $app.Deployed
            Overwrite             = $Overwrite
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            GlobalAdminAccount    = $GlobalAdminAccount
        }
    }
    catch
    {
        Write-Verbose -Message "The specified app doesn't already exist."
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.Boolean]
        $Publish = $true,

        [Parameter()]
        [System.Boolean]
        $Overwrite = $true,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration for app $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion


    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    $currentApp = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq "Present" -and $currentApp.Ensure -eq "Present" -and $Overwrite -eq $false)
    {
        throw "The app already exists in the Catalog. To overwrite it, please make sure you set the Overwrite property to 'true'."
    }
    elseif ($Ensure -eq "Present")
    {
        Write-Verbose -Message "Adding app instance $Identity"
        Add-PnPApp -Path $Path -Overwrite
    }
    elseif ($Ensure -eq "Absent" -and $currentApp.Ensure -eq "Present")
    {
        Write-Verbose -Message "Removing app instance $Identity"
        Remove-PnpApp -Identity $Identity
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.Boolean]
        $Publish = $true,

        [Parameter()]
        [System.Boolean]
        $Overwrite = $true,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration for app $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "Identity")

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion


    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    $tenantAppCatalogUrl = Get-PnPTenantAppCatalogUrl

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters `
        -ConnectionUrl $tenantAppCatalogUrl


    if (-not [string]::IsNullOrEmpty($tenantAppCatalogUrl))
    {
        if ($ConnectionMode -eq 'Credential')
        {
            $filesToDownload = Get-AllSPOPackages -GlobalAdminAccount $GlobalAdminAccount
        }
        else
        {
            $filesToDownload = Get-AllSPOPackages -ApplicationId $ApplicationId -CertificateThumbprint $CertificateThumbprint `
                -CertificatePassword $CertificatePassword -TenantId $TenantId -CertificatePath $CertificatePath
        }
        $tenantAppCatalogPath = $tenantAppCatalogUrl.Replace("https://", "")
        $tenantAppCatalogPath = $tenantAppCatalogPath.Replace($tenantAppCatalogPath.Split('/')[0], "")

        $content = ''
        $i = 1
        foreach ($file in $filesToDownload)
        {
            Write-Information "    [$i/$($filesToDownload.Length)] $($file.Name)"

            $identity = $file.Name.ToLower().Replace(".app", "").Replace(".sppkg", "")
            $app = Get-PnpApp -Identity $identity -ErrorAction SilentlyContinue

            if ($null -eq $app)
            {
                $identity = $file.Title
                $app = Get-PnpApp -Identity $file.Title -ErrorAction SilentlyContinue
            }
            if ($null -ne $app)
            {
                $params = @{
                    Identity              = $identity
                    Path                  = ("`$PSScriptRoot\" + $file.Name)
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificatePassword   = $CertificatePassword
                    CertificatePath       = $CertificatePath
                    CertificateThumbprint = $CertificateThumbprint
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                $organization = Get-M365DSCOrganization -GlobalAdminAccount $GlobalAdminAccount -TenantId $Tenantid
                if ($organization.IndexOf(".") -gt 0)
                {
                    $principal = $organization.Split(".")[0]
                }

                $result = Get-TargetResource @params
                if ($ConnectionMode -eq 'Credential')
                {
                    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                }
                else
                {
                    if ($null -ne $CertificatePassword)
                    {
                        $result.CertificatePassword = Resolve-Credentials -UserName "CertificatePassword"
                    }
                }
                $result = Remove-NullEntriesFromHashTable -Hash $result
                $content += "        SPOApp " + (New-GUID).ToString() + "`r`n"
                $content += "        {`r`n"
                $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot

                if ($ConnectionMode -eq 'Credential')
                {
                    $convertedContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                }
                else
                {
                    if ($null -ne $CertificatePassword)
                    {
                        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CertificatePassword"
                    }
                    else
                    {
                        $content += $currentDSCBlock
                    }
                    $content = Format-M365ServicePrincipalData -configContent $content -applicationid $ApplicationId `
                        -principal $principal -CertificateThumbprint $CertificateThumbprint
                }
                $content += $convertedContent
                $content += "        }`r`n"
            }
            $i++
        }

        $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters `
            -ConnectionUrl $tenantAppCatalogUrl
        foreach ($file in $filesToDownload)
        {
            $appInstanceUrl = $tenantAppCatalogPath + "/AppCatalog/" + $file.Name
            $appFileName = $appInstanceUrl.Split('/')[$appInstanceUrl.Split('/').Length - 1]
            Get-PnPFile -Url $appInstanceUrl -Path $env:Temp -Filename $appFileName -AsFile -Force | Out-Null
        }
    }
    else
    {
        Write-Information "    * App Catalog is not configured on tenant. Cannot extract information about SharePoint apps."
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
