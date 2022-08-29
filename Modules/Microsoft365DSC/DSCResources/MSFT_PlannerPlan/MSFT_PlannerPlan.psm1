function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OwnerGroup,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Write-Verbose -Message "Getting configuration of Planner Plan {$Title}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $UsedID = $false
        $AllGroups = Get-MgGroup -GroupId $OwnerGroup -ErrorAction 'SilentlyContinue'
        if ($AllGroups -eq $null)
        {
            Write-Verbose -Message "Could not get Azure AD Group {$OwnerGroup} by ID. `
                Trying by Name."
            [Array]$AllGroups = Get-MgGroup -Search $OwnerGroup
        }
        else
        {
            Write-Verbose -Message "Found group {$OwnerGroup} by ID"
            $UsedID = $true
        }

        if ($AllGroups -eq $null)
        {
            Write-Verbose -Message "No Azure AD Group found for {$OwnerGroup}"
        }
        elseif ($AllGroups.Length -gt 1)
        {
            Write-Verbose -Message "Multiple Groups with name {$OwnerGroup} found."
        }

        $plan = $null
        foreach ($group in $AllGroups)
        {
            try
            {
                Write-Verbose -Message "Scanning Group {$($group.DisplayName)} for plan {$Title}"
                $plan = Get-MgGroupPlannerPlan -GroupId $group.Id | Where-Object -FilterScript { $_.Title -eq $Title }
                if ($null -ne $plan)
                {
                    Write-Verbose -Message "Found Plan."
                    if ($UsedID)
                    {
                        $OwnerGroupValue = $group.Id
                    }
                    else
                    {
                        $OwnerGroupValue = $group.DisplayName
                    }
                    break;
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
            }
        }

        if ($null -eq $plan)
        {
            Write-Verbose -Message "Plan not found, returning Ensure = Absent"
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message "Plan found, returning Ensure = Present"
            $results = @{
                Title      = $Title
                OwnerGroup = $OwnerGroupValue
                Ensure     = 'Present'
                Credential = $Credential
            }
        }
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $results)"
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
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OwnerGroup,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    Write-Verbose -Message "Setting configuration of Planner Plan {$Title}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $SetParams = $PSBoundParameters
    $currentValues = Get-TargetResource @PSBoundParameters
    $SetParams.Remove("Credential") | Out-Null
    $SetParams.Remove("Ensure") | Out-Null

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Planner Plan {$Title} doesn't already exist. Creating it."
        New-MgPlannerPlan -Owner $OwnerGroup -Title $Title | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Plan {$Title} already exists, but is not in the `
            Desired State. Updating it."
        [Array]$AllGroups = Get-MgGroup -GroupId $OwnerGroup -ErrorAction 'SilentlyContinue'
        Write-Verbose -Message $AllGroups[0]
        if ($AllGroups -eq $null)
        {
            [Array]$AllGroups = Get-MgGroup -Search $OwnerGroup
        }
        $plan = Get-MgGroupPlannerPlan -GroupId $AllGroups[0].Id | Where-Object -FilterScript { $_.Title -eq $Title }
        $SetParams.Add("PlannerPlanId", $plan.Id)
        $SetParams.Add("Owner", $AllGroups[0].Id)
        $SetParams.Remove("OwnerGroup") | Out-Null
        Update-MgPlannerPlan @SetParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "This resource doesn't allow for removal of Planner plans."
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
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OwnerGroup,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $Credential
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Planner Plan {$Title}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
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
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = "Credentials"
    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    try
    {
        [array]$groups = Get-MgGroup -All:$true -ErrorAction Stop

        $i = 1
        $dscContent = ''
        Write-Host "`r`n" -NoNewline
        foreach ($group in $groups)
        {
            Write-Host "    [$i/$($groups.Length)] $($group.DisplayName) - {$($group.Id)}"
            try
            {
                [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.Id `
                    -All:$true `
                    -Filter $Filter `
                    -ErrorAction 'SilentlyContinue'

                $j = 1
                foreach ($plan in $plans)
                {
                    $params = @{
                        Title      = $plan.Title
                        OwnerGroup = $group.Id
                        Credential = $Credential
                    }

                    Write-Host "        [$j/$($plans.Length)] $($plan.Title)"
                    $results = Get-TargetResource @params
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    $dscContent += $currentDSCBlock

                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                    $j++
                }
                $i++
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
            }
        }

        return $dscContent
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
    }
}

Export-ModuleMember -Function *-TargetResource
