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

    $mailboxes = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                    -ScriptBlock {
        Get-Mailbox
    }
    $mailbox = $mailboxes | Where-Object {$_.RecipientTypeDetails -eq "SharedMailbox" -and $_.Identity -eq $DisplayName}

    if(!$mailbox)
    {
        Write-Verbose "The specified Shared Mailbox doesn't already exist."
        return $nullReturn
    }
    $result = @{
        DisplayName = $DisplayName
        PrimarySMTPAddress = $mailbox.PrimarySMTPAddress
        Ensure = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose "Found an existing instance of Shared Mailbox $($DisplayName)"
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
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Write-Verbose "Entering Set-TargetResource"
    Write-Verbose "Retrieving information about Shared Mailbox $($DisplayName) to see if it already exists"
    $currentMailbox = Get-TargetResource @PSBoundParameters

    # CASE: Mailbox doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentMailbox.Ensure -eq "Absent")
    {
        Write-Verbose "Shared Mailbox $($DisplayName) does not exist but it should. Creating it."
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            New-MailBox -Name $args[0].DisplayName -PrimarySMTPAddress $args[0].PrimarySMTPAddress -Shared:$true
        }
    }
    # CASE: Mailbox exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentMailbox.Ensure -eq "Present")
    {
        Write-Verbose "Shared Mailbox $($DisplayName) exists but it shouldn't. Deleting it."
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Remove-Mailbox -Identity $args[0]..DisplayName -Confirm:$false
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
                                                            "PrimarySMTPAddress")
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
        [System.String]
        $PrimarySMTPAddress,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $content = "EXOSharedMailbox " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
