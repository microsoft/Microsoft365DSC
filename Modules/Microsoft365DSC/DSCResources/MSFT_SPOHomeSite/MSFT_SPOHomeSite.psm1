function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration for hub site collection $Url"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $nullReturn = @{
        IsSingleInstance   = $IsSingleInstance
        Ensure             = "Absent"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    try
    {
        Write-Verbose -Message "Getting current home site collection settings"
        $homeSiteUrl = Get-PnPHomeSite
        if ($null -eq $homeSiteUrl)
        {
            Write-Verbose -Message "There is no Home Site Collection set."
            return $nullReturn
        }
        else
        {
            $result = @{
                IsSingleInstance   = $IsSingleInstance
                $Url               = $homeSiteUrl
                Ensure             = "Present"
                GlobalAdminAccount = $GlobalAdminAccount
            }
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message "There was an error in the SPOHomeSite resource."
    }
    return $nullReturn
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration for home site '$Url'"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform PnP

    $currentValues = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq "Present")
    {
        try
        {
            Write-Verbose -Message "Setting home site collection $Url"
            Get-PnPTenantSite -Url $Url
        }
        catch
        {
            $Message = "The specified Site Collection $($Url) for SPOHomeSite doesn't exist."
            New-M365DSCLogEntry -Error $_ -Message $Message
            throw $Message
        }

        Write-Verbose -Message "Configuring site collection as Home Site"
        Set-PnPHomeSite -Url $Url
    }

    if ($Ensure -eq "Absent" -and $currentValues.Ensure -eq "Present")
    {
        # Remove home site
        Remove-PnPHomeSite -Force
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("Yes")]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Url,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for home site collection"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $valuesToCheck = @("Ensure")
    if ($PSBoundParameters.ContainsKey("Url"))
    {
        $valuesToCheck += "Url"
    }

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $valuesToCheck

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    $params = @{
        IsSingleInstance   = "Yes"
        GlobalAdminAccount = $GlobalAdminAccount
    }

    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = "`$Credsglobaladmin"

    $content = "        SPOHomeSite " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
