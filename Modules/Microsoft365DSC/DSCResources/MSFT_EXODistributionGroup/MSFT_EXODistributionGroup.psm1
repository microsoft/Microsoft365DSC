function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed')]
        $MemberDepartRestriction,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed', 'ApprovalRequired')]
        $MemberJoinRestriction,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $RoomList,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Distribution', 'Security')]
        $Type,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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

    Write-Verbose -Message "Getting configuration of Distribution Group for $Name"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

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

    try
    {
        $distributionGroup = Get-DistributionGroup -Filter "Name -eq '$Name'" -ErrorAction Stop

        if ($null -eq $distributionGroup)
        {
            Write-Verbose -Message "Distribution Group $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $descriptionValue = $null
            if ($distributionGroup.Description.Length -gt 0)
            {
                $descriptionValue = $distributionGroup.Description[0].Replace("`r", '').Replace("`n", '')
            }

            $result = @{
                Alias                              = $distributionGroup.Alias
                BccBlocked                         = $distributionGroup.BccBlocked
                BypassNestedModerationEnabled      = $distributionGroup.BypassNestedModerationEnabled
                Description                        = $descriptionValue
                DisplayName                        = $distributionGroup.DisplayName
                HiddenGroupMembershipEnabled       = $distributionGroup.HiddenGroupMembershipEnabled
                ManagedBy                          = $distributionGroup.ManagedBy
                MemberDepartRestriction            = $distributionGroup.MemberDepartRestriction
                MemberJoinRestriction              = $distributionGroup.MemberJoinRestriction
                Members                            = $distributionGroup.Members
                ModeratedBy                        = $distributionGroup.ModeratedBy
                ModerationEnabled                  = $distributionGroup.ModerationEnabled
                Name                               = $distributionGroup.Name
                Notes                              = $distributionGroup.Notes
                OrganizationalUnit                 = $distributionGroup.OrganizationalUnit
                PrimarySmtpAddress                 = $distributionGroup.PrimarySmtpAddress
                RequireSenderAuthenticationEnabled = $distributionGroup.RequireSenderAuthenticationEnabled
                RoomList                           = $distributionGroup.RoomList
                SendModerationNotifications        = $distributionGroup.SendModerationNotifications
                Type                               = $distributionGroup.Type
                Ensure                             = 'Present'
                Credential                         = $Credential
                ApplicationId                      = $ApplicationId
                CertificateThumbprint              = $CertificateThumbprint
                CertificatePath                    = $CertificatePath
                CertificatePassword                = $CertificatePassword
                TenantId                           = $TenantId
            }

            Write-Verbose -Message "Found Distribution Group $($Name)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
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
        $Name,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed')]
        $MemberDepartRestriction,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed', 'ApprovalRequired')]
        $MemberJoinRestriction,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $RoomList,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Distribution', 'Security')]
        $Type,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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

    Write-Verbose -Message "Setting Distribution Group configuration for {$Name}"

    $currentDistributionGroup = Get-TargetResource @PSBoundParameters

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("Ensure") | Out-Null
    $currentParameters.Remove("Credential") | Out-Null
    $currentParameters.Remove("ApplicationId") | Out-Null
    $currentParameters.Remove("TenantId") | Out-Null
    $currentParameters.Remove("CertificateThumbprint") | Out-Null
    $currentParameters.Remove("CertificatePath") | Out-Null
    $currentParameters.Remove("CertificatePassword") | Out-Null

    # Distribution group doesn't exist but it should
    if ($Ensure -eq "Present" -and $currentDistributionGroup.Ensure -eq "Absent")
    {
        Write-Verbose -Message "The Distribution Group {$Name} does not exist but it should. Creating it."
        New-DistributionGroup @currentParameters
    }
    # Distribution group exists but shouldn't
    elseif ($Ensure -eq "Absent" -and $currentDistributionGroup.Ensure -eq "Present")
    {
        Write-Verbose -Message "The Distribution Group {$Name} exists but shouldn't. Removing it."
        Remove-DistributionGroup -Identity $Name -Confirm:$false
    }
    elseif ($Ensure -eq "Present" -and $currentDistributionGroup.Ensure -eq "Present")
    {
        Write-Verbose -Message "The Distribution Group {$Name} already exists. Updating settings"
        Write-Verbose -Message "Setting Distribution Group {$Name} with values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"

        if ($currentDistributionGroup.OrganizationalUnit -ne $OrganizationalUnit)
        {
            Write-Warning -Message "Desired and current OrganizationalUnit values differ. This property cannot be updated once the distribution group has been created. Delete and recreate the distribution group to update the value."
        }
        $currentParameters.Remove("OrganizationalUnit") | Out-Null
        Set-DistributionGroup @currentParameters -Identity $Name
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
        $Name,

        [Parameter()]
        [System.String]
        $Alias,

        [Parameter()]
        [System.Boolean]
        $BccBlocked,

        [Parameter()]
        [System.Boolean]
        $BypassNestedModerationEnabled,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $HiddenGroupMembershipEnabled,

        [Parameter()]
        [System.String[]]
        $ManagedBy,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed')]
        $MemberDepartRestriction,

        [Parameter()]
        [System.String]
        [ValidateSet('Open', 'Closed', 'ApprovalRequired')]
        $MemberJoinRestriction,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $ModeratedBy,

        [Parameter()]
        [System.Boolean]
        $ModerationEnabled,

        [Parameter()]
        [System.String]
        $Notes,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter()]
        [System.String]
        $PrimarySmtpAddress,

        [Parameter()]
        [System.Boolean]
        $RequireSenderAuthenticationEnabled,

        [Parameter()]
        [System.Boolean]
        $RoomList,

        [Parameter()]
        [System.String]
        [ValidateSet('Always', 'Internal', 'Never')]
        $SendModerationNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Distribution', 'Security')]
        $Type,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing Distribution Group configuration for {$Name}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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
    param (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

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
        $dscContent = ""
        [array]$distributionGroups = Get-DistributionGroup -ResultSize 'Unlimited' -ErrorAction Stop
        if ($distributionGroups.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1

        foreach ($distributionGroup in $distributionGroups)
        {
            Write-Host "    |---[$i/$($distributionGroups.Count)] $($distributionGroup.Name)" -NoNewline
            $params = @{
                Name                  = $distributionGroup.Name
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i ++
        }
        return $dscContent
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
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
