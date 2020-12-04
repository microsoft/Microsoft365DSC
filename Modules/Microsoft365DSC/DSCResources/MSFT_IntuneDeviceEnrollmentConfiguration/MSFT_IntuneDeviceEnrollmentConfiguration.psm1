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
        $AndroidForWorkPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $AndroidForWorkPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $AndroidForWorkOSMinimumVersion,

        [Parameter()]
        [System.String]
        $AndroidForWorkOSMaximumVersion,

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
            Write-Verbose -Message "No Device Enrollment Restriction {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Enrollment Restriction with Name {$DisplayName}"
        return @{
            DisplayName        = $category.displayName
            Description        = $category.description
            Ensure             = "Present"
            GlobalAdminAccount = $GlobalAdminAccount
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
        $AndroidForWorkPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $AndroidForWorkPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $AndroidForWorkOSMinimumVersion,

        [Parameter()]
        [System.String]
        $AndroidForWorkOSMaximumVersion,

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
    Write-Verbose -Message "Updating Teams Upgrade Policy {$Identity}"

    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $currentCategory = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Device Category {$DisplayName}"
        New-DeviceManagement_DeviceCategories -displayName $DisplayName `
            -description $Description
    }
    elseif ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Device Category {$DisplayName}"
        $category = Get-DeviceManagement_DeviceCategories -Filter "displayName eq '$DisplayName'"
        Update-DeviceManagement_DeviceCategories -deviceCategoryId $category.id `
            -displayName $DisplayName -description $Description
    }
    elseif ($Ensure -eq 'Absent' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Category {$DisplayName}"
        $category = Get-DeviceManagement_DeviceCategories -Filter "displayName eq '$DisplayName'"
        Remove-DeviceManagement_DeviceCategories -deviceCategoryId $category.id
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
        $AndroidForWorkPlatformBlocked,

        [Parameter()]
        [System.Boolean]
        $AndroidForWorkPersonalDeviceEnrollmentBlocked,

        [Parameter()]
        [System.String]
        $AndroidForWorkOSMinimumVersion,

        [Parameter()]
        [System.String]
        $AndroidForWorkOSMaximumVersion,

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
    Write-Verbose -Message "Testing configuration of Device Category {$DisplayName}"

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
            $content += "        IntuneDeviceEnrollmentRestriction " + (New-Guid).ToString() + "`r`n"
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
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $GlobalAdminAccount)
            {
                $tenantIdValue = $GlobalAdminAccount.UserName.Split('@')[1]
            }
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

Export-ModuleMember -Function *-TargetResource
