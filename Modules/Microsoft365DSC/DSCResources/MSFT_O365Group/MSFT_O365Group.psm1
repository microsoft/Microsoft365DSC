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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of Office 365 Group $DisplayName"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
            -InboundParameters $PSBoundParameters

        Write-Verbose -Message "Retrieving AzureADGroup by MailNickName {$MailNickName}"
        [array]$ADGroup = Get-AzureADGroup -All:$true | Where-Object -FilterScript {$_.MailNickName -eq $MailNickName}
        if ($null -eq $ADGroup)
        {
            Write-Verbose -Message "Retrieving AzureADGroup by DisplayName {$DisplayName}"
            [array]$ADGroup = Get-AzureADGroup -All:$true | Where-Object -FilterScript {$_.DisplayName -eq $DisplayName}
            if ($null -eq $ADGroup)
            {
                Write-Verbose -Message "Office 365 Group {$DisplayName} was not found."
                return $nullReturn
            }
            elseif ($ADGroup.Length -gt 1)
            {
                $Message = "Multiple O365 groups were found with DisplayName {$DisplayName}. Please specify the MailNickName parameter to uniquely identify the group."
                New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
            }
        }
        Write-Verbose -Message "Found Existing Instance of Group {$($ADGroup.DisplayName)}"

        try
        {
            $membersList = Get-AzureADGroupMember -ObjectId $ADGroup[0].ObjectId
            Write-Verbose -Message "Found Members for Group {$($ADGroup[0].DisplayName)}"
            $owners = Get-AzureADGroupOwner -ObjectId $ADGroup[0].ObjectId
            Write-Verbose -Message "Found Owners for Group {$($ADGroup[0].DisplayName)}"
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
                    if ($null -ne $ownersUPN -and $ownersUPN.Length -ge 1 -and `
                        -not [System.String]::IsNullOrEmpty($member.UserPrincipalName) -and `
                        -not $ownersUPN.Contains($member.UserPrincipalName))
                    {
                        $newMemberList += $member.UserPrincipalName
                    }
                }
            }

            $description = ""
            if ($null -ne $ADGroup[0].Description)
            {
                $description = $ADGroup[0].Description.ToString()
            }

            $returnValue = @{
                DisplayName           = $ADGroup[0].DisplayName
                MailNickName          = $ADGroup[0].MailNickName
                Members               = $newMemberList
                ManagedBy             = $ownersUPN
                Description           = $description
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Ensure                = "Present"
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
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $nullReturn
    }
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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Setting configuration of Office 365 Group $DisplayName"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    Write-Verbose -Message "Testing configuration of Office 365 Group $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $dscContent = ''
        $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
            -InboundParameters $PSBoundParameters
        $groups = Get-AzureADGroup -All $true | Where-Object -FilterScript {
            $_.MailNickName -ne "00000000-0000-0000-0000-000000000000"
        }

        $i = 1
        Write-Host "`r`n" -NoNewLine
        foreach ($group in $groups)
        {
            Write-Host "    |---[$i/$($groups.Length)] $($group.DisplayName)" -NoNewLine
            $Params = @{
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                DisplayName           = $group.DisplayName
                ManagedBy             = "DummyUser"
                MailNickName          = $group.MailNickName
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
