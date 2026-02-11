Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SCSecurityFilter'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        # Resource properties
        [Parameter(Mandatory = $true)]
        [System.String]
        $FilterName,

        [Parameter()]
        [ValidateSet('Export', 'Preview', 'Purge', 'Search', 'All')]
        [System.String]
        $Action = 'All',

        [Parameter()]
        [System.String[]]
        $Users,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Filters,

        [Parameter()]
        [ValidateSet(
            'APC', # Asia-Pacific
            'AUS', #Australia
            'CAN', # Canada
            'EUR', #Europe, Middle East, Africa
            'FRA', #France
            'GBR', # United Kingdom
            'IND', # India
            'JPN', # Japan
            'LAM', # Latin America
            'NAM', # North America
            '' # NOT MANDATORY
        )]
        [System.String]
        $Region,

        # And the DSC ones
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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Security Filter for $FilterName"

    $null = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -EnableSearchOnlySession

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'
    try
    {
        try
        {
            $secFilter = Get-ComplianceSecurityFilter -FilterName $FilterName -ErrorAction SilentlyContinue -WarningAction Ignore -Confirm:$false
        }
        catch
        {
            throw $_
        }

        if ($null -eq $secFilter)
        {
            Write-Verbose -Message "Security Filter $($FilterName) does not exist."
            return $nullReturn
        }
        else
        {
            Write-Verbose "Found existing Security Filter $($FilterName)"
            $result = Get-M365DSCSCMapSecurityFilter -Filter $secFilter -Credential $Credential -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint -CertificatePath $CertificatePath -CertificatePassword $CertificatePassword

            return $result
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

function Get-M365DSCSCMapSecurityFilter
{
    param(
        [Parameter(Mandatory = $true)]
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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword
    )
    $result = @{
        FilterName            = $Filter.FilterName
        Action                = $Filter.Action
        Users                 = $Filter.Users
        Description           = $Filter.Description
        Filters               = $Filter.Filters
        Region                = $Filter.Region
        Credential            = $Credential
        ApplicationId         = $ApplicationId
        TenantId              = $TenantId
        CertificateThumbprint = $CertificateThumbprint
        CertificatePath       = $CertificatePath
        CertificatePassword   = $CertificatePassword
        Ensure                = 'Present'
    }
    return $result
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        # Resource properties
        [Parameter(Mandatory = $true)]
        [System.String]
        $FilterName,

        [Parameter()]
        [ValidateSet('Export', 'Preview', 'Purge', 'Search', 'All')]
        [System.String]
        $Action = 'All',

        [Parameter()]
        [System.String[]]
        $Users,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Filters,

        [Parameter()]
        [ValidateSet(
            'APC', # Asia-Pacific
            'AUS', #Australia
            'CAN', # Canada
            'EUR', #Europe, Middle East, Africa
            'FRA', #France
            'GBR', # United Kingdom
            'IND', # India
            'JPN', # Japan
            'LAM', # Latin America
            'NAM', # North America
            '' # NOT MANDATORY
        )]
        [System.String]
        $Region,

        # And the DSC ones
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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of Security Filter for $FilterName"

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

    $CurrentFilter = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentFilter.Ensure))
    {
        Write-Verbose "Creating new Security Filter '$FilterName'."

        $CreationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        try
        {
            New-ComplianceSecurityFilter @CreationParams -Confirm:$false
        }
        catch
        {
            Write-Warning "New-ComplianceSecurityFilter is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
    }
    elseif (('Present' -eq $Ensure) -and ('Present' -eq $CurrentFilter.Ensure))
    {
        Write-Verbose "Updating existing Security Filter '$FilterName'."

        $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        try
        {
            Set-ComplianceSecurityFilter @SetParams -Confirm:$false
        }
        catch
        {
            Write-Warning "Set-ComplianceSecurityFilter is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentFilter.Ensure))
    {
        # If the filter exists and it shouldn't, simply remove it;Need to force deletion
        Write-Verbose -Message "Deleting Security Filter $FilterName."

        try
        {
            Remove-ComplianceSecurityFilter -FilterName $FilterName -Confirm:$false
        }
        catch
        {
            Write-Warning "emove-ComplianceSecurityFilter is not available in tenant $($Credential.UserName.Split('@')[1]): $_"
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        # Resource properties
        [Parameter(Mandatory = $true)]
        [System.String]
        $FilterName,

        [Parameter()]
        [ValidateSet('Export', 'Preview', 'Purge', 'Search', 'All')]
        [System.String]
        $Action = 'All',

        [Parameter()]
        [System.String[]]
        $Users,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Filters,

        [Parameter()]
        [ValidateSet(
            'APC', # Asia-Pacific
            'AUS', #Australia
            'CAN', # Canada
            'EUR', #Europe, Middle East, Africa
            'FRA', #France
            'GBR', # United Kingdom
            'IND', # India
            'JPN', # Japan
            'LAM', # Latin America
            'NAM', # North America
            '' # NOT MANDATORY
        )]
        [System.String]
        $Region,

        # And the DSC ones
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
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -EnableSearchOnlySession

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
        [array]$filters = Get-ComplianceSecurityFilter -ErrorAction Stop -WarningAction Ignore -Confirm:$false

        $dscContent = ''
        $i = 1
        if ($filters.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($filter in $filters)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($filters.Count)] $($filter.FilterName)" -DeferWrite

            # $GetParams = ([Hashtable]$PSBoundParameters).Clone()
            # $GetParams.Add("FilterName", $filter.FilterName)
            # $Results = Get-TargetResource @GetParams
            $Results = Get-M365DSCSCMapSecurityFilter -Filter $filter -Credential $Credential -ApplicationId $ApplicationId `
                -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint -CertificatePath $CertificatePath -CertificatePassword $CertificatePassword

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
        }
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
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
