Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsEventsPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $AllowWebinars,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $BroadcastPremiumApps,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'EveryoneInCompanyExcludingGuests')]
        $EventAccessType,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEmailEditing,

        [Parameter()]
        [System.Boolean]
        $AllowEventIntegrations,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowTownhalls,

        [Parameter()]
        [ValidateSet('DefaultOnly', 'DefaultAndPredefinedOnly', 'AllQuestions')]
        [System.String]
        $AllowedQuestionTypesInRegistrationForm,

        [Parameter()]
        [ValidateSet('None', 'InviteOnly', 'EveryoneInCompanyIncludingGuests', 'Everyone')]
        [System.String]
        $AllowedWebinarTypesForRecordingPublish,

        [Parameter()]
        [ValidateSet('None', 'InviteOnly', 'EveryoneInCompanyIncludingGuests', 'Everyone')]
        [System.String]
        $AllowedTownhallTypesForRecordingPublish,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $ImmersiveEvents,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $RecordingForTownhall,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $RecordingForWebinar,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'EveryoneInOrganizationAndGuests')]
        $TownhallEventAttendeeAccess,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $TranscriptionForTownhall,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $TranscriptionForWebinar,

        [Parameter()]
        [ValidateSet('Optimized', 'None')]
        [System.String]
        $TownhallChatExperience,

        [Parameter()]
        [System.Boolean]
        $UseMicrosoftECDN,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting the Teams Events Policy {$Identity}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $policy = Get-CsTeamsEventsPolicy -Identity $Identity `
                -ErrorAction 'SilentlyContinue'
        }
        else
        {
            $policy = $Script:exportedInstance
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Events Policy {$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Teams Events Policy {$Identity}"
        $result = @{
            Identity                                = $Identity
            Description                             = $policy.Description
            AllowWebinars                           = $policy.AllowWebinars
            BroadcastPremiumApps                    = $policy.BroadcastPremiumApps
            EventAccessType                         = $policy.EventAccessType
            AllowEmailEditing                       = $policy.AllowEmailEditing
            AllowEventIntegrations                  = $policy.AllowEventIntegrations
            AllowTownhalls                          = $policy.AllowTownhalls
            AllowedQuestionTypesInRegistrationForm  = $policy.AllowedQuestionTypesInRegistrationForm
            AllowedWebinarTypesForRecordingPublish  = $policy.AllowedWebinarTypesForRecordingPublish
            AllowedTownhallTypesForRecordingPublish = $policy.AllowedTownhallTypesForRecordingPublish
            ImmersiveEvents                         = $policy.ImmersiveEvents
            RecordingForTownhall                    = $policy.RecordingForTownhall
            RecordingForWebinar                     = $policy.RecordingForWebinar
            TownhallChatExperience                  = $policy.TownhallChatExperience
            TownhallEventAttendeeAccess             = $policy.TownhallEventAttendeeAccess
            TranscriptionForTownhall                = $policy.TranscriptionForTownhall
            TranscriptionForWebinar                 = $policy.TranscriptionForWebinar
            UseMicrosoftECDN                        = $policy.UseMicrosoftECDN
            Ensure                                  = 'Present'
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            CertificateThumbprint                   = $CertificateThumbprint
            ManagedIdentity                         = $ManagedIdentity.IsPresent
            AccessTokens                            = $AccessTokens
        }

        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $AllowWebinars,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $BroadcastPremiumApps,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'EveryoneInCompanyExcludingGuests')]
        $EventAccessType,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEmailEditing,

        [Parameter()]
        [System.Boolean]
        $AllowEventIntegrations,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowTownhalls,

        [Parameter()]
        [ValidateSet('DefaultOnly', 'DefaultAndPredefinedOnly', 'AllQuestions')]
        [System.String]
        $AllowedQuestionTypesInRegistrationForm,

        [Parameter()]
        [ValidateSet('None', 'InviteOnly', 'EveryoneInCompanyIncludingGuests', 'Everyone')]
        [System.String]
        $AllowedWebinarTypesForRecordingPublish,

        [Parameter()]
        [ValidateSet('None', 'InviteOnly', 'EveryoneInCompanyIncludingGuests', 'Everyone')]
        [System.String]
        $AllowedTownhallTypesForRecordingPublish,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $ImmersiveEvents,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $RecordingForTownhall,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $RecordingForWebinar,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'EveryoneInOrganizationAndGuests')]
        $TownhallEventAttendeeAccess,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $TranscriptionForTownhall,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $TranscriptionForWebinar,

        [Parameter()]
        [ValidateSet('Optimized', 'None')]
        [System.String]
        $TownhallChatExperience,

        [Parameter()]
        [System.Boolean]
        $UseMicrosoftECDN,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting Teams Events Policy {$Identity}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $SetParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Events Policy {$Identity}"
        New-CsTeamsEventsPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating settings for Teams Events Policy {$Identity}"
        Set-CsTeamsEventsPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Teams Events Policy {$Identity}"
        Remove-CsTeamsEventsPolicy -Identity $Identity -Confirm:$false
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
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $AllowWebinars,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $BroadcastPremiumApps,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'EveryoneInCompanyExcludingGuests')]
        $EventAccessType,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowEmailEditing,

        [Parameter()]
        [System.Boolean]
        $AllowEventIntegrations,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $AllowTownhalls,

        [Parameter()]
        [ValidateSet('DefaultOnly', 'DefaultAndPredefinedOnly', 'AllQuestions')]
        [System.String]
        $AllowedQuestionTypesInRegistrationForm,

        [Parameter()]
        [ValidateSet('None', 'InviteOnly', 'EveryoneInCompanyIncludingGuests', 'Everyone')]
        [System.String]
        $AllowedWebinarTypesForRecordingPublish,

        [Parameter()]
        [ValidateSet('None', 'InviteOnly', 'EveryoneInCompanyIncludingGuests', 'Everyone')]
        [System.String]
        $AllowedTownhallTypesForRecordingPublish,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $ImmersiveEvents,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $RecordingForTownhall,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $RecordingForWebinar,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'EveryoneInOrganizationAndGuests')]
        $TownhallEventAttendeeAccess,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $TranscriptionForTownhall,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $TranscriptionForWebinar,

        [Parameter()]
        [ValidateSet('Optimized', 'None')]
        [System.String]
        $TownhallChatExperience,

        [Parameter()]
        [System.Boolean]
        $UseMicrosoftECDN,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter = "*",

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $i = 1
        [array]$policies = Get-CsTeamsEventsPolicy -Filter $Filter -ErrorAction Stop
        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($policy in $policies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($policies.Count)] $($policy.Identity)" -DeferWrite
            $params = @{
                Identity              = $policy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $policy
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
