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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    $currentApp = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq "Present" -and $currentApp.Ensure -eq "Present" -and $Overwrite -eq $false)
    {
        throw "The app already exists in the Catalog. To overwrite it, please make sure you set the Overwrite property to 'true'."
    }
    elseif ($Ensure -eq "Present")
    {
        Write-Verbose -Message "Adding app instance $Identity"
        Add-PnPApp -Path $Path -Overwrite:$true
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

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                -InboundParameters $PSBoundParameters

    try
    {
        $tenantAppCatalogUrl = Get-PnPTenantAppCatalogUrl -ErrorAction Stop

        $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                    -InboundParameters $PSBoundParameters `
                    -Url $tenantAppCatalogUrl

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

            $dscContent = ''
            $i = 1
            Write-Host "`r`n" -NoNewline
            foreach ($file in $filesToDownload)
            {
                Write-Host "    |---[$i/$($filesToDownload.Length)] $($file.Name)" -NoNewline

                $identity = $file.Name.ToLower().Replace(".app", "").Replace(".sppkg", "")
                $app = Get-PnpApp -Identity $identity -ErrorAction SilentlyContinue

                if ($null -eq $app)
                {
                    $identity = $file.Title
                    $app = Get-PnpApp -Identity $file.Title -ErrorAction SilentlyContinue
                }
                if ($null -ne $app)
                {
                    $Params = @{
                        Identity              = $identity
                        Path                  = ("`$PSScriptRoot\" + $file.Name)
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificatePassword   = $CertificatePassword
                        CertificatePath       = $CertificatePath
                        CertificateThumbprint = $CertificateThumbprint
                        GlobalAdminAccount    = $GlobalAdminAccount
                    }

                    $Results = Get-TargetResource @Params
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                            -Results $Results
                    $dscContent = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $Results `
                            -GlobalAdminAccount $GlobalAdminAccount
                }
                $i++
                Write-Host $Global:M365DSCEmojiGreenCheckmark
            }

            $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
                    -InboundParameters $PSBoundParameters `
                    -Url $tenantAppCatalogUrl

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
