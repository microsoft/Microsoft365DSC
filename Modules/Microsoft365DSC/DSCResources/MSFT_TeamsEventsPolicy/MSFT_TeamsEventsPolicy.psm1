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
        $policy = Get-CsTeamsEventsPolicy -Identity $Identity `
            -ErrorAction 'SilentlyContinue'

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
            EventAccessType                         = $policy.EventAccessType
            AllowEmailEditing                       = $policy.AllowEmailEditing
            AllowEventIntegrations                  = $policy.AllowEventIntegrations
            AllowTownhalls                          = $policy.AllowTownhalls
            AllowedQuestionTypesInRegistrationForm  = $policy.AllowedQuestionTypesInRegistrationForm
            AllowedWebinarTypesForRecordingPublish  = $policy.AllowedWebinarTypesForRecordingPublish
            AllowedTownhallTypesForRecordingPublish = $policy.AllowedTownhallTypesForRecordingPublish
            TownhallChatExperience                  = $policy.TownhallChatExperience
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
    $SetParameters.Remove('AccessTokens') | Out-Null

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

    Write-Verbose -Message "Testing configuration of Teams Events Policy {$Identity}"

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
        $organization = ''
        if ($null -ne $Credential -and $Credential.UserName.Contains('@'))
        {
            $organization = $Credential.UserName.Split('@')[1]
        }

        $i = 1
        [array]$policies = Get-CsTeamsEventsPolicy -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewline
            $params = @{
                Identity              = $policy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
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
