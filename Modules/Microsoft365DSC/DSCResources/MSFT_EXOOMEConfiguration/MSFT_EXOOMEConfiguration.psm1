function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $BackgroundColor,

        [Parameter()]
        [System.String]
        $DisclaimerText,

        [Parameter()]
        [System.String]
        $EmailText,

        [Parameter()]
        [System.UInt32]
        $ExternalMailExpiryInDays,

        [Parameter()]
        [System.String]
        $IntroductionText,

        [Parameter()]
        [System.Boolean]
        $OTPEnabled,

        [Parameter()]
        [System.String]
        $PortalText,

        [Parameter()]
        [System.String]
        $PrivacyStatementUrl,

        [Parameter()]
        [System.String]
        $ReadButtonText,

        [Parameter()]
        [System.Boolean]
        $SocialIdSignIn,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    Write-Verbose -Message "Getting OME Configuration for $($Identity)"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        #Get-OMEConfiguration do NOT accept ErrorAction parameter
        $OMEConfigurations = Get-OMEConfiguration 2>&1
        if ($null -ne ($OMEConfigurations | Where-Object { $_.gettype().Name -like '*ErrorRecord*' }))
        {
            throw $OMEConfigurations
        }

        $OMEConfiguration = $OMEConfigurations | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $OMEConfiguration)
        {
            Write-Verbose -Message "OMEConfiguration $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity                 = $Identity
                BackgroundColor          = $OMEConfiguration.BackgroundColor
                DisclaimerText           = $OMEConfiguration.DisclaimerText
                EmailText                = $OMEConfiguration.EmailText
                ExternalMailExpiryInDays = $OMEConfiguration.ExternalMailExpiryInterval.Days
                #                Image                        = $OMEConfiguration.Image
                IntroductionText         = $OMEConfiguration.IntroductionText
                OTPEnabled               = $OMEConfiguration.OTPEnabled
                PortalText               = $OMEConfiguration.PortalText
                PrivacyStatementUrl      = $OMEConfiguration.PrivacyStatementUrl
                ReadButtonText           = $OMEConfiguration.ReadButtonText
                SocialIdSignIn           = $OMEConfiguration.SocialIdSignIn
                Credential               = $Credential
                Ensure                   = 'Present'
                ApplicationId            = $ApplicationId
                CertificateThumbprint    = $CertificateThumbprint
                CertificatePath          = $CertificatePath
                CertificatePassword      = $CertificatePassword
                Managedidentity          = $ManagedIdentity.IsPresent
                TenantId                 = $TenantId
                AccessTokens             = $AccessTokens
            }

            Write-Verbose -Message "Found OME Configuration $($Identity)"
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

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $BackgroundColor,

        [Parameter()]
        [System.String]
        $DisclaimerText,

        [Parameter()]
        [System.String]
        $EmailText,

        [Parameter()]
        [System.UInt32]
        $ExternalMailExpiryInDays,

        [Parameter()]
        [System.String]
        $IntroductionText,

        [Parameter()]
        [System.Boolean]
        $OTPEnabled,

        [Parameter()]
        [System.String]
        $PortalText,

        [Parameter()]
        [System.String]
        $PrivacyStatementUrl,

        [Parameter()]
        [System.String]
        $ReadButtonText,

        [Parameter()]
        [System.Boolean]
        $SocialIdSignIn,

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

    Write-Verbose -Message "Setting configuration of OME Configuration for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $OMEConfigurations = Get-OMEConfiguration
    $OMEConfiguration = $OMEConfigurations | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $OMEConfigurationParams = [System.Collections.Hashtable]($PSBoundParameters)
    $OMEConfigurationParams.Remove('Ensure') | Out-Null
    $OMEConfigurationParams.Remove('Credential') | Out-Null
    $OMEConfigurationParams.Remove('ApplicationId') | Out-Null
    $OMEConfigurationParams.Remove('TenantId') | Out-Null
    $OMEConfigurationParams.Remove('CertificateThumbprint') | Out-Null
    $OMEConfigurationParams.Remove('CertificatePath') | Out-Null
    $OMEConfigurationParams.Remove('CertificatePassword') | Out-Null
    $OMEConfigurationParams.Remove('ManagedIdentity') | Out-Null
    $OMEConfigurationParams.Remove('AccessTokens') | Out-Null

    #ExternalMailExpiryInDays cannot be updated in the default OME configuration
    if ('OME Configuration' -eq $Identity)
    {
        $OMEConfigurationParams.Remove('ExternalMailExpiryInDays') | Out-Null
    }
    if (('Present' -eq $Ensure ) -and ($null -eq $OMEConfiguration))
    {
        Write-Verbose -Message "Creating OME Configuration $($Identity)."
        New-OMEConfiguration @OMEConfigurationParams
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $OMEConfiguration))
    {
        Write-Verbose -Message "Setting OME Configuration $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $OMEConfigurationParams)"
        Set-OMEConfiguration @OMEConfigurationParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $OMEConfiguration))
    {
        Write-Verbose -Message "Removing OME Configuration $($Identity)"
        Remove-OMEConfiguration -Identity $Identity -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $BackgroundColor,

        [Parameter()]
        [System.String]
        $DisclaimerText,

        [Parameter()]
        [System.String]
        $EmailText,

        [Parameter()]
        [System.UInt32]
        $ExternalMailExpiryInDays,

        [Parameter()]
        [System.String]
        $IntroductionText,

        [Parameter()]
        [System.Boolean]
        $OTPEnabled,

        [Parameter()]
        [System.String]
        $PortalText,

        [Parameter()]
        [System.String]
        $PrivacyStatementUrl,

        [Parameter()]
        [System.String]
        $ReadButtonText,

        [Parameter()]
        [System.Boolean]
        $SocialIdSignIn,

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

    Write-Verbose -Message "Testing configuration of OME Configuration for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' -InboundParameters $PSBoundParameters -SkipModuleReload $true

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
        #Using 2>&1 to redirect Error stream to variable because Set-Perimeter do not inlude ErrorAction
        $OMEConfigurations = Get-OMEConfiguration 2>&1
        if ($null -ne ($OMEConfigurations | Where-Object { $_.gettype().Name -like '*ErrorRecord*' }))
        {
            throw $OMEConfigurations
        }

        [Array]$OMEConfigurations = $OMEConfigurations
        $dscContent = ''

        if ($OMEConfigurations.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($OMEConfiguration in $OMEConfigurations)
        {
            Write-Host "    |---[$i/$($OMEConfigurations.Length)] $($OMEConfiguration.Identity)" -NoNewline

            $Params = @{
                Identity              = $OMEConfiguration.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
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
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
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
