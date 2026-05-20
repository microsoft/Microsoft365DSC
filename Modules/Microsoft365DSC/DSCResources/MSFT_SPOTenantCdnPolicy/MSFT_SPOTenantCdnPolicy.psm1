Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOTenantCdnPolicy'

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

    try
    {
        if (-not $Script:ExportMode)
        {
            $null = New-M365DSCConnection -Workload 'PNP' `
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
        }

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
            ManagedIdentity                      = $ManagedIdentity.IsPresent
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

        throw
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

        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }
        $Script:ExportMode = $true

        $Params = @{
            CdnType               = 'Public'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
            AccessTokens          = $AccessTokens
        }
        $dscContent = [System.Text.StringBuilder]::new()

        Write-M365DSCHost -Message "`r`n    |---[1/2] Public" -DeferWrite
        $Results = Get-TargetResource @Params
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

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
        }

        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Params = @{
            CdnType               = 'Private'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
        }
        Write-M365DSCHost -Message '    |---[2/2] Private' -DeferWrite
        $Results = Get-TargetResource @Params
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

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
        }

        return $dscContent.ToString()
    }
    catch
    {
        # This method is not implemented in some sovereign clouds (e.g. GCCHigh)
        if ($_.Exception -like '*The method or operation is not implemented*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant does not support this feature."
            return ''
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

Export-ModuleMember -Function *-TargetResource
