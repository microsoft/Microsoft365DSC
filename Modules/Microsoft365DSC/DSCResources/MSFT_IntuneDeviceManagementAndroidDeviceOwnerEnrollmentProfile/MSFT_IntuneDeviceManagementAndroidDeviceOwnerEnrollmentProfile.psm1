Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneDeviceManagementAndroidDeviceOwnerEnrollmentProfile'

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
        [ValidateSet('corporateOwnedDedicatedDevice', 'corporateOwnedFullyManaged', 'corporateOwnedWorkProfile', 'corporateOwnedAOSPUserlessDevice', 'corporateOwnedAOSPUserAssociatedDevice')]
        [System.String]
        $EnrollmentMode,

        [Parameter()]
        [ValidateSet('default', 'corporateOwnedDedicatedDeviceWithAzureADSharedMode', 'deviceStaging')]
        [System.String]
        $EnrollmentTokenType,

        [Parameter()]
        [System.Boolean]
        $IsTeamsDeviceProfile,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $TokenExpirationDateTime,

        [Parameter()]
        [System.Boolean]
        $WifiHidden,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $WifiPassword,

        [Parameter()]
        [ValidateSet('none', 'wpa', 'wep' )]
        [System.String]
        $WifiSecurityType,

        [Parameter()]
        [System.String]
        $WifiSsid,

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

    Write-Verbose -Message "Getting configuration of the Intune Android Device Owner Enrollment Profile with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
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

            $androidDeviceOwnerEnrollmentProfile = $null
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message 'Trying to retrieve profile by Id'
                $androidDeviceOwnerEnrollmentProfile = Get-MgBetaDeviceManagementAndroidDeviceOwnerEnrollmentProfile `
                    -AndroidDeviceOwnerEnrollmentProfileId $Id `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $androidDeviceOwnerEnrollmentProfile)
            {
                Write-Verbose -Message 'Trying to retrieve profile by DisplayName'
                $androidDeviceOwnerEnrollmentProfile = Get-MgBetaDeviceManagementAndroidDeviceOwnerEnrollmentProfile `
                    -All `
                    -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                    -ErrorAction SilentlyContinue
            }

            if ($null -eq $androidDeviceOwnerEnrollmentProfile)
            {
                Write-Verbose -Message "No AndroidDeviceOwnerEnrollmentProfile with {$Id} was found."
                return $nullResult
            }
        }
        else
        {
            $androidDeviceOwnerEnrollmentProfile = $Script:exportedInstance
        }

        $tokenExpirationDateTimeString = $androidDeviceOwnerEnrollmentProfile.TokenExpirationDateTime
        if ($tokenExpirationDateTimeString -is [System.DateTime])
        {
            $tokenExpirationDateTimeString = $tokenExpirationDateTimeString.ToString('yyyy-MM-ddTHH:mm:ssZ')
        }
        elseif (-not [string]::IsNullOrEmpty($tokenExpirationDateTimeString))
        {
            $tokenExpirationDateTimeString = [System.DateTime]::Parse($tokenExpirationDateTimeString).ToString('yyyy-MM-ddTHH:mm:ssZ')
        }

        $results = @{
            Id                      = $androidDeviceOwnerEnrollmentProfile.Id
            DisplayName             = $androidDeviceOwnerEnrollmentProfile.DisplayName
            AccountId               = $androidDeviceOwnerEnrollmentProfile.AccountId
            ConfigureWifi           = $androidDeviceOwnerEnrollmentProfile.ConfigureWifi
            Description             = $androidDeviceOwnerEnrollmentProfile.Description
            EnrollmentMode          = $androidDeviceOwnerEnrollmentProfile.EnrollmentMode.ToString()
            EnrollmentTokenType     = $androidDeviceOwnerEnrollmentProfile.EnrollmentTokenType.ToString()
            IsTeamsDeviceProfile    = $androidDeviceOwnerEnrollmentProfile.IsTeamsDeviceProfile
            RoleScopeTagIds         = $androidDeviceOwnerEnrollmentProfile.RoleScopeTagIds
            TokenExpirationDateTime = $tokenExpirationDateTimeString
            WifiHidden              = $androidDeviceOwnerEnrollmentProfile.WifiHidden
            WifiPassword            = $androidDeviceOwnerEnrollmentProfile.WifiPassword
            WifiSecurityType        = $androidDeviceOwnerEnrollmentProfile.WifiSecurityType.ToString()
            WifiSsid                = $androidDeviceOwnerEnrollmentProfile.WifiSsid
            Ensure                  = 'Present'
            Credential              = $Credential
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            CertificateThumbprint   = $CertificateThumbprint
            CertificatePath         = $CertificatePath
            CertificatePassword     = $CertificatePassword
            ManagedIdentity         = $ManagedIdentity.IsPresent
            AccessTokens            = $AccessTokens
        }

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
        [ValidateSet('corporateOwnedDedicatedDevice', 'corporateOwnedFullyManaged', 'corporateOwnedWorkProfile', 'corporateOwnedAOSPUserlessDevice', 'corporateOwnedAOSPUserAssociatedDevice')]
        [System.String]
        $EnrollmentMode,

        [Parameter()]
        [ValidateSet('default', 'corporateOwnedDedicatedDeviceWithAzureADSharedMode', 'deviceStaging')]
        [System.String]
        $EnrollmentTokenType,

        [Parameter()]
        [System.Boolean]
        $IsTeamsDeviceProfile,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $TokenExpirationDateTime,

        [Parameter()]
        [System.Boolean]
        $WifiHidden,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $WifiPassword,

        [Parameter()]
        [ValidateSet('none', 'wpa', 'wep' )]
        [System.String]
        $WifiSecurityType,

        [Parameter()]
        [System.String]
        $WifiSsid,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters
    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $setParameters = Rename-M365DSCCimInstanceParameter -Properties $setParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Create AndroidDeviceOwnerEnrollmentProfile: $DisplayName with Enrollment Mode: $EnrollmentMode"
        $setParameters.Remove('Id') | Out-Null
        $null = New-MgBetaDeviceManagementAndroidDeviceOwnerEnrollmentProfile -BodyParameter $setParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating AndroidDeviceOwnerEnrollmentProfile: $DisplayName"
        Remove-MgBetaDeviceManagementAndroidDeviceOwnerEnrollmentProfile -AndroidDeviceOwnerEnrollmentProfileId $currentInstance.Id
        $null = New-MgBetaDeviceManagementAndroidDeviceOwnerEnrollmentProfile -BodyParameter $setParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AndroidDeviceOwnerEnrollmentProfile: $DisplayName"
        Remove-MgBetaDeviceManagementAndroidDeviceOwnerEnrollmentProfile -AndroidDeviceOwnerEnrollmentProfileId $currentInstance.Id
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
        [ValidateSet('corporateOwnedDedicatedDevice', 'corporateOwnedFullyManaged', 'corporateOwnedWorkProfile', 'corporateOwnedAOSPUserlessDevice', 'corporateOwnedAOSPUserAssociatedDevice')]
        [System.String]
        $EnrollmentMode,

        [Parameter()]
        [ValidateSet('default', 'corporateOwnedDedicatedDeviceWithAzureADSharedMode', 'deviceStaging')]
        [System.String]
        $EnrollmentTokenType,

        [Parameter()]
        [System.Boolean]
        $IsTeamsDeviceProfile,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $TokenExpirationDateTime,

        [Parameter()]
        [System.Boolean]
        $WifiHidden,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $WifiPassword,

        [Parameter()]
        [ValidateSet('none', 'wpa', 'wep' )]
        [System.String]
        $WifiSecurityType,

        [Parameter()]
        [System.String]
        $WifiSsid,

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
        # Exclude profiles with Microsoft internal enrollment mode (EnrollmentMode 5) from export
        # as it cannot be managed. Example is "Default enrollment profile for personally-owned work profile devices"
        [array] $Script:exportedInstances = Get-MgBetaDeviceManagementAndroidDeviceOwnerEnrollmentProfile `
            -All `
            -ErrorAction Stop | Where-Object EnrollmentMode -NE 5

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            $displayedKey = $config.DisplayName
            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('AccountId', 'TokenExpirationDateTime')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
