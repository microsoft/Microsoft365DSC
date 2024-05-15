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

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
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
            $result = Get-M365DSCSCMapSecurityFilter $secFilter $Credential $ApplicationId $TenantId $CertificateThumbprint $CertificatePath $CertificatePassword

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
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

        return $nullReturn
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
        FilterName                  = $Filter.FilterName
        Action                      = $Filter.Action
        Users                       = $Filter.Users
        Description                 = $Filter.Description
        Filters                     = $Filter.Filters
        Region                      = $Filter.Region
        Credential                  = $Credential
        ApplicationId               = $ApplicationId
        TenantId                    = $TenantId
        CertificateThumbprint       = $CertificateThumbprint
        CertificatePath             = $CertificatePath
        CertificatePassword         = $CertificatePassword
        Ensure                      = 'Present'
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

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $CurrentFilter = Get-TargetResource @PSBoundParameters

    if (('Present' -eq $Ensure) -and ('Absent' -eq $CurrentFilter.Ensure))
    {
        Write-Verbose "Creating new Security Filter '$FilterName'."

        $CreationParams = ([Hashtable]$PSBoundParameters).Clone()

        #Remove parameters not used in New-ComplianceSecurityFilter
        $CreationParams.Remove('Ensure') | Out-Null

        # Remove authentication parameters
        $CreationParams.Remove('Credential') | Out-Null
        $CreationParams.Remove('ApplicationId') | Out-Null
        $CreationParams.Remove('TenantId') | Out-Null
        $CreationParams.Remove('CertificatePath') | Out-Null
        $CreationParams.Remove('CertificatePassword') | Out-Null
        $CreationParams.Remove('CertificateThumbprint') | Out-Null
        $CreationParams.Remove('ManagedIdentity') | Out-Null
        $CreationParams.Remove('ApplicationSecret') | Out-Null
        $CreationParams.Remove('AccessTokens') | Out-Null

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

        $SetParams = ([Hashtable]$PSBoundParameters).Clone()

        #Remove unused parameters for Set-Label cmdlet
        $SetParams.Remove('Ensure') | Out-Null

        # Remove authentication parameters
        $SetParams.Remove('Credential') | Out-Null
        $SetParams.Remove('ApplicationId') | Out-Null
        $SetParams.Remove('TenantId') | Out-Null
        $SetParams.Remove('CertificatePath') | Out-Null
        $SetParams.Remove('CertificatePassword') | Out-Null
        $SetParams.Remove('CertificateThumbprint') | Out-Null
        $SetParams.Remove('ManagedIdentity') | Out-Null
        $SetParams.Remove('ApplicationSecret') | Out-Null
        $SetParams.Remove('AccessTokens') | Out-Null

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

    Write-Verbose -Message "Testing configuration of Sensitivity label for $FilterName"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    $ValuesToCheck = $PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $ValuesToCheck `
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
        -SkipModuleReload $true

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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($filter in $filters)
        {
            Write-Host "    |---[$i/$($filters.Count)] $($filter.FilterName)" -NoNewline

            # $GetParams = ([Hashtable]$PSBoundParameters).Clone()
            # $GetParams.Add("FilterName", $filter.FilterName)
            # $Results = Get-TargetResource @GetParams
            $Results = Get-M365DSCSCMapSecurityFilter -Filter $filter -Credential $Credential -ApplicationId $ApplicationId `
                -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint -CertificatePath $CertificatePath -CertificatePassword $CertificatePassword

            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
        }
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
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
