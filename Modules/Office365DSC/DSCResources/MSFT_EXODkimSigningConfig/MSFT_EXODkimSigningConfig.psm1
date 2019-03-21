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
    Write-Verbose "Get-TargetResource will attempt to retrieve DkimSigningConfig $($Identity)"
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Get-DkimSigningConfig'
    try
    {
        $DkimSigningConfigs = Get-DkimSigningConfig
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }
    $DkimSigningConfig = $DkimSigningConfigs | Where-Object Identity -eq $Identity
    if (-NOT $DkimSigningConfig)
    {
        Write-Verbose "DkimSigningConfig $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }
        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object {$_ -ne 'Ensure'}) )
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

        Write-Verbose "Found DkimSigningConfig $($Identity)"
        Write-Verbose "Get-TargetResource Result: `n $($result | Out-String)"
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
    Write-Verbose 'Entering Set-TargetResource'
    Write-Verbose 'Retrieving information about DkimSigningConfig configuration'
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'New-DkimSigningConfig'
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Set-DkimSigningConfig'
    try
    {
        $DkimSigningConfigs = Get-DkimSigningConfig
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    $DkimSigningConfig = $DkimSigningConfigs | Where-Object Identity -eq $Identity

    if ( ('Present' -eq $Ensure ) -and (-NOT $DkimSigningConfig) )
    {
        try
        {
            $DkimSigningConfigParams = $PSBoundParameters
            $DkimSigningConfigParams.Remove('Ensure') | Out-Null
            $DkimSigningConfigParams.Remove('GlobalAdminAccount') | Out-Null
            $DkimSigningConfigParams += @{
                DomainName = $PSBoundParameters.Identity
            }
            $DkimSigningConfigParams.Remove('Identity') | Out-Null
            New-DkimSigningConfig @DkimSigningConfigParams -Confirm:$false
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        }
    }
    elseif ( ('Present' -eq $Ensure ) -and ($DkimSigningConfig) )
    {
        try
        {
            $DkimSigningConfigParams = $PSBoundParameters
            $DkimSigningConfigParams.Remove('Ensure') | Out-Null
            $DkimSigningConfigParams.Remove('GlobalAdminAccount') | Out-Null
            $DkimSigningConfigParams.Remove('KeySize') | Out-Null
            Set-DkimSigningConfig @DkimSigningConfigParams -Confirm:$false
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        }
    }

    if ( ('Absent' -eq $Ensure ) -and ($DkimSigningConfig) )
    {
        Write-Verbose "Removing DkimSigningConfig $($Identity) "
        try
        {
            Remove-DkimSigningConfig -Identity $Identity -Confirm:$false
        }
        catch
        {
            Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        }
    }

    Write-Verbose "Closing Remote PowerShell Sessions"
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    Write-Verbose "Global ExchangeOnlineSession status: `n"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
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
    Write-Verbose -Message "Testing DkimSigningConfig for $($Identity)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $DkimSigningConfigTestParams = $PSBoundParameters
    $DkimSigningConfigTestParams.Remove('GlobalAdminAccount') | out-null
    $DkimSigningConfigTestParams.Remove('KeySize') | out-null
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $DkimSigningConfigTestParams.Keys
    if ($TestResult)
    {
        Write-Verbose 'Closing Remote PowerShell Sessions'
        $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
        Write-Verbose "Global ExchangeOnlineSession status: `n"
        Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    }

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
    Write-Verbose 'Closing Remote PowerShell Sessions'
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    Write-Verbose "Global ExchangeOnlineSession status: `n"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXODkimSigningConfig " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
