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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $Policy = Get-AzureADDirectorySetting | Where-Object -FilterScript {$_.DisplayName -eq "Group.Unified"}

        if ($null -eq $Policy)
        {
            return $nullReturn
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
                EnableGroupCreation            = [Boolean]::Parse($Policy["EnableGroupCreation"])
                AllowGuestsToBeGroupOwner      = [Boolean]::Parse($Policy["AllowGuestsToBeGroupOwner"])
                AllowGuestsToAccessGroups      = [Boolean]::Parse($Policy["AllowGuestsToAccessGroups"])
                GuestUsageGuidelinesUrl        = $Policy["GuestUsageGuidelinesUrl"]
                GroupCreationAllowedGroupName  = $AllowedGroupName
                AllowToAddGuests               = [Boolean]::Parse($Policy["AllowToAddGuests"])
                UsageGuidelinesUrl             = $Policy["UsageGuidelinesUrl"]
                Ensure                         = "Present"
                GlobalAdminAccount             = $GlobalAdminAccount
                ApplicationId                  = $ApplicationId
                TenantId                       = $TenantId
                CertificateThumbprint          = $CertificateThumbprint
            }

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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

    Write-Verbose -Message "Setting configuration of Azure AD Groups Settings"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
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

    Write-Verbose -Message "Testing configuration of AzureAD Groups Settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' -InboundParameters $PSBoundParameters
        $Params = @{
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                IsSingleInstance      = 'Yes'
                GlobalAdminAccount    = $GlobalAdminAccount
        }
        $dscContent = ''
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -GlobalAdminAccount $GlobalAdminAccount
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
