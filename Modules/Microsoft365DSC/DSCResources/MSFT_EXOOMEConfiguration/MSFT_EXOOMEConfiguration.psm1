Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOOMEConfiguration'

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

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            #Get-OMEConfiguration do NOT accept ErrorAction parameter
            $OMEConfiguration = Get-OMEConfiguration -Identity $Identity 2>&1
            if ($null -ne ($OMEConfiguration | Where-Object { $_.GetType().Name -like '*ErrorRecord*' }))
            {
                throw $OMEConfiguration
            }

            if ($null -eq $OMEConfiguration)
            {
                Write-Verbose -Message "OMEConfiguration $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $OMEConfiguration = $Script:exportedInstance
        }

        Write-Verbose -Message "Found OME Configuration $($Identity)"

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
            ManagedIdentity          = $ManagedIdentity.IsPresent
            TenantId                 = $TenantId
            AccessTokens             = $AccessTokens
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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $OMEConfigurations = Get-OMEConfiguration
    $OMEConfiguration = $OMEConfigurations | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $OMEConfigurationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    #ExternalMailExpiryInDays cannot be updated in the default OME configuration
    if ('OME Configuration' -eq $Identity)
    {
        $OMEConfigurationParams.Remove('ExternalMailExpiryInDays') | Out-Null
    }
    if ($Ensure -eq 'Present' -and $null -eq $OMEConfiguration)
    {
        Write-Verbose -Message "Creating OME Configuration $($Identity)."
        New-OMEConfiguration @OMEConfigurationParams
    }
    elseif ($Ensure -eq 'Present' -and $null -ne $OMEConfiguration)
    {
        Write-Verbose -Message "Setting OME Configuration $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $OMEConfigurationParams)"
        Set-OMEConfiguration @OMEConfigurationParams -Confirm:$false
    }
    elseif ($Ensure -eq 'Absent' -and $null -ne $OMEConfiguration)
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
        #Using 2>&1 to redirect Error stream to variable because Set-Perimeter do not inlude ErrorAction
        $OMEConfigurations = Get-OMEConfiguration 2>&1
        if ($null -ne ($OMEConfigurations | Where-Object { $_.GetType().Name -like '*ErrorRecord*' }))
        {
            throw $OMEConfigurations
        }

        [Array]$OMEConfigurations = $OMEConfigurations
        $dscContent = ''

        if ($OMEConfigurations.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($OMEConfiguration in $OMEConfigurations)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($OMEConfigurations.Length)] $($OMEConfiguration.Identity)" -DeferWrite

            $Params = @{
                Identity              = $OMEConfiguration.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $OMEConfiguration
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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
Export-ModuleMember -Function *-TargetResource
