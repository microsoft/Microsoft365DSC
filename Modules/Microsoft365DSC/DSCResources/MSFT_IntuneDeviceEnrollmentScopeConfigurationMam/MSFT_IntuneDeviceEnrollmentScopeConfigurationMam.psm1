function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('none','all','selected','unknownFutureValue')]
        [System.String]
        $AppliesTo,

        [Parameter()]
        [System.String]
        $ComplianceUrl,

        [Parameter()]
        [System.String]
        $DiscoveryUrl,

        [Parameter()]
        [System.String[]]
        $IncludedGroups,

        [Parameter()]
        [System.String]
        $TermsOfUseUrl,
        #endregion

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration for the Intune Device Enrollment Scope Configuration Mam'

    try
    {
        if (-not $Script:exportedInstance)
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

            $getValue = Get-MgBetaPolicyMobileAppManagementPolicy -ExpandProperty IncludedGroups -ErrorAction Stop
        }
        else
        {
            $getValue = $Script:exportedInstance
        }

        Write-Verbose -Message 'An Intune Device Enrollment Scope Configuration Mam was found'

        #region resource generator code
        $enumAppliesTo = $null
        if ($null -ne $getValue.AppliesTo)
        {
            $enumAppliesTo = $getValue.AppliesTo.ToString()
        }
        #endregion

        $includedGroupsValue = $null
        if ($enumAppliesTo -eq 'Selected')
        {
            $includedGroupsValue = @()
            foreach ($group in $getValue.IncludedGroups)
            {
                $includedGroupsValue += $group.DisplayName
            }
        }

        $results = @{
            #region resource generator code
            AppliesTo             = $enumAppliesTo
            ComplianceUrl         = $getValue.ComplianceUrl
            DiscoveryUrl          = $getValue.DiscoveryUrl
            IncludedGroups        = $includedGroupsValue
            TermsOfUseUrl         = $getValue.TermsOfUseUrl
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            TenantId              = $TenantId
            #endregion
        }

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
        [ValidateSet('none','all','selected','unknownFutureValue')]
        [System.String]
        $AppliesTo,

        [Parameter()]
        [System.String]
        $ComplianceUrl,

        [Parameter()]
        [System.String]
        $DiscoveryUrl,

        [Parameter()]
        [System.String[]]
        $IncludedGroups,

        [Parameter()]
        [System.String]
        $TermsOfUseUrl,
        #endregion

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Intune Device Enrollment Scope Configuration Mam"

    if ($AppliesTo -eq 'Selected' -and $IncludedGroups.Count -eq 0)
    {
        throw "IncludedGroups cannot be empty when AppliesTo is set to 'Selected'. Please provide at least one group or change the AppliesTo value."
    }

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
    $updateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
    $updateParameters.Remove('IncludedGroups') | Out-Null
    $updateParameters.Remove('IsSingleInstance') | Out-Null

    $urlProps = $updateParameters.Clone()
    $urlProps.Remove('AppliesTo') | Out-Null
    foreach ($prop in ($updateParameters.Keys | Where-Object { $urlProps.ContainsKey($_) }))
    {
        if ([System.String]::IsNullOrEmpty($urlProps[$prop]))
        {
            $urlProps[$prop] = $null
        }
    }

    $nonUrlProps = $updateParameters.Clone()
    foreach ($key in $urlProps.Keys)
    {
        $nonUrlProps.Remove($key) | Out-Null
    }

    if ($nonUrlProps.ContainsKey('AppliesTo') -and $nonUrlProps['AppliesTo'] -eq 'Selected')
    {
        $nonUrlProps.Remove('AppliesTo') | Out-Null
    }

    #region resource generator code
    Invoke-MgGraphRequest -Uri '/beta/policies/mobileAppManagementPolicies/0000000a-0000-0000-c000-000000000000' `
        -Body $urlProps `
        -Method PATCH `
        -ErrorAction Stop

    if ($nonUrlProps.Keys.Count -gt 0)
    {
        Invoke-MgGraphRequest -Uri '/beta/policies/mobileAppManagementPolicies/0000000a-0000-0000-c000-000000000000' `
            -Body $nonUrlProps `
            -Method PATCH `
            -ErrorAction Stop
    }

    if ($PSBoundParameters.ContainsKey('IncludedGroups') -and $AppliesTo -eq 'Selected')
    {
        $diffs = Compare-Object -ReferenceObject $IncludedGroups -DifferenceObject @($currentInstance.IncludedGroups | Where-Object { $null -ne $_ })
        if ($diffs.Count -eq 0)
        {
            Write-Verbose -Message 'Included groups are already in the desired state.'
            return
        }

        Write-Verbose -Message "Updating the IncludedGroups of the Intune Device Enrollment Scope Configuration Mam"
        foreach ($diff in $diffs)
        {
            $group = Get-MgGroup -Filter "displayName eq '$($diff.InputObject)'" -Property id
            if ($null -eq $group)
            {
                throw "Failed to find group '$($diff.InputObject)' in the tenant. Please make sure it exists."
            }
            $request = @{}
            if ($diff.SideIndicator -eq "=>")
            {
                $request.Add('Method', 'DELETE')
                $request.Add('Uri', "/beta/policies/mobileAppManagementPolicies/0000000a-0000-0000-c000-000000000000/includedGroups/$($group.Id)/`$ref")
            }
            elseif ($diff.SideIndicator -eq "<=")
            {
                $request.Add('Method', 'POST')
                $request.Add('Body', @{ "@odata.id" = "$((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl)odata/groups('$($group.Id)')" })
                $request.Add('Uri', "/beta/policies/mobileAppManagementPolicies/0000000a-0000-0000-c000-000000000000/includedGroups/`$ref")
            }
            Invoke-MgGraphRequest @request -ErrorAction Stop
        }
    }
    #endregion
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [ValidateSet('none','all','selected','unknownFutureValue')]
        [System.String]
        $AppliesTo,

        [Parameter()]
        [System.String]
        $ComplianceUrl,

        [Parameter()]
        [System.String]
        $DiscoveryUrl,

        [Parameter()]
        [System.String[]]
        $IncludedGroups,

        [Parameter()]
        [System.String]
        $TermsOfUseUrl,
        #endregion

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $TenantId,

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
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $TenantId,

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
        [array]$getValue = Get-MgBetaPolicyMobileAppManagementPolicy -ExpandProperty IncludedGroups -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = ''
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
            $displayedKey = $config.Id
            if (-not [System.String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [System.String]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                IsSingleInstance      = 'Yes'
                Credential            = $Credential
                TenantId              = $TenantId
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            if ($DesiredValues.AppliesTo -ne 'Selected')
            {
                $ValuesToCheck.Remove('IncludedGroups')
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function *-TargetResource
