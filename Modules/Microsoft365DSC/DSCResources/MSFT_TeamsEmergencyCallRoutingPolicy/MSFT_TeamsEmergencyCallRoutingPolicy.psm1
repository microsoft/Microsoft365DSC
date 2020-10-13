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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EmergencyNumbers,

        [Parameter()]
        [System.Boolean]
        $AllowEnhancedEmergencyServices,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting the Teams Emergency Call Routing Policy $Identity"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        $policy = Get-CsTeamsEmergencyCallRoutingPolicy -Identity $Identity `
            -ErrorAction 'SilentlyContinue'

        if ($null -eq $policy)
        {
            Write-Verbose -Message "Could not find Teams Emergency Call Routing Policy ${$Identity}"
            return $nullReturn
        }
        Write-Verbose -Message "Found Teams Emergency Call Routing Policy {$Identity}"
        $results = @{
            Identity                       = $Identity
            Description                    = $policy.Description
            AllowEnhancedEmergencyServices = $policy.AllowEnhancedEmergencyServices
            Ensure                         = "Present"
            GlobalAdminAccount             = $GlobalAdminAccount
        }

        if ($policy.EmergencyNumbers.Count -gt 0)
        {
            $numbers = Get-TeamsEmergencyNumbers -Numbers $policy.EmergencyNumbers
            $results.Add("EmergencyNumbers", $numbers)
        }
        return $results
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EmergencyNumbers,

        [Parameter()]
        [System.Boolean]
        $AllowEnhancedEmergencyServices,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Teams Emergency Call Routing Policy {$Identity}"

    # Check that at least one optional parameter is specified
    $inputValues = @()
    foreach ($item in $PSBoundParameters.Keys)
    {
        if (-not [System.String]::IsNullOrEmpty($PSBoundParameters.$item) -and $item -ne 'GlobalAdminAccount' `
            -and $item -ne 'Identity' -and $item -ne 'Ensure')
        {
            $inputValues += $item
        }
    }

    if ($inputValues.Count -eq 0)
    {
        throw "You need to specify at least one optional parameter for the Set-TargetResource function" + `
            " of the [TeamsEmergencyCallRoutingPolicy] instance {$Identity}"
    }

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("GlobalAdminAccount") | Out-Null

    if ($PSBoundParameters.ContainsKey("EmergencyNumbers"))
    {
        $values = Convert-CIMToTeamsEmergencyNumbers $EmergencyNumbers
        $SetParameters["EmergencyNumbers"] = $values
    }

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new Teams Emergency Call Routing Policy {$Identity}"
        $numbers = @()
        if ($null -ne $SetParameters["EmergencyNumbers"])
        {
            foreach ($number in $SetParameters["EmergencyNumbers"])
            {
                $curNumber = New-CsTeamsEmergencyNumber @number
                $numbers += $curNumber
            }
            $SetParameters.EmergencyNumbers = $numbers
        }
        New-CsTeamsEmergencyCallRoutingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        # If we get here, it's because the Test-TargetResource detected a drift, therefore we always call
        # into the Set-CsTeamsEmergencyCallRoutingPolicy cmdlet.
        Write-Verbose -Message "Updating settings for Teams Emergency Call Routing Policy {$Identity}"
        $numbers = @()
        if ($null -ne $SetParameters["EmergencyNumbers"])
        {
            foreach ($number in $SetParameters["EmergencyNumbers"])
            {
                $curNumber = New-CsTeamsEmergencyNumber @number
                $numbers += $curNumber
            }
            $SetParameters.EmergencyNumbers = $numbers
        }
        Set-CsTeamsEmergencyCallRoutingPolicy @SetParameters
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing Teams Meeting Policy {$Identity}"
        Remove-CsTeamsEmergencyCallRoutingPolicy -Identity $Identity -Confirm:$false
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $EmergencyNumbers,

        [Parameter()]
        [System.Boolean]
        $AllowEnhancedEmergencyServices,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of Team EmergencyCall Routing Policy {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $DesiredValues = $PSBoundParameters
    if ($null -ne $DesiredValues.EmergencyNumbers -and $DesiredValues.EmergencyNumbers.Count -gt 0)
    {
        $numbers = Convert-CIMToTeamsEmergencyNumbers -Numbers $DesiredValues.EmergencyNumbers
        $DesiredValues["EmergencyNumbers"] = $numbers
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $DesiredValues)"

    $ValuesToCheck = $DesiredValues
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $DesiredValues `
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

    $ConnectionMode = New-M365DSCConnection -Platform 'SkypeForBusiness' `
        -InboundParameters $PSBoundParameters

    try
    {
        $i = 1
        [array]$policies = Get-CsTeamsEmergencyCallRoutingPolicy -ErrorAction Stop
        $content = ''
        Write-Host "`r`n" -NoNewLine
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewLine
            $params = @{
                Identity           = $policy.Identity
                GlobalAdminAccount = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        TeamsEmergencyCallRoutingPolicy " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"

            if ($null -ne $result.EmergencyNumbers)
            {
                $result.EmergencyNumbers = ConvertTo-TeamsEmergencyNumbersString -Numbers $result.EmergencyNumbers
            }

            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot

            if ($null -ne $result.EmergencyNumbers)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "EmergencyNumbers"
            }

            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $content
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

function Get-TeamsEmergencyNumbers
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable[]])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Numbers
    )

    if ($null -eq $Numbers)
    {
        return $null
    }

    $result = @()
    foreach ($number in $numbers)
    {
        $result += @{
            EmergencyDialString = $number.EmergencyDialString
            EmergencyDialMask   = $number.EmergencyDialMask
            OnlinePSTNUsage     = $number.OnlinePSTNUsage
        }
    }

    return $result
}

function ConvertTo-TeamsEmergencyNumbersString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $Numbers
    )

    if ($null -eq $Numbers)
    {
        return $null
    }

    $StringContent = "@(`r`n"
    foreach ($number in $numbers)
    {
        $StringContent += "                MSFT_TeamsEmergencyNumber`r`n"
        $StringContent += "                {`r`n"
        $StringContent += "                    EmergencyDialString = '$($number.EmergencyDialString)'`r`n"
        $StringContent += "                    EmergencyDialMask   = '$($number.EmergencyDialMask)'`r`n"
        $StringContent += "                    OnlinePSTNUsage     = '$($number.OnlinePSTNUsage)'`r`n"
        $StringContent += "                }`r`n"
    }
    $StringContent += "            )"
    return $StringContent
}

function Convert-CIMToTeamsEmergencyNumbers
{
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    Param(
        [parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Numbers
    )
    $values = [System.Collections.ArrayList]@()
    foreach ($number in $Numbers)
    {
        $current = @{
            EmergencyDialString = $number.EmergencyDialString
            EmergencyDialMask   = $number.EmergencyDialMask
            OnlinePSTNUsage     = $number.OnlinePSTNUsage
        }
        $values += $current
    }

    return $values
}

Export-ModuleMember -Function *-TargetResource
