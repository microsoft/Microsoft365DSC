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
        $Description,

        [Parameter()]
        [System.String]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AzureAD Group"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    $Group = Get-AzureADMSGroup -Filter "DisplayName eq '$DisplayName'"

    if ($null -eq $Group)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose -Message "Found existing AzureAD Group"
        $result = @{
            DisplayName                   = $Group.DisplayName
            Description                   = $Group.Description
            GroupTypes                    = $Group.$GroupTypes
            MembershipRule                = $Group.MembershipRule
            MembershipRuleProcessingState = $Group.MembershipRuleProcessingState
            SecurityEnabled               = $Group.SecurityEnabled
            MailEnabled                   = $Group.MailEnabled
            MailNickname                  = $Group.MailNickname
            Visibility                    = $Group.Visibility
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Azure AD Groups"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    $currentGroup = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove("GlobalAdminAccount")
    $currentParameters.Remove("Ensure")

    if ($Ensure -eq 'Present' -and $currentGroup.Ensure -eq 'Present')
    {
        $Group = Get-AzureADMSGroup -Filter "DisplayName eq '$DisplayName'"
        Set-AzureADMSGroup @currentParameters -id $Group.ID
    }
    elseif ($Ensure -eq 'Present' -and $currentGroup.Ensure -eq 'Absent')
    {
        New-AzureADMSGroup @currentParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentGroup.Ensure -eq 'Present')
    {
        $Group = Get-AzureADMSGroup -Filter "DisplayName eq '$DisplayName'"
        Remove-AzureADMSGroup -Id $Group.ID
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GroupTypes,

        [Parameter()]
        [System.String]
        $MembershipRule,

        [Parameter()]
        [ValidateSet('On', 'Paused')]
        [System.String]
        $MembershipRuleProcessingState,

        [Parameter()]
        [System.Boolean]
        $SecurityEnabled,

        [Parameter()]
        [System.Boolean]
        $MailEnabled,

        [Parameter()]
        [System.String]
        $MailNickname,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AzureAD Groups"

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

    $groups = Get-AzureADMSGroup
    $i = 1
    $content = ''
    foreach ($group in $groups)
    {
        $params = @{
            GlobalAdminAccount = $GlobalAdminAccount
            DisplayName        = $group.DisplayName
        }
        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        AADMSGroup " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $partialContent += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $partialContent += "        }`r`n"
        $content += $partialContent
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
