Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsOnlineVoicemailPolicy'

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
        [System.Boolean]
        $EnableEditingCallAnswerRulesSetting,

        [Parameter()]
        [System.Boolean]
        $EnableTranscription,

        [Parameter()]
        [System.Boolean]
        $EnableTranscriptionProfanityMasking,

        [Parameter()]
        [System.Boolean]
        $EnableTranscriptionTranslation,

        [Parameter()]
        [System.Int32]
        $MaximumRecordingLength,

        [Parameter()]
        [System.String]
        $PostAmbleAudioFile,

        [Parameter()]
        [System.String]
        $PreambleAudioFile,

        [Parameter()]
        [System.Boolean]
        $PreamblePostambleMandatory,

        [Parameter()]
        [System.String]
        $PrimarySystemPromptLanguage,

        [Parameter()]
        [System.String]
        $SecondarySystemPromptLanguage,

        [Parameter()]
        [System.String]
        $ShareData,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting the Teams Online Voicemail Policy $($Identity)"

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

            $policy = Get-CsOnlineVoicemailPolicy -Identity $Identity `
                -ErrorAction 'SilentlyContinue'
        }
        else
        {
            $policy = $Script:exportedInstance
        }

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Online Voicemail Policy ${$Identity}"
            return $nullReturn
        }

        Write-Verbose -Message "Found Teams Online Voicemail Policy {$Identity}"
        return @{
            Identity                            = $policy.Identity.Replace('Tag:', '')
            EnableEditingCallAnswerRulesSetting = $policy.EnableEditingCallAnswerRulesSetting
            EnableTranscription                 = $policy.EnableTranscription
            EnableTranscriptionProfanityMasking = $policy.EnableTranscriptionProfanityMasking
            EnableTranscriptionTranslation      = $policy.EnableTranscriptionTranslation
            MaximumRecordingLength              = $policy.MaximumRecordingLength.TotalSeconds
            PostambleAudioFile                  = $policy.PostambleAudioFile
            PreambleAudioFile                   = $policy.PreambleAudioFile
            PreamblePostambleMandatory          = $policy.PreamblePostambleMandatory
            PrimarySystemPromptLanguage         = $policy.PrimarySystemPromptLanguage
            SecondarySystemPromptLanguage       = $policy.SecondarySystemPromptLanguage
            ShareData                           = $policy.ShareData
            Ensure                              = 'Present'
            Credential                          = $Credential
            ApplicationId                       = $ApplicationId
            TenantId                            = $TenantId
            CertificateThumbprint               = $CertificateThumbprint
            CertificatePath                     = $CertificatePath
            CertificatePassword                 = $CertificatePassword
            ManagedIdentity                     = $ManagedIdentity.IsPresent
            AccessTokens                        = $AccessTokens
        }
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
        [System.Boolean]
        $EnableEditingCallAnswerRulesSetting,

        [Parameter()]
        [System.Boolean]
        $EnableTranscription,

        [Parameter()]
        [System.Boolean]
        $EnableTranscriptionProfanityMasking,

        [Parameter()]
        [System.Boolean]
        $EnableTranscriptionTranslation,

        [Parameter()]
        [System.Int32]
        $MaximumRecordingLength,

        [Parameter()]
        [System.String]
        $PostAmbleAudioFile,

        [Parameter()]
        [System.String]
        $PreambleAudioFile,

        [Parameter()]
        [System.Boolean]
        $PreamblePostambleMandatory,

        [Parameter()]
        [System.String]
        $PrimarySystemPromptLanguage,

        [Parameter()]
        [System.String]
        $SecondarySystemPromptLanguage,

        [Parameter()]
        [System.String]
        $ShareData,

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Setting Teams Online Voicemail Policy'

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

    # Convert recording length in seconds to a TimeSpan value expected by Teams cmdlets.
    if ($PSBoundParameters.ContainsKey('MaximumRecordingLength'))
    {
        $SetParameters.MaximumRecordingLength = New-TimeSpan -Seconds $MaximumRecordingLength
    }

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Online Voicemail Policy {$Identity}"
        New-CsOnlineVoicemailPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Teams Online Voicemail Policy with Identity {$Identity}"
        Set-CsOnlineVoicemailPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Teams Online Voicemail Policy with Identity {$Identity}"
        Remove-CsOnlineVoicemailPolicy -Identity $Identity
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
        [System.Boolean]
        $EnableEditingCallAnswerRulesSetting,

        [Parameter()]
        [System.Boolean]
        $EnableTranscription,

        [Parameter()]
        [System.Boolean]
        $EnableTranscriptionProfanityMasking,

        [Parameter()]
        [System.Boolean]
        $EnableTranscriptionTranslation,

        [Parameter()]
        [System.Int32]
        $MaximumRecordingLength,

        [Parameter()]
        [System.String]
        $PostAmbleAudioFile,

        [Parameter()]
        [System.String]
        $PreambleAudioFile,

        [Parameter()]
        [System.Boolean]
        $PreamblePostambleMandatory,

        [Parameter()]
        [System.String]
        $PrimarySystemPromptLanguage,

        [Parameter()]
        [System.String]
        $SecondarySystemPromptLanguage,

        [Parameter()]
        [System.String]
        $ShareData,

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
        $CertificatePassword,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [array]$policies = Get-CsOnlineVoicemailPolicy -Filter $Filter -ErrorAction Stop
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
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
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
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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
