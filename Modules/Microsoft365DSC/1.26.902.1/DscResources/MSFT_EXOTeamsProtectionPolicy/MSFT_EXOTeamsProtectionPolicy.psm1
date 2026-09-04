Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOTeamsProtectionPolicy'

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
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('AdminOnlyAccessPolicy', 'DefaultFullAccessPolicy', 'DefaultFullAccessWithNotificationPolicy')]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [ValidateSet('AdminOnlyAccessPolicy', 'DefaultFullAccessPolicy', 'DefaultFullAccessWithNotificationPolicy')]
        [System.String]
        $MalwareQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $ZapEnabled,

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

    Write-Verbose -Message 'Getting configuration of EXO Teams Protection Policy'

    try
    {
        if (-not $Script:exportedInstance)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
                IsSingleInstance                 = 'Yes'
                AdminDisplayName                 = $null
                HighConfidencePhishQuarantineTag = $null
                MalwareQuarantineTag             = $null
                ZapEnabled                       = $null
            }

            $ProtectionPolicy = Get-TeamsProtectionPolicy -ErrorAction SilentlyContinue
            if ($null -eq $ProtectionPolicy)
            {
                Write-Verbose -Message 'Teams Protection Policy does not exist.'
                return $nullReturn
            }
        }
        else
        {
            $ProtectionPolicy = $Script:exportedInstance
        }

        Write-Verbose -Message 'An EXO Teams Protection Policy was found.'
        $result = @{
            IsSingleInstance                 = 'Yes'
            AdminDisplayName                 = $ProtectionPolicy.AdminDisplayName
            HighConfidencePhishQuarantineTag = $ProtectionPolicy.HighConfidencePhishQuarantineTag
            MalwareQuarantineTag             = $ProtectionPolicy.MalwareQuarantineTag
            ZapEnabled                       = $ProtectionPolicy.ZapEnabled
            Credential                       = $Credential
            ApplicationId                    = $ApplicationId
            CertificateThumbprint            = $CertificateThumbprint
            CertificatePath                  = $CertificatePath
            CertificatePassword              = $CertificatePassword
            ManagedIdentity                  = $ManagedIdentity.IsPresent
            TenantId                         = $TenantId
            AccessTokens                     = $AccessTokens
        }

        return $result
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
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('AdminOnlyAccessPolicy', 'DefaultFullAccessPolicy', 'DefaultFullAccessWithNotificationPolicy')]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [ValidateSet('AdminOnlyAccessPolicy', 'DefaultFullAccessPolicy', 'DefaultFullAccessWithNotificationPolicy')]
        [System.String]
        $MalwareQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $ZapEnabled,

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
    Write-Verbose -Message 'Setting configuration of Teams Protection Policy'

    $currentValues = Get-TargetResource @PSBoundParameters

    if ($null -eq $currentValues.AdminDisplayName -and `
            $null -eq $currentValues.HighConfidencePhishQuarantineTag -and `
            $null -eq $currentValues.MalwareQuarantineTag -and `
            $null -eq $currentValues.ZapEnabled)
    {
        Write-Verbose -Message 'Teams Protection Policy does not exist, creating new policy'
        New-TeamsProtectionPolicy -Name 'Teams Protection Policy'
    }

    $params = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $params.Add('Identity', 'Teams Protection Policy')
    $params.Remove('IsSingleInstance')

    Set-TeamsProtectionPolicy @params
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
        [System.String]
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('AdminOnlyAccessPolicy', 'DefaultFullAccessPolicy', 'DefaultFullAccessWithNotificationPolicy')]
        [System.String]
        $HighConfidencePhishQuarantineTag,

        [Parameter()]
        [ValidateSet('AdminOnlyAccessPolicy', 'DefaultFullAccessPolicy', 'DefaultFullAccessWithNotificationPolicy')]
        [System.String]
        $MalwareQuarantineTag,

        [Parameter()]
        [System.Boolean]
        $ZapEnabled,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

        $dscContent = [System.Text.StringBuilder]::new()

        [array]$teamsProtectionPolicy = Get-TeamsProtectionPolicy -ErrorAction Stop
        if ($null -ne $teamsProtectionPolicy)
        {
            $Params = @{
                IsSingleInstance      = 'Yes'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $teamsProtectionPolicy
            $Results = Get-TargetResource @Params
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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}
Export-ModuleMember -Function *-TargetResource
