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
        $EnableAntispoofEnforcement = $true,

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
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('1', '2', '3', '4')]
        [System.String]
        $PhishThresholdLevel = '1',

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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
                $PhishThresholdLevelValue = '1'
            }

            $TargetedUserProtectionActionValue = $AntiPhishPolicy.TargetedUserProtectionAction
            if ([System.String]::IsNullOrEmpty($TargetedUserProtectionActionValue))
            {
                $TargetedUserProtectionActionValue = 'NoAction'
            }

            $result = @{
                Identity                                      = $Identity
                AdminDisplayName                              = $AntiPhishPolicy.AdminDisplayName
                AuthenticationFailAction                      = $AntiPhishPolicy.AuthenticationFailAction
                Enabled                                       = $AntiPhishPolicy.Enabled
                EnableFirstContactSafetyTips                  = $AntiPhishPolicy.EnableFirstContactSafetyTips
                EnableAntispoofEnforcement                    = $AntiPhishPolicy.EnableAntispoofEnforcement
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
                ImpersonationProtectionState                  = $AntiPhishPolicy.ImpersonationProtectionState
                MailboxIntelligenceProtectionAction           = $AntiPhishPolicy.MailboxIntelligenceProtectionAction
                MailboxIntelligenceProtectionActionRecipients = $AntiPhishPolicy.MailboxIntelligenceProtectionActionRecipients
                MakeDefault                                   = $AntiPhishPolicy.MakeDefault
                PhishThresholdLevel                           = $PhishThresholdLevelValue
                TargetedDomainActionRecipients                = $AntiPhishPolicy.TargetedDomainActionRecipients
                TargetedDomainProtectionAction                = $AntiPhishPolicy.TargetedDomainProtectionAction
                TargetedDomainsToProtect                      = $AntiPhishPolicy.TargetedDomainsToProtect
                TargetedUserActionRecipients                  = $AntiPhishPolicy.TargetedUserActionRecipients
                TargetedUserProtectionAction                  = $TargetedUserProtectionActionValue
                TargetedUsersToProtect                        = $AntiPhishPolicy.TargetedUsersToProtect
                Credential                                    = $Credential
                Ensure                                        = 'Present'
                ApplicationId                                 = $ApplicationId
                CertificateThumbprint                         = $CertificateThumbprint
                CertificatePath                               = $CertificatePath
                CertificatePassword                           = $CertificatePassword
                TenantId                                      = $TenantId
            }

            Write-Verbose -Message "Found AntiPhishPolicy $($Identity)"
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
        $EnableAntispoofEnforcement = $true,

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
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('1', '2', '3', '4')]
        [System.String]
        $PhishThresholdLevel = '1',

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

    Write-Verbose -Message "Setting configuration of AntiPhishPolicy for $Identity"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $AntiPhishPolicies = Get-AntiPhishPolicy

    $AntiPhishPolicy = $AntiPhishPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if (('Present' -eq $Ensure ) -and (-not $AntiPhishPolicy))
    {
        New-EXOAntiPhishPolicy -AntiPhishPolicyParams $PSBoundParameters
    }

    if (('Present' -eq $Ensure ) -and ($AntiPhishPolicy))
    {
        # The Set-AntiphishPolicy cmdlet doesn't account for more than 80% of the parameters
        # defined by the New-AntiphishPolicy one. Therefore we need to delete the existing
        # policy and recreate it in order to make sure the parameters all match the desired
        # state specified;
        Remove-AntiPhishPolicy -Identity $Identity -Confirm:$false -Force
        New-EXOAntiPhishPolicy -AntiPhishPolicyParams $PSBoundParameters
    }

    if (('Absent' -eq $Ensure ) -and ($AntiPhishPolicy))
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
        $EnableAntispoofEnforcement = $true,

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
        [System.Boolean]
        $MakeDefault = $false,

        [Parameter()]
        [ValidateSet('1', '2', '3', '4')]
        [System.String]
        $PhishThresholdLevel = '1',

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        [array]$AntiPhishPolicies = Get-AntiPhishPolicy -ErrorAction Stop
        $dscContent = ""
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
            Write-Host "    |---[$i/$($AntiphishPolicies.Length)] $($Policy.Identity)" -NoNewline

            $Params = @{
                Identity              = $Policy.Identity
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
            $i++
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
