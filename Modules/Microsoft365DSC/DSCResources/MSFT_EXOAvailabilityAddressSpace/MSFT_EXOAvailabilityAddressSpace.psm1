function Get-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of AvailabilityAddressSpace for $($Identity)"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    try
    {
        $AvailabilityAddressSpaces = Get-AvailabilityAddressSpace -ea stop
    }
    catch
    {
        New-M365DSCLogEntry -Error $_ -Message "Couldn't get AvailabilityAddressSpaces" -Source $MyInvocation.MyCommand.ModuleName
    }

    $AvailabilityAddressSpace = $AvailabilityAddressSpaces | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if ($null -eq $AvailabilityAddressSpace)
    {
        Write-Verbose -Message "AvailabilityAddressSpace $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {


        if ($Null -eq $AvailabilityAddressSpace.TargetAutodiscoverEpr -or $AvailabilityAddressSpace.TargetAutodiscoverEpr -eq "" )
        {
            $TargetAutodiscoverEpr = ""
        }
        else
        {
            $TargetAutodiscoverEpr = $AvailabilityAddressSpace.TargetAutodiscoverEpr.tostring()
        }

        $result = @{
            Identity              = $Identity
            AccessMethod          = $AvailabilityAddressSpace.AccessMethod
            Credentials           = $AvailabilityAddressSpace.Credentials
            ForestName            = $AvailabilityAddressSpace.ForestName
            TargetAutodiscoverEpr = $TargetAutodiscoverEpr
            GlobalAdminAccount    = $GlobalAdminAccount
            Ensure                = 'Present'
        }

        Write-Verbose -Message "Found AvailabilityAddressSpace $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of AvailabilityAddressSpace for $($Identity)"

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    try
    {
        $AvailabilityAddressSpaces = Get-AvailabilityAddressSpace -ea stop
    }
    catch
    {
        New-M365DSCLogEntry -Error $_ -Message "Couldn't get AvailabilityAddressSpaces" -Source $MyInvocation.MyCommand.ModuleName
    }

    $AvailabilityAddressSpace = $AvailabilityAddressSpaces | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $AvailabilityAddressSpaceParams = $PSBoundParameters
    $AvailabilityAddressSpaceParams.Remove('Ensure') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('GlobalAdminAccount') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $AvailabilityAddressSpace))
    {
        Write-Verbose -Message "Creating AvailabilityAddressSpace $($Identity)."
        # AvailabilityAddressSpace doe not have a new-AvailabilityAddressSpace cmdlet but instead uses an add-AvailabilityAddressSpace cmdlet
        try
        {
            add-AvailabilityAddressSpace @AvailabilityAddressSpaceParams -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't add new AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $AvailabilityAddressSpace))
    {
        Write-Verbose -Message "Setting AvailabilityAddressSpace $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $AvailabilityAddressSpaceParams)"
        # AvailabilityAddressSpace is a special case in that it does not have a "set-AvailabilityAddressSpace" cmdlet. To change values of an existing AvailabilityAddressSpace it must be removed and then added again with add-AvailabilityAddressSpace
        try
        {
            Remove-AvailabilityAddressSpace -identity $Identity -Confirm:$false -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't remove AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }

        try
        {
            add-AvailabilityAddressSpace @AvailabilityAddressSpaceParams -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't add new AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $AvailabilityAddressSpace))
    {
        Write-Verbose -Message "Removing AvailabilityAddressSpace $($Identity)"
        try
        {
            Remove-AvailabilityAddressSpace -identity $Identity -Confirm:$false -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't remove AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
}
function Test-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of AvailabilityAddressSpace for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

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

    $InformationPreference = "Continue"
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline `
        -ErrorAction SilentlyContinue

    try
    {
            [array]$AvailabilityAddressSpaces = Get-AvailabilityAddressSpace -ea stop
    }
    catch
    {
        New-M365DSCLogEntry -Error $_ -Message "Couldn't get AvailabilityAddressSpaces" -Source $MyInvocation.MyCommand.ModuleName
    }

    $content = ""
    $i = 1
    foreach ($AvailabilityAddressSpace in $AvailabilityAddressSpaces)
    {
        Write-Information "    [$i/$($AvailabilityAddressSpaces.length)] $($AvailabilityAddressSpace.Identity)"

        $Params = @{
            Identity           = $AvailabilityAddressSpace.Identity
            GlobalAdminAccount = $GlobalAdminAccount
        }

        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOAvailabilityAddressSpace " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}
Export-ModuleMember -Function *-TargetResource
