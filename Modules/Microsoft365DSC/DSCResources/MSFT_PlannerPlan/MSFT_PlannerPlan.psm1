Confirm-M365DSCModuleDependency -ModuleName 'MSFT_PlannerPlan'

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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting configuration of Planner Plan {$Title}"

    try
    {
        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters

        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = 'Absent'

        $UsedID = $false
        $AllGroups = Get-MgGroup -GroupId $OwnerGroup -ErrorAction 'SilentlyContinue'
        if ($null -eq $AllGroups)
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

        if ($null -eq $AllGroups)
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
                    Write-Verbose -Message 'Found Plan.'
                    if ($UsedID)
                    {
                        $OwnerGroupValue = $group.Id
                    }
                    else
                    {
                        $OwnerGroupValue = $group.DisplayName
                    }
                    break
                }
            }
            catch
            {
                New-M365DSCLogEntry -Message 'Error retrieving data:' `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential
            }
        }

        if ($null -eq $plan)
        {
            Write-Verbose -Message 'Plan not found, returning Ensure = Absent'
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message 'Plan found, returning Ensure = Present'
            $results = @{
                Title                 = $Title
                OwnerGroup            = $OwnerGroupValue
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
                ManagedIdentity       = $ManagedIdentity.IsPresent
            }
        }
        return $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Setting configuration of Planner Plan {$Title}"

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    $currentValues = Get-TargetResource @PSBoundParameters
    $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

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
        if ($null -eq $AllGroups)
        {
            [Array]$AllGroups = Get-MgGroup -Search $OwnerGroup
        }
        $plan = Get-MgGroupPlannerPlan -GroupId $AllGroups[0].Id | Where-Object -FilterScript { $_.Title -eq $Title }
        $SetParams.Add('PlannerPlanId', $plan.Id)
        $SetParams.Add('Owner', $AllGroups[0].Id)
        $SetParams.Remove('OwnerGroup') | Out-Null
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
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '')
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    try
    {
        [array]$groups = Get-MgGroup -All -ErrorAction Stop -Filter $filter

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        Write-M365DSCHost -Message "`r`n" -DeferWrite
        foreach ($group in $groups)
        {
            Write-M365DSCHost -Message "    [$i/$($groups.Length)] $($group.DisplayName) - {$($group.Id)}"
            try
            {
                [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.Id `
                    -All `
                    -ErrorAction 'SilentlyContinue'

                $j = 1
                foreach ($plan in $plans)
                {
                    if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                    {
                        $Global:M365DSCExportResourceInstancesCount++
                    }

                    $params = @{
                        Title                 = $plan.Title
                        OwnerGroup            = $group.Id
                        Credential            = $Credential
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        CertificateThumbprint = $CertificateThumbprint
                        ApplicationSecret     = $ApplicationSecret
                        ManagedIdentity       = $ManagedIdentity.IsPresent
                    }

                    Write-M365DSCHost -Message "        [$j/$($plans.Length)] $($plan.Title)"
                    $results = Get-TargetResource @params
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    [void]$dscContent.Append($currentDSCBlock)

                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                    $j++
                    Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                }
                $i++
            }
            catch
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

                New-M365DSCLogEntry -Message 'Error during Export:' `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential
            }
        }

        return $dscContent.ToString()
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
