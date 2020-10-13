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

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Write-Verbose -Message "Getting configuration of Planner Plan {$Title}"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        $UsedID = $false
        $AllGroups = Get-AzureADGroup -ObjectId $OwnerGroup -ErrorAction 'SilentlyContinue'
        if ($AllGroups -eq $null)
        {
            Write-Verbose -Message "Could not get Azure AD Group {$OwnerGroup} by ID. `
                Trying by Name."
            [Array]$AllGroups = Get-AzureADGroup -SearchString $OwnerGroup
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

        Write-Verbose -Message "Connecting to the Microsoft Graph"
        $ConnectionMode = Connect-Graph -Scopes "Group.ReadWrite.All"

        $plan = $null
        foreach ($group in $AllGroups)
        {
            try
            {
                Write-Verbose -Message "Scanning Group {$($group.DisplayName)} for plan {$Title}"
                $plan = Get-MGGroupPlannerPlan -GroupId $group.ObjectId | Where-Object -FilterScript {$_.Title -eq $Title}
                if ($null -ne $plan)
                {
                    Write-Verbose -Message "Found Plan."
                    if ($UsedID)
                    {
                        $OwnerGroupValue = $group.ObjectId
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
                Write-Verbose -Message $_
                Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
                New-M365DSCLogEntry -Error $_ `
                    -Message "Couldn't get Planner plans for {$($group.DisplayName)}" `
                    -Source $MyInvocation.MyCommand.ModuleName
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
                Title                 = $Title
                OwnerGroup            = $OwnerGroupValue
                Ensure                = 'Present'
                CertificateThumbprint = $CertificateThumbprint
                ApplicationId         = $ApplicationId
                TenantID              = $TenantId
            }
        }
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $results)"
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
        $Title,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OwnerGroup,

        [Parameter()]
        [System.String]
        [ValidateSet("Present", "Absent")]
        $Ensure = 'Present',

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )
    Write-Verbose -Message "Setting configuration of Planner Plan {$Title}"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Connect-Graph -Scopes "Group.ReadWrite.All" | Out-Null

    $SetParams = $PSBoundParameters
    $currentValues = Get-TargetResource @PSBoundParameters
    $SetParams.Remove("ApplicationId") | Out-Null
    $SetParams.Remove("TenantId") | Out-Null
    $SetParams.Remove("CertificateThumbprint") | Out-Null
    $SetParams.Remove("Ensure") | Out-Null

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Planner Plan {$Title} doesn't already exist. Creating it."
        New-MGPlannerPlan -Owner $OwnerGroup -Title $Title | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Plan {$Title} already exists, but is not in the `
            Desired State. Updating it."
        [Array]$AllGroups = Get-AzureADGroup -ObjectId $OwnerGroup -ErrorAction 'SilentlyContinue'
        Write-Verbose -Message $AllGroups[0]
        if ($AllGroups -eq $null)
        {
            [Array]$AllGroups = Get-AzureADGroup -SearchString $OwnerGroup
        }
        $plan = Get-MGGroupPlannerPlan -GroupId $AllGroups[0].ObjectId | Where-Object -FilterScript {$_.Title -eq $Title}
        $SetParams.Add("PlannerPlanId", $plan.Id)
        $SetParams.Add("Owner", $AllGroups[0].ObjectId)
        $SetParams.Remove("OwnerGroup") | Out-Null
        Update-MGPlannerPlan @SetParams
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

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Write-Verbose -Message "Testing configuration of Planner Plan {$Title}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
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
        [System.String]
        $ApplicationId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CertificateThumbprint
    )
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'AzureAD' `
        -InboundParameters $PSBoundParameters

    try
    {
        [array]$groups = Get-AzureADGroup -All:$true -ErrorAction Stop

        $ConnectionMode = Connect-Graph -Scopes "Group.ReadWrite.All"
        $i = 1
        $content = ''
        foreach ($group in $groups)
        {
            Write-Information "    [$i/$($groups.Length)] $($group.DisplayName) - {$($group.ObjectID)}"
            try
            {
                [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.ObjectId -ErrorAction 'SilentlyContinue'

                $j = 1
                foreach ($plan in $plans)
                {
                    $params = @{
                        Title                 = $plan.Title
                        OwnerGroup            = $group.ObjectId
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                    }
                    Write-Information "        [$j/$($plans.Length)] $($plan.Title)"
                    $result = Get-TargetResource @params
                    $content += "        PlannerPlan " + (New-GUID).ToString() + "`r`n"
                    $content += "        {`r`n"
                    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
                    $content += $currentDSCBlock
                    $content += "        }`r`n"
                    $j++
                }
                $i++
            }
            catch
            {
                Write-Verbose -Message $_
                Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                    -EventID 1 -Source $($MyInvocation.MyCommand.Source)
            }
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

Export-ModuleMember -Function *-TargetResource
