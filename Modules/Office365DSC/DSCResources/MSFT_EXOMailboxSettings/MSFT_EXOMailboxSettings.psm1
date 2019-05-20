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
        $TimeZone,

        [Parameter()]
        [System.String]
        $Locale,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve information for Mailbox $($DisplayName)"
    $nullReturn = @{
        DisplayName = $DisplayName
        TimeZone = $null
        Locale = $null
        Ensure = "Absent"
    }

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $mailboxSettings = Get-MailboxRegionalConfiguration -Identity $DisplayName

    if ($null -eq $mailboxSettings)
    {
        Write-Verbose "The specified Mailbox doesn't already exist."
        return $nullReturn
    }

    $result = @{
        DisplayName = $DisplayName
        TimeZone = $mailboxSettings.TimeZone
        Locale = $mailboxSettings.Language.Name
        Ensure = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose "Found an existing instance of Mailbox '$($DisplayName)'"
    return $result
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
        $TimeZone,

        [Parameter()]
        [System.String]
        $Locale,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose "Entering Set-TargetResource"
    Write-Verbose "Retrieving information about Mailbox '$($DisplayName)' to see if it exists"
    $currentMailbox = Get-TargetResource @PSBoundParameters

    # CASE: Mailbox doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentMailbox.Ensure -eq "Absent")
    {
        throw "The specified mailbox {$($DisplayName)} does not exist."
    }

    $AllowedTimeZones = (Get-ChildItem "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Time zones" | `
        ForEach-Object {Get-ItemProperty $_.PSPath}).PSChildName

    if ($AllowedTimeZones.Contains($TimeZone) -eq $false)
    {
        throw "The specified Time Zone {$($TimeZone)} is not valid."
    }

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Set-MailboxRegionalConfiguration -Identity $DisplayName `
                                     -Language $Locale `
                                     -TimeZone $TimeZone
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
        $TimeZone,

        [Parameter()]
        [System.String]
        $Locale,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Office 365 Mailbox Settings for $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("Ensure", `
                                                                   "DisplayName", `
                                                                   "TimeZone", `
                                                                   "Locale")

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
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $modulePath = $PSScriptRoot + "\MSFT_EXOMailboxSettings.psm1"
    $content = "        EXOMailboxSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $modulePath -UseGetTargetResource
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
