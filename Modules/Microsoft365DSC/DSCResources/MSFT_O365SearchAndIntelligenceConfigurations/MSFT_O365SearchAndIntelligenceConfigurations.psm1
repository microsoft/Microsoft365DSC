Confirm-M365DSCModuleDependency -ModuleName 'MSFT_O365SearchAndIntelligenceConfigurations'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ItemInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $ItemInsightsDisabledForGroup,

        [Parameter()]
        [System.Boolean]
        $MeetingInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.Boolean]
        $PersonInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $PersonInsightsDisabledForGroup,

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

    Write-Verbose -Message 'Getting the O365 Search and Intelligence Configurations'

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters

        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        if ($ConnectionMode -eq 'Credentials')
        {
            $TenantId = $Credential.UserName.Split('@')[1]
        }

        $ItemInsights = Get-MgBetaOrganizationSettingItemInsight -OrganizationId $TenantId
        $itemInsightsDisabledForGroupValue = $null
        if (-not [System.String]::IsNullOrEmpty($ItemInsights.DisabledForGroup))
        {
            $group = Invoke-M365DSCCommand -ScriptBlock { Get-MgGroup -GroupId ($ItemInsights.DisabledForGroup) }
            $itemInsightsDisabledForGroupValue = $group.DisplayName
        }

        try
        {
            $PersonInsights = Get-MgBetaOrganizationSettingPersonInsight -OrganizationId $TenantId `
                -ErrorAction Stop
            $PersonInsightsDisabledForGroupValue = $null
            if (-not [System.String]::IsNullOrEmpty($PersonInsights.DisabledForGroup))
            {
                $group = Invoke-M365DSCCommand -ScriptBlock { Get-MgGroup -GroupId ($PersonInsights.DisabledForGroup) }
                $PersonInsightsDisabledForGroupValue = $group.DisplayName
            }
        }
        catch
        {
            if ($_.Exception.Message -eq "[BadRequest] : Resource not found for the segment 'peopleInsights'.")
            {
                Write-Warning -Message 'The peopleInsights segment is not available in the selected environment.'
            }
            else
            {
                throw
            }
        }

        $MeetingInsightsResponse = Invoke-M365DSCCommand -ScriptBlock { Get-MeetingInsightsSettings }
        $MeetingInsightsValue = [Boolean]::Parse($MeetingInsightsResponse.Split(':')[1].Trim())

        return @{
            IsSingleInstance                       = 'Yes'
            ItemInsightsIsEnabledInOrganization    = $ItemInsights.IsEnabledInOrganization
            ItemInsightsDisabledForGroup           = $itemInsightsDisabledForGroupValue
            MeetingInsightsIsEnabledInOrganization = $MeetingInsightsValue
            PersonInsightsIsEnabledInOrganization  = $PersonInsights.IsEnabledInOrganization
            PersonInsightsDisabledForGroup         = $PersonInsightsDisabledForGroupValue
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            CertificateThumbprint                  = $CertificateThumbprint
            CertificatePath                        = $CertificatePath
            CertificatePassword                    = $CertificatePassword
            ManagedIdentity                        = $ManagedIdentity.IsPresent
            AccessTokens                           = $AccessTokens
        }
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
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ItemInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $ItemInsightsDisabledForGroup,

        [Parameter()]
        [System.Boolean]
        $MeetingInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.Boolean]
        $PersonInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $PersonInsightsDisabledForGroup,

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

    Write-Verbose -Message 'Setting the O365 Search and Intelligence Configurations'

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    if ($ConnectionMode -eq 'Credentials')
    {
        $TenantId = $Credential.UserName.Split('@')[1]
    }

    #region Item Insights
    $ItemInsightsUpdateParams = @{
        IsEnabledInOrganization = $ItemInsightsIsEnabledInOrganization
    }
    if ($PSBoundParameters.ContainsKey('ItemInsightsDisabledForGroup'))
    {
        $disabledForGroupValue = $null
        try
        {
            $group = Get-MgGroup -Filter "DisplayName eq '$($ItemInsightsDisabledForGroup -replace "'", "''")'"
            $disabledForGroupValue = $group.Id
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error retrieving data getting group' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }
        $ItemInsightsUpdateParams.Add('DisabledForGroup', $disabledForGroupValue)
    }
    Write-Verbose -Message 'Updating settings for Item Insights'
    Update-MgBetaOrganizationSettingItemInsight -OrganizationId $TenantId -BodyParameter $ItemInsightsUpdateParams | Out-Null
    #endregion

    #region Person Insights
    $PersonInsightsUpdateParams = @{
        IsEnabledInOrganization = $PersonInsightsIsEnabledInOrganization
    }
    if ($PSBoundParameters.ContainsKey('PersonInsightsDisabledForGroup'))
    {
        $disabledForGroupValue = $null
        try
        {
            $group = Get-MgGroup -Filter "DisplayName eq '$($PersonInsightsDisabledForGroup -replace "'", "''")'"
            $disabledForGroupValue = $group.Id
        }
        catch
        {
            New-M365DSCLogEntry -Message 'Error retrieving data getting group' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }
        $PersonInsightsUpdateParams.Add('DisabledForGroup', $disabledForGroupValue)
    }

    Write-Verbose -Message 'Updating settings for Person Insights'
    Update-MgBetaOrganizationSettingPersonInsight -OrganizationId $TenantId -BodyParameter $PersonInsightsUpdateParams | Out-Null
    #endregion

    if ($null -ne $MeetingInsightsIsEnabledInOrganization)
    {
        Set-MeetingInsightsSettings -Enabled $MeetingInsightsIsEnabledInOrganization | Out-Null
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ItemInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $ItemInsightsDisabledForGroup,

        [Parameter()]
        [System.Boolean]
        $MeetingInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.Boolean]
        $PersonInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $PersonInsightsDisabledForGroup,

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
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
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        $Results = Get-TargetResource @Params
        $dscContent = [System.Text.StringBuilder]::new()
        if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
        {
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
        }
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite

        return $dscContent.ToString()
    }
    catch
    {
        $TenantId = $Credential.UserName.Split('@')[1]
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
