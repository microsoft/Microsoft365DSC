function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ItemInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $ItemInsightsDisabledForGroup,

        [Parameter()]
        [System.Boolean]
        $PersonInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $PersonInsightsDisabledForGroup,

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
        [Switch]
        $ManagedIdentity
    )

    if ($PSBoundParameters.ContainsKey('Ensure') -and $Ensure -eq 'Absent')
    {
        throw 'This resource is not able to remove Search and Intelligence configuration settings and therefore only accepts Ensure=Present.'
    }

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

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

    $nullReturn = @{
        IsSingleInstance = $IsSingleInstance
        Ensure           = 'Absent'
    }

    try
    {
        if ($ConnectionMode -eq 'Credentials')
        {
            $TenantId = $Credential.UserName.Split('@')[1]
        }

        $ItemInsights = Get-MgOrganizationSettingItemInsight -OrganizationId $TenantId
        $itemInsightsDisabledForGroupValue = $null
        if (-not [System.String]::IsNullOrEmpty($ItemInsights.DisabledForGroup))
        {
            $group = Get-MgGroup -GroupId ($ItemInsights.DisabledForGroup)
            $itemInsightsDisabledForGroupValue = $group.DisplayName
        }

        $PersonInsights = Get-MgOrganizationSettingPersonInsight -OrganizationId $TenantId
        $PersonInsightsDisabledForGroupValue = $null
        if (-not [System.String]::IsNullOrEmpty($PersonInsights.DisabledForGroup))
        {
            $group = Get-MgGroup -GroupId ($PersonInsights.DisabledForGroup)
            $PersonInsightsDisabledForGroupValue = $group.DisplayName
        }

        return @{
            IsSingleInstance                      = 'Yes'
            ItemInsightsIsEnabledInOrganization   = $ItemInsights.IsEnabledInOrganization
            ItemInsightsDisabledForGroup          = $itemInsightsDisabledForGroupValue
            PersonInsightsIsEnabledInOrganization = $PersonInsights.IsEnabledInOrganization
            PersonInsightsDisabledForGroup        = $PersonInsightsDisabledForGroupValue
            Ensure                                = 'Present'
            Credential                            = $Credential
            ApplicationId                         = $ApplicationId
            TenantId                              = $TenantId
            ApplicationSecret                     = $ApplicationSecret
            CertificateThumbprint                 = $CertificateThumbprint
            ManagedIdentity                       = $ManagedIdentity.IsPresent
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ItemInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $ItemInsightsDisabledForGroup,

        [Parameter()]
        [System.Boolean]
        $PersonInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $PersonInsightsDisabledForGroup,

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
        [Switch]
        $ManagedIdentity
    )

    if ($PSBoundParameters.ContainsKey('Ensure') -and $Ensure -eq 'Absent')
    {
        throw 'This resource is not able to remove the Search And Intelligence Configuration settings and therefore only accepts Ensure=Present.'
    }

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

    Write-Verbose -Message 'Setting configuration of Search and Intelligence'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

    if ($ConnectionMode -eq 'Credentials')
    {
        $TenantId = $Credential.UserName.Split('@')[1]
    }

    #region Item Insights
    $ItemInsightsUpdateParams = @{
        OrganizationId          = $TenantId
        IsEnabledInOrganization = $ItemInsightsIsEnabledInOrganization
    }
    if ($PSBoundParameters.ContainsKey("ItemInsightsDisabledForGroup"))
    {
        $disabledForGroupValue = $null
        try
        {
            $group = Get-MgGroup -Filter "DisplayName eq '$ItemInsightsDisabledForGroup'"
            $disabledForGroupValue = $group.Id
        }
        catch
        {
            Write-Verbose -Message $_
        }
        $ItemInsightsUpdateParams.Add("DisabledForGroup", $disabledForGroupValue)
    }
    Write-Verbose -Message "Updating settings for Item Insights"
    Update-MgOrganizationSettingItemInsight @ItemInsightsUpdateParams | Out-Null
    #endregion

    #region Person Insights
    $PersonInsightsUpdateParams = @{
        OrganizationId          = $TenantId
        IsEnabledInOrganization = $ItemInsightsIsEnabledInOrganization
    }
    if ($PSBoundParameters.ContainsKey("PersonInsightsDisabledForGroup"))
    {
        $disabledForGroupValue = $null
        try
        {
            $group = Get-MgGroup -Filter "DisplayName eq '$PersonInsightsDisabledForGroup'"
            $disabledForGroupValue = $group.Id
        }
        catch
        {
            Write-Verbose -Message $_
        }
        $PersonInsightsUpdateParams.Add("DisabledForGroup", $disabledForGroupValue)
    }

    Write-Verbose -Message "Updating settings for Person Insights"
    Update-MgOrganizationSettingPersonInsight @PersonInsightsUpdateParams | Out-Null
    #endregion
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $ItemInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $ItemInsightsDisabledForGroup,

        [Parameter()]
        [System.Boolean]
        $PersonInsightsIsEnabledInOrganization,

        [Parameter()]
        [System.String]
        $PersonInsightsDisabledForGroup,

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
        [Switch]
        $ManagedIdentity
    )
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

    Write-Verbose -Message 'Testing configuration for Search And Intelligence Configuration Settings.'

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'

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
        $Params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
        }

        $Results = Get-TargetResource @Params

        $dscContent = ''
        if ($Results.Ensure -eq 'Present')
        {
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
        }
        Write-Host $Global:M365DSCEmojiGreenCheckMark

        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
