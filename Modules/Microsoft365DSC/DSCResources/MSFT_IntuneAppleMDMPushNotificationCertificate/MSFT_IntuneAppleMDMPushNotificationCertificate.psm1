function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region Intune params

        [Parameter()]
        [System.String]
        $Id,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Intune Apple Push Notification Certificate with Id {$Id}."

    try
    {
        if (-not $Script:exportedInstance)
        {
            New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters | Out-Null

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
                Write-Verbose -Message "No Intune Apple MDM Push Notification Certificate with Id {$Id}."
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        $results = @{
            Id                    = $instance.Id
            AppleIdentifier       = $instance.AppleIdentifier

            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
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

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region Intune params

        [Parameter()]
        [System.String]
        $Id,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
    $SetParameters.Remove('Id') | Out-Null
    $SetParameters.Remove('DataSharingConsetGranted') | Out-Null

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Apple Push Notification Certificate with Apple ID: '$AppleIdentifier'."

        # Post data sharing consent as granted between Intune and Apple. NOTE: It's a one-way operation. Once agreed, it can't be revoked.
        # so first check if it is $false, then make a post call to agree to the consent, this set the DataSharingConsetGranted to $true.
        $consentInstance = Get-MgBetaDeviceManagementDataSharingConsent -DataSharingConsentId 'appleMDMPushCertificate'
        If ($consentInstance.Granted -eq $False)
        {
            Invoke-MgGraphRequest -Method POST -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/deviceManagement/dataSharingConsents/appleMDMPushCertificate/consentToDataSharing') -Headers @{ 'Content-Type' = 'application/json' }
        }
        else
        {
            Write-Host "Data sharing conset is already granted, so it can't be revoked."
        }

        # There is only PATCH request hence using Update cmdlet to post the certificate
        Update-MgBetaDeviceManagementApplePushNotificationCertificate @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Apple Push Notification Certificate with Apple ID: '$AppleIdentifier'."
        Update-MgBetaDeviceManagementApplePushNotificationCertificate @SetParameters
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

        [Parameter()]
        [System.String]
        $Id,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $testResult = $true

    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
        [array] $getValue = Get-MgBetaDeviceManagementApplePushNotificationCertificate -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline

            $Params = @{
                Id                    = $config.Id
                AppleIdentifier       = $config.AppleIdentifier
                Certificate           = $config.Certificate

                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            # Get the value of Data sharing consent between Intune and Apple. The id is hardcoded to "appleMDMPushCertificate".
            $consentInstance = Get-MgBetaDeviceManagementDataSharingConsent -DataSharingConsentId 'appleMDMPushCertificate'
            $Params.Add('DataSharingConsetGranted', $consentInstance.Granted)

            $Script:exportedInstance = $config
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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
