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
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SafeLinksPolicy for $Identity"

    Write-Verbose -Message "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    Write-Verbose -Message "Global ExchangeOnlineSession status:"
    Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

    try
    {
        $SafeLinksPolicies = Get-SafeLinksPolicy
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        $Message = "Error calling {Get-SafeLinksPolicy}"
        New-Office365DSCLogEntry -Error $_ -Message $Message
    }

    $SafeLinksPolicy = $SafeLinksPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if (-not $SafeLinksPolicy)
    {
        Write-Verbose -Message "SafeLinksPolicy $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object -FilterScript { $_ -inotmatch 'Ensure' }))
        {
            if ($null -ne $SafeLinksPolicy.$KeyName)
            {
                $result += @{
                    $KeyName = $SafeLinksPolicy.$KeyName
                }
            }
            else
            {
                $result += @{
                    $KeyName = $PSBoundParameters[$KeyName]
                }
            }
        }

        Write-Verbose -Message "Found SafeLinksPolicy $($Identity)"
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
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SafeLinksPolicy for $Identity"

    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount

    $SafeLinksPolicies = Get-SafeLinksPolicy

    $SafeLinksPolicy = $SafeLinksPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $SafeLinksPolicyParams = $PSBoundParameters
    $SafeLinksPolicyParams.Remove('Ensure') | Out-Null
    $SafeLinksPolicyParams.Remove('GlobalAdminAccount') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $SafeLinksPolicy))
    {
        $SafeLinksPolicyParams += @{
            Name = $SafeLinksPolicyParams.Identity
        }
        $SafeLinksPolicyParams.Remove('Identity') | Out-Null
        Write-Verbose -Message "Creating SafeLinksPolicy $($Identity)"
        New-SafeLinksPolicy @SafeLinksPolicyParams
    }
    elseif (('Present' -eq $Ensure ) -and ($null -ne $SafeLinksPolicy))
    {
        Write-Verbose -Message "Setting SafeLinksPolicy $($Identity) with values: $(Convert-O365DscHashtableToString -Hashtable $SafeLinksPolicyParams)"
        Set-SafeLinksPolicy @SafeLinksPolicyParams -Confirm:$false
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $SafeLinksPolicy))
    {
        Write-Verbose -Message "Removing SafeLinksPolicy $($Identity) "
        Remove-SafeLinksPolicy -Identity $Identity -Confirm:$false
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
        [Boolean]
        $DoNotAllowClickThrough = $true,

        [Parameter()]
        [System.String[]]
        $DoNotRewriteUrls = @(),

        [Parameter()]
        [Boolean]
        $DoNotTrackUserClicks = $true,

        [Parameter()]
        [Boolean]
        $EnableForInternalSenders,

        [Parameter()]
        [Boolean]
        $IsEnabled,

        [Parameter()]
        [Boolean]
        $ScanUrls = $false,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SafeLinksPolicy for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
    $ValuesToCheck.Remove('Verbose') | Out-Null

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
    $content = "        EXOSafeLinksPolicy " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
