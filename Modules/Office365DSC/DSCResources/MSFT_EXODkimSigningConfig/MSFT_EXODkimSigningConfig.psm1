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

    Write-Verbose -Message "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

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
        New-Office365DSCLogEntry -Error $_ -Message $Message
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
            Ensure = 'Present'
        }
        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object -FilterScript { $_ -ne 'Ensure' }))
        {
            if ($null -ne $DkimSigningConfig.$KeyName)
            {
                $result += @{
                    $KeyName = $DkimSigningConfig.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose -Message "Found DkimSigningConfig $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
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

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

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
        Write-Verbose -Message "Setting DkimSigningConfig $($Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $DkimSigningConfigParams)"
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

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        EXODkimSigningConfig " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
