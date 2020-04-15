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
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $BodyCanonicalization = 'Relaxed',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $HeaderCanonicalization = 'Relaxed',

        [Parameter()]
        [ValidateSet(1024)]
        [uint16]
        $KeySize = 1024,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of DkimSigningConfig for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    Write-Verbose -Message "Global ExchangeOnlineSession status:"
    Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

    try
    {
        $DkimSigningConfigs = Get-DkimSigningConfig
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        $Message = "Error calling {Get-DkimSigningConfig}"
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
    }
    $DkimSigningConfig = $DkimSigningConfigs | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if (-not $DkimSigningConfig)
    {
        Write-Verbose -Message "DkimSigningConfig $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure                 = 'Present'
            Identity               = $Identity
            AdminDisplayName       = $DkimSigningConfig.AdminDisplayName
            BodyCanonicalization   = $DkimSigningConfig.BodyCanonicalization
            Enabled                = $DkimSigningConfig.Enabled
            HeaderCanonicalization = $DkimSigningConfig.HeaderCanonicalization
            KeySize                = 1024
            GlobalAdminAccount     = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found DkimSigningConfig $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $BodyCanonicalization = 'Relaxed',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $HeaderCanonicalization = 'Relaxed',

        [Parameter()]
        [ValidateSet(1024)]
        [uint16]
        $KeySize = 1024,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of DkimSigningConfig for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $DkimSigningConfigs = Get-DkimSigningConfig

    $DkimSigningConfig = $DkimSigningConfigs | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if (('Present' -eq $Ensure ) -and ($null -eq $DkimSigningConfig))
    {
        $DkimSigningConfigParams = $PSBoundParameters
        $DkimSigningConfigParams.Remove('Ensure') | Out-Null
        $DkimSigningConfigParams.Remove('GlobalAdminAccount') | Out-Null
        $DkimSigningConfigParams += @{
            DomainName = $PSBoundParameters.Identity
        }
        $DkimSigningConfigParams.Remove('Identity') | Out-Null
        Write-Verbose -Message "Creating DkimSigningConfig $($Identity)."
        New-DkimSigningConfig @DkimSigningConfigParams
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $DkimSigningConfig))
    {
        $DkimSigningConfigParams = $PSBoundParameters
        $DkimSigningConfigParams.Remove('Ensure') | Out-Null
        $DkimSigningConfigParams.Remove('GlobalAdminAccount') | Out-Null
        $DkimSigningConfigParams.Remove('KeySize') | Out-Null
        Write-Verbose -Message "Setting DkimSigningConfig $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $DkimSigningConfigParams)"
        Set-DkimSigningConfig @DkimSigningConfigParams -Confirm:$false
    }

    if (('Absent' -eq $Ensure ) -and ($DkimSigningConfig))
    {
        Write-Verbose -Message "Removing DkimSigningConfig $($Identity) "
        Remove-DkimSigningConfig -Identity $Identity -Confirm:$false
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
        $AdminDisplayName,

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $BodyCanonicalization = 'Relaxed',

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [ValidateSet('Simple', 'Relaxed')]
        [System.String]
        $HeaderCanonicalization = 'Relaxed',

        [Parameter()]
        [ValidateSet(1024)]
        [uint16]
        $KeySize = 1024,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of DkimSigningConfig for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
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
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-DkimSigningConfig)
    {
        $DkimSigningConfigs = Get-DkimSigningConfig

        $i = 1
        $content = ""
        $organization = ""
        $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
        if ($GlobalAdminAccount.UserName.Contains("@"))
        {
            $organization = $GlobalAdminAccount.UserName.Split("@")[1]

            if ($organization.IndexOf(".") -gt 0)
            {
                $principal = $organization.Split(".")[0]
            }
        }
        foreach ($DkimSigningConfig in $DkimSigningConfigs)
        {
            Write-Verbose -Message "    - [$i/$($DkimSigningConfigs.Length)] $($DkimSigningConfig.Identity)}"
            $params = @{
                Identity           = $DkimSigningConfig.Identity
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        EXODkimSigningConfig " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($organization), "`$OrganizationName"
            }
            if ($partialContent.ToLower().IndexOf($principal.ToLower() + ".") -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape($principal + "."), "`$(`$OrganizationName.Split('.')[0])."
            }
            $content += Convert-DSCStringParamToVariable -DSCBlock $partialContent -ParameterName 'GlobalAdminAccount'
            $content += "        }`r`n"
            $i++
        }
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
