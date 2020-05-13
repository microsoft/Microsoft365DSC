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
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of CASMailboxPlan for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $CASMailboxPlans = Get-CASMailboxPlan

    if ($Identity.Contains('-'))
    {
        $CASMailboxPlan = $CASMailboxPlans | Where-Object -FilterScript { $_.Identity -eq $Identity }
    }
    else
    {
        $CASMailboxPlan = $CASMailboxPlans | Where-Object -FilterScript { $_.Identity -like ($Identity + '-*') }
    }

    if ($null -eq $CASMailboxPlan)
    {
        Write-Verbose -Message "CASMailboxPlan $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure             = 'Present'
            Identity           = $Identity
            ActiveSyncEnabled  = $CASMailboxPlan.ActiveSyncEnabled
            ImapEnabled        = $CASMailboxPlan.ImapEnabled
            OwaMailboxPolicy   = $CASMailboxPlan.OwaMailboxPolicy
            PopEnabled         = $CASMailboxPlan.PopEnabled
            GlobalAdminAccount = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found CASMailboxPlan $($Identity)"
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
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of CASMailboxPlan for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $CASMailboxPlanParams = $PSBoundParameters
    $CASMailboxPlanParams.Remove('Ensure') | Out-Null
    $CASMailboxPlanParams.Remove('GlobalAdminAccount') | Out-Null

    $CASMailboxPlans = Get-CASMailboxPlan
    $CASMailboxPlan = $CASMailboxPlans | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if ($null -ne $CASMailboxPlan)
    {
        Write-Verbose -Message "Setting CASMailboxPlan $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $CASMailboxPlanParams)"
        Set-CASMailboxPlan @CASMailboxPlanParams
    }
    else
    {
        throw "The specified CAS Mailbox Plan {$($Identity)} doesn't exist"
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
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of CASMailboxPlan for $Identity"

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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $InformationPreference = 'Continue'
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline
    [array]$CASMailboxPlans = Get-CASMailboxPlan

    $content = ""
    $i = 1
    foreach ($CASMailboxPlan in $CASMailboxPlans)
    {
        Write-Information -MessageData "    [$i/$($CASMailboxPlans.Count)] $($CASMailboxPlan.Identity.Split('-')[0])"
        $params = @{
            Identity           = $CASMailboxPlan.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @params
        $result.Identity = $result.Identity.Split('-')[0]
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOCASMailboxPlan " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
