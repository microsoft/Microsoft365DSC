function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $AccountId,

        [Parameter()]
        [System.Boolean]
        $ConfigureWifi,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $EnrolledDeviceCount,

        [Parameter()]
        [System.String]
        [ValidateSet( 'corporateOwnedDedicatedDevice', 'corporateOwnedFullyManaged', 'corporateOwnedWorkProfile', 'corporateOwnedAOSPUserlessDevice', 'corporateOwnedAOSPUserAssociatedDevice')]
        $EnrollmentMode,

        [Parameter()]
        [ValidateSet( 'default', 'corporateOwnedDedicatedDeviceWithAzureADSharedMode', 'deviceStaging')]
        $EnrollmentTokenType,

        [Parameter()]
        [System.Int32]
        $EnrollmentTokenUsageCount,

        [Parameter()]
        [System.Boolean]
        $IsTeamsDeviceProfile,

        [Parameter()]
        [System.String]
        $QrCodeContent,

        [Parameter()]
        [System.String]
        $QrCodeImage,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $TokenValue,

        [Parameter()]
        [System.Boolean]
        $WifiHidden,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $WifiPassword,

        [Parameter()]
        [System.String]
        [ValidateSet( 'none', 'wpa', 'wep' )]
        $WifiSecurityType,

        [Parameter()]
        [System.String]
        $WifiSsid,

        [Parameter()]
        [System.String]
        [ValidateSet('Present', 'Absent')]
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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Checking for the Intune Android Device Owner Enrollment Profile {$DisplayName}"
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
    try
    {
        $androidDeviceOwnerEnrollmentProfile = Get-MgAndroidDeviceOwnerEnrollmentProfile `
        -Filter "displayName eq '$DisplayName')"
        -ErrorAction SilentlyContinue | Where-Object

        if ($null -eq $androidDeviceOwnerEnrollmentProfile)
        {
            Write-Verbose -Message "No AndroidDeviceOwnerEnrollmentProfiles with DisplayName {$DisplayName} was found. Search with DisplayName."
            $androidDeviceOwnerEnrollmentProfile = Get-MgAndroidDeviceOwnerEnrollmentProfile
                -ProfileId $Id
        }

        if ($null -eq $androidDeviceOwnerEnrollmentProfile)
        {
            Write-Verbose -Message "No AndroidDeviceOwnerEnrollmentProfiles with {$Id} was found."
            return $nullResult
        }

        $results = @{
            Id                    = $androidDeviceOwnerEnrollmentProfile.Id
            DisplayName           = $androidDeviceOwnerEnrollmentProfile.DisplayName
            AccountId             = $androidDeviceOwnerEnrollmentProfile.AccountId
            ConfigureWifi         = $androidDeviceOwnerEnrollmentProfile.ConfigureWifi
            Description           = $androidDeviceOwnerEnrollmentProfile.Description
            EnrolledDeviceCount   = $androidDeviceOwnerEnrollmentProfile.EnrolledDeviceCount
            EnrollmentMode        = $androidDeviceOwnerEnrollmentProfile.EnrollmentMode
            EnrollmentTokenType   = $androidDeviceOwnerEnrollmentProfile.EnrollmentTokenType
            EnrollmentTokenUsageCount = $androidDeviceOwnerEnrollmentProfile.EnrollmentTokenUsageCount
            IsTeamsDeviceProfile  = $androidDeviceOwnerEnrollmentProfile.IsTeamsDeviceProfile
            QrCodeContent         = $androidDeviceOwnerEnrollmentProfile.QrCodeContent
            QrCodeImage           = $androidDeviceOwnerEnrollmentProfile.QrCodeImage
            RoleScopeTagIds       = $androidDeviceOwnerEnrollmentProfile.RoleScopeTagIds
            TokenValue            = $androidDeviceOwnerEnrollmentProfile.TokenValue
            WifiHidden            = $androidDeviceOwnerEnrollmentProfile.WifiHidden
            WifiPassword          = $androidDeviceOwnerEnrollmentProfile.WifiPassword
            WifiSecurityType      = $androidDeviceOwnerEnrollmentProfile.WifiSecurityType
            WifiSsid              = $androidDeviceOwnerEnrollmentProfile.WifiSsid

            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
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
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $AccountId,

        [Parameter()]
        [System.Boolean]
        $ConfigureWifi,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $EnrolledDeviceCount,

        [Parameter()]
        [System.String]
        [ValidateSet( 'corporateOwnedDedicatedDevice', 'corporateOwnedFullyManaged', 'corporateOwnedWorkProfile', 'corporateOwnedAOSPUserlessDevice', 'corporateOwnedAOSPUserAssociatedDevice')]
        $EnrollmentMode,

        [Parameter()]
        [ValidateSet( 'default', 'corporateOwnedDedicatedDeviceWithAzureADSharedMode', 'deviceStaging')]
        $EnrollmentTokenType,

        [Parameter()]
        [System.Int32]
        $EnrollmentTokenUsageCount,

        [Parameter()]
        [System.Boolean]
        $IsTeamsDeviceProfile,

        [Parameter()]
        [System.String]
        $QrCodeContent,

        [Parameter()]
        [System.String]
        $QrCodeImage,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $TokenValue,

        [Parameter()]
        [System.Boolean]
        $WifiHidden,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $WifiPassword,

        [Parameter()]
        [System.String]
        [ValidateSet( 'none', 'wpa', 'wep' )]
        $WifiSecurityType,

        [Parameter()]
        [System.String]
        $WifiSsid,

        [Parameter()]
        [System.String]
        [ValidateSet('Present', 'Absent')]
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
    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Host "Create AndroidDeviceOwnerEnrollmentProfile: $DisplayName with Enrollment Mode: $EnrollmentMode"

        $CreateParameters.remove('Id') | Out-Null
        $CreateParameters.remove('Ensure') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null

        New-MgAndroidDeviceOwnerEnrollmentProfile @CreateParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Host "Update AndroidDeviceOwnerEnrollmentProfile: $DisplayName"

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null

        Update-MgAndroidDeviceOwnerEnrollmentProfile -ProfileId $currentInstance.Id @UpdateParameters
        Write-Host "Updated AndroidDeviceOwnerEnrollmentProfile: $DisplayName"
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Host "Remove AndroidDeviceOwnerEnrollmentProfile: $DisplayName"

        Remove-MgAndroidDeviceOwnerEnrollmentProfile -ProfileId $currentInstance.Id -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $AccountId,

        [Parameter()]
        [System.Boolean]
        $ConfigureWifi,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Int32]
        $EnrolledDeviceCount,

        [Parameter()]
        [System.String]
        [ValidateSet( 'corporateOwnedDedicatedDevice', 'corporateOwnedFullyManaged', 'corporateOwnedWorkProfile', 'corporateOwnedAOSPUserlessDevice', 'corporateOwnedAOSPUserAssociatedDevice')]
        $EnrollmentMode,

        [Parameter()]
        [ValidateSet( 'default', 'corporateOwnedDedicatedDeviceWithAzureADSharedMode', 'deviceStaging')]
        $EnrollmentTokenType,

        [Parameter()]
        [System.Int32]
        $EnrollmentTokenUsageCount,

        [Parameter()]
        [System.Boolean]
        $IsTeamsDeviceProfile,

        [Parameter()]
        [System.String]
        $QrCodeContent,

        [Parameter()]
        [System.String]
        $QrCodeImage,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $TokenValue,

        [Parameter()]
        [System.Boolean]
        $WifiHidden,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $WifiPassword,

        [Parameter()]
        [System.String]
        [ValidateSet( 'none', 'wpa', 'wep' )]
        $WifiSecurityType,

        [Parameter()]
        [System.String]
        $WifiSsid,

        [Parameter()]
        [System.String]
        [ValidateSet('Present', 'Absent')]
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

    Write-Verbose -Message "Testing configuration of AndroidDeviceOwnerEnrollmentProfile: {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $CurrentValues))
    {
        Write-Verbose "An error occured in Get-TargetResource, the enrollmentProfile {$displayName} will not be processed"
        throw "An error occured in Get-TargetResource, the enrollmentProfile {$displayName} will not be processed. Refer to the event viewer logs for more information."
    }
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    $TestResult = Test-M365DSCParameterState `
            -CurrentValues $CurrentValues
            -Source $($MyInvocation.MyCommand.Source)
            -DesiredValues $PSBoundParameters
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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
        [array] $Script:exportedInstances = Get-MgAndroidDeviceOwnerEnrollmentProfile `
         -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
            Id                    = $androidDeviceOwnerEnrollmentProfile.Id
            DisplayName           = $androidDeviceOwnerEnrollmentProfile.DisplayName

            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

                if (-not (Test-M365DSCAuthenticationParameter -BoundParameters $Results))
            {
                Write-Verbose "An error occured in Get-TargetResource, the app {$($params.displayName)} will not be processed."
                throw "An error occured in Get-TargetResource, the app {$($params.displayName)} will not be processed. Refer to the event viewer logs for more information."
            }

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
