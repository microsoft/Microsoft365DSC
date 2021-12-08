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
        $Credential
    )

    Write-Verbose -Message "Getting the Teams Emergency Call Routing Policy $Identity"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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
            Credential             = $Credential
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
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
        $Credential
    )

    Write-Verbose -Message "Setting Teams Emergency Call Routing Policy {$Identity}"

    # Check that at least one optional parameter is specified
    $inputValues = @()
    foreach ($item in $PSBoundParameters.Keys)
    {
        if (-not [System.String]::IsNullOrEmpty($PSBoundParameters.$item) -and $item -ne 'Credential' `
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

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    $SetParameters = $PSBoundParameters
    $SetParameters.Remove("Ensure") | Out-Null
    $SetParameters.Remove("Credential") | Out-Null

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
        $Credential
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

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
    $ValuesToCheck.Remove('Credential') | Out-Null

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
        $Credential
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $i = 1
        [array]$policies = Get-CsTeamsEmergencyCallRoutingPolicy -ErrorAction Stop
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity)" -NoNewline
            $params = @{
                Identity           = $policy.Identity
                Credential = $Credential
            }
            $result = Get-TargetResource @params
            $result = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Result
            $currentDSCBlock = "        TeamsEmergencyCallRoutingPolicy " + (New-Guid).ToString() + "`r`n"
            $currentDSCBlock += "        {`r`n"

            if ($null -ne $result.EmergencyNumbers)
            {
                $result.EmergencyNumbers = ConvertTo-TeamsEmergencyNumbersString -Numbers $result.EmergencyNumbers
            }

            $content = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot

            if ($null -ne $result.EmergencyNumbers)
            {
                $content = Convert-DSCStringParamToVariable -DSCBlock $content -ParameterName "EmergencyNumbers"
            }

            $currentDSCBlock += Convert-DSCStringParamToVariable -DSCBlock $content -ParameterName "Credential"
            $currentDSCBlock += "        }`r`n"
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
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
