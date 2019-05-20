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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    $nullReturn = @{
        Identity        = $Title
        Path            = $null
        Publish         = $Publish
        Overwrite       = $Overwrite
        Ensure          = "Absent"
        CentralAdminUrl = $CentralAdminUrl
    }

    try
    {
        Write-Verbose -Message "Getting app instance $Title"
        Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
        $app = Get-PnPApp -Identity $Identity -ErrorAction SilentlyContinue
        if ($null -eq $app)
        {
            Write-Verbose "The specified app wasn't found."
            return $nullReturn
        }
        return @{
            Identity        = $app.Title
            Path            = $Path
            Publish         = $app.Deployed
            Overwrite       = $Overwrite
            CentralAdminUrl = $CentralAdminUrl
            Ensure          = "Present"
        }
    }
    catch
    {
        Write-Verbose "The specified app doesn't already exist."
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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-PnPOnlineConnection -SiteUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount
    $currentApp = Get-TargetResource @PSBoundParameters
    if ($Ensure -eq "Present" -and $currentApp.Ensure -eq "Present" -and $Overwrite -eq $false)
    {
        throw "The app already exists in the Catalog. To overwrite it, please make sure you set the Overwrite property to 'true'."
    }
    elseif ($Ensure -eq "Present")
    {
        Write-Verbose -Message "Adding app instance $Title"
        Add-PnPApp -Path $Path -Overwrite $Overwrite
    }
    elseif ($Ensure -eq "Absent" -and $currentApp.Ensure -eq "Present")
    {
        Write-Verbose -Message "Removing app instance $Title"
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
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing app $Title"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("Ensure", `
                                                                   "Title")

    Write-Verbose "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        SPOApp " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
