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
    Write-Verbose "Get-TargetResource will attempt to retrieve SafeLinksPolicy $($Identity)"
    Write-Verbose "Calling Connect-ExchangeOnline function:"
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    Write-Verbose "Global ExchangeOnlineSession status:"
    Write-Verbose "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object Name -eq 'ExchangeOnline' | Out-String)"
    try
    {
        $SafeLinksPolicies = Get-SafeLinksPolicy
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
    }

    $SafeLinksPolicy = $SafeLinksPolicies | Where-Object Identity -eq $Identity
    if (-NOT $SafeLinksPolicy)
    {
        Write-Verbose "SafeLinksPolicy $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
        }

        foreach ($KeyName in ($PSBoundParameters.Keys | Where-Object {$_ -inotmatch 'Ensure'}) )
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

        Write-Verbose "Found SafeLinksPolicy $($Identity)"
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
    Write-Verbose 'Entering Set-TargetResource'
    Connect-ExchangeOnline -GlobalAdminAccount $GlobalAdminAccount
    $SafeLinksPolicies = Get-SafeLinksPolicy

    $SafeLinksPolicy = $SafeLinksPolicies | Where-Object Identity -eq $Identity
    $SafeLinksPolicyParams = $PSBoundParameters
    $SafeLinksPolicyParams.Remove('Ensure') | Out-Null
    $SafeLinksPolicyParams.Remove('GlobalAdminAccount') | Out-Null

    if ( ('Present' -eq $Ensure ) -and ($null -eq $SafeLinksPolicy) )
    {
        $SafeLinksPolicyParams += @{
            Name = $SafeLinksPolicyParams.Identity
        }
        $SafeLinksPolicyParams.Remove('Identity') | Out-Null
        Write-Verbose "Creating SafeLinksPolicy $($Identity)"
        New-SafeLinksPolicy @SafeLinksPolicyParams
    }
    elseif ( ('Present' -eq $Ensure ) -and ($null -ne $SafeLinksPolicy) )
    {
        Write-Verbose "Setting SafeLinksPolicy $($Identity) with values: $($SafeLinksPolicyParams | Out-String)"
        Set-SafeLinksPolicy @SafeLinksPolicyParams -Confirm:$false
    }
    elseif ( ('Absent' -eq $Ensure ) -and ($null -ne $SafeLinksPolicy) )
    {
        Write-Verbose "Removing SafeLinksPolicy $($Identity) "
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
    Write-Verbose -Message "Testing SafeLinksPolicy for $($Identity)"

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

    Write-Verbose "Test-TargetResource returned $TestResult"

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
