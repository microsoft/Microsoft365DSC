function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Office 365 Group $DisplayName"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = @{
        DisplayName        = $DisplayName
        MailNickName       = $Name
        Description        = $null
        ManagedBy          = $null
        GlobalAdminAccount = $null
        Ensure             = "Absent"
    }

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    $ADGroup = Get-AzureADGroup | Where-Object -FilterScript {$_.MailNickName -eq $MailNickName}
    if ($null -eq $ADGroup)
    {
        $ADGroup = Get-AzureADGroup | Where-Object -FilterScript {$_.DisplayName -eq $DisplayName}
        if ($null -eq $ADGroup)
        {
            Write-Verbose -Message "Office 365 Group {$DisplayName} was not found."
            return $nullReturn
        }
    }
    Write-Verbose -Message "Found Existing Instance of Group {$($ADGroup.DisplayName)}"

    try
    {
        $membersList = Get-AzureADGroupMember -ObjectId $ADGroup.ObjectId
        Write-Verbose -Message "Found Members for Group {$($ADGroup.DisplayName)}"
        $owners = Get-AzureADGroupOwner -ObjectId $ADGroup.ObjectId
        Write-Verbose -Message "Found Owners for Group {$($ADGroup.DisplayName)}"
        $ownersUPN = @()
        if ($null -ne $owners)
        {
            # Need to cast as an array for the test to properly compare cases with
            # a single owner;
            $ownersUPN = [System.String[]]$owners.UserPrincipalName

            # Also need to remove the owners from the members list for Test
            # to handle the validation properly;
            $newMemberList = @()

            foreach ($member in $membersList)
            {
                if (-not $ownersUPN.Contains($member.UserPrincipalName))
                {
                    $newMemberList += $member.UserPrincipalName
                }
            }
        }

        $description = ""
        if ($null -ne $ADGroup.Description)
        {
            $description = $ADGroup.Description.ToString()
        }

        $returnValue = @{
            DisplayName        = $ADGroup.DisplayName
            MailNickName       = $ADGroup.MailNickName
            Members            = $newMemberList
            ManagedBy          = $ownersUPN
            Description        = $description
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure             = "Present"
        }

        Write-Verbose -Message "Retrieved the following instance of the Group:"
        foreach ($value in $returnValue.GetEnumerator())
        {
            Write-Verbose -Message "$($value.Key) = $($value.Value)"
        }
        return $returnValue
    }
    catch
    {
        $Message = "An error occured retrieving info for Group $DisplayName"
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
    }
    return $nullReturn
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Office 365 Group $DisplayName"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $currentGroup = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq "Present")
    {
        $CurrentParameters = $PSBoundParameters
        $CurrentParameters.Remove("Ensure")
        $CurrentParameters.Remove("GlobalAdminAccount")

        if ($currentGroup.Ensure -eq "Absent")
        {
            Write-Verbose -Message "Creating Office 365 Group {$DisplayName}"
            $groupParams = @{
                DisplayName = $DisplayName
                Notes       = $Description
                Owner       = $ManagedBy
            }

            $groupParams.Owner = $ManagedBy[0]
            if ("" -ne $MailNickName)
            {
                $groupParams.Add("Name", $MailNickName)
            }
            Write-Verbose -Message "Initiating Group Creation"
            Write-Verbose -Message "Owner = $($groupParams.Owner)"
            New-UnifiedGroup @groupParams
            Write-Verbose -Message "Group Created"
            if ($ManagedBy.Length -gt 1)
            {
                for ($i = 1; $i -lt $ManagedBy.Length; $i++)
                {
                    Write-Verbose -Message "Adding additional owner {$($ManagedBy[$i])} to group."
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

        if ("" -ne $MailNickName)
        {
            $groupLinks = Get-UnifiedGroupLinks -Identity $MailNickName -LinkType "Members"
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

        if ($null -ne $CurrentParameters.Members)
        {
            $difference = Compare-Object -ReferenceObject $curMembers -DifferenceObject $CurrentParameters.Members

            if ($null -ne $difference.InputObject)
            {
                Write-Verbose -Message "Detected a difference in the current list of members and the desired one"
                $membersToRemove = @()
                $membersToAdd = @()
                foreach ($diff in $difference)
                {
                    if (-not $ManagedBy.Contains($diff.InputObject))
                    {
                        if ($diff.SideIndicator -eq "<=" -and $diff.InputObject -ne $ManagedBy.Split('@')[0])
                        {
                            Write-Verbose "Will be removing Member: {$($diff.InputObject)}"
                            $membersToRemove += $diff.InputObject
                        }
                        elseif ($diff.SideIndicator -eq "=>")
                        {
                            Write-Verbose "Will be adding Member: {$($diff.InputObject)}"
                            $membersToAdd += $diff.InputObject
                        }
                    }
                }

                if ($membersToAdd.Count -gt 0)
                {
                    if ("" -ne $MailNickName)
                    {
                        Write-Verbose "Adding members {$($membersToAdd.ToString())}"
                        Add-UnifiedGroupLinks -Identity $MailNickName -LinkType Members -Links $membersToAdd
                    }
                    else
                    {
                        Write-Verbose "Adding members {$($membersToAdd.ToString())} with DisplayName"
                        Add-UnifiedGroupLinks -Identity $DisplayName -LinkType Members -Links $membersToAdd
                    }
                }

                if ($membersToRemove.Count -gt 0)
                {
                    if ("" -ne $name)
                    {
                        Remove-UnifiedGroupLinks -Identity $MailNickName -LinkType Members -Links $membersToRemove
                    }
                    else
                    {
                        Remove-UnifiedGroupLinks -Identity $DisplayName -LinkType Members -Links $membersToRemove
                    }
                }
            }
        }
    }
    elseif($Ensure -eq "Absent")
    {
        try
        {
            [array]$existingO365Group = Get-UnifiedGroup -Identity $currentGroup.MailNickName
        }
        catch
        {
            Write-Error -Message "Could not find group $($currrentGroup.MailNickName)"
        }
        if($existingO365Group.Length -eq 1)
        {
            Write-Verbose -Message "Removing O365Group $($existingO365Group.Name)"
            Remove-UnifiedGroup -Identity $existingO365Group.Name -confirm:$false -Force
        }
        else
        {
            Write-Verbose -Message "There was more than one group identified with the name $($currentGroup.MailNickName)."
            Write-Verbose -Message "No action taken. Please remove the group manually."
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
        $MailNickName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Office 365 Group $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters

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
    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $content = ''
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD
    $groups = Get-AzureADGroup -All $true | Where-Object -FilterScript {
        $_.MailNickName -ne "00000000-0000-0000-0000-000000000000"
    }

    $i = 1
    $organization = ""
    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
    if ($GlobalAdminAccount.UserName.Contains("@"))
    {
        $organization = $GlobalAdminAccount.UserName.Split("@")[1]

        if ($organization.IndexOf(".") -gt 0)
        {
            $principal = $organization.Split(".")[0]
        }
    }
    foreach ($group in $groups)
    {
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            DisplayName        = $group.DisplayName
            ManagedBy          = "DummyUser"
            MailNickName       = $group.MailNickName
        }
        Write-Information "    [$i/$($groups.Length)] $($group.DisplayName)"
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = "`$Credsglobaladmin"
        $content += "        O365Group " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName "GlobalAdminAccount"
        if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
        {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
        }
        if ($partialContent.ToLower().IndexOf($principal.ToLower()) -gt 0)
        {
            $partialContent = $partialContent -ireplace [regex]::Escape("@" + $principal), "@`$(`$OrganizationName.Split('.')[0])"
        }
        $content += $partialContent
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
