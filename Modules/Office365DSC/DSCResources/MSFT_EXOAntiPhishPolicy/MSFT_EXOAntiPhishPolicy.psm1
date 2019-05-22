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
        $EnableAuthenticationSafetyTip = $true,

        [Parameter()]
        [System.Boolean]
        $EnableAuthenticationSoftPassSafetyTip = $false,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence = $true,

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
        $EnableTargetedDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips = $false,

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
        [System.Boolean]
        $TreatSoftPassAsAuthenticated = $true,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AntiPhishPolicy for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $AntiPhishPolicies = Get-AntiPhishPolicy

    $AntiPhishPolicy = $AntiPhishPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if ($null -eq $AntiPhishPolicy)
    {
        Write-Verbose -Message "AntiPhishPolicy $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object -FilterScript { $_ -ne 'Ensure' }))
        {
            if ($null -ne $AntiPhishPolicy.$KeyName)
            {
                $result += @{
                    $KeyName = $AntiPhishPolicy.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose -Message "Found AntiPhishPolicy $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
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
        $EnableAuthenticationSafetyTip = $true,

        [Parameter()]
        [System.Boolean]
        $EnableAuthenticationSoftPassSafetyTip = $false,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence = $true,

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
        $EnableTargetedDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips = $false,

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
        [System.Boolean]
        $TreatSoftPassAsAuthenticated = $true,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of AntiPhishPolicy for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $AntiPhishPolicies = Get-AntiPhishPolicy

    $AntiPhishPolicy = $AntiPhishPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if (('Present' -eq $Ensure ) -and (-not $AntiPhishPolicy))
    {
        New-EXOAntiPhishPolicy -AntiPhishPolicyParams $PSBoundParameters
        Start-Sleep -Seconds 1
        Set-EXOAntiPhishPolicy -AntiPhishPolicyParams $PSBoundParameters
    }

    if (('Present' -eq $Ensure ) -and ($AntiPhishPolicy))
    {
        Set-EXOAntiPhishPolicy -AntiPhishPolicyParams $PSBoundParameters
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
        $EnableAuthenticationSafetyTip = $true,

        [Parameter()]
        [System.Boolean]
        $EnableAuthenticationSoftPassSafetyTip = $false,

        [Parameter()]
        [System.Boolean]
        $EnableMailboxIntelligence = $true,

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
        $EnableTargetedDomainsProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableTargetedUserProtection = $false,

        [Parameter()]
        [System.Boolean]
        $EnableUnusualCharactersSafetyTips = $false,

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
        [System.Boolean]
        $TreatSoftPassAsAuthenticated = $true,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AntiPhishPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXOAntiPhishPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
