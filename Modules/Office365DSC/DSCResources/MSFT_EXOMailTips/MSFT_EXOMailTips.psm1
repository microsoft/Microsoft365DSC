function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()] 
        [ValidateSet("Present","Absent")] 
        [System.String] 
        $Ensure = "Present",

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Write-Verbose "Get-TargetResource will attempt to retrieve information for Shared Mailbox $($Organization)"
    $nullReturn = @{
        Organization = $Organization
        MailTipsAllTipsEnabled = $null
        MailTipsGroupMetricsEnabled = $null
        MailTipsLargeAudienceThreshold = $null
        MailTipsMailboxSourcedTipsEnabled = $null
        MailTipsExternalRecipientsTipsEnabled = $null
        Ensure = "Absent"
        GlobalAdminAccount = $null
    }
    $OrgConfig = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                    -ScriptBlock {
        Get-OrganizationConfig
    }

    if(!$OrgConfig)
    {
        Write-Verbose "Can't find the information about the Organization Configuration."
        return $nullReturn
    }
    $result = @{
        Organization = $Organization
        MailTipsAllTipsEnabled = $OrgConfig.MailTipsAllTipsEnabled
        MailTipsGroupMetricsEnabled = $OrgConfig.MailTipsGroupMetricsEnabled
        MailTipsLargeAudienceThreshold = $OrgConfig.MailTipsLargeAudienceThreshold
        MailTipsMailboxSourcedTipsEnabled = $OrgConfig.MailTipsMailboxSourcedTipsEnabled
        MailTipsExternalRecipientsTipsEnabled = $OrgConfig.MailTipsExternalRecipientsTipsEnabled
        Ensure = "Present"
        GlobalAdminAccount = $GlobalAdminAccount
    }
    Write-Verbose "Found configuration of the Mailtips for $($Organization)"
    return $result
}


function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Write-Verbose "Entering Set-TargetResource"
    Write-Verbose "Retrieving information about Mailtips Configuration"
    $OrgConfig = Get-TargetResource @PSBoundParameters

    # CASE : MailTipsAllTipsEnabled is used
    if ($PSBoundParameters.ContainsKey('MailTipsAllTipsEnabled'))
    {
        Write-Verbose "Setting Mailtips for $($Organization) to $($args[0].MailTipsAllTipsEnabled)"
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsAllTipsEnabled $args[0].MailTipsAllTipsEnabled
        }
    }
    # CASE : MailTipsGroupMetricsEnabled is used
    if ($PSBoundParameters.ContainsKey('MailTipsGroupMetricsEnabled'))
    {
        Write-Verbose "Setting Mailtips for Group Metrics of $($Organization) to $($args[0].MailTipsGroupMetricsEnabled)"
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsGroupMetricsEnabled $args[0].MailTipsGroupMetricsEnabled
        }
    }
    # CASE : MailTipsLargeAudienceThreshold is used
    if ($PSBoundParameters.ContainsKey('MailTipsLargeAudienceThreshold'))
    {
        Write-Verbose "Setting Mailtips for Large Audience of $($Organization) to $($args[0].MailTipsLargeAudienceThreshold)"
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsLargeAudienceThreshold $args[0].MailTipsLargeAudienceThreshold
        }
    }
    # CASE : MailTipsMailboxSourcedTipsEnabled is used
    if ($PSBoundParameters.ContainsKey('MailTipsMailboxSourcedTipsEnabled'))
    {
        Write-Verbose "Setting Mailtips for Mailbox Data (OOF/Mailbox Full) of $($Organization) to $($args[0].MailTipsMailboxSourcedTipsEnabled)"
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsMailboxSourcedTipsEnabled $args[0].MailTipsMailboxSourcedTipsEnabled
        }
    }
    # CASE : MailTipsExternalRecipientsTipsEnabled is used
    if ($PSBoundParameters.ContainsKey('MailTipsExternalRecipientsTipsEnabled'))
    {
        Write-Verbose "Setting Mailtips for External Users of $($Organization) to $($args[0].MailTipsExternalRecipientsTipsEnabled)"
        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                          -Arguments $PSBoundParameters `
                          -ScriptBlock {
            Set-OrganizationConfig -MailTipsExternalRecipientsTipsEnabled $args[0].MailTipsExternalRecipientsTipsEnabled
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
        $Organization,

        [Parameter()]
        [System.Boolean]
        $MailTipsAllTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsGroupMetricsEnabled,

        [Parameter()]
        [System.UInt32]
        $MailTipsLargeAudienceThreshold,

        [Parameter()]
        [System.Boolean]
        $MailTipsMailboxSourcedTipsEnabled,

        [Parameter()]
        [System.Boolean]
        $MailTipsExternalRecipientsTipsEnabled,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing Mailtips for $($Organization)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("MailTipsAllTipsEnabled",
                                                            "MailTipsGroupMetricsEnabled",
                                                            "MailTipsLargeAudienceThreshold",
                                                            "MailTipsMailboxSourcedTipsEnabled",
                                                            "MailTipsExternalRecipientsTipsEnabled",
                                                            "Ensure"
                                           )
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [parameter(Mandatory = $true)]
        [System.String]
        $Organization,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $content = "EXOMailTips " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource

