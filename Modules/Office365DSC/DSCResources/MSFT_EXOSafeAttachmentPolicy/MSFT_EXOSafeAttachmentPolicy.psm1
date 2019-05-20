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
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SafeAttachmentPolicy for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $SafeAttachmentPolicies = Get-SafeAttachmentPolicy

    $SafeAttachmentPolicy = $SafeAttachmentPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if (-not $SafeAttachmentPolicy)
    {
        Write-Verbose -Message "SafeAttachmentPolicy $($Identity) does not exist."
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
            if ($null -ne $SafeAttachmentPolicy.$KeyName)
            {
                $result += @{
                    $KeyName = $SafeAttachmentPolicy.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose -Message "Found SafeAttachmentPolicy $($Identity)"
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
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SafeAttachmentPolicy for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $SafeAttachmentPolicyParams = $PSBoundParameters
    $SafeAttachmentPolicyParams.Remove('Ensure') | Out-Null
    $SafeAttachmentPolicyParams.Remove('GlobalAdminAccount') | Out-Null
    $SafeAttachmentPolicies = Get-SafeAttachmentPolicy

    $SafeAttachmentPolicy = $SafeAttachmentPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if ('Present' -eq $Ensure )
    {
        if (-not $SafeAttachmentPolicy)
        {
            Write-Verbose -Message "Creating SafeAttachmentPolicy $($Identity)."
            $SafeAttachmentPolicyParams += @{
                Name = $SafeAttachmentPolicyParams.Identity
            }

            $SafeAttachmentPolicyParams.Remove('Identity') | Out-Null
            New-SafeAttachmentPolicy @SafeAttachmentPolicyParams
        }
        else
        {
            Write-Verbose -Message "Setting SafeAttachmentPolicy $Identity with values: $(Convert-O365DscHashtableToString -Hashtable $SafeAttachmentPolicyParams)"
            Set-SafeAttachmentPolicy @SafeAttachmentPolicyParams
        }
    }
    elseif (('Absent' -eq $Ensure) -and ($SafeAttachmentPolicy))
    {
        Write-Verbose -Message "Removing SafeAttachmentPolicy $($Identity) "
        Remove-SafeAttachmentPolicy -Identity $Identity -Confirm:$false -Force
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
        [ValidateSet('Block', 'Replace', 'Allow', 'DynamicDelivery')]
        [System.String]
        $Action = 'Block',

        [Parameter()]
        [Boolean]
        $ActionOnError = $false,

        [Parameter()]
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [Boolean]
        $Enable = $false,

        [Parameter()]
        [Boolean]
        $Redirect = $false,

        [Parameter()]
        [System.String]
        $RedirectAddress,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SafeAttachmentPolicy for $Identity"

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
    $content = "        EXOSafeAttachmentPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
