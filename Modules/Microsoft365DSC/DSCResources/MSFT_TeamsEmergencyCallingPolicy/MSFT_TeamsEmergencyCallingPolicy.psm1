Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsEmergencyCallingPolicy'

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
        $EnhancedEmergencyServiceDisclaimer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExtendedNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $ExternalLocationLookupMode,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(?:\+)?[0-9]*$')]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.String]
        [ValidateSet('NotificationOnly', 'ConferenceMuted', 'ConferenceUnMuted')]
        $NotificationMode,

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

    Write-Verbose -Message "Getting the Teams Emergency Calling Policy {$Identity}"

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

            $policy = Get-CsTeamsEmergencyCallingPolicy -Identity $Identity `
                -ErrorAction 'SilentlyContinue'
        }
        else
        {
            $policy = $Script:exportedInstance
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Emergency Calling Policy {$Identity}"
            return $nullReturn
        }

        $complexExtendedNotifications = @()
        foreach ($notification in $policy.ExtendedNotifications)
        {
            $complexExtendedNotification = [ordered]@{
                EmergencyDialString = $notification.EmergencyDialString
            }
            if ($null -ne $notification.NotificationGroup)
            {
                $complexExtendedNotification.Add('NotificationGroup', $notification.NotificationGroup.Split(";"))
            }
            if ($null -ne $notification.NotificationDialOutNumber)
            {
                $complexExtendedNotification.Add('NotificationDialOutNumber', $notification.NotificationDialOutNumber)
            }
            if ($null -ne $notification.NotificationMode)
            {
                $complexExtendedNotification.Add('NotificationMode', $notification.NotificationMode)
            }
            $complexExtendedNotifications += $complexExtendedNotification
        }

        Write-Verbose -Message "Found Teams Emergency Calling Policy {$Identity}"
        $result = @{
            Identity                           = $Identity
            Description                        = $policy.Description
            EnhancedEmergencyServiceDisclaimer = $policy.EnhancedEmergencyServiceDisclaimer
            ExtendedNotifications              = $complexExtendedNotifications
            ExternalLocationLookupMode         = $policy.ExternalLocationLookupMode
            NotificationDialOutNumber          = $policy.NotificationDialOutNumber
            NotificationGroup                  = $policy.NotificationGroup
            NotificationMode                   = [String]$policy.NotificationMode
            Ensure                             = 'Present'
            Credential                         = $Credential
            ApplicationId                      = $ApplicationId
            TenantId                           = $TenantId
            CertificateThumbprint              = $CertificateThumbprint
            ManagedIdentity                    = $ManagedIdentity.IsPresent
            AccessTokens                       = $AccessTokens
        }

        if ([System.String]::IsNullOrEmpty($result.NotificationMode))
        {
            $result.Remove('NotificationMode') | Out-Null
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
        $EnhancedEmergencyServiceDisclaimer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExtendedNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $ExternalLocationLookupMode,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(?:\+)?[0-9]*$')]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.String]
        [ValidateSet('NotificationOnly', 'ConferenceMuted', 'ConferenceUnMuted')]
        $NotificationMode,

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

    Write-Verbose -Message "Setting Teams Emergency Calling Policy {$Identity}"

    # Check that at least one optional parameter is specified
    $inputValues = @()
    foreach ($item in $PSBoundParameters.Keys)
    {
        if (-not [System.String]::IsNullOrEmpty($PSBoundParameters.$item) -and $item -ne 'Credential' `
                -and $item -ne 'Identity' -and $item -ne 'Ensure')
        {
            $inputValues += $item
        }
    }

    if ($inputValues.Count -eq 0)
    {
        throw 'You need to specify at least one optional parameter for the Set-TargetResource function' + `
            " of the [TeamsEmergencyCallingPolicy] instance {$Identity}"
    }

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
    if ($PSBoundParameters.ContainsKey('ExtendedNotifications'))
    {
        if ($SetParameters.ExtendedNotifications.Count -gt 0)
        {
            $SetParameters.ExtendedNotifications = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $SetParameters.ExtendedNotifications
            for ($i = 0; $i -lt $SetParameters.ExtendedNotifications.Count; $i++)
            {
                $SetParameters.ExtendedNotifications[$i].NotificationGroup -join ";"
            }
        }
    }

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Emergency Calling Policy {$Identity}"
        New-CsTeamsEmergencyCallingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        # If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
        # into the Set-CsTeamsEmergencyCallingPolicy cmdlet.
        Write-Verbose -Message "Updating settings for Teams Emergency Calling Policy {$Identity}"
        Set-CsTeamsEmergencyCallingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Teams Emergency Calling Policy {$Identity}"
        Remove-CsTeamsEmergencyCallingPolicy -Identity $Identity
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
        $EnhancedEmergencyServiceDisclaimer,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExtendedNotifications,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled', 'Disabled')]
        $ExternalLocationLookupMode,

        [Parameter()]
        [System.String]
        [ValidatePattern('^(?:\+)?[0-9]*$')]
        $NotificationDialOutNumber,

        [Parameter()]
        [System.String]
        $NotificationGroup,

        [Parameter()]
        [System.String]
        [ValidateSet('NotificationOnly', 'ConferenceMuted', 'ConferenceUnMuted')]
        $NotificationMode,

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
        [array]$policies = Get-CsTeamsEmergencyCallingPolicy -ErrorAction Stop
        $dscContent = ''
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

            if ($null -ne $Results.ExtendedNotifications)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExtendedNotifications `
                    -CIMInstanceName 'TeamsEmergencyCallingExtendedNotification'
                if (-not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ExtendedNotifications = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ExtendedNotifications') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('ExtendedNotifications')
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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
