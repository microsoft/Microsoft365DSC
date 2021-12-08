function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AndroidPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $AndroidPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $AndroidOSMinimumVersion,

        [Parameter()]
        [System.String]
        $AndroidOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $iOSPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $iOSPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $iOSOSMinimumVersion,

        [Parameter()]
        [System.String]
        $iOSOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $MacPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $MacPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $MacOSMinimumVersion,

        [Parameter()]
        [System.String]
        $MacOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $WindowsPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $WindowsOSMinimumVersion,

        [Parameter()]
        [System.String]
        $WindowsOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $WindowsMobilePlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsMobilePersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $WindowsMobileOSMinimumVersion,

        [Parameter()]
        [System.String]
        $WindowsMobileOSMaximumVersion,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Write-Verbose -Message "Checking for the Intune Device Enrollment Restriction {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $config = Get-MgDeviceManagementDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }

        if ($null -eq $config)
        {
            Write-Verbose -Message "No Device Enrollment Platform Restriction {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Enrollment Platform Restriction with Name {$DisplayName}"
        return @{
            DisplayName                                  = $config.DisplayName
            Description                                  = $config.Description
            AndroidPlatformBlocked                       = $config.AdditionalProperties.androidRestriction.platformBlocked
            AndroidPersonalDeviceEnrollmentBlocked       = $config.AdditionalProperties.androidRestriction.personalDeviceEnrollmentBlocked
            AndroidOSMinimumVersion                      = $config.AdditionalProperties.androidRestriction.osMinimumVersion
            AndroidOSMaximumVersion                      = $config.AdditionalProperties.androidRestriction.osMaximumVersion
            iOSPlatformBlocked                           = $config.AdditionalProperties.iosRestriction.platformBlocked
            iOSPersonalDeviceEnrollmentBlocked           = $config.AdditionalProperties.iosRestriction.personalDeviceEnrollmentBlocked
            iOSOSMinimumVersion                          = $config.AdditionalProperties.iosRestriction.osMinimumVersion
            iOSOSMaximumVersion                          = $config.AdditionalProperties.iosRestriction.osMaximumVersion
            MacPlatformBlocked                           = $config.AdditionalProperties.macOSRestriction.platformBlocked
            MacPersonalDeviceEnrollmentBlocked           = $config.AdditionalProperties.macOSRestriction.personalDeviceEnrollmentBlocked
            MacOSMinimumVersion                          = $config.AdditionalProperties.macOSRestriction.minimumVersion
            MacOSMaximumVersion                          = $config.AdditionalProperties.macOSRestriction.osMaximumVersion
            WindowsPlatformBlocked                       = $config.AdditionalProperties.windowsRestriction.platformBlocked
            WindowsPersonalDeviceEnrollmentBlocked       = $config.AdditionalProperties.windowsRestriction.personalDeviceEnrollmentBlocked
            WindowsOSMinimumVersion                      = $config.AdditionalProperties.windowsRestriction.osMinimumVersion
            WindowsOSMaximumVersion                      = $config.AdditionalProperties.windowsRestriction.osMaximumVersion
            WindowsMobilePlatformBlocked                 = $config.AdditionalProperties.windowsMobileRestriction.platformBlocked
            WindowsMobilePersonalDeviceEnrollmentBlocked = $config.AdditionalProperties.windowsMobileRestriction.personalDeviceEnrollmentBlocked
            WindowsMobileOSMinimumVersion                = $config.AdditionalProperties.windowsMobileRestriction.osMinimumVersion
            WindowsMobileOSMaximumVersion                = $config.AdditionalProperties.windowsMobileRestriction.osMaximumVersion
            Ensure                                       = "Present"
            Credential                           = $Credential
            ApplicationId                                = $ApplicationId
            TenantId                                     = $TenantId
            ApplicationSecret                            = $ApplicationSecret
            CertificateThumbprint                        = $CertificateThumbprint
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AndroidPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $AndroidPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $AndroidOSMinimumVersion,

        [Parameter()]
        [System.String]
        $AndroidOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $iOSPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $iOSPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $iOSOSMinimumVersion,

        [Parameter()]
        [System.String]
        $iOSOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $MacPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $MacPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $MacOSMinimumVersion,

        [Parameter()]
        [System.String]
        $MacOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $WindowsPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $WindowsOSMinimumVersion,

        [Parameter()]
        [System.String]
        $WindowsOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $WindowsMobilePlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsMobilePersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $WindowsMobileOSMinimumVersion,

        [Parameter()]
        [System.String]
        $WindowsMobileOSMaximumVersion,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentCategory = Get-TargetResource @PSBoundParameters
    $PSBoundParameters.Remove("Credential") | Out-Null
    $PSBoundParameters.Remove("ApplicationId") | Out-Null
    $PSBoundParameters.Remove("TenantId") | Out-Null
    $PSBoundParameters.Remove("ApplicationSecret") | Out-Null
    $PSBoundParameters.Remove("DisplayName") | Out-Null
    $PSBoundParameters.Remove("Description") | Out-Null

    if ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Enrollment Platform Restriction {$DisplayName}"

        $AdditionalProperties = Get-M365DSCIntuneDeviceEnrollmentPlatformRestrictionAdditionalProperties -Properties $PSBoundParameters

        New-MgDeviceManagementDeviceEnrollmentCOnfiguration -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties
    }
    elseif ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Device Enrollment Platform Restriction {$DisplayName}"
        $config = Get-MgDeviceManagementDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" `
            | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }
        $AdditionalProperties = Get-M365DSCIntuneDeviceEnrollmentPlatformRestrictionAdditionalProperties -Properties $PSBoundParameters
        Update-MgDeviceManagementDeviceEnrollmentConfiguration -DisplayName $DisplayName `
            -Description $Description `
            -AdditionalProperties $AdditionalProperties `
            -DeviceEnrollmentConfigurationId $config.id
    }
    elseif ($Ensure -eq 'Absent' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Enrollment Platform Restriction {$DisplayName}"
        $config = Get-MgDeviceManagementDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" `
            | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }

        Remove-MgDeviceManagementDeviceEnrollmentConfiguration -DeviceEnrollmentConfigurationId $config.id
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $AndroidPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $AndroidPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $AndroidOSMinimumVersion,

        [Parameter()]
        [System.String]
        $AndroidOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $iOSPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $iOSPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $iOSOSMinimumVersion,

        [Parameter()]
        [System.String]
        $iOSOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $MacPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $MacPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $MacOSMinimumVersion,

        [Parameter()]
        [System.String]
        $MacOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $WindowsPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $WindowsOSMinimumVersion,

        [Parameter()]
        [System.String]
        $WindowsOSMaximumVersion,

        [Parameter()]
        [System.Boolean]
        $WindowsMobilePlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $WindowsMobilePersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $WindowsMobileOSMinimumVersion,

        [Parameter()]
        [System.String]
        $WindowsMobileOSMaximumVersion,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure,

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
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Enrollment Platform Restriction {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$configs = Get-MgDeviceManagementDeviceEnrollmentConfiguration -ErrorAction Stop `
            | Where-Object -FilterScript { $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }
        $i = 1
        $dscContent = ''
        if ($configs.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        foreach ($config in $configs)
        {
            Write-Host "    |---[$i/$($configs.Count)] $($config.displayName)" -NoNewline
            $params = @{
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential    = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}


function Get-M365DSCIntuneDeviceEnrollmentPlatformRestrictionAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $results = @{
        "@odata.type" = "#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration"
        androidRestriction = @{
            platformBlocked = $Properties.AndroidPlatformBlocked
            personalDeviceEnrollmentBlocked = $Properties.AndroidPersonalDeviceEnrollmentBlocked
            osMinimumVersion = $Properties.AndroidOSMinimumVersion
            osMaximumVersion = $Properties.AndroidOSMaximumVersion
        }
        iosRestriction = @{
            platformBlocked = $Properties.iOSPlatformBlocked
            personalDeviceEnrollmentBlocked = $Properties.iOSPersonalDeviceEnrollmentBlocked
            osMinimumVersion = $Properties.iOSOSMinimumVersion
            osMaximumVersion = $Properties.iOSOSMaximumVersion
        }
        macOSRestriction = @{
            platformBlocked = $Properties.MacPlatformBlocked
            personalDeviceEnrollmentBlocked = $Properties.MacPersonalDeviceEnrollmentBlocked
            osminimumVersion = $Properties.MacOSMinimumVersion
            osMaximumVersion = $Properties.MacOSMaximumVersion
        }
        windowsRestriction = @{
            platformBlocked = $Properties.WindowsPlatformBlocked
            personalDeviceEnrollmentBlocked = $Properties.WindowsPersonalDeviceEnrollmentBlocked
            osMinimumVersion = $Properties.WindowsOSMinimumVersion
            osMaximumVersion = $Properties.WindowsOSMaximumVersion
        }
        windowsMobileRestriction = @{
            platformBlocked = $Properties.WindowsMobilePlatformBlocked
            personalDeviceEnrollmentBlocked = $Properties.WindowsMobilePersonalDeviceEnrollmentBlocked
            osMinimumVersion = $Properties.WindowsMobileOSMinimumVersion
            osMaximumVersion = $Properties.WindowsMobileOSMaximumVersion
        }
    }
    return $results
}

Export-ModuleMember -Function *-TargetResource
