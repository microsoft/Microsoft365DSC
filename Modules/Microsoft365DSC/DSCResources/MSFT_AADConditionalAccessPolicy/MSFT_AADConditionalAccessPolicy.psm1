function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        [ValidateSet('Enabled')]
        $State,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $Conditions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $GrantControls,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AzureAD Conditional Policy {$DisplayName}"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Obtaining the Access Token for the Microsoft Graph"
    $MSGraphAccessToken = Get-MSCloudLoginAADToken -GlobalAdminAccount $GlobalAdminAccount

    $RequestURL = "https://graph.microsoft.com/beta/conditionalAccess/policies?filter=displayName eq '$DisplayName'"
    $Policy = Get-M365DSCDataFromGraph -AccessToken $MSGraphAccessToken -Uri $RequestUrl

    if ($null -eq $Policy)
    {
        Write-Verbose -Message "Could not find policy {$DisplayName}"
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose "Found existing policy {$DisplayName}"
        $result = @{
            DisplayName                   = $DisplayName
            State                         = $policy.state
            Ensure                        = "Present"
            GlobalAdminAccount            = $GlobalAdminAccount
        }

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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $PrefixSuffixNamingRequirement,

        [Parameter()]
        [System.String[]]
        $CustomBlockedWordsList,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Azure AD Groups Naming Policy"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    $currentPolicy = Get-TargetResource @PSBoundParameters

    # Policy should exist but it doesn't
    $needToUpdate = $false
    if ($Ensure -eq "Present" -and $currentPolicy.Ensure -eq "Absent")
    {
        $ds = (Get-AzureADDirectorySettingTemplate -id 62375ab9-6b52-47ed-826b-58e47e0e304b).CreateDirectorySetting()
        New-AzureADDirectorySetting -DirectorySetting $ds
        $needToUpdate = $true
    }

    $Policy = Get-AzureADDirectorySetting | Where-Object -FilterScript {$_.DisplayName -eq "Group.Unified"}

    if (($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present') -or $needToUpdate)
    {
        $Policy["PrefixSuffixNamingRequirement"] = $PrefixSuffixNamingRequirement

        [string]$blockedWordsValue = $null

        $blockedWordsValue = $CustomBlockedWordsList -join ","
        $Policy["CustomBlockedWordsList"] = $blockedWordsValue

        Set-AzureADDirectorySetting -Id $Policy.id -DirectorySetting $Policy
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        $Policy = Get-AzureADDirectorySetting | Where-Object -FilterScript {$_.DisplayName -eq "Group.Unified"}
        Remove-AzureADDirectorySetting -Id $policy.Id
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $PrefixSuffixNamingRequirement,

        [Parameter()]
        [System.String[]]
        $CustomBlockedWordsList,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AzureAD Groups Naming Policy"

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


    Write-Verbose -Message "Obtaining the Access Token for the Microsoft Graph"
    $MSGraphAccessToken = Get-MSCloudLoginAADToken -GlobalAdminAccount $GlobalAdminAccount

    $RequestURL = "https://graph.microsoft.com/beta/conditionalAccess/policies"
    [array]$Policies = Get-M365DSCDataFromGraph -AccessToken $MSGraphAccessToken -Uri $RequestUrl

    $content = ''
    $i = 1
    foreach ($policy in $Policies)
    {
        Write-Information "    [$i/$($Policies.Length)] $($policy.displayName)"
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            DisplayName        = $policy.displayName
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        AADConditionalAccessPolicy " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }

    return $content
}

Export-ModuleMember -Function *-TargetResource
