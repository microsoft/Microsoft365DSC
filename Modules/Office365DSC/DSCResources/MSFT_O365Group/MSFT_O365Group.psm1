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
        [System.String]
        $Name = "",

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
        Name = $Name
        GroupType = $GroupType
        Description = $null
        ManagedBy = $null
        GlobalAdminAccount = $null
        Ensure = "Absent"
    }

    if ($GroupType -eq "Security")
    {
        Connect-MsolService -Credential $GlobalAdminAccount
        Write-Verbose -Message "Getting Security Group $($DisplayName)"

        if ($null -ne $Name)
        {
            $group = Get-MSOLGroup | Where-Object {$_.Name -eq $Name}
        }
        else
        {
            $group = Get-MSOLGroup | Where-Object {$_.DisplayName -eq $DisplayName}
        }

        if ($null -eq $Name -and $group.Length -gt 1)
        {
            throw "Multiple instance of group named {$DisplayName} were found. " + `
                  "Please use property Name instead of DisplayName to retrieve a specific instance."
        }

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

        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
        $allGroups = Get-Group

        if ($null -ne $Name)
        {
            $group = $allGroups | Where-Object {$_.Name -eq $Name -and $_.RecipientTypeDetails -eq $RecipientTypeDetails}
        }
        else
        {
            $group = $allGroups | Where-Object {$_.DisplayName -eq $DisplayName -and $_.RecipientTypeDetails -eq $RecipientTypeDetails}
        }

        if ($null -eq $Name -and $group.Length -gt 1)
        {
            throw "Multiple instance of group named {$DisplayName} were found. " + `
                  "Please use property Name instead of DisplayName to retrieve a specific instance."
        }

        if (!$group)
        {
            Write-Verbose "The specified Group doesn't already exist."
            return $nullReturn
        }

        switch ($GroupType)
        {
            "Office365"
            {
                Write-Verbose "Found Office365 Group $($group.DisplayName)"
                Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
                $groupLinks = Get-UnifiedGroupLinks -Identity $DisplayName -LinkType "Members"

                $groupMembers = ""
                foreach ($link in $groupLinks.Name)
                {
                    $groupMembers += $link.ToString() + ","
                }
                if ($groupMembers -ne "")
                {
                    # Remove the trailing comma
                    $groupMembers = $groupMembers.Remove($groupMembers.Length -1, 1)
                    $groupMembers = $groupMembers.Split(',')
                }
                else
                {
                    $groupMembers = @()
                }
                return @{
                    DisplayName = $group.DisplayName
                    Name = $Name
                    GroupType = $GroupType
                    Members = $groupMembers
                    ManagedBy = $group.ManagedBy
                    Description = $group.Notes.ToString()
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure = "Present"
                }
            }
            "DistributionList"
            {
                Write-Verbose "Found Distribution List $($group.DisplayName)"
                return @{
                    DisplayName = $group.DisplayName
                    Name = $Name
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
                    Name = $Name
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
        [System.String]
        $Name = "",

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
    if ($Ensure -eq "Present")
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
        else
        {
            switch ($GroupType)
            {
                "Office365"
                {
                    if ($currentGroup.Ensure -eq "Absent")
                    {
                        Write-Verbose -Message "Creating Office 365 Group {$DisplayName}"
                        Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
                        $groupParams = @{
                            DisplayName = $DisplayName
                            Notes       = $Description
                            Owner       = $ManagedBy
                        }

                        $groupParams.Owner = $ManagedBy[0]
                        if ("" -ne $Name)
                        {
                            $groupParams.Add("Name", $Name)
                        }
                        Write-Verbose "Initiating Group Creation"
                        Write-Verbose "Owner = $($groupParams.Owner)"
                        New-UnifiedGroup @groupParams
                        Write-Verbose "Group Created"
                        if ($ManagedBy.Length -gt 1)
                        {
                            for ($i = 1; $i -lt $ManagedBy.Length; $i++)
                            {
                                Write-Verbose "Adding additional owner {$($ManagedBy[$i])} to group."
                                if ("" -ne $Name)
                                {
                                    Add-UnifiedGroupLinks -Identity $Name -LinkType Owner -Links $ManagedBy[$i]
                                }
                                else
                                {
                                    Add-UnifiedGroupLinks -Identity $DisplayName -LinkType Owner -Links $ManagedBy[$i]
                                }
                            }
                        }
                    }

                    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
                    if ("" -ne $Name)
                    {
                        $groupLinks = Get-UnifiedGroupLinks -Identity $Name -LinkType "Members"
                    }
                    else
                    {
                        $groupLinks = Get-UnifiedGroupLinks -Identity $DisplayName -LinkType "Members"
                    }
                    $curMembers = @()
                    foreach ($link in $groupLinks)
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
                        foreach ($diff in $difference)
                        {
                            if (-not $ManagedBy.Contains($diff.InputObject))
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
                        }

                        if ($membersToAdd.Count -gt 0)
                        {
                            $CurrentParameters.Members = $membersToAdd
                            Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

                            if ("" -ne $name)
                            {
                                Add-UnifiedGroupLinks -Identity $Name -LinkType Members -Links $membersToAdd
                            }
                            else
                            {
                                Add-UnifiedGroupLinks -Identity $DisplayName -LinkType Members -Links $membersToAdd
                            }
                        }

                        if ($membersToRemove.Count -gt 0)
                        {
                            Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
                            if ("" -ne $name)
                            {
                                Remove-UnifiedGroupLinks -Identity $Name -LinkType Members -Links $membersToRemove
                            }
                            else
                            {
                                Remove-UnifiedGroupLinks -Identity $DisplayName -LinkType Members -Links $membersToRemove
                            }
                        }
                        $CurrentParameters.Members = $members
                    }
                }
                "DistributionList"
                {
                    Write-Verbose -Message "Creating Distribution List $DisplayName"
                    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
                    New-DistributionGroup -DisplayName $DisplayName -Notes $Description `
                                          -Name $DisplayName
                }
                "MailEnabledSecurity"
                {
                    Write-Verbose -Message "Creating Mail-Enabled Security Group $DisplayName"
                    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
                    New-DistributionGroup -Name $DisplayName `
                                          -Alias $Alias `
                                          -Type "Security" `
                                          -PrimarySMTPAddress $PrimarySMTPAddress
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
        [System.String]
        $Name = "",

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
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Office365", "Security", "DistributionList", "MailEnabledSecurity")]
        [System.String]
        $GroupType,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        O365Group " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
