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
        [System.Boolean]
        $EnableGroupCreation,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToBeGroupOwner,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToAccessGroups,

        [Parameter()]
        [System.String]
        $GuestUsageGuidelinesUrl,

        [Parameter()]
        [System.String]
        $GroupCreationAllowedGroupName,

        [Parameter()]
        [System.Boolean]
        $AllowToAddGuests,

        [Parameter()]
        [System.String]
        $UsageGuidelinesUrl,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AzureAD Groups Naming Policy"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform AzureAD

    $Policy = Get-AzureADDirectorySetting | Where-Object -FilterScript {$_.DisplayName -eq "Group.Unified"}

    if ($null -eq $Policy)
    {
        $currentValues = $PSBoundParameters
        $currentValues.Ensure = "Absent"
        return $currentValues
    }
    else
    {
        Write-Verbose -Message "Found existing AzureAD Groups Settings"
        $AllowedGroupName = $null
        if (-not [System.String]::IsNullOrEmpty($Policy["GroupCreationAllowedGroupId"]))
        {
            $groupObject = Get-AzureADGroup -ObjectId $Policy["GroupCreationAllowedGroupId"]
            $AllowedGroupName = $groupObject.DisplayName
        }
        $result = @{
            IsSingleInstance               = 'Yes'
            EnableGroupCreation            = $Policy["EnableGroupCreation"]
            AllowGuestsToBeGroupOwner      = $Policy["AllowGuestsToBeGroupOwner"]
            AllowGuestsToAccessGroups      = $Policy["AllowGuestsToAccessGroups"]
            GuestUsageGuidelinesUrl        = $Policy["GuestUsageGuidelinesUrl"]
            GroupCreationAllowedGroupName  = $AllowedGroupName
            AllowToAddGuests               = $Policy["AllowToAddGuests"]
            UsageGuidelinesUrl             = $Policy["UsageGuidelinesUrl"]
            Ensure                         = "Present"
            GlobalAdminAccount             = $GlobalAdminAccount
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
        [System.Boolean]
        $EnableGroupCreation,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToBeGroupOwner,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToAccessGroups,

        [Parameter()]
        [System.String]
        $GuestUsageGuidelinesUrl,

        [Parameter()]
        [System.String]
        $GroupCreationAllowedGroupName,

        [Parameter()]
        [System.Boolean]
        $AllowToAddGuests,

        [Parameter()]
        [System.String]
        $UsageGuidelinesUrl,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of Azure AD Groups Settings"
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
        $groupObject = Get-AzureADGroup -SearchString $GroupCreationAllowedGroupName
        $groupId = $null
        if ($null -ne $groupObject)
        {
            $groupId = $groupObject.ObjectId
        }
        $Policy["EnableGroupCreation"]           = [System.Boolean]$EnableGroupCreation
        $Policy["AllowGuestsToBeGroupOwner"]     = [System.Boolean]$AllowGuestsToBeGroupOwner
        $Policy["AllowGuestsToAccessGroups"]     = [System.Boolean]$AllowGuestsToAccessGroups
        $Policy["GuestUsageGuidelinesUrl"]       = $GuestUsageGuidelinesUrl
        $Policy["GroupCreationAllowedGroupId"]   = $groupId
        $Policy["AllowToAddGuests"]              = [System.Boolean]$AllowToAddGuests
        $Policy["UsageGuidelinesUrl"]            = $UsageGuidelinesUrl

        Set-AzureADDirectorySetting -Id $Policy.id -DirectorySetting $Policy
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "An existing Directory Setting entry exists, and we don't allow to have it removed."
        throw "The AADGroupsSettings resource cannot delete existing Directory Setting entries. Please specify Present."
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
        [System.Boolean]
        $EnableGroupCreation,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToBeGroupOwner,

        [Parameter()]
        [System.Boolean]
        $AllowGuestsToAccessGroups,

        [Parameter()]
        [System.String]
        $GuestUsageGuidelinesUrl,

        [Parameter()]
        [System.String]
        $GroupCreationAllowedGroupName,

        [Parameter()]
        [System.Boolean]
        $AllowToAddGuests,

        [Parameter()]
        [System.String]
        $UsageGuidelinesUrl,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AzureAD Groups Settings"

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

    $content = ''
    $params = @{
        GlobalAdminAccount = $GlobalAdminAccount
        IsSingleInstance   = 'Yes'
    }
    $result = Get-TargetResource @params
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content += "        AADGroupsSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"

    return $content
}

Export-ModuleMember -Function *-TargetResource
