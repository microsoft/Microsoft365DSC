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
        $Description,

        [Parameter()]
        [System.String]
        $NumberPattern,

        [Parameter()]
        [System.String[]]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.String[]]
        $OnlinePstnUsages,

        [Parameter()]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting the Voice Route {$Identity}"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    $nullReturn = @{
        Identity           = $Identity
        Ensure             = 'Absent'
        GlobalAdminAccount = $GlobalAdminAccount
    }
    try
    {
        $route = Get-CsOnlineVoiceRoute -Identity $Identity -ErrorAction 'SilentlyContinue'

        if ($null -eq $route)
        {
            Write-Verbose -Message "Could not find Voice Route {$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Voice Route {$Identity}"
        return @{
            Identity              = $Identity
            Description           = $route.Description
            NumberPattern         = $route.NumberPattern
            OnlinePstnGatewayList = $route.OnlinePstnGatewayList
            OnlinePstnUsages      = $route.OnlinePstnUsages
            Priority              = $route.Priority
            Ensure                = 'Present'
            GlobalAdminAccount    = $GlobalAdminAccount
        }
    }
    catch
    {
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
        return $nullReturn
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
        $Description,

        [Parameter()]
        [System.String]
        $NumberPattern,

        [Parameter()]
        [System.String[]]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.String[]]
        $OnlinePstnUsages,

        [Parameter()]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    # Validate that the selected PSTN usages exist in the environment
    $existingUsages = Get-CsOnlinePstnUsage | Select-Object -ExpandProperty Usage
    $notFoundUsageList = @()
    foreach ($usage in $OnlinePstnUsages)
    {
        if ( -not ($existingUsages -match $usage))
        {
            $notFoundUsageList += $usage
        }
    }

    if ($notFoundUsageList)
    {
        $notFoundUsages = $notFoundUsageList -join ","
        throw "Please create the PSTN Usage(s) ($notFoundUsages) using `"TeamsPstnUsage`""
    }

    # Validate that the selected PSTN gateway exists in the environment
    $existingGateways = Get-CsOnlinePstnGateway | Select-Object -ExpandProperty Identity
    $notFoundGatewayList = @()
    foreach ($gateway in $OnlinePstnGatewayList)
    {
        if ( -not ($existingGateways -match $gateway))
        {
            $notFoundGatewayList += $gateway
        }
    }

    if ($notFoundUsageList)
    {
        $notFoundGateways = $notFoundGatewayList -join ","
        throw "Please create the Voice Gateway object(s) ($notFoundGateways) using `"TeamsVoiceRoute`""
    }

    Write-Verbose -Message "Setting Voice Route {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("GlobalAdminAccount") | Out-Null

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Voice Route {$Identity}"
        New-CsOnlineVoiceRoute @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        <#
            If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
            into the Set-CsOnlineVoiceRoute cmdlet.
        #>
        Write-Verbose -Message "Updating settings for Voice Route {$Identity}"
        Set-CsOnlineVoiceRoute @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Voice Route {$Identity}"
        Remove-CsOnlineVoiceRoute -Identity $Identity -Confirm:$false
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
        $Description,

        [Parameter()]
        [System.String]
        $NumberPattern,

        [Parameter()]
        [System.String[]]
        $OnlinePstnGatewayList,

        [Parameter()]
        [System.String[]]
        $OnlinePstnUsages,

        [Parameter()]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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

    Write-Verbose -Message "Testing configuration of Voice Route {$Identity}"

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
    $InformationPreference = 'Continue'

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    try
    {
        $i = 1
        [array]$routes = Get-CsOnlineVoiceRoute -ErrorAction Stop
        $content = ''
        Write-Host "`r`n" -NoNewline
        foreach ($route in $routes)
        {
            Write-Host "    |---[$i/$($routes.Count)] $($route.Identity)" -NoNewline
            $params = @{
                Identity           = $route.Identity
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        TeamsVoiceRoute " + (New-Guid).ToString() + "`r`n"
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
