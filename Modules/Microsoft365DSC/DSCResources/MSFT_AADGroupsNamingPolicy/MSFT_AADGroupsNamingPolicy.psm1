function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AzureAD Groups Naming Policy"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = $null
    if (-not [String]::IsNullOrEmpty($ApplicationId) -and `
        -not [String]::IsNullOrEmpty($TenantId) -and `
        -not [String]::IsNullOrEmpty($CertificateThumbprint))
    {
        Write-Verbose -Message "Connecting to AzureAD using ApplicationId {$ApplicationId}"
        Test-MSCloudLogin -Platform AzureAD -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
        $ConnectionMode = "ServicePrincipal"
    }
    else
    {
        Write-Verbose -Message "Connecting to AzureAD using Credentials"
        Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
            -Platform AzureAD
        $ConnectionMode = "Credential"
    }

    $Policy = Get-AzureADDirectorySetting | Where-Object -FilterScript {$_.DisplayName -eq "Group.Unified"}

    if ($null -eq $Policy)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose "Found existing AzureAD Groups Naming Policy"
        $result = @{
            IsSingleInstance              = 'Yes'
            PrefixSuffixNamingRequirement = $Policy["PrefixSuffixNamingRequirement"]
            CustomBlockedWordsList        = $Policy["CustomBlockedWordsList"].Split(',')
            Ensure                        = "Present"
            GlobalAdminAccount            = $GlobalAdminAccount
            ApplicationId                 = $ApplicationId
            TenantId                      = $TenantId
            CertificateThumbprint         = $CertificateThumbprint
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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD Groups Naming Policy"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of AzureAD Groups Naming Policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters

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
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $content = ''
    $ConnectionMode = $null
    if (-not [String]::IsNullOrEmpty($ApplicationId) -and `
        -not [String]::IsNullOrEmpty($TenantId) -and `
        -not [String]::IsNullOrEmpty($CertificateThumbprint))
    {
        $params = @{
            ApplicationId          = $ApplicationId
            TenantId               = $TenantId
            CertificateThumbprint  = $CertificateThumbprint
            IsSingleInstance       = 'Yes'
        }
        $ConnectionMode = "ServicePrincipal"
    }
    else
    {
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            IsSingleInstance   = 'Yes'
        }
        $ConnectionMode = "Credential"
    }

    $result = Get-TargetResource @params

    if ($ConnectionMode -eq 'Credential')
    {
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $result.Remove("ApplicationId")
        $result.Remove("TenantId")
        $result.Remove("CertificateThumbprint")
    }
    else
    {
        $result.Remove("GlobalAdminAccount")
    }
    $content += "        AADGroupsNamingPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    if ($ConnectionMode -eq 'Credential')
    {
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    }
    else
    {
        $content += $currentDSCBlock
    }
    $content += "        }`r`n"

    return $content
}

Export-ModuleMember -Function *-TargetResource
