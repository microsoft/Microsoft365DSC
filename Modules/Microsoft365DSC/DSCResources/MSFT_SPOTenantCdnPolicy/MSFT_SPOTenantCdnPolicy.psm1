function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $CDNType,

        [Parameter()]
        [System.String[]]
        $ExcludeRestrictedSiteClassifications,

        [Parameter()]
        [System.String[]]
        $IncludeFileExtensions,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for SPOTenantCdnPolicy {$CDNType}"
    $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
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

    $nullReturn = @{
        CDNType = $CDNType
    }

    try
    {
        $Policies = Get-PnPTenantCdnPolicies -CdnType $CDNType -ErrorAction Stop
        if ($Policies['ExcludeRestrictedSiteClassifications'].Length -gt 0)
        {
            $ExcludeRestrictedSiteClassifications = `
                $Policies['ExcludeRestrictedSiteClassifications'].Split(',')
        }
        else
        {
            $ExcludeRestrictedSiteClassifications = @()
        }
        if ($Policies['IncludeFileExtensions'].Length -gt 0)
        {
            $IncludeFileExtensions = `
                $Policies['IncludeFileExtensions'].Split(',')
        }
        else
        {
            $IncludeFileExtensions = @()
        }

        return @{
            CDNType                              = $CDNType
            ExcludeRestrictedSiteClassifications = $ExcludeRestrictedSiteClassifications
            IncludeFileExtensions                = $IncludeFileExtensions
            Credential                           = $Credential
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            ApplicationSecret                    = $ApplicationSecret
            CertificatePassword                  = $CertificatePassword
            CertificatePath                      = $CertificatePath
            CertificateThumbprint                = $CertificateThumbprint
            Managedidentity                      = $ManagedIdentity.IsPresent
            AccessTokens                         = $AccessTokens
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
        [ValidateSet('Private', 'Public')]
        [System.String]
        $CDNType,

        [Parameter()]
        [System.String[]]
        $ExcludeRestrictedSiteClassifications,

        [Parameter()]
        [System.String[]]
        $IncludeFileExtensions,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration for SPOTenantCDNPolicy {$CDNType}"

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

    $curPolicies = Get-TargetResource @PSBoundParameters

    if ($null -ne `
        (Compare-Object -ReferenceObject $curPolicies.IncludeFileExtensions -DifferenceObject $IncludeFileExtensions))
    {
        Write-Verbose 'Found difference in IncludeFileExtensions'

        [String]$IncludeFileExtensions = [String[]]$IncludeFileExtensions -join ','
        Set-PnPTenantCdnPolicy -CdnType $CDNType `
            -PolicyType 'IncludeFileExtensions' `
            -PolicyValue $IncludeFileExtensions
    }

    if ($null -ne (Compare-Object -ReferenceObject $curPolicies.ExcludeRestrictedSiteClassifications `
                -DifferenceObject $ExcludeRestrictedSiteClassifications))
    {
        Write-Verbose 'Found difference in ExcludeRestrictedSiteClassifications'

        [String]$ExcludeRestrictedSiteClassifications = [String[]]$ExcludeRestrictedSiteClassifications -join ','
        Set-PnPTenantCdnPolicy -CdnType $CDNType `
            -PolicyType 'ExcludeRestrictedSiteClassifications' `
            -PolicyValue $ExcludeRestrictedSiteClassifications
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Private', 'Public')]
        [System.String]
        $CDNType,

        [Parameter()]
        [System.String[]]
        $ExcludeRestrictedSiteClassifications,

        [Parameter()]
        [System.String[]]
        $IncludeFileExtensions,

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration for SPO Storage Entity for $Key"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('CDNType', `
            'ExcludeRestrictedSiteClassifications', `
            'IncludeFileExtensions')

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
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

        $Params = @{
            CdnType               = 'Public'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
            AccessTokens          = $AccessTokens
        }
        $dscContent = ''

        Write-Host "`r`n    |---[1/2] Public" -NoNewline
        $Results = Get-TargetResource @Params

        if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
        {
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            Save-M365DSCPartialExport -Content $dscContent `
                -FileName $Global:PartialExportFileName

            Write-Host $Global:M365DSCEmojiGreenCheckmark
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
        }

        $Params = @{
            CdnType               = 'Private'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
        }
        Write-Host '    |---[2/2] Private' -NoNewline
        $Results = Get-TargetResource @params

        if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
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

            Write-Host $Global:M365DSCEmojiGreenCheckmark
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
        }

        return $dscContent
    }
    catch
    {
        # This method is not implemented in some sovereign clouds (e.g. GCCHigh)
        if ($_.Exception -like '*The method or operation is not implemented*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant does not support this feature."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }
        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
