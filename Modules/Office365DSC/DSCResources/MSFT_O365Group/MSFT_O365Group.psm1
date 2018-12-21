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
        [System.String[]]
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
    Write-Verbose "Get-TargetResource will attempt to retrieve information for group $($DisplayName)"
    $nullReturn = @{
        DisplayName = $DisplayName
        GroupType = $GroupType
        Description = $null
        ManagedBy = $null
        GlobalAdminAccount = $null
        Ensure = "Absent"
    }

    if ($GroupType -eq "Security")
    {
        Test-O365ServiceConnection -GlobalAdminAccount $GlobalAdminAccount
        Write-Verbose -Message "Getting Security Group $($DisplayName)"
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

        $allGroups = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                                   -Arguments $CurrentParameters `
                                   -ScriptBlock{
            Get-Group
        }
        $group = $allGroups | Where-Object {$_.DisplayName -eq $DisplayName -and $_.RecipientTypeDetails -eq $RecipientTypeDetails}

        if (!$group)
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

                $groupMembers = ""
                foreach($link in $groupLinks.Name)
                {
                    $groupMembers += $link.ToString() + ","
                }
                if ($groupMembers -ne "")
                {
                    # Remove the trailing comma
                    $groupMembers = $groupMembers.Remove($groupMembers.Length -1, 1)
                    $groupMembers = $groupMembers.Split(',')
                }
                else {
                    $groupMembers = @()
                }
                return @{
                    DisplayName = $group.DisplayName
                    GroupType = $GroupType
                    Members = $groupMembers
                    ManagedBy = $group.ManagedBy
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
        [System.String[]]
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
    Write-Verbose "Retrieving information about group $($DisplayName) to see if it already exists"
    $currentGroup = Get-TargetResource @PSBoundParameters
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
                    if ($currentGroup.Ensure -eq "Absent")
                    {
                        Write-Verbose -Message "Creating Office 365 Group $DisplayName"
                        Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                            -Arguments $CurrentParameters `
                            -ScriptBlock {
                            New-UnifiedGroup -DisplayName $args[0].DisplayName -Notes $args[0].Description -Owner $args[0].ManagedBy
                        }
                    }

                    $groupLinks = Invoke-ExoCommand -GlobalAdminAccount $GlobalAdminAccount `
                        -Arguments $PSBoundParameters `
                        -ScriptBlock {
                        Get-UnifiedGroupLinks -Identity $args[0].DisplayName -LinkType "Members"
                    }
                    $curMembers = @()
                    foreach($link in $groupLinks)
                    {
                        if ($link.Name -and $link.Name -ne $currentGroup.ManagedBy)
                        {
                            $curMembers += $link.Name
                        }
                    }

                    $difference = Compare-Object -ReferenceObject $curMembers -DifferenceObject $CurrentParameters.Members

                    if ($difference.InputObject)
                    {
                        Write-Verbose "Detected a difference in the current list of members and the desired one"
                        $membersToRemove = @()
                        $membersToAdd = @()
                        foreach($diff in $difference)
                        {
                            if ($diff.SideIndicator -eq "<=" -and $diff.InputObject -ne $ManagedBy.Split('@')[0])
                            {
                                $membersToRemove += $diff.InputObject
                            }
                            elseif ($diff.SideIndicator -eq "=>")
                            {
                                $membersToAdd += $diff.InputObject
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
                Default
                {
                    throw "The specified GroupType is not valid"
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
        [System.String[]]
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
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        O365Group " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
