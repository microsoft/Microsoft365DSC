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
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Office 365 Group $DisplayName"

    $nullReturn = @{
        DisplayName = $DisplayName
        MailNickName = $Name
        Description = $null
        ManagedBy = $null
        GlobalAdminAccount = $null
        Ensure = "Absent"
    }

    $catch = Connect-AzureAD -Credential $GlobalAdminAccount

    $ADGroup = Get-AzureADGroup -SearchString $MailNickName -ErrorAction SilentlyContinue
    if ($null -eq $ADGroup)
    {
        $ADGroup = Get-AzureADGroup -SearchString $DisplayName -ErrorAction SilentlyContinue
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
        $ownersUPN = $null
        if ($null -ne $owners)
        {
            $ownersUPN = $owners.UserPrincipalName
        }

        $description = ""
        if ($null -ne $ADGroup.Description)
        {
            $description = $ADGroup.Description.ToString()
        }

        $returnValue = @{
            DisplayName = $ADGroup.DisplayName
            MailNickName = $ADGroup.MailNickName
            Members = $membersList.UserPrincipalName
            ManagedBy = $ownersUPN
            Description = $description
            GlobalAdminAccount = $GlobalAdminAccount
            Ensure = "Present"
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
        Write-Verbose "An error occured retrieving info for Group $DisplayName"
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
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Office 365 Group $DisplayName"

    $currentGroup = Get-TargetResource @PSBoundParameters

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

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
                    if ("" -ne $MailNickName)
                    {
                        Add-UnifiedGroupLinks -Identity $MailNickName -LinkType Members -Links $membersToAdd
                    }
                    else
                    {
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
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Office 365 Group $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("Ensure", `
                                                                   "DisplayName", `
                                                                   "MailNickName", `
                                                                   "Description", `
                                                                   "Members")

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
        [System.String]
        $MailNickName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = "`$Credsglobaladmin"
    $content = "        O365Group " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
