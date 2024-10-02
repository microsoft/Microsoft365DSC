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
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'Quarantine')]
        [System.String]
        $AuthenticationFailAction = 'MoveToJmf',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.Boolean]
        $EnableFirstContactSafetyTips = $true,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence = $true,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligenceProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarDomainsSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarUsersSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSpoofIntelligence = $true,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableUnauthenticatedSender = $true,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableViaTag = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExcludedDomains = @(),

        [Parameter()]
        [System.String[]]
        $ExcludedSenders = @(),

        [Parameter()]
        [System.Boolean]
        $HonorDmarcPolicy,

        [Parameter()]
        [ValidateSet('Automatic', 'Manual', 'Off')]
        [System.String]
        $ImpersonationProtectionState = 'Automatic',

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $MailboxIntelligenceProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $MailboxIntelligenceProtectionActionRecipients = @(),

        [Parameter()]
        [System.String]
        $MailboxIntelligenceQuarantineTag,

        [Parameter()]
        [System.String]
        $SpoofQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet(1, 2, 3, 4)]
        [System.Int32]
        $PhishThresholdLevel = 1,

        [Parameter()]
        [System.String[]]
        $TargetedDomainActionRecipients = @(),

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $TargetedDomainProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $TargetedDomainsToProtect = @(),

        [Parameter()]
        [System.String]
        $TargetedDomainQuarantineTag,

        [Parameter()]
        [System.String[]]
        $TargetedUserActionRecipients = @(),

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $TargetedUserProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $TargetedUsersToProtect = @(),

        [Parameter()]
        [System.String]
        $TargetedUserQuarantineTag,

        [Parameter()]
        [System.String]
        [ValidateSet('MoveToJmf', 'Quarantine')]
        $DmarcQuarantineAction,

        [Parameter()]
        [System.String]
        [ValidateSet('Quarantine', 'Reject')]
        $DmarcRejectAction,

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

    Write-Verbose -Message "Getting configuration of AntiPhishPolicy for $Identity"

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
        $AntiPhishPolicies = Get-AntiPhishPolicy -ErrorAction Stop

        $AntiPhishPolicy = $AntiPhishPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $AntiPhishPolicy)
        {
            Write-Verbose -Message "AntiPhishPolicy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $PhishThresholdLevelValue = $AntiPhishPolicy.PhishThresholdLevel
            if ([System.String]::IsNullOrEmpty($PhishThresholdLevelValue))
            {
                $PhishThresholdLevelValue = 1
            }

            $TargetedUserProtectionActionValue = $AntiPhishPolicy.TargetedUserProtectionAction
            if ([System.String]::IsNullOrEmpty($TargetedUserProtectionActionValue))
            {
                $TargetedUserProtectionActionValue = 'NoAction'
            }

            $TargetedDomainProtectionActionValue = $AntiPhishPolicy.TargetedDomainProtectionAction
            if ([System.String]::IsNullOrEmpty($TargetedDomainProtectionActionValue))
            {
                $TargetedDomainProtectionActionValue = 'NoAction'
            }

            $result = @{
                Identity                                      = $Identity
                AdminDisplayName                              = $AntiPhishPolicy.AdminDisplayName
                AuthenticationFailAction                      = $AntiPhishPolicy.AuthenticationFailAction
                Enabled                                       = $AntiPhishPolicy.Enabled
                EnableFirstContactSafetyTips                  = $AntiPhishPolicy.EnableFirstContactSafetyTips
                EnableMailboxIntelligence                     = $AntiPhishPolicy.EnableMailboxIntelligence
                EnableMailboxIntelligenceProtection           = $AntiPhishPolicy.EnableMailboxIntelligenceProtection
                EnableOrganizationDomainsProtection           = $AntiPhishPolicy.EnableOrganizationDomainsProtection
                EnableSimilarDomainsSafetyTips                = $AntiPhishPolicy.EnableSimilarDomainsSafetyTips
                EnableSimilarUsersSafetyTips                  = $AntiPhishPolicy.EnableSimilarUsersSafetyTips
                EnableSpoofIntelligence                       = $AntiPhishPolicy.EnableSpoofIntelligence
                EnableTargetedDomainsProtection               = $AntiPhishPolicy.EnableTargetedDomainsProtection
                EnableTargetedUserProtection                  = $AntiPhishPolicy.EnableTargetedUserProtection
                EnableUnauthenticatedSender                   = $AntiPhishPolicy.EnableUnauthenticatedSender
                EnableUnusualCharactersSafetyTips             = $AntiPhishPolicy.EnableUnusualCharactersSafetyTips
                EnableViaTag                                  = $AntiPhishPolicy.EnableViaTag
                ExcludedDomains                               = $AntiPhishPolicy.ExcludedDomains
                ExcludedSenders                               = $AntiPhishPolicy.ExcludedSenders
                HonorDmarcPolicy                              = $AntiPhishPolicy.HonorDmarcPolicy
                ImpersonationProtectionState                  = $AntiPhishPolicy.ImpersonationProtectionState
                MailboxIntelligenceProtectionAction           = $AntiPhishPolicy.MailboxIntelligenceProtectionAction
                MailboxIntelligenceProtectionActionRecipients = $AntiPhishPolicy.MailboxIntelligenceProtectionActionRecipients
                MailboxIntelligenceQuarantineTag              = $AntiPhishPolicy.MailboxIntelligenceQuarantineTag
                SpoofQuarantineTag                            = $AntiPhishPolicy.SpoofQuarantineTag
                MakeDefault                                   = $AntiPhishPolicy.IsDefault
                PhishThresholdLevel                           = $PhishThresholdLevelValue
                TargetedDomainActionRecipients                = $AntiPhishPolicy.TargetedDomainActionRecipients
                TargetedDomainProtectionAction                = $TargetedDomainProtectionActionValue
                TargetedDomainsToProtect                      = $AntiPhishPolicy.TargetedDomainsToProtect
                TargetedDomainQuarantineTag                   = $AntiPhishPolicy.TargetedDomainQuarantineTag
                TargetedUserActionRecipients                  = $AntiPhishPolicy.TargetedUserActionRecipients
                TargetedUserProtectionAction                  = $TargetedUserProtectionActionValue
                TargetedUsersToProtect                        = $AntiPhishPolicy.TargetedUsersToProtect
                TargetedUserQuarantineTag                     = $AntiPhishPolicy.TargetedUserQuarantineTag
                DmarcQuarantineAction                         = $AntiPhishPolicy.DmarcQuarantineAction
                DmarcRejectAction                             = $AntiPhishPolicy.DmarcRejectAction
                Credential                                    = $Credential
                Ensure                                        = 'Present'
                ApplicationId                                 = $ApplicationId
                CertificateThumbprint                         = $CertificateThumbprint
                CertificatePath                               = $CertificatePath
                CertificatePassword                           = $CertificatePassword
                Managedidentity                               = $ManagedIdentity.IsPresent
                TenantId                                      = $TenantId
                AccessTokens                                  = $AccessTokens
            }

            Write-Verbose -Message "Found AntiPhishPolicy $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
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
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'Quarantine')]
        [System.String]
        $AuthenticationFailAction = 'MoveToJmf',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.Boolean]
        $EnableFirstContactSafetyTips = $true,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence = $true,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligenceProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarDomainsSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarUsersSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSpoofIntelligence = $true,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableUnauthenticatedSender = $true,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableViaTag = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExcludedDomains = @(),

        [Parameter()]
        [System.String[]]
        $ExcludedSenders = @(),

        [Parameter()]
        [System.Boolean]
        $HonorDmarcPolicy,

        [Parameter()]
        [ValidateSet('Automatic', 'Manual', 'Off')]
        [System.String]
        $ImpersonationProtectionState = 'Automatic',

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $MailboxIntelligenceProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $MailboxIntelligenceProtectionActionRecipients = @(),

        [Parameter()]
        [System.String]
        $MailboxIntelligenceQuarantineTag,

        [Parameter()]
        [System.String]
        $SpoofQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet(1, 2, 3, 4)]
        [System.Int32]
        $PhishThresholdLevel = 1,

        [Parameter()]
        [System.String[]]
        $TargetedDomainActionRecipients = @(),

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $TargetedDomainProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $TargetedDomainsToProtect = @(),

        [Parameter()]
        [System.String]
        $TargetedDomainQuarantineTag,

        [Parameter()]
        [System.String[]]
        $TargetedUserActionRecipients = @(),

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $TargetedUserProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $TargetedUsersToProtect = @(),

        [Parameter()]
        [System.String]
        $TargetedUserQuarantineTag,

        [Parameter()]
        [System.String]
        [ValidateSet('MoveToJmf', 'Quarantine')]
        $DmarcQuarantineAction,

        [Parameter()]
        [System.String]
        [ValidateSet('Quarantine', 'Reject')]
        $DmarcRejectAction,

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

    Write-Verbose -Message "Setting configuration of AntiPhishPolicy for $Identity"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $currentInstance = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('CertificatePassword') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('CertificatePath') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    if (('Present' -eq $Ensure ) -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new instance of AntiPhish Policy {$Identity}"
        $CreateParams = $PSBoundParameters
        $CreateParams.Remove('Ensure') | Out-Null
        $createParams.Add('Name', $Identity)
        $createParams.Remove('Identity') | Out-Null
        New-AntiPhishPolicy @PSBoundParameters
    }
    elseif (('Present' -eq $Ensure ) -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing AntiPhishPolicy {$Identity}"
        $UpdateParams = $PSBoundParameters
        $UpdateParams.Remove('Ensure') | Out-Null
        Set-AntiphishPolicy @UpdateParams
    }
    elseif (('Absent' -eq $Ensure ) -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AntiPhishPolicy $($Identity)"
        Remove-AntiPhishPolicy -Identity $Identity -Confirm:$false -Force
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
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('MoveToJmf', 'Quarantine')]
        [System.String]
        $AuthenticationFailAction = 'MoveToJmf',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [System.Boolean]
        $EnableFirstContactSafetyTips = $true,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence = $true,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligenceProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableOrganizationDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarDomainsSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSimilarUsersSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableSpoofIntelligence = $true,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableUnauthenticatedSender = $true,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips = $false,

        [Parameter()]
        [System.Boolean]
        $EnableViaTag = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExcludedDomains = @(),

        [Parameter()]
        [System.String[]]
        $ExcludedSenders = @(),

        [Parameter()]
        [System.Boolean]
        $HonorDmarcPolicy,

        [Parameter()]
        [ValidateSet('Automatic', 'Manual', 'Off')]
        [System.String]
        $ImpersonationProtectionState = 'Automatic',

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $MailboxIntelligenceProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $MailboxIntelligenceProtectionActionRecipients = @(),

        [Parameter()]
        [System.String]
        $MailboxIntelligenceQuarantineTag,

        [Parameter()]
        [System.String]
        $SpoofQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet(1, 2, 3, 4)]
        [System.Int32]
        $PhishThresholdLevel = 1,

        [Parameter()]
        [System.String[]]
        $TargetedDomainActionRecipients = @(),

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $TargetedDomainProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $TargetedDomainsToProtect = @(),

        [Parameter()]
        [System.String]
        $TargetedDomainQuarantineTag,

        [Parameter()]
        [System.String[]]
        $TargetedUserActionRecipients = @(),

        [Parameter()]
        [ValidateSet('BccMessage', 'Delete', 'MoveToJmf', 'NoAction', 'Quarantine', 'Redirect')]
        [System.String]
        $TargetedUserProtectionAction = 'NoAction',

        [Parameter()]
        [System.String[]]
        $TargetedUsersToProtect = @(),

        [Parameter()]
        [System.String]
        $TargetedUserQuarantineTag,

        [Parameter()]
        [System.String]
        [ValidateSet('MoveToJmf', 'Quarantine')]
        $DmarcQuarantineAction,

        [Parameter()]
        [System.String]
        [ValidateSet('Quarantine', 'Reject')]
        $DmarcRejectAction,

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

    Write-Verbose -Message "Testing configuration of AntiPhishPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null

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
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        [array]$AntiPhishPolicies = Get-AntiPhishPolicy -ErrorAction Stop
        $dscContent = ''
        $i = 1

        if ($AntiphishPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($Policy in $AntiPhishPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($AntiphishPolicies.Length)] $($Policy.Identity)" -NoNewline

            $Params = @{
                Identity              = $Policy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
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
