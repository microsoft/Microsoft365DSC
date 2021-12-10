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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Getting configuration of AzureAD Groups Settings"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    Select-MgProfile -Name 'beta'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $Policy = Get-MgDirectorySetting | Where-Object -FilterScript { $_.DisplayName -eq "Group.Unified" }

        if ($null -eq $Policy)
        {
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message "Found existing AzureAD Groups Settings"
            $AllowedGroupName = $null
            $GroupCreationValue = $Policy.Values | Where-Object -FilterScript {$_.Name -eq 'GroupCreationAllowedGroupId'}
            if (-not [System.String]::IsNullOrEmpty($GroupCreationValue.Value))
            {
                $groupObject = Get-MgGroup -GroupId $GroupCreationValue.Value
                $AllowedGroupName = $groupObject.DisplayName
            }

            $valueEnableGroupCreation = $Policy.Values | Where-Object -FilterScript {$_.Name -eq "EnableGroupCreation"}
            $valueAllowGuestsToBeGroupOwner = $Policy.Values | Where-Object -FilterScript {$_.Name -eq "AllowGuestsToBeGroupOwner"}
            $valueAllowGuestsToAccessGroups = $Policy.Values | Where-Object -FilterScript {$_.Name -eq "AllowGuestsToAccessGroups"}
            $valueGuestUsageGuidelinesUrl = $Policy.Values | Where-Object -FilterScript {$_.Name -eq "GuestUsageGuidelinesUrl"}
            $valueAllowToAddGuests = $Policy.Values | Where-Object -FilterScript {$_.Name -eq "AllowToAddGuests"}
            $valueUsageGuidelinesUrl = $Policy.Values | Where-Object -FilterScript {$_.Name -eq "UsageGuidelinesUrl"}

            $result = @{
                IsSingleInstance              = 'Yes'
                EnableGroupCreation           = [Boolean]::Parse($valueEnableGroupCreation.Value)
                AllowGuestsToBeGroupOwner     = [Boolean]::Parse($valueAllowGuestsToBeGroupOwner.Value)
                AllowGuestsToAccessGroups     = [Boolean]::Parse($valueAllowGuestsToAccessGroups.Value)
                GuestUsageGuidelinesUrl       = $valueGuestUsageGuidelinesUrl.Value
                GroupCreationAllowedGroupName = $AllowedGroupName
                AllowToAddGuests              = [Boolean]::Parse($valueAllowToAddGuests.Value)
                UsageGuidelinesUrl            = $valueUsageGuidelinesUrl.Value
                Ensure                        = "Present"
                ApplicationId                 = $ApplicationId
                TenantId                      = $TenantId
                ApplicationSecret             = $ApplicationSecret
                CertificateThumbprint         = $CertificateThumbprint
                Credential                    = $Credential
            }

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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Setting configuration of Azure AD Groups Settings"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentPolicy = Get-TargetResource @PSBoundParameters

    # Policy should exist but it doesn't
    $needToUpdate = $false
    if ($Ensure -eq "Present" -and $currentPolicy.Ensure -eq "Absent")
    {
        $Policy = New-MgDirectorySetting -TemplateId '62375ab9-6b52-47ed-826b-58e47e0e304b' | Out-Null
        $needToUpdate = $true
    }

    $Policy = Get-MgDirectorySetting | Where-Object -FilterScript { $_.DisplayName -eq "Group.Unified" }

    if (($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present') -or $needToUpdate)
    {
        $groupObject = $null
        if (-not [System.String]::IsNullOrEmpty($GroupCreationAllowedGroupName))
        {
            $groupObject = Get-MgGroup -Filter "DisplayName eq '$GroupCreationAllowedGroupName'"
        }
        $groupId = $null
        if ($null -ne $groupObject)
        {
            $groupId = $groupObject.ObjectId
        }
        $index = 0
        foreach ($property in $Policy.Values)
        {
            if ($property.Name -eq 'EnableGroupCreation')
            {
                $Policy.Values[$index].Value = [System.Boolean]$EnableGroupCreation
            }
            elseif ($property.Name -eq 'AllowGuestsToBeGroupOwner')
            {
                $Policy.Values[$index].Value = [System.Boolean]$AllowGuestsToBeGroupOwner
            }
            elseif ($property.Name -eq 'AllowGuestsToAccessGroups')
            {
                $Policy.Values[$index].Value = [System.Boolean]$AllowGuestsToAccessGroups
            }
            elseif ($property.Name -eq 'GuestUsageGuidelinesUrl')
            {
                $Policy.Values[$index].Value = $GuestUsageGuidelinesUrl
            }
            elseif ($property.Name -eq 'GroupCreationAllowedGroupId')
            {
                $Policy.Values[$index].Value = $groupId
            }
            elseif ($property.Name -eq 'AllowToAddGuests')
            {
                $Policy.Values[$index].Value = [System.Boolean]$AllowToAddGuests
            }
            elseif ($property.Name -eq 'UsageGuidelinesUrl')
            {
                $Policy.Values[$index].Value = $UsageGuidelinesUrl
            }
            $index++;
        }

        Update-MgDirectorySetting -DirectorySettingId $Policy.id -Values $Policy.Values | Out-Null
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
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )


    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AzureAD Groups Settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'
    $MaximumFunctionCount = 32000
    Select-MgProfile -Name 'beta'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

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
        $Params = @{
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            IsSingleInstance      = 'Yes'
            ApplicationSecret     = $ApplicationSecret
            Credential            = $Credential
        }
        $dscContent = ''
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
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
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
