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
        [System.Boolean]
        $AllowManagedUpdates,

        [Parameter()]
        [System.Boolean]
        $AllowPreview,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled","Enabled","FollowOfficePreview")]
        $AllowPublicPreview,

        [Parameter()]
        [System.UInt32]
        $UpdateDayOfWeek,

        [Parameter()]
        [System.String]
        $UpdateTime,

        [Parameter()]
        [System.String]
        $UpdateTimeOfDay,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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

    Write-Verbose -Message "Checking the Teams Update Management Policies"

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $policy = Get-CsTeamsUpdateManagementPolicy -Identity $Identity `
            -ErrorAction SilentlyContinue

        if ($null -eq $policy)
        {
            Write-Verbose "No Teams Update Management Policy with Identity {$Identity} was found"
            return $nullReturn
        }

        Write-Verbose -Message "Found Teams Update Management Policy with Identity {$Identity}"
        return @{
            Identity            = $policy.Identity
            Description         = $policy.Description
            AllowManagedUpdates = $policy.AllowManagedUpdates
            AllowPreview        = $policy.AllowPreview
            AllowPublicPreview  = $policy.AllowPublicPreview
            UpdateDayOfWeek     = $policy.UpdateDayOfWeek
            UpdateTime          = $policy.UpdateTime
            UpdateTimeOfDay     = $policy.UpdateTimeOfDay
            Ensure              = 'Present'
            Credential          = $Credential
        }
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
        [System.Boolean]
        $AllowManagedUpdates,

        [Parameter()]
        [System.Boolean]
        $AllowPreview,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled","Enabled","FollowOfficePreview")]
        $AllowPublicPreview,

        [Parameter()]
        [System.UInt32]
        $UpdateDayOfWeek,

        [Parameter()]
        [System.String]
        $UpdateTime,

        [Parameter()]
        [System.String]
        $UpdateTimeOfDay,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
    Write-Verbose -Message "Updating Teams Update Management Policy {$Identity}"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($CurrentValues.Ensure -eq 'Absent' -and $Ensure -eq 'Present')
    {
        Write-Verbose "Creating new Teams Update Management Policy {$Identity}"
        $newParams = $PSBoundParameters
        $newParams.Remove("Ensure") | Out-Null
        $newParams.Remove("Credential") | Out-Null

        New-CsTeamsUpdateManagementPolicy @newParams | Out-Null
    }
    elseif ($CurrentValues.Ensure -eq 'Present' -and $Ensure -eq 'Absent')
    {
        Write-Verbose "Updating existing Teams Update Management Policy {$Identity}"
        $setParams = $PSBoundParameters
        $setParams.Remove("Ensure") | Out-Null
        $setParams.Remove("Credential") | Out-Null

        Set-CsTeamsUpdateManagementPolicy @setParams | Out-Null
    }
    elseif ($CurrentValues.Ensure -eq 'Present' -and $Ensure -eq 'Absent')
    {
        Write-Verbose "Removing existing Teams Update Management Policy {$Identity}"

        Remove-CsTeamsUpdateManagementPolicy -Identity $Identity | Out-Null
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
        [System.Boolean]
        $AllowManagedUpdates,

        [Parameter()]
        [System.Boolean]
        $AllowPreview,

        [Parameter()]
        [System.String]
        [ValidateSet("Disabled","Enabled","FollowOfficePreview")]
        $AllowPublicPreview,

        [Parameter()]
        [System.UInt32]
        $UpdateDayOfWeek,

        [Parameter()]
        [System.String]
        $UpdateTime,

        [Parameter()]
        [System.String]
        $UpdateTimeOfDay,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
    Write-Verbose -Message "Testing configuration of Team Update Management Policy {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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

    $organization = ""
    if ($Credential.UserName.Contains("@"))
    {
        $organization = $Credential.UserName.Split("@")[1]
    }

    try
    {
        [array]$policies = Get-CsTeamsUpdateManagementPolicy -ErrorAction Stop
        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($policy in $policies)
        {
            Write-Host "    |---[$i/$($policies.Count)] $($policy.Identity.Replace('Tag:', ''))" -NoNewline
            $params = @{
                Identity   = $policy.Identity.Replace("Tag:", "")
                Credential = $Credential
            }
            $result = Get-TargetResource @params
            $result = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Result
            $currentDSCBlock = "        TeamsUpdateManagementPolicy " + (New-Guid).ToString() + "`r`n"
            $currentDSCBlock += "        {`r`n"
            $partialContent = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $partialContent = Convert-DSCStringParamToVariable -DSCBlock $partialContent `
                -ParameterName "Credential"
            if ($partialContent.ToLower().IndexOf($organization.ToLower()) -gt 0)
            {
                $partialContent = $partialContent -ireplace [regex]::Escape("@" + $organization), "@`$OrganizationName"
            }
            $currentDSCBlock += $partialContent
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

Export-ModuleMember -Function *-TargetResource
