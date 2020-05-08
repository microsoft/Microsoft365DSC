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
        $SafeLinksPolicies = Get-SafeLinksPolicy
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        $Message = "Error calling {Get-SafeLinksPolicy}"
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
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
            Identity                 = $SafeLinksPolicy.Identity
            AdminDisplayName         = $SafeLinksPolicy.AdminDisplayName
            DoNotAllowClickThrough   = $SafeLinksPolicy.DoNotAllowClickThrough
            DoNotRewriteUrls         = $SafeLinksPolicy.DoNotRewriteUrls
            DoNotTrackUserClicks     = $SafeLinksPolicy.DoNotTrackUserClicks
            EnableForInternalSenders = $SafeLinksPolicy.EnableForInternalSenders
            IsEnabled                = $SafeLinksPolicy.IsEnabled
            ScanUrls                 = $SafeLinksPolicy.ScanUrls
            Ensure                   = 'Present'
            GlobalAdminAccount       = $GlobalAdminAccount
        }

        Write-Verbose -Message "Found SafeLinksPolicy $($Identity)"
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
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

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
        Write-Verbose -Message "Setting SafeLinksPolicy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SafeLinksPolicyParams)"
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

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null
    $ValuesToCheck.Remove('IsSingleInstance') | Out-Null
    $ValuesToCheck.Remove('Verbose') | Out-Null

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
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline `
        -ErrorAction SilentlyContinue
    $content = ''
    if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeLinksPolicy)
    {
        [array]$SafeLinksPolicies = Get-SafeLinksPolicy
        $i = 1
        foreach ($SafeLinksPolicy in $SafeLinksPolicies)
        {
            Write-Information "    [$i/$($SafeLinksPolicies.Length)] $($SafeLinksPolicy.Name)"
            $params = @{
                GlobalAdminAccount = $GlobalAdminAccount
                Identity           = $SafeLinksPolicy.Identity
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        EXOSafeLinksPolicy " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
        }
    }
    else
    {
        Write-Information "The current tenant is not registered to allow for Safe Attachment Rules."
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
