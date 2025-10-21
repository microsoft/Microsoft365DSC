Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsAppSetupPolicy'

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
        [System.String[]]
        $AppPresetList,

        [Parameter()]
        [System.String[]]
        $AppPresetMeetingList,

        [Parameter()]
        [System.String[]]
        $PinnedAppBarApps,

        [Parameter()]
        [System.String[]]
        $PinnedCallingBarApps,

        [Parameter()]
        [System.String[]]
        $PinnedMessageBarApps,

        [Parameter()]
        [System.Boolean]
        $AllowUserPinning,

        [Parameter()]
        [System.Boolean]
        $AllowSideLoading,

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

    Write-Verbose -Message "Getting configuration for TeamsAppSetupPolicy $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $instance = Get-CsTeamsAppSetupPolicy -Identity $Identity -ErrorAction SilentlyContinue
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        if ($null -eq $instance)
        {
            return $nullResult
        }

        $appPresetListValue = $instance.AppPresetList.Id
        if ($instance.AppPresetList.Count -eq 0)
        {
            $appPresetListValue = @()
        }

        $appPresetMeetingListValue = $instance.AppPresetMeetingList.Id
        if ($instance.AppPresetMeetingList.Count -eq 0)
        {
            $appPresetMeetingListValue = @()
        }

        $pinnedAppBarAppsValue = $instance.PinnedAppBarApps.Id
        if ($instance.PinnedAppBarApps.Count -eq 0)
        {
            $pinnedAppBarAppsValue = @()
        }

        $pinnedCallingBarAppsValue = $instance.PinnedCallingBarApps.Id
        if ($instance.PinnedCallingBarApps.Count -eq 0)
        {
            $pinnedCallingBarAppsValue = @()
        }

        $pinnedMessageBarAppsValue = $instance.PinnedMessageBarApps.Id
        if ($instance.PinnedMessageBarApps.Count -eq 0)
        {
            $pinnedMessageBarAppsValue = @()
        }

        Write-Verbose -Message "Found an instance with Identity {$Identity}"
        $results = @{
            Identity              = $instance.Identity.Replace('Tag:', '')
            Description           = $instance.Description
            AppPresetList         = [Array]$appPresetListValue
            AppPresetMeetingList  = [Array]$appPresetMeetingListValue
            PinnedAppBarApps      = [Array]$pinnedAppBarAppsValue
            PinnedCallingBarApps  = [Array]$pinnedCallingBarAppsValue
            PinnedMessageBarApps  = [Array]$pinnedMessageBarAppsValue
            AllowUserPinning      = $instance.AllowUserPinning
            AllowSideLoading      = $instance.AllowSideLoading
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
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
        [System.String[]]
        $AppPresetList,

        [Parameter()]
        [System.String[]]
        $AppPresetMeetingList,

        [Parameter()]
        [System.String[]]
        $PinnedAppBarApps,

        [Parameter()]
        [System.String[]]
        $PinnedCallingBarApps,

        [Parameter()]
        [System.String[]]
        $PinnedMessageBarApps,

        [Parameter()]
        [System.Boolean]
        $AllowUserPinning,

        [Parameter()]
        [System.Boolean]
        $AllowSideLoading,

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

    Write-Verbose -Message "Setting configuration for TeamsAppSetupPolicy $Identity"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $appPresetValues = @()
    if ($null -ne $AppPresetList -and ([Array]$AppPresetList).Count -gt 0)
    {
        foreach ($appInstance in $AppPresetList)
        {
            $appPresetValues += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.AppPreset]::new($appInstance)
        }
    }

    $appPresetMeetingValues = @()
    if ($null -ne $AppPresetMeetingList -and ([Array]$AppPresetMeetingList).Count -gt 0)
    {
        foreach ($appInstance in $AppPresetMeetingList)
        {
            $appPresetMeetingValues += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.AppPresetMeeting]::new($appInstance)
        }
    }

    $pinnedAppBarAppsValue = @()
    if ($null -ne $PinnedAppBarApps -and ([Array]$PinnedAppBarApps).Count -gt 0)
    {
        $i = 1
        foreach ($appInstance in $PinnedAppBarApps)
        {
            $pinnedAppBarAppsValue += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.PinnedApp]::new($appInstance, $i)
            $i++
        }
    }

    $pinnedCallingBarAppsValue = @()
    if ($null -ne $PinnedCallingBarApps -and ([Array]$PinnedCallingBarApps).Count -gt 0)
    {
        $i = 1
        foreach ($appInstance in $PinnedCallingBarApps)
        {
            $pinnedCallingBarAppsValue += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.PinnedCallingBarApp]::new($appInstance, $i)
            $i++
        }
    }

    $pinnedMessageBarAppsValue = @()
    if ($null -ne $PinnedMessageBarApps -and ([Array]$PinnedMessageBarApps).Count -gt 0)
    {
        $i = 1
        foreach ($appInstance in $PinnedMessageBarApps)
        {
            $pinnedMessageBarAppsValue += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.PinnedMessageBarApp]::new($appInstance, $i)
            $i++
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $CreateParameters.Remove('Verbose') | Out-Null
        Write-Verbose -Message "Creating the Teams App Setup Policy {$Identity} with Parameters:`r`n$(Convert-M365DscHashtableToString -Hashtable $CreateParameters)"

        $CreateParameters.AppPresetList = $appPresetValues
        $CreateParameters.AppPresetMeetingList = $appPresetMeetingValues
        $CreateParameters.PinnedAppBarApps = $pinnedAppBarAppsValue
        $CreateParameters.PinnedCallingBarApps = $pinnedCallingBarAppsValue
        $CreateParameters.PinnedMessageBarApps = $pinnedMessageBarAppsValue

        New-CsTeamsAppSetupPolicy @CreateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $UpdateParameters.Remove('Verbose') | Out-Null
        Write-Verbose -Message "Updating the Teams App Setup Policy with Identity {$Identity}"

        $UpdateParameters.AppPresetList = $appPresetValues
        $UpdateParameters.AppPresetMeetingList = $appPresetMeetingValues
        $UpdateParameters.PinnedAppBarApps = $pinnedAppBarAppsValue
        $UpdateParameters.PinnedCallingBarApps = $pinnedCallingBarAppsValue
        $UpdateParameters.PinnedMessageBarApps = $pinnedMessageBarAppsValue

        Set-CsTeamsAppSetupPolicy @UpdateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Teams App Setup Policy with Identity {$Identity}"
        Remove-CsTeamsAppSetupPolicy -Identity $currentInstance.Identity
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
        [System.String[]]
        $AppPresetList,

        [Parameter()]
        [System.String[]]
        $AppPresetMeetingList,

        [Parameter()]
        [System.String[]]
        $PinnedAppBarApps,

        [Parameter()]
        [System.String[]]
        $PinnedCallingBarApps,

        [Parameter()]
        [System.String[]]
        $PinnedMessageBarApps,

        [Parameter()]
        [System.Boolean]
        $AllowUserPinning,

        [Parameter()]
        [System.Boolean]
        $AllowSideLoading,

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
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$getValue = Get-CsTeamsAppSetupPolicy -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Identity
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
