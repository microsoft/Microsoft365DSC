function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $BlockUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForClients = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    if ('Absent' -eq $Ensure)
    {
        throw "EXOAtpPolicyForO365 configurations MUST specify Ensure value of 'Present'"
    }

    if ('Default' -ne $Identity)
    {
        throw "EXOAtpPolicyForO365 configurations MUST specify Identity value of 'Default'"
    }

    Write-Verbose "Get-TargetResource will attempt to retrieve AtpPolicyForO365 $($Identity)"
    Write-Verbose 'Calling Connect-ExchangeOnline function:'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount -CommandsToImport '*AtpPolicyForO365'
    Write-Verbose 'Global ExchangeOnlineSession status:'
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Get-AtpPolicyForO365'
    try
    {
        $AtpPolicies = Get-AtpPolicyForO365
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    $AtpPolicyForO365 = $AtpPolicies | Where-Object Identity -eq $Identity
    if (-NOT $AtpPolicyForO365)
    {
        Write-Verbose "AtpPolicyForO365 $($Identity) does not exist."
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
            if ($null -ne $AtpPolicyForO365.$KeyName)
            {
                $result += @{
                    $KeyName = $AtpPolicyForO365.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose "Found AtpPolicyForO365 $($Identity)"
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $BlockUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForClients = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    if ('Absent' -eq $Ensure)
    {
        throw "EXOAtpPolicyForO365 configurations MUST specify Ensure value of 'Present'"
    }

    if ('Default' -ne $Identity)
    {
        throw "EXOAtpPolicyForO365 configurations MUST specify Identity value of 'Default'"
    }

    Write-Verbose 'Entering Set-TargetResource'
    Write-Verbose 'Calling Connect-ExchangeOnline function:'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount -CommandsToImport '*AtpPolicyForO365'
    Write-Verbose 'Global ExchangeOnlineSession status:'
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    $CmdletIsAvailable = Confirm-ImportedCmdletIsAvailable -CmdletName 'Set-AtpPolicyForO365'
    $AtpPolicyParams = $PSBoundParameters
    $AtpPolicyParams.Remove('Ensure') | out-null
    $AtpPolicyParams.Remove('GlobalAdminAccount') | out-null
    $AtpPolicyParams.Remove('IsSingleInstance') | out-null
    try
    {
        Write-Verbose "Setting AtpPolicyForO365 $Identity with values: $($AtpPolicyParams | Out-String)"
        Set-AtpPolicyForO365 @AtpPolicyParams
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    Write-Verbose 'Closing Remote PowerShell Sessions'
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    Write-Verbose 'Global ExchangeOnlineSession status: '
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter()]
        [System.String]
        $Identity = 'Default',

        [Parameter()]
        [Boolean]
        $AllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $BlockUrls = @(),

        [Parameter()]
        [Boolean]
        $EnableATPForSPOTeamsODB = $false,

        [Parameter()]
        [Boolean]
        $EnableSafeLinksForClients = $false,

        [Parameter()]
        [Boolean]
        $TrackClicks = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing AtpPolicyForO365 for $($Identity)"
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | out-null
    $ValuesToCheck.Remove('IsSingleInstance') | out-null
    $ValuesToCheck.Remove('Verbose') | out-null
    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys
    if ($TestResult)
    {
        Write-Verbose 'Test-TargetResource returned True'
        Write-Verbose 'Closing Remote PowerShell Sessions'
        $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
        Write-Verbose 'Global ExchangeOnlineSession status: '
        Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    }
    else
    {
        Write-Verbose 'Test-TargetResource returned False'
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
        [ValidateSet('Yes')]
        [String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $IsSingleInstance = 'Yes'
    $result = Get-TargetResource @PSBoundParameters
    Write-Verbose 'Closing Remote PowerShell Sessions'
    $ClosedPSSessions = (Get-PSSession | Remove-PSSession)
    $result.GlobalAdminAccount = Resolve-Credentials -UserName $GlobalAdminAccount.UserName
    $content = "        EXOAtpPolicyForO365 " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'GlobalAdminAccount'
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
