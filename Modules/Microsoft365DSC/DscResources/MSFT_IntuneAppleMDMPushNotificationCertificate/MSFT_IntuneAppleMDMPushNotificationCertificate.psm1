Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneAppleMDMPushNotificationCertificate'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region Intune params
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppleIdentifier,

        [Parameter()]
        [System.String]
        $Certificate,

        [Parameter()]
        [System.Boolean]
        $DataSharingConsetGranted,
        #endregion Intune params

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

    Write-Verbose -Message "Getting configuration of the Intune Apple Push Notification Certificate with Id {$AppleIdentifier}."

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.AppleIdentifier -ne $AppleIdentifier)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters

            #Ensure the proper dependencies are installed in the current environment.
            Confirm-M365DSCDependencies

            #region Telemetry
            $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
            $CommandName = $MyInvocation.MyCommand
            $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
                -CommandName $CommandName `
                -Parameters $PSBoundParameters
            Add-M365DSCTelemetryEvent -Data $data
            #endregion

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            # There is only one Apple push notification certificate per tenant so no need to filter by Id
            $instance = Get-MgBetaDeviceManagementApplePushNotificationCertificate -ErrorAction SilentlyContinue

            if ($null -eq $instance)
            {
                Write-Verbose -Message "No Intune Apple MDM Push Notification Certificate with Id {$AppleIdentifier}."
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        $results = @{
            AppleIdentifier       = $instance.AppleIdentifier
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }

        if (-not [String]::IsNullOrEmpty($instance.Certificate))
        {
            $results.Add('Certificate', $instance.Certificate)
        }
        else
        {
            $results.Add('Certificate', '')
        }

        # Get the value of Data sharing consent between Intune and Apple. The id is hardcoded to "appleMDMPushCertificate".
        $consentInstance = Get-MgBetaDeviceManagementDataSharingConsent -DataSharingConsentId 'appleMDMPushCertificate'
        $results.Add('DataSharingConsetGranted', $consentInstance.Granted)

        return $results
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
        #region Intune params
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppleIdentifier,

        [Parameter()]
        [System.String]
        $Certificate,

        [Parameter()]
        [System.Boolean]
        $DataSharingConsetGranted,
        #endregion Intune params

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $SetParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $SetParameters = Rename-M365DSCCimInstanceParameter -Properties $SetParameters
    $SetParameters.Remove('DataSharingConsetGranted') | Out-Null

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Apple Push Notification Certificate with Apple ID: '$AppleIdentifier'."

        # Post data sharing consent as granted between Intune and Apple. NOTE: It's a one-way operation. Once agreed, it can't be revoked.
        # so first check if it is $false, then make a post call to agree to the consent, this set the DataSharingConsetGranted to $true.
        $consentInstance = Get-MgBetaDeviceManagementDataSharingConsent -DataSharingConsentId 'appleMDMPushCertificate'
        if ($consentInstance.Granted -eq $False)
        {
            Invoke-MgGraphRequest -Method POST -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/deviceManagement/dataSharingConsents/appleMDMPushCertificate/consentToDataSharing') -Headers @{ 'Content-Type' = 'application/json' }
        }
        else
        {
            Write-M365DSCHost -Message "Data sharing consent is already granted, so it can't be revoked."
        }

        # There is only PATCH request hence using Update cmdlet to post the certificate
        Update-MgBetaDeviceManagementApplePushNotificationCertificate -BodyParameter $SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Apple Push Notification Certificate with Apple ID: '$AppleIdentifier'."
        Update-MgBetaDeviceManagementApplePushNotificationCertificate -BodyParameter $SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Apple Push Notification Certificate with Apple ID: '$AppleIdentifier' by patching with empty certificate."

        # There is only PATCH request hence using Update cmdlet to remove the certificate by passing empty certificate as param.
        $params = @{
            appleIdentifier = ''
            certificate     = ''
        }
        Update-MgBetaDeviceManagementApplePushNotificationCertificate -BodyParameter $params
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region Intune params
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppleIdentifier,

        [Parameter()]
        [System.String]
        $Certificate,

        [Parameter()]
        [System.Boolean]
        $DataSharingConsetGranted,
        #endregion Intune params

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$getValue = Get-MgBetaDeviceManagementApplePushNotificationCertificate -ErrorAction SilentlyContinue

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite

            $Params = @{
                AppleIdentifier       = $config.AppleIdentifier
                Certificate           = $config.Certificate
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            # Get the value of Data sharing consent between Intune and Apple. The id is hardcoded to "appleMDMPushCertificate".
            $consentInstance = Get-MgBetaDeviceManagementDataSharingConsent -DataSharingConsentId 'appleMDMPushCertificate'
            $Params.Add('DataSharingConsetGranted', $consentInstance.Granted)

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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

Export-ModuleMember -Function *-TargetResource
