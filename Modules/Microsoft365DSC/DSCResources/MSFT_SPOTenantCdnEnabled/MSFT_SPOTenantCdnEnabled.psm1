function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType,

        [Parameter()]
        [System.Boolean]
        $Enable,

        [Parameter()]
        [ValidateSet('Present')]
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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword

    )

    Write-Verbose -Message "Getting configuration of SPO Cdn enabled"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters

    try
    {
        $cdnEnabled = Get-PnPTenantCdnEnabled -CdnType $CdnType -ErrorAction SilentlyContinue
    }
    catch
    {
        Write-Verbose -Message $_
    }

    $result = @{
        CdnType             = $CdnType
        Enable              = $cdnEnabled.Value
        Ensure              = $Ensure
        GlobalAdminAccount  = $GlobalAdminAccount
        ApplicationId       = $ApplicationId
        TenantId            = $TenantId
        CertificatePassword = $CertificatePassword
        CertificatePath     = $CertificatePath
    }
    return $result

}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType,

        [Parameter()]
        [System.Boolean]
        $Enable,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword

    )

    Write-Verbose -Message "Setting configuration of SPO Cdn enabled"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentOrgSiteAsset = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("Ensure")
    $currentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("ApplicationId")
    $CurrentParameters.Remove("TenantId")
    $CurrentParameters.Remove("CertificatePath")
    $CurrentParameters.Remove("CertificatePassword")
    #No add only a set
    Set-PnPTenantCdnEnabled @currentParameters

}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Public', 'Private')]
        [System.String]
        $CdnType,

        [Parameter()]
        [System.Boolean]
        $Enable,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword

    )

    Write-Verbose -Message "Testing configuration of SPO Cdn enabled"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Starting the test to compare"
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: `n $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove("ApplicationId")| Out-Null
    $ValuesToCheck.Remove("TenantId")| Out-Null
    $ValuesToCheck.Remove("CertificatePath")| Out-Null
    $ValuesToCheck.Remove("CertificatePassword")| Out-Null

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' -InboundParameters $PSBoundParameters


    $content = ''
    $cdnTypes = "Public", "Private"

    foreach ($cType in $cdnTypes)
    {
        if ($ConnectionMode -eq 'Credential')
        {
            $params = @{
                GlobalAdminAccount = $GlobalAdminAccount
                CdnType            = $cType
            }
        }
        else
        {
            $params = @{
                CdnType             = $cType
                ApplicationId       = $ApplicationId
                TenantId            = $TenantId
                CertificatePassword = $CertificatePassword
                CertificatePath     = $CertificatePath
            }
        }

        $result = Get-TargetResource @Params
        if ($result.Enable -eq $True)
        {
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        SPOTenantCdnEnabled " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
        }
    }

    return $content
}

Export-ModuleMember -Function *-TargetResource
