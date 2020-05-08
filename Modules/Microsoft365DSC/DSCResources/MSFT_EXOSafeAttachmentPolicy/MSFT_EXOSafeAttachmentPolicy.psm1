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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

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
            Ensure             = 'Present'
            Identity           = $Identity
            Action             = $SafeAttachmentPolicy.Action
            ActionOnError      = $SafeAttachmentPolicy.ActionOnError
            AdminDisplayName   = $SafeAttachmentPolicy.AdminDisplayName
            Enable             = $SafeAttachmentPolicy.Enable
            Redirect           = $SafeAttachmentPolicy.Redirect
            RedirectAddress    = $SafeAttachmentPolicy.RedirectAddress
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found SafeAttachmentPolicy $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

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
            Write-Verbose -Message "Setting SafeAttachmentPolicy $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $SafeAttachmentPolicyParams)"
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

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline `
        -ErrorAction SilentlyContinue

    $content = ''
    if (Confirm-ImportedCmdletIsAvailable -CmdletName 'Get-SafeAttachmentPolicy')
    {
        $SafeAttachmentPolicies = Get-SafeAttachmentPolicy
        $i = 1
        foreach ($SafeAttachmentPolicy in $SafeAttachmentPolicies)
        {
            Write-Information "    [$i/$($SafeAttachmentPolicies.Length)] $($SafeAttachmentPolicy.Identity)"
            $params = @{
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = $SafeAttachmentPolicy.Identity
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        EXOSafeAttachmentPolicy " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
            $content += "        }`r`n"
            $i++
        }
    }
    else
    {
        Write-Information "The current tenant doesn't have access to Safe Attachment Policy APIs."
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
