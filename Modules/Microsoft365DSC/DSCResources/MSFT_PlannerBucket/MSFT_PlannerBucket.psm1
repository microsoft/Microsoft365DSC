Confirm-M365DSCModuleDependency -ModuleName 'MSFT_PlannerBucket'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $BucketId,

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

    Write-Verbose -Message "Getting configuration of Planner Bucket {$Name}"

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

        if (-not [System.String]::IsNullOrEmpty($BucketId))
        {
            [Array]$bucket = Get-MgPlannerPlanBucket -PlannerPlanId $PlanId | Where-Object -FilterScript { $_.Id -eq $BucketId }
        }
        else
        {
            [Array]$bucket = Get-MgPlannerPlanBucket -PlannerPlanId $PlanId | Where-Object -FilterScript { $_.Name -eq $Name }

            if ($bucket.Length -gt 1)
            {
                throw ("Multiple Buckets with Name {$Name} were found for Plan with ID {$PlanID}." + `
                        ' Please use the BucketId property to identify the exact bucket.')
            }
        }

        if ($null -eq $bucket)
        {
            return $nullReturn
        }

        $results = @{
            Name                  = $Name
            PlanId                = $PlanId
            BucketId              = $bucket[0].Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
            ManagedIdentity       = $ManagedIdentity.IsPresent
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $BucketId,

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

    Write-Verbose -Message "Setting configuration of Planner Bucket {$Name}"

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

    $currentValues = Get-TargetResource @PSBoundParameters
    $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Planner Bucket {$Name} doesn't already exist. Creating it."
        New-MgPlannerBucket -Name $Name -PlanId $PlanId | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message ("Planner Bucket {$Bucket} already exists, but is not in the " + `
                'Desired State. Updating it.')
        Update-MgPlannerPlan @SetParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "This resource doesn't allow for removal of Planner Bucket."
        # TODO - Implement when available in the MSGraph PowerShell SDK
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $BucketId,

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
                [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.Id -ErrorAction 'SilentlyContinue'

                $j = 1
                foreach ($plan in $plans)
                {
                    Write-M365DSCHost -Message "        |---[$j/$($plans.Length)] $($plan.Title)"
                    $buckets = Get-MgPlannerPlanBucket -PlannerPlanId $plan.Id
                    $k = 1
                    foreach ($bucket in $buckets)
                    {
                        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                        {
                            $Global:M365DSCExportResourceInstancesCount++
                        }

                        Write-M365DSCHost -Message "            |---[$k/$($buckets.Length)] $($bucket.Name)" -DeferWrite
                        $params = @{
                            Name                  = $bucket.Name
                            PlanId                = $plan.Id
                            BucketId              = $Bucket.Id
                            Credential            = $Credential
                            ApplicationId         = $ApplicationId
                            TenantId              = $TenantId
                            CertificateThumbprint = $CertificateThumbprint
                            ApplicationSecret     = $ApplicationSecret
                            ManagedIdentity       = $ManagedIdentity.IsPresent
                        }
                        $results = Get-TargetResource @params
                        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $Results `
                            -Credential $Credential
                        [void]$dscContent.Append($currentDSCBlock)

                        Save-M365DSCPartialExport -Content $currentDSCBlock `
                            -FileName $Global:PartialExportFileName
                        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                        $k++
                    }
                    $j++
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
