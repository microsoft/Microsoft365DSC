Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOBrowserIdleSignout'

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

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9]{0,7}\.?[0-2][0-9]:[0-5][0-9]:[0-5][0-9])$')]
        $SignOutAfter,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9]{0,7}\.?[0-2][0-9]:[0-5][0-9]:[0-5][0-9])$')]
        $WarnAfter,

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

    Write-Verbose -Message 'Getting configuration for SPO Browser Idle Signout settings'

    try
    {
        if ($null -eq $Script:exportedInstance)
        {
            $null = New-M365DSCConnection -Workload 'PnP' `
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

            $BrowserIdleSignout = Get-PnPBrowserIdleSignout -ErrorAction Stop
        }
        else
        {
            $BrowserIdleSignout = $Script:exportedInstance
        }

        return @{
            IsSingleInstance      = 'Yes'
            Enabled               = $BrowserIdleSignout.Enabled
            SignOutAfter          = $BrowserIdleSignout.SignOutAfter.ToString()
            WarnAfter             = $BrowserIdleSignout.WarnAfter.ToString()
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9]{0,7}\.?[0-2][0-9]:[0-5][0-9]:[0-5][0-9])$')]
        $SignOutAfter,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9]{0,7}\.?[0-2][0-9]:[0-5][0-9]:[0-5][0-9])$')]
        $WarnAfter,

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

    Write-Verbose -Message 'Setting configuration for SPO Browser Idle Signout settings'

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

    $null = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    $CurrentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $CurrentParameters.Remove('IsSingleInstance') | Out-Null

    Set-PnPBrowserIdleSignout @CurrentParameters | Out-Null
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

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9]{0,7}\.?[0-2][0-9]:[0-5][0-9]:[0-5][0-9])$')]
        $SignOutAfter,

        [Parameter()]
        [System.String]
        [ValidatePattern('^([0-9]{0,7}\.?[0-2][0-9]:[0-5][0-9]:[0-5][0-9])$')]
        $WarnAfter,

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

        $Script:exportedInstance = Get-PnPBrowserIdleSignout -ErrorAction Stop

        $Params = @{
            IsSingleInstance      = 'Yes'
            Enabled               = $false
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
            ApplicationSecret     = $ApplicationSecret
            AccessTokens          = $AccessTokens
        }

        $dscContent = [System.Text.StringBuilder]::new()
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
            if ($null -ne $DesiredValues.SignOutAfter -and $null -ne $CurrentValues.SignOutAfter)
            {
                $desiredTimeSpan = [System.TimeSpan]::Parse($DesiredValues.SignOutAfter)
                $currentTimeSpan = [System.TimeSpan]::Parse($CurrentValues.SignOutAfter)
                $delta = [System.TimeSpan]::FromSeconds(30)
                if ([System.TimeSpan]::Compare($desiredTimeSpan, $currentTimeSpan) -ne 0 -and [System.TimeSpan]::Compare(($desiredTimeSpan - $currentTimeSpan).Duration(), $delta) -le 0)
                {
                    Write-Verbose -Message "Difference between Desired and Current SignOutAfter is less than or equal to 30 seconds. Desired: $desiredTimeSpan, Current: $currentTimeSpan. Treating as equal."
                    $ValuesToCheck.Remove('SignOutAfter') | Out-Null
                }
            }
            if ($null -ne $DesiredValues.WarnAfter -and $null -ne $CurrentValues.WarnAfter)
            {
                $desiredTimeSpan = [System.TimeSpan]::Parse($DesiredValues.WarnAfter)
                $currentTimeSpan = [System.TimeSpan]::Parse($CurrentValues.WarnAfter)
                $delta = [System.TimeSpan]::FromSeconds(30)
                if ([System.TimeSpan]::Compare($desiredTimeSpan, $currentTimeSpan) -ne 0 -and [System.TimeSpan]::Compare(($desiredTimeSpan - $currentTimeSpan).Duration(), $delta) -le 0)
                {
                    Write-Verbose -Message "Difference between Desired and Current WarnAfter is less than or equal to 30 seconds. Desired: $desiredTimeSpan, Current: $currentTimeSpan. Treating as equal."
                    $ValuesToCheck.Remove('WarnAfter') | Out-Null
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
