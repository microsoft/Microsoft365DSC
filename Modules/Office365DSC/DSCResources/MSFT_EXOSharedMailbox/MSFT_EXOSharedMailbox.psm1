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
        $PrimarySMTPAddress,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve information for Shared Mailbox $($DisplayName)"
    $nullReturn = @{
        DisplayName = $DisplayName
        PrimarySMTPAddress = $null
        GlobalAdminAccount = $null
        Ensure = "Absent"
    }

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $mailboxes = Get-Mailbox
    $mailbox = $mailboxes | Where-Object {$_.RecipientTypeDetails -eq "SharedMailbox" -and $_.Identity -eq $DisplayName}

    if (!$mailbox)
    {
        Write-Verbose "The specified Shared Mailbox doesn't already exist."
        return $nullReturn
    }

    #region Email Aliases
    $CurrentAliases = @()

    foreach($email in $mailbox.EmailAddresses)
    {
        $emailValue = $email.Split(":")[1]
        if ($emailValue -and $emailValue -ne $mailbox.PrimarySMTPAddress)
        {
            $CurrentAliases += $emailValue
        }
    }
    #endregion

    $result = @{
        DisplayName = $DisplayName
        PrimarySMTPAddress = $mailbox.PrimarySMTPAddress.ToString()
        Aliases = $CurrentAliases
        Ensure = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose "Found an existing instance of Shared Mailbox '$($DisplayName)'"
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
        $PrimarySMTPAddress,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose "Entering Set-TargetResource"
    Write-Verbose "Retrieving information about Shared Mailbox '$($DisplayName)' to see if it already exists"
    $currentMailbox = Get-TargetResource @PSBoundParameters

    #region Validation
    foreach ($alias in $Aliases)
    {
        if ($alias.ToLower() -eq $PrimarySMTPAddress.ToLower())
        {
            throw "You cannot have the Aliases list contain the PrimarySMTPAddress"
        }
    }
    #endregion

    $CurrentParameters = $PSBoundParameters
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    # CASE: Mailbox doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentMailbox.Ensure -eq "Absent")
    {
        Write-Verbose "Shared Mailbox '$($DisplayName)' does not exist but it should. Creating it."
        $emails = ""
        foreach($alias in $Aliases)
        {
            $emails += $alias + ","
        }
        $emails += $PrimarySMTPAddress
        $proxyAddresses = $emails -Split ','
        $CurrentParameters.Aliases = $proxyAddresses
        New-MailBox -Name $DisplayName -PrimarySMTPAddress $PrimarySMTPAddress -Shared:$true
        Set-Mailbox -Identity $DisplayName -EmailAddresses @{add=$Aliases}
    }
    # CASE: Mailbox exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentMailbox.Ensure -eq "Present")
    {
        Write-Verbose "Shared Mailbox '$($DisplayName)' exists but it shouldn't. Deleting it."
        Remove-Mailbox -Identity $DisplayName -Confirm:$false
    }
    # CASE: Mailbox exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentMailbox.Ensure -eq "Present")
    {
        # CASE: Email Aliases need to be updated
        Write-Verbose "Shared Mailbox '$($DisplayName)' already exists, but needs updating."
        $current = $currentMailbox.Aliases
        $desired = $Aliases
        $diff = Compare-Object -ReferenceObject $current -DifferenceObject $desired
        if ($diff)
        {
            Write-Verbose "Updating the list of Aliases for the Shared Mailbox '$($DisplayName)'"
            $emails = ""
            foreach($alias in $Aliases)
            {
                $emails += $alias + ","
            }
            $emails += $PrimarySMTPAddress
            $proxyAddresses = $emails -Split ','
            $CurrentParameters.Aliases = $proxyAddresses

            Write-Verbose "Adding the following email aliases: $($emails)"
            Set-Mailbox -Identity $DisplayName -EmailAddresses @{add=$Aliases}
        }
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
        $PrimarySMTPAddress,

        [Parameter()]
        [System.String[]]
        $Aliases,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Office 365 Shared Mailbox $DisplayName"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("Ensure", `
                                                            "DisplayName", `
                                                            "PrimarySMTPAddress",
                                                            "Aliases")
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
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $modulePath = $PSScriptRoot + "\MSFT_EXOSharedMailbox.psm1"
    $content = "        EXOSharedMailbox " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $modulePath -UseGetTargetResource
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
