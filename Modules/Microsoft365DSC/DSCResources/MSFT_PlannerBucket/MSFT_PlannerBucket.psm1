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
    Write-Verbose -Message "Getting configuration of Planner Bucket {$Name}"

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"
    try
    {
        Connect-Graph -Scopes "Group.ReadWrite.All" | Out-Null

        if (-not [System.String]::IsNullOrEmpty($BucketId))
        {
            [Array]$bucket = Get-MGPlannerPlanBucket -PlannerPlanId $PlanId | Where-Object -FilterScript {$_.Id -eq $BucketId}
        }
        else
        {
            [Array]$bucket = Get-MGPlannerPlanBucket -PlannerPlanId $PlanId | Where-Object -FilterScript {$_.Name -eq $Name}

            if ($bucket.Length -gt 1)
            {
                throw "Multiple Buckets with Name {$Name} were found for Plan with ID {$PlanID}." + `
                    " Please use the BucketId property to identify the exact bucket."
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
            Ensure                = "Present"
            ApplicationId         = $ApplicationId
            TenantID              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PlanId,

        [Parameter()]
        [System.String]
        $BucketId,

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
    Write-Verbose -Message "Setting configuration of Planner Bucket {$Name}"

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
        Write-Verbose -Message "Planner Bucket {$Name} doesn't already exist. Creating it."
        New-MGPlannerBucket -Name $Name -PlanId $PlanId | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Planner Bucket {$Bucket} already exists, but is not in the " + `
            "Desired State. Updating it."
        Update-MGPlannerPlan @SetParams
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

    Write-Verbose -Message "Testing configuration of Planner Bucket {$Name}"

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
        Write-Host "`r`n" -NoNewLine
        foreach ($group in $groups)
        {
            Write-Host "    [$i/$($groups.Length)] $($group.DisplayName) - {$($group.ObjectID)}"
            try
            {
                [Array]$plans = Get-MgGroupPlannerPlan -GroupId $group.ObjectId -ErrorAction 'SilentlyContinue'

                $j = 1
                foreach ($plan in $plans)
                {
                    Write-Host "        [$j/$($plans.Length)] $($plan.Title)"
                    $buckets = Get-MGPlannerPlanBucket -PlannerPlanId $plan.Id
                    $k = 1
                    foreach ($bucket in $buckets)
                    {
                        Write-Host "            [$k/$($buckets.Length)] $($bucket.Name)" -NoNewLine
                        $params = @{
                            Name                  = $bucket.Name
                            PlanId                = $plan.Id
                            BucketId              = $Bucket.Id
                            ApplicationId         = $ApplicationId
                            TenantId              = $TenantId
                            CertificateThumbprint = $CertificateThumbprint
                        }
                        $result = Get-TargetResource @params
                        $content += "        PlannerBucket " + (New-GUID).ToString() + "`r`n"
                        $content += "        {`r`n"
                        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
                        $content += $currentDSCBlock
                        $content += "        }`r`n"
                        Write-Host $Global:M365DSCEmojiGreenCheckMark
                        $k++
                    }
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
