function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Identity,

        [Parameter()]
        [System.String]
        [ValidateSet('DeclineCall', 'PromptOnly', 'PromptOnlyWithTransfer', 'RegularVoicemail', 'VoicemailWithTransferOption')]
        $CallAnswerRule,

        [Parameter()]
        [System.String]
        $DefaultGreetingPromptOverwrite,

        [Parameter()]
        [System.String]
        $DefaultOofGreetingPromptOverwrite,

        [Parameter()]
        [System.Boolean]
        $OofGreetingEnabled,

        [Parameter()]
        [System.Boolean]
        $OofGreetingFollowAutomaticRepliesEnabled,

        [Parameter()]
        [System.Boolean]
        $OofGreetingFollowCalendarEnabled,

        [Parameter()]
        [System.String]
        $PromptLanguage,

        [Parameter()]
        [System.Boolean]
        $ShareData,

        [Parameter()]
        [System.String]
        $TransferTarget,

        [Parameter()]
        [System.Boolean]
        $VoicemailEnabled,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting the Teams Online Voicemail User Settings $($Identity)"

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $instance = Get-CsOnlineVoicemailUserSettings -Identity $Identity -ErrorAction 'SilentlyContinue'

        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find Teams Online Voicemail User Settings for ${$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Teams Online Voicemail User Settings for {$Identity}"
        return @{
            Identity                                 = $Identity
            CallAnswerRule                           = $instance.CallAnswerRule
            DefaultGreetingPromptOverwrite           = $instance.DefaultGreetingPromptOverwrite
            DefaultOofGreetingPromptOverwrite        = $instance.DefaultOofGreetingPromptOverwrite
            OofGreetingEnabled                       = $instance.OofGreetingEnabled
            OofGreetingFollowAutomaticRepliesEnabled = $instance.OofGreetingFollowAutomaticRepliesEnabled
            OofGreetingFollowCalendarEnabled         = $instance.OofGreetingFollowCalendarEnabled
            PromptLanguage                           = $instance.PromptLanguage
            ShareData                                = $instance.ShareData
            TransferTarget                           = $instance.TransferTarget
            VoicemailEnabled                         = $instance.VoicemailEnabled
            Ensure                                   = 'Present'
            Credential                               = $Credential
            ApplicationId                            = $ApplicationId
            TenantId                                 = $TenantId
            CertificateThumbprint                    = $CertificateThumbprint
            ManagedIdentity                          = $ManagedIdentity.IsPresent
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Identity,

        [Parameter()]
        [System.String]
        [ValidateSet('DeclineCall', 'PromptOnly', 'PromptOnlyWithTransfer', 'RegularVoicemail', 'VoicemailWithTransferOption')]
        $CallAnswerRule,

        [Parameter()]
        [System.String]
        $DefaultGreetingPromptOverwrite,

        [Parameter()]
        [System.String]
        $DefaultOofGreetingPromptOverwrite,

        [Parameter()]
        [System.Boolean]
        $OofGreetingEnabled,

        [Parameter()]
        [System.Boolean]
        $OofGreetingFollowAutomaticRepliesEnabled,

        [Parameter()]
        [System.Boolean]
        $OofGreetingFollowCalendarEnabled,

        [Parameter()]
        [System.String]
        $PromptLanguage,

        [Parameter()]
        [System.Boolean]
        $ShareData,

        [Parameter()]
        [System.String]
        $TransferTarget,

        [Parameter()]
        [System.Boolean]
        $VoicemailEnabled,

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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Setting Teams Online Voicemail User Settings'

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove('Ensure') | Out-Null
    $SetParameters.Remove('Credential') | Out-Null
    $SetParameters.Remove('ApplicationId') | Out-Null
    $SetParameters.Remove('TenantId') | Out-Null
    $SetParameters.Remove('CertificateThumbprint') | Out-Null
    $SetParameters.Remove('ManagedIdentity') | Out-Null

    try
    {
        Set-CsOnlineVoicemailUserSettings @SetParameters
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error updating data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Identity,

        [Parameter()]
        [System.String]
        [ValidateSet('DeclineCall', 'PromptOnly', 'PromptOnlyWithTransfer', 'RegularVoicemail', 'VoicemailWithTransferOption')]
        $CallAnswerRule,

        [Parameter()]
        [System.String]
        $DefaultGreetingPromptOverwrite,

        [Parameter()]
        [System.String]
        $DefaultOofGreetingPromptOverwrite,

        [Parameter()]
        [System.Boolean]
        $OofGreetingEnabled,

        [Parameter()]
        [System.Boolean]
        $OofGreetingFollowAutomaticRepliesEnabled,

        [Parameter()]
        [System.Boolean]
        $OofGreetingFollowCalendarEnabled,

        [Parameter()]
        [System.String]
        $PromptLanguage,

        [Parameter()]
        [System.Boolean]
        $ShareData,

        [Parameter()]
        [System.String]
        $TransferTarget,

        [Parameter()]
        [System.Boolean]
        $VoicemailEnabled,

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
        $ManagedIdentity
    )
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

    Write-Verbose -Message "Testing configuration of Team Online Voicemail User Settings {$Identity}"

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
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        $allUsers = Get-MgUser -All -Property 'UserPrincipalName'
        $i = 1
        Write-Host "`r`n" -NoNewline
        $dscContent = [System.Text.StringBuilder]::New()
        foreach ($user in $allUsers)
        {
            Write-Host "    |---[$i/$($allUsers.Length)] $($user.UserPrincipalName)" -NoNewline
            $params = @{
                Identity              = $user.UserPrincipalName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent.Append($currentDSCBlock) | Out-Null
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent.ToString()
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
