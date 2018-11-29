function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Office365", "Security", "DistributionList", "MailEnabledSecurity")]
        [System.String]
        $GroupType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $ManagedBy,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String]
        $Alias,

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
    
    $nullReturn = @{
        DisplayName = $DisplayName
        GroupType = $GroupType
        Description = $null
        GlobalAdminAccount = $null
        Ensure = "Absent"
    }

    if ($GroupType -eq "Security")
    {
        Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
        Write-Verbose -Message "Getting Security Group $($DisplayName)"
        $group = Get-MSOLGroup | Where-Object {$_.DisplayName -eq $DisplayName}

        $group = Get-MSOLGroup | Where-Object {$_.DisplayName -eq $DisplayName}

        if(!$group)
        {
            Write-Verbose "The specified Group doesn't already exist."
            return $nullReturn
        }
        return @{
            DisplayName = $group.DisplayName
            GroupType = $GroupType
            Description = $group.Description
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure = "Present"
        }
    }
    else 
    {
        $RecipientTypeDetails = "GroupMailbox"
        switch($GroupType)
        {
            "Office365" { $RecipientTypeDetails = "GroupMailbox" }
            "DistributionList" { $RecipientTypeDetails = "MailUniversalDistributionGroup" }
            "MailEnabledSecurity" { $RecipientTypeDetails = "MailUniversalSecurityGroup" }
        }

        $allGroups = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount -ScriptBlock{
            Get-Group
        }

        $group = $allGroups | Where-Object {$_.DisplayName -eq $DisplayName -and $_.RecipientTypeDetails -eq $RecipientTypeDetails}
        if(!$group)
        {
            Write-Verbose "The specified Group doesn't already exist."
            return $nullReturn
        }

        switch($GroupType)
        {
            "Office365"
            {
                Write-Verbose "Found Office365 Group $($group.DisplayName)"
                $groupLinks = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                    -Arguments $PSBoundParameters `
                    -ScriptBlock {
                    Get-UnifiedGroupLinks -Identity $args[0].DisplayName -LinkType "Members"
                }

                $members = @()
                foreach($link in $groupLinks)
                {
                    $member += $link.Name
                }
                return @{
                    DisplayName = $group.DisplayName
                    GroupType = $GroupType
                    Members = $Members
                    Description = $group.Notes
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure = "Present"
                }
            }
            "DistributionList"
            {
                Write-Verbose "Found Distribution List $($group.DisplayName)"
                return @{
                    DisplayName = $group.DisplayName
                    GroupType = $GroupType
                    Description = $group.Notes
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure = "Present"
                }
            }
            "MailEnabledSecurity"
            {
                Write-Verbose "Found Mail-Enabled Security Group $($group.DisplayName)"
                return @{
                    DisplayName = $group.DisplayName
                    GroupType = $GroupType
                    Description = $group.Notes
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure = "Present"
                }
            }
        }
    }
    Write-Verbose "The specified Group doesn't already exist."
    return $nullReturn
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Office365", "Security", "DistributionList", "MailEnabledSecurity")]
        [System.String]
        $GroupType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $ManagedBy,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String]
        $Alias,

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
    if( $Ensure -eq "Present")
    {
        $CurrentParameters = $PSBoundParameters
        $CurrentParameters.Remove("Ensure")
        $CurrentParameters.Remove("GlobalAdminAccount")
        $CurrentParameters.Remove("GroupType")

        if ($GroupType -eq "Security")
        {
            Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
            Write-Verbose -Message "Creating Security Group $DisplayName"
            New-MsolGroup @CurrentParameters
        }
        else {
            switch($GroupType)
            {
                "Office365"
                {
                    Write-Verbose -Message "Creating Office 365 Group $DisplayName"
                    Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                        -Arguments $CurrentParameters `
                        -ScriptBlock {
                        New-UnifiedGroup -DisplayName $args[0].DisplayName -Notes $args[0].Description -Owner $args[0].ManagedBy
                    }

                    $groupLinks = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                        -Arguments $PSBoundParameters `
                        -ScriptBlock {
                        Get-UnifiedGroupLinks -Identity $args[0].DisplayName -LinkType "Members"
                    }
                    $members = @()
                    foreach($link in $groupLinks)
                    {
                        $member += $link.Name
                    }

                    $difference = Compare-Object -ReferenceObject $Members -DifferenceObject $CurrentParameters.Members
                    if ($difference.InputObject)
                    {
                        Write-Verbose "Detected a difference in the current list of members and the desired one"
                        Write-Verbose "Current Membership is $($groupLinks)"
                        Write-Verbose "New License Assignment is $($members)"
                        $membersToRemove = @()
                        $membersToAdd = @()
                        foreach($difference in $diff)
                        {
                            if ($difference.SideIndicator -eq "<=")
                            {
                                $membersToRemove += $difference.InputObject
                            }
                            elseif ($difference.SideIndicator -eq "=>")
                            {
                                $membersToAdd += $difference.InputObject
                            }
                        }

                        if ($membersToAdd.Count -gt 0)
                        {
                            $CurrentParameters.Members = $membersToAdd
                            Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                -Arguments $CurrentParameters `
                                -ScriptBlock {
                                    Add-UnifiedGroupLinks -Identity $args[0].DisplayName -LinkType Members -Links $args[0].Members
                            }
                        }

                        if ($membersToRemove.Count -gt 0)
                        {
                            $CurrentParameters.Members = $membersToRemove
                            Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                -Arguments $CurrentParameters `
                                -ScriptBlock {
                                    Remove-UnifiedGroupLinks -Identity $args[0].DisplayName -LinkType Members -Links $args[0].Members
                            }
                        }
                        $CurrentParameters.Members = $members
                    }
                }
                "DistributionList"
                {
                    Write-Verbose -Message "Creating Distribution List $DisplayName"
                    Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                        -Arguments $CurrentParameters `
                        -ScriptBlock {
                        New-DistributionGroup -DisplayName $args[0].DisplayName -Notes $args[0].Description `
                                              -Name $args[0].DisplayName
                    }
                }
                "MailEnabledSecurity"
                {
                    Write-Verbose -Message "Creating Mail-Enabled Security Group $DisplayName"
                    Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                        -Arguments $CurrentParameters `
                        -ScriptBlock {
                            New-DistributionGroup -Name $args[0].DisplayName `
                                                  -Alias $args[0].Alias `
                                                  -Type "Security" `
                                                  -PrimarySMTPAddress $args[0].PrimarySMTPAddress
                    }
                }
            }
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

        [Parameter(Mandatory = $true)]
        [ValidateSet("Office365", "Security", "DistributionList", "MailEnabledSecurity")]
        [System.String]
        $GroupType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $ManagedBy,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String]
        $Alias,

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

    Write-Verbose -Message "Testing Office 365 Group $DisplayName"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    return Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                           -DesiredValues $PSBoundParameters `
                                           -ValuesToCheck @("Ensure", `
                                                            "DisplayName", `
                                                            "Description", `
                                                            "Members")
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
        [ValidateSet("Office365", "Security", "DistributionList", "MailEnabledSecurity")]
        [System.String]
        $GroupType,

        [Parameter(Mandatory = $true)] 
        [System.Management.Automation.PSCredential] 
        $GlobalAdminAccount
    )
    Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
    $result = Get-TargetResource @PSBoundParameters
    $content = "O365Group " + (New-GUID).ToString() + "`r`n"
    $content += "{`r`n"
    $content += Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += "}`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
