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
        [ValidateRange(1, 15)]
        [System.UInt32]
        $Limit,

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

    Write-Verbose -Message "Checking for the Intune Device Enrollment Limit Restriction {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Platform 'Intune' `
        -InboundParameters $PSBoundParameters

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $config = Get-IntuneDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentLimitConfiguration' }

        if ($null -eq $config)
        {
            Write-Verbose -Message "No Device Enrollment Limit Restriction {$DisplayName} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found Device Enrollment Limit Restriction with Name {$DisplayName}"
        return @{
            DisplayName        = $config.DisplayName
            Description        = $config.Description
            Limit              = $config.Limit
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
        [ValidateRange(1, 15)]
        [System.UInt32]
        $Limit,

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
        Write-Verbose -Message "Creating new Device Enrollment Limit Restriction {$DisplayName}"
        $JsonContent = Get-M365DSCIntuneDeviceEnrollmentLimitRestrictionJSON -Parameters $PSBoundParameters
        New-M365DSCIntuneDeviceEnrollmentLimitRestriction -JSONContent $JsonContent
    }
    elseif ($Ensure -eq 'Present' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Device Enrollment Limit Restriction {$DisplayName}"
        $config = Get-IntuneDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentLimitConfiguration' }
        $JsonContent = Get-M365DSCIntuneDeviceEnrollmentLimitRestrictionJSON -Parameters $PSBoundParameters
        Set-M365DSCIntuneDeviceEnrollmentLimitRestriction -JSONContent $JsonContent `
            -RestrictionId $config.id
    }
    elseif ($Ensure -eq 'Absent' -and $currentCategory.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Device Enrollment Limit Restriction {$DisplayName}"
        $config = Get-IntuneDeviceEnrollmentConfiguration -Filter "displayName eq '$DisplayName'" | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentLimitConfiguration' }

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
        [ValidateRange(1, 15)]
        [System.UInt32]
        $Limit,

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
    Write-Verbose -Message "Testing configuration of Device Enrollment Limit Restriction {$DisplayName}"

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
        [array]$configs = Get-IntuneDeviceEnrollmentConfiguration -ErrorAction Stop | Where-Object -FilterScript { $_.'@odata.type' -eq '#microsoft.graph.deviceEnrollmentLimitConfiguration' }
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
            $content += "        IntuneDeviceEnrollmentLimitRestriction " + (New-Guid).ToString() + "`r`n"
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

function Get-M365DSCIntuneDeviceEnrollmentLimitRestrictionJSON
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
        "@odata.type":"#microsoft.graph.deviceEnrollmentLimitConfiguration",
        "displayName":"$($Parameters.DisplayName)",
        "description":"$($Parameters.Description)",
        "limit":$($Parameters.Limit.TOString())
    }
"@
    return $JsonContent
}

function New-M365DSCIntuneDeviceEnrollmentLimitRestriction
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $JsonContent
    )

    try
    {
        Write-Verbose -Message "Creating new Device Enrollment Limit Restriction with payload {$JsonContent}"
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

function Set-M365DSCIntuneDeviceEnrollmentLimitRestriction
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
        Write-Verbose -Message "Updating Device Enrollment Limit Restriction with payload {$JsonContent}"
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
