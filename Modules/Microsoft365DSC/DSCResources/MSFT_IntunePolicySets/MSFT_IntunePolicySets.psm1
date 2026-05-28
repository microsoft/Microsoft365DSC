Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntunePolicySets'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $GuidedDeploymentTags,

        [Parameter()]
        [System.String[]]
        $RoleScopeTags,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Items,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Policy Sets with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        if (-not [string]::IsNullOrEmpty($Id))
        {
            $getValue = Get-MgBetaDeviceAppManagementPolicySet -PolicySetId $Id -ExpandProperty * -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Policy Sets with Id {$Id}"

            if (-not [string]::IsNullOrEmpty($DisplayName))
            {
                [array]$getValue = Get-MgBetaDeviceAppManagementPolicySet `
                    -All `
                    -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'"

                if ($null -eq $getValue)
                {
                    Write-Verbose -Message "Could not find an Intune Policy Sets with DisplayName {$DisplayName}"
                    return $nullResult
                }
                else
                {
                    if ($getValue.Count -gt 1)
                    {
                        Write-Verbose -Message "Multiple Intune Policy Sets with DisplayName {$DisplayName} - unable to continue"
                        return $nullResult
                    }
                    else
                    {
                        $getValue = Get-MgBetaDeviceAppManagementPolicySet -PolicySetId $getValue.Id -ExpandProperty * -ErrorAction SilentlyContinue
                    }
                }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Policy Sets with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Policy Sets with Id {$Id} and DisplayName {$DisplayName} was found."

        $results = @{
            #region resource generator code
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            GuidedDeploymentTags  = $getValue.GuidedDeploymentTags
            RoleScopeTags         = $getValue.RoleScopeTags
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            #endregion
        }

        if ($null -eq $getValue.GuidedDeploymentTags)
        {
            $results.GuidedDeploymentTags = @()
        }

        $assignmentsValues = $getValue.Assignments
        $assignmentResult = @()
        if ($assignmentsValues.Count -gt 0)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment `
                -IncludeDeviceFilter:$true `
                -Assignments ($assignmentsValues)
        }
        $results.Add('Assignments', $assignmentResult)

        $itemsValues = $getValue.Items

        $itemResult = @()
        $Script:itemResultCache = @()
        foreach ($itemEntry in $itemsValues)
        {
            $itemValue = @{
                dataType             = $itemEntry.'@odata.type'
                payloadId            = $itemEntry.PayloadId
                itemType             = $itemEntry.ItemType
                displayName          = $itemEntry.displayName
                guidedDeploymentTags = $itemEntry.GuidedDeploymentTags
            }
            $itemResult += $itemValue

            $itemValue = $itemValue.Clone()
            $itemValue.Add('id', $itemEntry.Id)
            $Script:itemResultCache += $itemValue
        }

        $results.Add('Items', $itemResult)

        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $GuidedDeploymentTags,

        [Parameter()]
        [System.String[]]
        $RoleScopeTags,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Items,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Policy Sets with DisplayName {$DisplayName}"
        # remove complex values
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('Items') | Out-Null
        # remove unused values
        $BoundParameters.Remove('Id') | Out-Null

        $CreateParameters = ([Hashtable]$BoundParameters).Clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters

        # set assignments and items to work with New-MgBetaDeviceAppManagementPolicySet command
        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        $CreateParameters.Add('assignments', $assignmentsHash)

        $itemsHash = @()
        foreach ($item in $items)
        {
            $itemsHash += @{
                payloadId            = Get-PayloadIdFromItem -Item $item
                '@odata.type'        = $item.dataType
                guidedDeploymentTags = $item.guidedDeploymentTags
            }
        }
        $CreateParameters.Add('items', $itemsHash)
        $policy = New-MgBetaDeviceAppManagementPolicySet -BodyParameter $CreateParameters

        if ($policy.id)
        {
            $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
            $url = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceAppManagement/policySets/$($policy.Id)/update"
            Invoke-MgGraphRequest -Method POST -Uri ($url) -Body @{
                assignments = $assignmentsHash
            }
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Policy Sets with Id {$($currentInstance.Id)}"
        # remove complex values
        $BoundParameters.Remove('Assignments') | Out-Null
        $BoundParameters.Remove('Items') | Out-Null
        # remove unused values
        $BoundParameters.Remove('Id') | Out-Null

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        #region resource generator code
        Update-MgBetaDeviceAppManagementPolicySet -PolicySetId $currentInstance.Id -BodyParameter $UpdateParameters

        $Url = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/deviceAppManagement/policySets/$($currentInstance.Id)/update"
        if ($null -ne ($itemamendments = Get-ItemsAmendmentsObject -currentObjectItems $Script:itemResultCache -targetObjectItems $items))
        {
            Write-Verbose $($itemamendments | ConvertTo-Json -Depth 10) -Verbose
            Invoke-MgGraphRequest -Method POST -Uri $url -Body $itemamendments
        }

        $assignmentsHash = ConvertTo-IntunePolicyAssignment -IncludeDeviceFilter:$true -Assignments $Assignments
        Invoke-MgGraphRequest -Method POST -Uri $url -Body @{
            assignments = $assignmentsHash
        }
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Policy Sets with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceAppManagementPolicySet -PolicySetId $currentInstance.Id
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $GuidedDeploymentTags,

        [Parameter()]
        [System.String[]]
        $RoleScopeTags,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
        #endregion

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Items,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceAppManagementPolicySet -Filter $Filter -All -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if ($complexTypeStringResult)
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }
            if ($Results.Items)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Items -CIMInstanceName DeviceManagementConfigurationPolicyItems
                if ($complexTypeStringResult)
                {
                    $Results.Items = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Items') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments', 'Items')

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        if ($_.Exception -like '*401*' -or $_.ErrorDetails.Message -like "*`"ErrorCode`":`"Forbidden`"*" -or
            $_.Exception -like '* Unauthorized*' -or `
                $_.Exception -like '*Request not applicable to target tenant*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

function Get-ItemsAmendmentsObject
{
    [CmdletBinding()]
    param
    (
        $currentObjectItems,
        $targetObjectItems
    )

    $nullreturn = $true
    $ItemsModificationTemplate = @{
        deletedPolicySetItems = @()
        updatedPolicySetItems = @()
        addedPolicySetItems   = @()
    }

    $nullreturn = $true
    $currentObjectItems | ForEach-Object {
        if (-not ($targetObjectItems.DisplayName -contains $_.DisplayName))
        {
            Write-Verbose -Message ($_.DisplayName + ' NOT present in Config Document, Removing')
            $ItemsModificationTemplate.deletedPolicySetItems += $_.id
            $nullreturn = $false
        }
    }

    $targetObjectItems | ForEach-Object {
        if (-not ($currentObjectItems.DisplayName -contains $_.DisplayName))
        {
            Write-Verbose -Message ($_.DisplayName + ' NOT already present in Policy Set, Adding')
            $ItemsModificationTemplate.addedPolicySetItems += @{
                payloadId            = Get-PayloadIdFromItem -Item $_
                '@odata.type'        = $_.dataType
                guidedDeploymentTags = $_.guidedDeploymentTags
            }
            $nullreturn = $false
        }
    }

    if (-not $nullreturn)
    {
        return $ItemsModificationTemplate
    }

    return $null
}

function Get-PayloadIdFromItem
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Item
    )

    switch ($Item.dataType)
    {
        '#microsoft.graph.windowsAutopilotDeploymentProfilePolicySetItem'
        {
            $object = Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -WindowsAutopilotDeploymentProfileId $Item.payloadId -ErrorAction SilentlyContinue
            if ($null -eq $object)
            {
                if ($null -eq $Item.displayName)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and no displayName to fallback on"
                }
                $object = Get-MgBetaDeviceManagementWindowsAutopilotDeploymentProfile -Filter "displayName eq '$($Item.displayName)'" -All -ErrorAction SilentlyContinue
                if ($null -eq $object)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and displayName $($Item.displayName)"
                }
            }
        }
        '#microsoft.graph.deviceCompliancePolicyPolicySetItem'
        {
            $object = Get-MgBetaDeviceManagementDeviceCompliancePolicy -DeviceCompliancePolicyId $Item.payloadId -ErrorAction SilentlyContinue
            if ($null -eq $object)
            {
                if ($null -eq $Item.displayName)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and no displayName to fallback on"
                }
                $object = Get-MgBetaDeviceManagementDeviceCompliancePolicy -Filter "displayName eq '$($Item.displayName)'" -All -ErrorAction SilentlyContinue
                if ($null -eq $object)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and displayName $($Item.displayName)"
                }
            }
        }
        '#microsoft.graph.deviceConfigurationPolicySetItem'
        {
            $object = Get-MgBetaDeviceManagementDeviceConfiguration -DeviceConfigurationId $Item.payloadId -ErrorAction SilentlyContinue
            if ($null -eq $object)
            {
                if ($null -eq $Item.displayName)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and no displayName to fallback on"
                }
                $object = Get-MgBetaDeviceManagementDeviceConfiguration -Filter "displayName eq '$($Item.displayName)'" -All -ErrorAction SilentlyContinue
                if ($null -eq $object)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and displayName $($Item.displayName)"
                }
            }
        }
        '#microsoft.graph.mobileAppPolicySetItem'
        {
            $object = Get-MgBetaDeviceAppManagementMobileApp -MobileAppId $Item.payloadId -ErrorAction SilentlyContinue
            if ($null -eq $object)
            {
                if ($null -eq $Item.displayName)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and no displayName to fallback on"
                }
                $object = Get-MgBetaDeviceAppManagementMobileApp -Filter "displayName eq '$($Item.displayName)'" -All -ErrorAction SilentlyContinue
                if ($null -eq $object)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and displayName $($Item.displayName)"
                }
            }
        }
        '#microsoft.graph.targetedManagedAppConfigurationPolicySetItem'
        {
            $object = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -TargetedManagedAppConfigurationId $Item.payloadId -ErrorAction SilentlyContinue
            if ($null -eq $object)
            {
                if ($null -eq $Item.displayName)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and no displayName to fallback on"
                }
                $object = Get-MgBetaDeviceAppManagementTargetedManagedAppConfiguration -Filter "displayName eq '$($Item.displayName)'" -All -ErrorAction SilentlyContinue
                if ($null -eq $object)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and displayName $($Item.displayName)"
                }
            }
        }
        '#microsoft.graph.managedAppProtectionPolicySetItem'
        {
            $object = Get-MgBetaDeviceAppManagementManagedAppPolicy -ManagedAppPolicyId $Item.payloadId -ErrorAction SilentlyContinue
            if ($null -eq $object)
            {
                if ($null -eq $Item.displayName)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and no displayName to fallback on"
                }
                $object = Get-MgBetaDeviceAppManagementManagedAppPolicy -Filter "displayName eq '$($Item.displayName)'" -All -ErrorAction SilentlyContinue
                if ($null -eq $object)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and displayName $($Item.displayName)"
                }
            }
        }
        '#microsoft.graph.windows10EnrollmentCompletionPageConfigurationPolicySetItem'
        {
            $object = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $Item.payloadId -ErrorAction SilentlyContinue
            if ($null -eq $object)
            {
                if ($null -eq $Item.displayName)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and no displayName to fallback on"
                }
                $object = Get-MgBetaDeviceManagementDeviceEnrollmentConfiguration -Filter "displayName eq '$($Item.displayName)'" -All -ErrorAction SilentlyContinue
                if ($null -eq $object)
                {
                    throw "Unable to find the item with payloadId $($Item.payloadId) and displayName $($Item.displayName)"
                }
            }
        }
    }

    return $object.Id
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('PayloadId')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
