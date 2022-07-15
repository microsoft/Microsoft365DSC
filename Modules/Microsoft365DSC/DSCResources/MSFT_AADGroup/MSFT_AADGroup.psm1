function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $GroupTypes = @("Unified"),

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
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssignedLicenses,

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

    Write-Verbose -Message "Getting configuration of AzureAD Group"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

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
        if ($PSBoundParameters.ContainsKey("Id"))
        {
            Write-Verbose -Message "GroupID was specified"
            try
            {
                $Group = Get-MgGroup -GroupId $Id -ErrorAction Stop
            }
            catch
            {
                Write-Verbose -Message "Couldn't get group by ID, trying by name"
                $Group = Get-MgGroup -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
                if ($Group.Length -gt 1)
                {
                    throw "Duplicate AzureAD Groups named $DisplayName exist in tenant"
                }
            }
        }
        else
        {
            Write-Verbose -Message "Id was NOT specified"
            ## Can retreive multiple AAD Groups since displayname is not unique
            $Group = Get-MgGroup -Filter "DisplayName eq '$DisplayName'" -ErrorAction Stop
            if ($Group.Length -gt 1)
            {
                throw "Duplicate AzureAD Groups named $DisplayName exist in tenant"
            }
        }

        if ($null -eq $Group)
        {
            Write-Verbose -Message "Group was null, returning null"
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message "Found existing AzureAD Group"

            $assignedLicensesRequest = Invoke-MgGraphRequest -Method 'GET' `
                -Uri "https://graph.microsoft.com/v1.0/groups/$($Group.Id)/assignedLicenses"

            if ($assignedLicensesRequest.value.Length -gt 0)
            {
                $assignedLicensesValues = Get-M365DSCAzureADGroupLicenses -AssignedLicenses $assignedLicensesRequest.value
            }

            $result = @{
                DisplayName                   = $Group.DisplayName
                Id                            = $Group.Id
                Description                   = $Group.Description
                GroupTypes                    = [System.String[]]$Group.GroupTypes
                MembershipRule                = $Group.MembershipRule
                MembershipRuleProcessingState = $Group.MembershipRuleProcessingState
                SecurityEnabled               = $Group.SecurityEnabled
                MailEnabled                   = $Group.MailEnabled
                IsAssignableToRole            = $Group.IsAssignableToRole
                MailNickname                  = $Group.MailNickname
                Visibility                    = $Group.Visibility
                AssignedLicenses              = $assignedLicensesValues
                Ensure                        = "Present"
                ApplicationId                 = $ApplicationId
                TenantId                      = $TenantId
                CertificateThumbprint         = $CertificateThumbprint
                ApplicationSecret             = $ApplicationSecret
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
        $DisplayName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
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
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssignedLicenses,

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

    Write-Verbose -Message "Setting configuration of Azure AD Groups"

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

    $currentParameters = $PSBoundParameters
    $currentGroup = Get-TargetResource @PSBoundParameters
    $currentParameters.Remove("ApplicationId") | Out-Null
    $currentParameters.Remove("TenantId") | Out-Null
    $currentParameters.Remove("CertificateThumbprint") | Out-Null
    $currentParameters.Remove("ApplicationSecret") | Out-Null
    $currentParameters.Remove("Ensure") | Out-Null
    $currentParameters.Remove("Credential") | Out-Null

    if ($Ensure -eq 'Present' -and `
        ($null -ne $GroupTypes -and $GroupTypes.Contains("Unified")) -and `
        ($null -ne $MailEnabled -and $MailEnabled -eq $false))
    {
        Write-Verbose -Message "Cannot set mailenabled to false if GroupTypes is set to Unified when creating group."
        throw "Cannot set mailenabled to false if GroupTypes is set to Unified when creating a group."
    }
    if (-not $GroupTypes -and $currentParameters.GroupTypes -eq $null)
    {
        $currentParameters.Add("GroupTypes", @("Unified"))
    }

    $currentValuesToCheck = @()
    if ($currentGroup.AssignedLicenses.Length -gt 0)
    {
        $currentValuesToCheck = $currentGroup.AssignedLicenses.SkuId
    }
    $desiredValuesToCheck = @()
    if ($AssignedLicenses.Length -gt 0)
    {
        $desiredValuesToCheck = $AssignedLicenses.SkuId
    }

    [Array]$licensesDiff = Compare-Object -ReferenceObject $currentValuesToCheck -DifferenceObject $desiredValuesToCheck -IncludeEqual
    $toAdd = @()
    $toRemove = @()
    foreach ($diff in $licensesDiff)
    {
        if ($diff.SideIndicator -eq '=>')
        {
            $toAdd += $diff.InputObject
        }
        elseif ($diff.SideIndicator -eq '<=')
        {
            $toRemove += $diff.InputObject
        }
        elseif ($diff.SideIndicator -eq '==')
        {
            # This will take care of the scenario where the license is already assigned but has different disabled plans
            $toAdd += $diff.InputObject
        }
    }

    # Convert AssignedLicenses from SkuPartNumber back to GUID
    $licensesToAdd = @()
    $licensesToRemove = @()
    [Array]$AllLicenses = Get-M365DSCCombinedLicenses -DesiredLicenses $AssignedLicenses -CurrentLicenses $currentGroup.AssignedLicenses

    $allSkus = Get-MgSubscribedSku
    # Create complete list of all Service Plans
    $allServicePlans = @()
    Write-Verbose -Message "Getting all Service Plans"
    foreach ($sku in $allSkus)
    {
        foreach ($serviceplan in $sku.ServicePlans)
        {
            if ($allServicePlans.Length -eq 0 -or -not $allServicePlans.ServicePlanName.Contains($servicePlan.ServicePlanName))
            {
                $allServicePlans += @{
                    ServicePlanId   = $serviceplan.ServicePlanId
                    ServicePlanName = $serviceplan.ServicePlanName
                }
            }
        }
    }

    foreach ($assignedLicense in $AllLicenses)
    {
        $skuInfo = $allSkus | Where-Object -FilterScript {$_.SkuPartNumber -eq $assignedLicense.SkuId}
        if ($skuInfo)
        {
            if ($toAdd.Contains($assignedLicense.SkuId))
            {
                $disabledPlansValues = @()
                foreach ($plan in $assignedLicense.DisabledPlans)
                {
                    $foundItem = $allServicePlans | Where-Object -FilterScript {$_.ServicePlanName -eq $plan}
                    $disabledPlansValues += $foundItem.ServicePlanId
                }

                $skuInfo = $allSkus | Where-Object -FilterScript {$_.SkuPartNumber -eq $assignedLicense.SkuId}
                $licensesToAdd += @{
                    DisabledPlans = $disabledPlansValues
                    SkuId         = $skuInfo.SkuId
                }
            }
            elseif ($toRemove.Contains($assignedLicense.SkuId))
            {
                $licensesToRemove += $skuInfo.SkuId
            }
        }
    }

    $currentParameters.Remove('AssignedLicenses') | Out-Null

    if ($Ensure -eq 'Present' -and $currentGroup.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Group {$DisplayName} exists and it should."
        try
        {
            Write-Verbose -Message "Updating settings by ID for group {$DisplayName}"
            if ($true -eq $currentParameters.ContainsKey("IsAssignableToRole"))
            {
                Write-Verbose -Message "Cannot set IsAssignableToRole once group is created."
                $currentParameters.Remove("IsAssignableToRole") | Out-Null
            }
            if ($false -eq $currentParameters.ContainsKey("Id"))
            {
                Update-MgGroup @currentParameters -GroupId $currentGroup.Id | Out-Null
            }
            else
            {
                $currentParameters.Remove("Id") | Out-Null
                $currentParameters.Add("GroupId", $currentGroup.Id)
                Write-Verbose -Message "Updating Group with Values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"
                Update-MgGroup @currentParameters | Out-Null
            }

            if ($licensesToAdd.Length -gt 0 -or $licensesToRemove.Length -gt 0)
            {
                try
                {
                    Set-MgGroupLicense -GroupId $currentGroup.Id `
                        -AddLicenses $licensesToAdd `
                        -RemoveLicenses $licensesToRemove `
                        -ErrorAction Stop | Out-Null
                }
                catch
                {
                    Write-Verbose -Message $_
                }
            }
        }
        catch
        {
            Write-Error -Message $_
            New-M365DSCLogEntry -Error $_ -Message "Couldn't set group $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentGroup.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new group {$DisplayName}"
        $currentParameters.Remove("Id") | Out-Null

        try
        {
            Write-Verbose -Message "Creating Group with Values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"
            $group = New-MgGroup @currentParameters

            Write-Verbose -Message "Created Group $($group.id)"
            if ($assignedLicensesGUIDs.Length -gt 0)
            {
                Set-MgGroupLicense -GroupId $group.Id -AddLicenses $licensesToAdd -RemoveLicenses @()
            }
        }
        catch
        {
            Write-Verbose -Message $_
            New-M365DSCLogEntry -Error $_ -Message "Couldn't create group $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentGroup.Ensure -eq 'Present')
    {
        try
        {
            Remove-MgGroup -GroupId $currentGroup.ID | Out-Null
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't delete group $DisplayName" -Source $MyInvocation.MyCommand.ModuleName
        }
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $MailNickname,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
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
        [System.Boolean]
        $IsAssignableToRole,

        [Parameter()]
        [ValidateSet('Public', 'Private', 'HiddenMembership')]
        [System.String]
        $Visibility,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AssignedLicenses,

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

    Write-Verbose -Message "Testing configuration of AzureAD Groups"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    # Check Licenses
    if ($PSBoundParameters.ContainsKey("AssignedLicenses"))
    {
        try
        {
            $licensesDiff = Compare-Object -ReferenceObject ($CurrentValues.AssignedLicenses.SkuId) -DifferenceObject ($AssignedLicenses.SkuId)
            if ($null -ne $licensesDiff)
            {
                Write-Verbose -Message "AssignedLicenses differ: $($licensesDiff | Out-String)"
                Write-Verbose -Message "Test-TargetResource returned $false"
                $EventMessage = "Assigned Licenses for Azure AD Group {$DisplayName} were not in the desired state.`r`n" + `
                    "They should contain {$($AssignedLicenses.SkuId)} but instead contained {$($CurrentValues.AssignedLicenses.SkuId)}"
                Add-M365DSCEvent -Message $EventMessage -EntryType 'Warning' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
                return $false
            }
            else
            {
                Write-Verbose -Message "AssignedLicenses for Azure AD Group are the same"
            }
        }
        catch
        {
            Write-Verbose -Message "Test-TargetResource returned $false"
            return $false
        }

        #Check DisabledPlans
        try
        {
            $licensesDiff = Compare-Object -ReferenceObject ($CurrentValues.AssignedLicenses.DisabledPlans) -DifferenceObject ($AssignedLicenses.DisabledPlans)
            if ($null -ne $licensesDiff)
            {
                Write-Verbose -Message "DisabledPlans differ: $($licensesDiff | Out-String)"
                Write-Verbose -Message "Test-TargetResource returned $false"
                $EventMessage = "Disabled Plans for Azure AD Group Licenses {$DisplayName} were not in the desired state.`r`n" + `
                    "They should contain {$($AssignedLicenses.DisabledPlans)} but instead contained {$($CurrentValues.AssignedLicenses.DisabledPlans)}"
                Add-M365DSCEvent -Message $EventMessage -EntryType 'Warning' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
                return $false
            }
            else
            {
                Write-Verbose -Message "DisabledPlans for Azure AD Group Licensing are the same"
            }
        }
        catch
        {
            Write-Verbose -Message "Test-TargetResource returned $false"
            return $false
        }
    }

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck.Remove('GroupTypes') | Out-Null
    $ValuesToCheck.Remove('AssignedLicenses') | Out-Null

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
        -InboundParameters $PSBoundParameters

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
        [array] $groups = Get-MgGroup -All -ErrorAction Stop
        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($group in $groups)
        {
            Write-Host "    |---[$i/$($groups.Count)] $($group.DisplayName)" -NoNewline
            $Params = @{
                ApplicationSecret     = $ApplicationSecret
                DisplayName           = $group.DisplayName
                MailNickName          = $group.MailNickName
                Id                    = $group.Id
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Credential            = $Credential
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($results.AssignedLicenses.Length -gt 0)
            {
                $Results.AssignedLicenses = Get-M365DSCAzureADGroupLicensesAsString $Results.AssignedLicenses
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($null -ne $Results.AssignedLicenses)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                    -ParameterName "AssignedLicenses"
            }
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
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

function Get-M365DSCAzureADGroupLicenses
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory = $true)]
        $AssignedLicenses
    )

    $returnValue = @()
    $allSkus = Get-MgSubscribedSku

    # Create complete list of all Service Plans
    $allServicePlans = @()
    Write-Verbose -Message "Getting all Service Plans"
    foreach ($sku in $allSkus)
    {
        foreach ($serviceplan in $sku.ServicePlans)
        {
            if ($allServicePlans.Length -eq 0 -or -not $allServicePlans.ServicePlanName.Contains($servicePlan.ServicePlanName))
            {
                Write-Verbose -Message "$($servicePlan.ServicePlanId) :: $($serviceplan.ServicePlanName)"
                $allServicePlans += @{
                    ServicePlanId   = $serviceplan.ServicePlanId
                    ServicePlanName = $serviceplan.ServicePlanName
                }
            }
        }
    }

    foreach ($assignedLicense in $AssignedLicenses)
    {
        $skuPartNumber = $allSkus | Where-Object -FilterScript {$_.SkuId -eq $assignedLicense.SkuId}
        $disabledPlansValues = @()
        foreach ($plan in $assignedLicense.DisabledPlans)
        {
            $foundItem = $allServicePlans | Where-Object -FilterScript {$_.ServicePlanId -eq $plan}
            $disabledPlansValues += $foundItem.ServicePlanName
        }
        $currentLicense = @{
            DisabledPlans = $disabledPlansValues
            SkuId         = $skuPartNumber.SkuPartNumber
        }
        $returnValue += $currentLicense
    }

    return $returnValue
}

function Get-M365DSCAzureADGroupLicensesAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $AssignedLicenses
    )

    $StringContent = [System.Text.StringBuilder]::new()
    $StringContent.Append("@(") | Out-Null
    foreach ($assignedLicense in $AssignedLicenses)
    {
        $StringContent.Append("MSFT_AADGroupLicense { `r`n") | Out-Null
        if ($assignedLicense.DisabledPlans.Length -gt 0)
        {
            $StringContent.Append("                DisabledPlans = @('" + ($assignedLicense.DisabledPlans -join "','") + "')`r`n") | Out-Null
        }
        else
        {
            $StringContent.Append("                DisabledPlans = @()`r`n") | Out-Null
        }
        $StringContent.Append("                SkuId         = '" + $assignedLicense.SkuId + "'`r`n") | Out-Null
        $StringContent.Append("            }`r`n") | Out-Null
    }
    $StringContent.Append("            )") | Out-Null
    return $StringContent.ToString()
}

function Get-M365DSCCombinedLicenses
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter()]
        [System.Object[]]
        $CurrentLicenses,

        [Parameter()]
        [System.Object[]]
        $DesiredLicenses
    )
    $result = @()
    if ($currentLicenses.Length -gt 0)
    {
        foreach ($license in $CurrentLicenses)
        {
            Write-Verbose -Message "Including Current $license"
            $result += @{
                SkuId         = $license.SkuId
                DisabledPlans = $license.DisabledPlans
            }
        }
    }

    if ($DesiredLicenses.Length -gt 0)
    {
        foreach ($license in $DesiredLicenses)
        {
            if (-not $result.SkuId.Contains($license.SkuId))
            {
                $result += @{
                    SkuId         = $license.SkuId
                    DisabledPlans = $license.DisabledPlans
                }
            }
            else
            {
                #Set the Desired Disabled Plans if the sku is already added to the list
                foreach ($item in $result)
                {
                    if ($item.SkuId -eq $license.SkuId)
                    {
                        $item.DisabledPlans = $license.DisabledPlans
                    }
                }
            }
        }
    }

    return $result
}
Export-ModuleMember -Function *-TargetResource
