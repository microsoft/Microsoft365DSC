function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $BindStatus,

        [Parameter()]
        [System.String]
        $OwnerUserPrincipalName,

        [Parameter()]
        [System.String]
        $OwnerOrganizationName,

        [Parameter()]
        [System.String]
        $EnrollmentTarget,

        [Parameter()]
        [System.Boolean]
        $DeviceOwnerManagementEnabled,

        [Parameter()]
        [System.Boolean]
        $AndroidDeviceOwnerFullyManagedEnrollmentEnabled,

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

    Write-Verbose -Message "Getting configuration of the Intune Device Management Android Google Play Enrollment with Id {$Id}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
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

            if (-not [string]::IsNullOrEmpty($Id))
            {
                $allSettings = Get-MgBetaDeviceManagementAndroidManagedStoreAccountEnterpriseSetting
                $specificSetting = $allSettings | Where-Object { $_.id -eq $Id }
            }

            if (-not $specificSetting)
            {
                Write-Verbose "No Android Managed Store Account Enterprise Setting found with Id $Id."
                return $nullResult
            }
        }
        else
        {
            $specificSetting = $Script:exportedInstance
        }

        $result = @{
            Id                                              = $specificSetting.id
            BindStatus                                      = $specificSetting.bindStatus
            OwnerUserPrincipalName                          = $specificSetting.ownerUserPrincipalName
            OwnerOrganizationName                           = $specificSetting.ownerOrganizationName
            EnrollmentTarget                                = $specificSetting.enrollmentTarget
            DeviceOwnerManagementEnabled                    = $specificSetting.deviceOwnerManagementEnabled
            AndroidDeviceOwnerFullyManagedEnrollmentEnabled = $specificSetting.androidDeviceOwnerFullyManagedEnrollmentEnabled
            Ensure                                          = 'Present'
            Credential                                      = $Credential
            ApplicationId                                   = $ApplicationId
            TenantId                                        = $TenantId
            CertificateThumbprint                           = $CertificateThumbprint
            ApplicationSecret                               = $ApplicationSecret
            ManagedIdentity                                 = $ManagedIdentity.IsPresent
            AccessTokens                                    = $AccessTokens
        }

        return $result

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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $BindStatus,

        [Parameter()]
        [System.String]
        $OwnerUserPrincipalName,

        [Parameter()]
        [System.String]
        $OwnerOrganizationName,

        [Parameter()]
        [System.String]
        $EnrollmentTarget,

        [Parameter()]
        [System.Boolean]
        $DeviceOwnerManagementEnabled,

        [Parameter()]
        [System.Boolean]
        $AndroidDeviceOwnerFullyManagedEnrollmentEnabled,

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
    <#Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters


    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Management Android Google Play Enrollment with id {$Id}"
        # Check data sharing consent status
        $dataSharingConsent = Get-MgBetaDeviceManagementDataSharingConsent -DataSharingConsentId 'androidManagedStore'
        if ($dataSharingConsent.granted -eq $false)
        {
            Write-Verbose -Message 'Consent not granted, requesting consent...'
            $consentResult = Invoke-MgGraphRequest -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/deviceManagement/dataSharingConsents/androidManagedStore/consentToDataSharing') -Method 'POST' -Body @{
                DataSharingConsentId = 'androidManagedStore'
            } -ContentType 'application/json'
        }

        if ($BindStatus -eq 'notBound')
        {
            Write-Verbose -Message "Requesting signup URL for enrollment..."
            $signupUri = ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + `
                            "beta/deviceManagement/androidManagedStoreAccountEnterpriseSettings/requestSignupUrl")
            $body = @{
                hostName = 'intune.microsoft.com'
            }
            Invoke-MgGraphRequest -Uri $signupUri `
                                  -Method 'POST' `
                                  -ContentType "application/json" `
                                  -Body $body
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $uri = ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/deviceManagement/androidManagedStoreAccountEnterpriseSettings')
        $UpdateParameters = @{
            '@odata.type' = '#microsoft.graph.androidManagedStoreAccountEnterpriseSettings'
            androidDeviceOwnerFullyManagedEnrollmentEnabled = $AndroidDeviceOwnerFullyManagedEnrollmentEnabled;
            bindStatus                                      = $BindStatus;
            deviceOwnerManagementEnabled                    = $DeviceOwnerManagementEnabled;
            enrollmentTarget                                = $EnrollmentTarget;
            id                                              = $Id;
            ownerOrganizationName                           = $OwnerOrganizationName;
            ownerUserPrincipalName                          = $OwnerUserPrincipalName;
        }


        Write-Verbose -Message "Updating Intune Device Management Android Google Play Enrollment with values:`r`n$(ConvertTo-Json $UpdateParameters -Depth 10)"
        Invoke-MgGraphRequest -Uri $uri `
                              -Method 'PATCH' `
                              -Body $UpdateParameters `
                              -ContentType 'application/json'
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-M365DSCHost -Message "Remove the Intune Device Management Android Google Play Enrollment with Id {$($currentInstance.Id)}"
        $unbindResult = Invoke-MgGraphRequest -Uri ((Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/deviceManagement/androidManagedStoreAccountEnterpriseSettings/unbind') -Method 'POST' -Body @{} -ContentType 'application/json'
    }#>

    Write-Verbose -Message "WARNING: This resource is currently read-only. This means you can use it to monitor for drifts, but it can't automate any configuration changes. The APIs associated with the binding process are owned by Google."
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $BindStatus,

        [Parameter()]
        [System.String]
        $OwnerUserPrincipalName,

        [Parameter()]
        [System.String]
        $OwnerOrganizationName,

        [Parameter()]
        [System.String]
        $EnrollmentTarget,

        [Parameter()]
        [System.Boolean]
        $DeviceOwnerManagementEnabled,

        [Parameter()]
        [System.Boolean]
        $AndroidDeviceOwnerFullyManagedEnrollmentEnabled,

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

    Write-Verbose -Message "Testing configuration of the Intune Device Management Android Google Play Enrollment with Id {$Id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    if ($testResult)
    {
        $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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
        [System.String]
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
        $Script:ExportMode = $true
        [array] $getValue = Get-MgBetaDeviceManagementAndroidManagedStoreAccountEnterpriseSetting `
            -ErrorAction Stop

        $i = 1
        $dscContent = ''
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite

            $params = @{
                Id                    = $config.Id
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }

        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
