function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String[]]
        $Owner,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private", "HiddenMembership")]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Write-Verbose -Message "Getting configuration of Team $DisplayName"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    Write-Verbose -Message "Checking for existence of Team $DisplayName"

    try
    {
        ## will only return 1 instance
        if ($PSBoundParameters.ContainsKey("GroupID"))
        {
            Write-Verbose -Message "GroupID was specified"
            $team = Get-Team -GroupId $GroupID
            if ($null -eq $team)
            {
                Write-Verbose -Message "Teams with GroupId $($GroupID) doesn't exist"
                return $nullReturn
            }
        }
        else
        {
            Write-Verbose -Message "GroupID was NOT specified"
            ## Can retreive multiple Teams since displayname is not unique
            # Filter on DisplayName as -DisplayName also does partial matches and will report duplicate names that are not real duplicate names
            $team = Get-Team -DisplayName $DisplayName | Where-Object {$_.DisplayName -eq $DisplayName}
            if ($null -eq $team)
            {
                Write-Verbose -Message "Teams with displayname $DisplayName doesn't exist"
                return $nullReturn
            }
            if ($team.Length -gt 1)
            {
                throw "Duplicate Teams name $DisplayName exist in tenant"
            }
        }

        Write-Verbose -Message "Getting Team {$DisplayName} Owners"
        [array]$Owners = Get-TeamUser -GroupId $team.GroupId | Where-Object { $_.Role -eq "owner" }
        Write-Verbose -Message "Found Team $($team.DisplayName)."

        $result = @{
            DisplayName                       = $team.DisplayName
            GroupID                           = $team.GroupId
            Description                       = $team.Description
            Owner                             = $Owners[0].User.ToString()
            MailNickName                      = $team.MailNickName
            Visibility                        = $team.Visibility
            AllowAddRemoveApps                = $team.AllowAddRemoveApps
            AllowGiphy                        = $team.AllowGiphy
            GiphyContentRating                = $team.GiphyContentRating
            AllowStickersAndMemes             = $team.AllowStickersAndMemes
            AllowCustomMemes                  = $team.AllowCustomMemes
            AllowUserEditMessages             = $team.AllowUserEditMessages
            AllowUserDeleteMessages           = $team.AllowUserDeleteMessages
            AllowOwnerDeleteMessages          = $team.AllowOwnerDeleteMessages
            AllowCreateUpdateRemoveConnectors = $team.AllowCreateUpdateRemoveConnectors
            AllowCreateUpdateRemoveTabs       = $team.AllowCreateUpdateRemoveTabs
            AllowTeamMentions                 = $team.AllowTeamMentions
            AllowChannelMentions              = $team.AllowChannelMentions
            AllowGuestCreateUpdateChannels    = $team.AllowGuestCreateUpdateChannels
            AllowGuestDeleteChannels          = $team.AllowGuestDeleteChannels
            AllowCreateUpdateChannels         = $team.AllowCreateUpdateChannels
            AllowDeleteChannels               = $team.AllowDeleteChannels
            ShowInTeamsSearchAndSuggestions   = $team.ShowInTeamsSearchAndSuggestions
            Ensure                            = "Present"
        }

        if ($ConnectionMode -eq "ServicePrincipal")
        {
            $result.Add("ApplicationId", $ApplicationId)
            $result.Add("TenantId", $TenantId)
            $result.Add("CertificateThumbprint", $CertificateThumbprint)
        }
        else
        {
            $result.Add("Credential", $Credential)
        }
        return $result
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String[]]
        $Owner,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private", "HiddenMembership")]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        [System.Management.Automation.PSCredential]
        $Credential
    )

    Write-Verbose -Message "Setting configuration of Team $DisplayName"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    $team = Get-TargetResource @PSBoundParameters

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure") | Out-Null

    if ($Ensure -eq "Present" -and ($team.Ensure -eq "Present"))
    {
        ## Can't pass Owner parm into set opertaion
        if ($CurrentParameters.ContainsKey("Owner"))
        {
            $CurrentParameters.Remove("Owner") | Out-Null
        }
        if (-not $CurrentParameters.ContainsKey("GroupID"))
        {
            $CurrentParameters.Add("GroupID", $team.GroupID)
        }
        if ($ConnectionMode -eq 'Credential')
        {
            $CurrentParameters.Remove("Credential") | Out-Null
        }
        else
        {
            $CurrentParameters.Remove("ApplicationId") | Out-Null
            $CurrentParameters.Remove("TenantId") | Out-Null
            $CurrentParameters.Remove("CertificateThumbprint") | Out-Null
        }
        Set-Team @CurrentParameters
        Write-Verbose -Message "Updating team $DisplayName"
    }
    elseif ($Ensure -eq "Present" -and ($team.Ensure -eq "Absent"))
    {
        ## GroupID not used on New-Team cmdlet
        if ($CurrentParameters.ContainsKey("GroupID"))
        {
            $CurrentParameters.Remove("GroupID") | Out-Null
        }
        Write-Verbose -Message "Creating team $DisplayName"
        if ($null -ne $Owner)
        {
            $CurrentParameters.Owner = [array](($Owner[0]).ToString())
        }

        if ($ConnectionMode -eq "ServicePrincipal")
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters
            $group = New-MgSGroup -DisplayName $DisplayName -GroupTypes "Unified" -MailEnabled $true -SecurityEnabled $true -MailNickname $MailNickName
            $currentOwner = (($CurrentParameters.Owner)[0])

            Write-Verbose -Message "Retrieving Group Owner {$currentOwner}"
            $ownerUser = Get-MgUser -Search $currentOwner

            Write-Verbose -Message "Adding Owner {$($ownerUser.ObjectId)} to Group {$($group.Id)}"
            try
            {
                New-MgGroupOwnerByRef -GroupId $group.Id -RefObjectId $ownerUser.ObjectId -ErrorAction Stop
            }
            catch
            {
                Write-Verbose -Message "Adding Owner - Sleeping for 15 seconds"
                Start-Sleep -Seconds 15
                New-MgGroupOwnerByRef -GroupId $group.Id -RefObjectId $ownerUser.ObjectId
            }

            try
            {
                New-Team -GroupId $group.Id -ErrorAction Stop
            }
            catch
            {
                Write-Verbose -Message "Creating Team - Sleeping for 15 seconds"
                Start-Sleep -Seconds 15
                New-Team -GroupId $group.Id
            }
        }
        else
        {
            $OwnerValue = $Owner[0].ToString()
            $CurrentParameters.Owner = [System.String]$OwnerValue
            $CurrentParameters.Remove("Credential") | Out-Null
            $newTeam = New-Team @CurrentParameters

            for ($i = 1; $i -le $Owner.Length; $i++)
            {
                Add-TeamUser -GroupId $newTeam.GroupId -User $Owner[$i] -Role 'Owner'
            }
        }
    }
    elseif ($Ensure -eq "Absent" -and ($team.Ensure -eq "Present"))
    {
        Write-Verbose -Message "Removing team $DisplayName"
        Remove-Team -GroupId $team.GroupId
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
        [ValidateLength(1, 256)]
        $DisplayName,

        [Parameter()]
        [System.String]
        $GroupID,

        [Parameter()]
        [System.String]
        [ValidateLength(1, 1024)]
        $Description,

        [Parameter()]
        [System.String]
        $MailNickName,

        [Parameter()]
        [System.String[]]
        $Owner,

        [Parameter()]
        [System.String]
        [ValidateSet("Public", "Private", "HiddenMembership")]
        $Visibility,

        [Parameter()]
        [System.Boolean]
        $AllowAddRemoveApps,

        [Parameter()]
        [System.Boolean]
        $AllowGiphy,

        [Parameter()]
        [ValidateSet("Strict", "Moderate")]
        [System.String]
        $GiphyContentRating,

        [Parameter()]
        [System.Boolean]
        $AllowStickersAndMemes,

        [Parameter()]
        [System.Boolean]
        $AllowCustomMemes,

        [Parameter()]
        [System.Boolean]
        $AllowUserEditMessages,

        [Parameter()]
        [System.Boolean]
        $AllowUserDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowOwnerDeleteMessages,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveConnectors,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateRemoveTabs,

        [Parameter()]
        [System.Boolean]
        $AllowCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $AllowTeamMentions,

        [Parameter()]
        [System.Boolean]
        $AllowChannelMentions,

        [Parameter()]
        [System.Boolean]
        $AllowGuestCreateUpdateChannels,

        [Parameter()]
        [System.Boolean]
        $AllowGuestDeleteChannels,

        [Parameter()]
        [System.Boolean]
        $ShowInTeamsSearchAndSuggestions,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        [System.Management.Automation.PSCredential]
        $Credential
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Team $DisplayName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    If (!$PSBoundParameters.ContainsKey('Ensure'))
    {
        $PSBoundParameters.Add('Ensure', $Ensure)
    }
    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('GroupID') | Out-Null

    if ($null -eq $CurrentValues.Owner)
    {
        $ValuesToCheck.Remove("Owner") | Out-Null
    }

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        if ($ConnectionMode -eq 'ServicePrincipal')
        {
            $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
        }
        else
        {
            $organization = $Credential.UserName.Split('@')[1]
        }

        $teams = Get-Team
        $i = 1
        $dscContent = ""
        Write-Host "`r`n" -NoNewline
        foreach ($team in $teams)
        {
            Write-Host "    |---[$i/$($teams.Length)] $($team.DisplayName)" -NoNewline
            $params = @{
                DisplayName           = $team.DisplayName
                GroupID               = $team.GroupId
                Credential    = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
            }
            $result = Get-TargetResource @params

            if ($ConnectionMode -eq 'Credential')
            {
                $result = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Result
            }

            $result.Remove("GroupID") | Out-Null
            if ("" -eq $result.Owner)
            {
                $result.Remove("Owner") | Out-Null
            }
            $currentDSCBlock = "        TeamsTeam " + (New-Guid).ToString() + "`r`n"
            $currentDSCBlock += "        {`r`n"
            $content = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            if ($ConnectionMode -eq 'Credential')
            {
                $currentDSCBlock += Convert-DSCStringParamToVariable -DSCBlock $content -ParameterName "Credential"
            }
            else
            {
                $currentDSCBlock += $content
            }
            $currentDSCBlock += "        }`r`n"
            if ($currentDSCBlock.ToLower().Contains("@" + $organization.ToLower()))
            {
                $currentDSCBlock = $currentDSCBlock -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
            }
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckmark
        }

        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
