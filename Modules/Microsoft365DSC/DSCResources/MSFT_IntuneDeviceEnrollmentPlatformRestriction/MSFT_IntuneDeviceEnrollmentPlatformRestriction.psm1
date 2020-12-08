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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Checking for the Intune Device Enrollment Restriction {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $config = Get-IntuneDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }

        if ($null -eq $config)
        {
            Write-Verbose -Message "No Device Enrollment Platform Restriction {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Enrollment Platform Restriction with Name {$DisplayName}"
        return @{
            DisplayName                                  = $config.DisplayName
            Description                                  = $config.Description
            AndroidPlatformBlocked                       = $config.androidRestriction.PlatformBlocked
            AndroidPersonalDeviceEnrollmentBlocked       = $config.androidRestriction.PersonalDeviceEnrollmentBlocked
            AndroidOSMinimumVersion                      = $config.androidRestriction.OSMinimumVersion
            AndroidOSMaximumVersion                      = $config.androidRestriction.OSMaximumVersion
            iOSPlatformBlocked                           = $config.iOSRestriction.PlatformBlocked
            iOSPersonalDeviceEnrollmentBlocked           = $config.iOSRestriction.PersonalDeviceEnrollmentBlocked
            iOSOSMinimumVersion                          = $config.iOSRestriction.OSMinimumVersion
            iOSOSMaximumVersion                          = $config.iOSRestriction.OSMaximumVersion
            MacPlatformBlocked                           = $config.macOSRestriction.PlatformBlocked
            MacPersonalDeviceEnrollmentBlocked           = $config.macOSRestriction.PersonalDeviceEnrollmentBlocked
            MacOSMinimumVersion                          = $config.macOSRestriction.OSMinimumVersion
            MacOSMaximumVersion                          = $config.macOSRestriction.OSMaximumVersion
            WindowsPlatformBlocked                       = $config.windowsRestriction.PlatformBlocked
            WindowsPersonalDeviceEnrollmentBlocked       = $config.windowsRestriction.PersonalDeviceEnrollmentBlocked
            WindowsOSMinimumVersion                      = $config.windowsRestriction.OSMinimumVersion
            WindowsOSMaximumVersion                      = $config.windowsRestriction.OSMaximumVersion
            WindowsMobilePlatformBlocked                 = $config.windowsMobileRestriction.PlatformBlocked
            WindowsMobilePersonalDeviceEnrollmentBlocked = $config.windowsMobileRestriction.PersonalDeviceEnrollmentBlocked
            WindowsMobileOSMinimumVersion                = $config.windowsMobileRestriction.OSMinimumVersion
            WindowsMobileOSMaximumVersion                = $config.windowsMobileRestriction.OSMaximumVersion
            Ensure                                       = "Present"
            GlobalAdminAccount                           = $GlobalAdminAccount
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $currentCategory = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Enrollment Platform Restriction {$DisplayName}"
        $JsonContent = Get-M365DSCIntuneDeviceEnrollmentPlatformRestrictionJSON -Parameters $PSBoundParameters
        New-M365DSCIntuneDeviceEnrollmentPlatformRestriction -JSONContent $JsonContent
    }
    elseif ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Device Enrollment Platform Restriction {$DisplayName}"
        $config = Get-IntuneDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }
        $JsonContent = Get-M365DSCIntuneDeviceEnrollmentPlatformRestrictionJSON -Parameters $PSBoundParameters
        Set-M365DSCIntuneDeviceEnrollmentPlatformRestriction -JSONContent $JsonContent `
            -RestrictionId $config.id
    }
    elseif ($Ensure -eq 'Absent' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Enrollment Platform Restriction {$DisplayName}"
        $config = Get-IntuneDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }

        Remove-IntuneDeviceEnrollmentConfiguration -deviceEnrollmentConfigurationId $config.id
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

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Testing configuration of Device Enrollment Platform Restriction {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    try
    {
        [array]$configs = Get-IntuneDeviceEnrollmentConfiguration -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration' }
        $i = 1
        $content = ''
        Write-Host "`r`n" -NoNewline
        foreach ($config in $configs)
        {
            Write-Host "    |---[$i/$($configs.Count)] $($config.displayName)" -NoNewline
            $params = @{
                DisplayName        = $config.displayName
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        IntuneDeviceEnrollmentPlatformRestriction " + (New-Guid).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $content
    }
    catch
    {
        if ($_.Exception -like '*401*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered for Intune."
        }
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
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

function Get-M365DSCIntuneDeviceEnrollmentPlatformRestrictionJSON
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Parameters
    )

    $JsonContent = @"
    {
        "@odata.type":"#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration",
        "displayName":"$($Parameters.DisplayName)",
        "description":"$($Parameters.Description)",
        "androidRestriction":{
            "platformBlocked":$($Parameters.AndroidPlatformBlocked.ToString().ToLower()),
            "personalDeviceEnrollmentBlocked":$($Parameters.AndroidPersonalDeviceEnrollmentBlocked.ToString().ToLower()),
            "osMinimumVersion":"$($Parameters.AndroidOSMinimumVersion)",
            "osMaximumVersion":"$($Parameters.AndroidOSMaximumVersion)"
        },
        "iosRestriction":{
            "platformBlocked":$($Parameters.iOSPlatformBlocked.ToString().ToLower()),
            "personalDeviceEnrollmentBlocked":$($Parameters.iOSPersonalDeviceEnrollmentBlocked.ToString().ToLower()),
            "osMinimumVersion":"$($Parameters.iOSOSMinimumVersion)",
            "osMaximumVersion":"$($Parameters.iOSOSMaximumVersion)"
        },
        "macRestriction":{
            "platformBlocked":$($Parameters.MacPlatformBlocked.ToString().ToLower()),
            "personalDeviceEnrollmentBlocked":$($Parameters.MacPersonalDeviceEnrollmentBlocked.ToString().ToLower()),
            "osMinimumVersion":"$($Parameters.MacOSMinimumVersion)",
            "osMaximumVersion":"$($Parameters.MacOSMaximumVersion)"
        },
        "windowsRestriction":{
            "platformBlocked":$($Parameters.WindowsPlatformBlocked.ToString().ToLower()),
            "personalDeviceEnrollmentBlocked":$($Parameters.WindowsPersonalDeviceEnrollmentBlocked.ToString().ToLower()),
            "osMinimumVersion":"$($Parameters.WindowsOSMinimumVersion)",
            "osMaximumVersion":"$($Parameters.WindowsOSMaximumVersion)"
        },
        "windowsMobileRestriction":{
            "platformBlocked":$($Parameters.WindowsMobilePlatformBlocked.ToString().ToLower()),
            "personalDeviceEnrollmentBlocked":$($Parameters.WindowsMobilePersonalDeviceEnrollmentBlocked.ToString().ToLower()),
            "osMinimumVersion":"$($Parameters.WindowsMobileOSMinimumVersion)",
            "osMaximumVersion":"$($Parameters.WindowsMobileOSMaximumVersion)"
        }
    }
"@
    return $JsonContent
}

function New-M365DSCIntuneDeviceEnrollmentPlatformRestriction
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $JsonContent
    )

    try
    {
        Write-Verbose -Message "Creating new Device Enrollment Platform Restriction with payload {$JsonContent}"
        $Url = "https://graph.microsoft.com/Beta/deviceManagement/deviceEnrollmentConfigurations/"
        Invoke-MSGraphRequest -Url $Url `
            -HttpMethod POST `
            -Headers @{'Content-Type' = 'application/json' } `
            -Content $JsonContent
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

function Set-M365DSCIntuneDeviceEnrollmentPlatformRestriction
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $JsonContent,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RestrictionId
    )

    try
    {
        Write-Verbose -Message "Updating Device Enrollment Platform Restriction with payload {$JsonContent}"
        $Url = "https://graph.microsoft.com/Beta/deviceManagement/deviceEnrollmentConfigurations/$RestrictionId"
        Invoke-MSGraphRequest -Url $Url `
            -HttpMethod PATCH `
            -Headers @{'Content-Type' = 'application/json' } `
            -Content $JsonContent
    }
    catch
    {
        Write-Verbose -Message $_
        $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $tenantIdValue
    }
}

Export-ModuleMember -Function *-TargetResource
