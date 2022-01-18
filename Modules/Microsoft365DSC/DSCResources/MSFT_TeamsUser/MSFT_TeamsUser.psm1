function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Guest", "Member", "Owner")]
        $Role = "Member",

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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

    Write-Verbose -Message "Getting configuration of member $User to Team $TeamName"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

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
        Write-Verbose -Message "Checking for existance of Team User $User"
        $team = Get-TeamByName ([System.Net.WebUtility]::UrlEncode($TeamName)) -ErrorAction SilentlyContinue
        if ($null -eq $team)
        {
            return $nullReturn
        }

        Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

        try
        {
            Write-Verbose "Retrieving user without a specific Role specified"
            $allMembers = Get-TeamUser -GroupId $team.GroupId -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Warning "The current user doesn't have the rights to access the list of members for Team {$($TeamName)}."
            Write-Verbose $_
            return $nullReturn
        }

        if ($null -eq $allMembers)
        {
            Write-Verbose -Message "Failed to get Team's users for Team $TeamName"
            return $nullReturn
        }

        $myUser = $allMembers | Where-Object -FilterScript { $_.User -eq $User }
        Write-Verbose -Message "Found team user $($myUser.User) with role:$($myUser.Role)"
        return @{
            User                  = $myUser.User
            Role                  = $myUser.Role
            TeamName              = $TeamName
            Ensure                = "Present"
            Credential    = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
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
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Guest", "Member", "Owner")]
        $Role = "Member",

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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

    Write-Verbose -Message "Setting configuration of member $User to Team $TeamName"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    $team = Get-TeamByName ([System.Net.WebUtility]::UrlEncode($TeamName))

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("TeamName") | Out-Null
    $CurrentParameters.Add("GroupId", $team.GroupId)
    $CurrentParameters.Remove("Credential") | Out-Null
    $CurrentParameters.Remove("ApplicationId") | Out-Null
    $CurrentParameters.Remove("TenantId") | Out-Null
    $CurrentParameters.Remove("CertificateThumbprint") | Out-Null
    $CurrentParameters.Remove("Ensure") | Out-Null

    if ($Ensure -eq "Present")
    {
        Write-Verbose -Message "Adding team user $User with role:$Role"
        Add-TeamUser @CurrentParameters
    }
    else
    {
        if ($Role -eq "Member" -and $CurrentParameters.ContainsKey("Role"))
        {
            $CurrentParameters.Remove("Role") | Out-Null
            Write-Verbose -Message "Removed role parameter"
        }
        Remove-TeamUser @CurrentParameters
        Write-Verbose -Message "Removing team user $User"
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
        $TeamName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        [ValidateSet("Guest", "Member", "Owner")]
        $Role = "Member",

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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

    Write-Verbose -Message "Testing configuration of member $User to Team $TeamName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($null -eq $Role)
    {
        $CurrentValues.Remove("Role") | Out-Null
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @("Ensure", `
            "User", `
            "Role")

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [ValidateRange(1, 100)]
        $MaxProcesses,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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

    $result = ""

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters
    if ($ConnectionMode -eq 'ServicePrincipal')
    {
        $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
    }
    else
    {
        $organization = $Credential.UserName.Split('@')[1]
    }
    try
    {
        [array]$instances = Get-Team
        if ($instances.Length -ge $MaxProcesses)
        {
            [array]$instances = Split-ArrayByParts -Array $instances -Parts $MaxProcesses
            $batchSize = $instances[0].Length
        }
        else
        {
            try
            {
                $MaxProcesses = $instances.Length
            }
            catch
            {
                if ($MaxProcesses -eq 0 -or $null -eq $MaxProcesses)
                {
                    $MaxProcesses = 1
                }
            }

            $batchSize = 1
        }

        # For each batch of items, start and asynchronous background PowerShell job. Each
        # job will be given the name of the current resource followed by its ID;
        $i = 1
        foreach ($batch in $instances)
        {
            Start-Job -Name "TeamsUser$i" -ScriptBlock {
                Param(
                    [Parameter(Mandatory = $true)]
                    [System.Object[]]
                    $Instances,

                    [Parameter(Mandatory = $true)]
                    [System.String]
                    $ScriptRoot,

                    [Parameter()]
                    [System.Management.Automation.PSCredential]
                    $Credential,

                    [Parameter()]
                    [System.String]
                    $ApplicationId,

                    [Parameter()]
                    [System.String]
                    $TenantId,

                    [Parameter()]
                    [System.String]
                    $CertificateThumbprint,

                    [Parameter()]
                    [System.String]
                    $OrganizationName
                )
                $WarningPreference = 'SilentlyContinue'

                Import-Module ($ScriptRoot + "\..\..\Modules\M365DSCUtil.psm1") -Force | Out-Null

                # Invoke the logic that extracts the all the Property Bag values of the current site using the
                # the invokation wrapper that handles throttling;
                $returnValue = ""
                $returnValue += Invoke-M365DSCCommand -Arguments $PSBoundParameters -InvokationPath $ScriptRoot -ScriptBlock {
                    $WarningPreference = 'SilentlyContinue'
                    $params = $args[0]
                    $dscContent = ""
                    $j = 1
                    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

                    $principal = "" # Principal represents the "NetBios" name of the tenant (e.g. the M365DSC part of M365DSC.onmicrosoft.com)
                    if ($params.OrganizationName.IndexOf(".") -gt 0)
                    {
                        $principal = $params.OrganizationName.Split(".")[0]
                    }
                    foreach ($item in $params.Instances)
                    {
                        foreach ($team in $item)
                        {
                            try
                            {
                                $users = Get-TeamUser -GroupId $team.GroupId
                                $i = 1
                                $totalCount = $item.Count
                                if ($null -eq $totalCount)
                                {
                                    $totalCount = 1
                                }
                                Write-Verbose -Message "    > [$j/$totalCount] Team {$($team.DisplayName)}"
                                foreach ($user in $users)
                                {
                                    Write-Verbose -Message "        - [$i/$($users.Length)] $($user.User)"

                                    if ($ConnectionMode -eq 'Credential')
                                    {
                                        $getParams = @{
                                            TeamName           = $team.DisplayName
                                            User               = $user.User
                                            Credential = $params.Credential
                                        }
                                    }
                                    else
                                    {
                                        $getParams = @{
                                            TeamName              = $team.DisplayName
                                            User                  = $user.User
                                            ApplicationId         = $ApplicationId
                                            TenantId              = $TenantId
                                            CertificateThumbprint = $CertificateThumbprint
                                        }
                                    }
                                    $CurrentModulePath = $params.ScriptRoot + "\MSFT_TeamsUser.psm1"
                                    Import-Module $CurrentModulePath -Force | Out-Null
                                    Import-Module ($params.ScriptRoot + "\..\..\Modules\M365DSCTelemetryEngine.psm1") -Force | Out-Null
                                    $result = Get-TargetResource @getParams
                                    if ($ConnectionMode -eq 'Credential')
                                    {
                                        $result = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                                            -Results $Result
                                        $result.Remove("ApplicationId") | Out-Null
                                        $result.Remove("TenantId") | Out-Null
                                        $result.Remove("CertificateThumbprint") | Out-Null
                                    }
                                    else
                                    {
                                        $result.Remove("Credential") | Out-Null
                                    }
                                    $currentDSCBlock = "        TeamsUser " + (New-Guid).ToString() + "`r`n"
                                    $currentDSCBlock += "        {`r`n"
                                    $content = Get-DSCBlock -Params $result -ModulePath $params.ScriptRoot
                                    if ($ConnectionMode -eq 'Credential')
                                    {
                                        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $content -ParameterName "Credential"
                                    }
                                    else
                                    {
                                        $partialContent = $content
                                    }
                                    $partialContent += "        }`r`n"
                                    if ($partialContent.ToLower().Contains($params.OrganizationName.ToLower()))
                                    {
                                        $partialContent = $partialContent -ireplace [regex]::Escape($params.OrganizationName), "`$OrganizationName"
                                    }
                                    $currentDSCBlock += $partialContent
                                    $dscContent += $currentDSCBlock
                                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                                        -FileName $Global:PartialExportFileName
                                    $i++
                                }
                            }
                            catch
                            {
                                Write-Verbose -Message $_
                                Write-Verbose -Message "The current User doesn't have the required permissions to extract Users for Team {$($team.DisplayName)}."
                            }
                            $j++
                        }
                    }
                    return $dscContent
                }
                return $returnValue
            } -ArgumentList @($batch, $PSScriptRoot, $Credential, $ApplicationId, $TenantId, $CertificateThumbprint, $organization) | Out-Null
            $i++
        }

        try
        {
            Write-Host "    `r`nBroke extraction process down into {$MaxProcesses} jobs of {$($instances[0].Length)} item(s) each" -NoNewline
        }
        catch
        {
            Write-Verbose $_
        }

        $totalJobs = $MaxProcesses
        $jobsCompleted = 0
        $status = "Running..."
        $elapsedTime = 0
        do
        {
            $jobs = Get-Job | Where-Object -FilterScript { $_.Name -like '*TeamsUser*' }
            $count = $jobs.Length
            foreach ($job in $jobs)
            {
                if ($job.JobStateInfo.State -eq "Complete")
                {
                    $partialResult = Receive-Job -Name $job.name
                    $result += $partialResult
                    Remove-Job -Name $job.name | Out-Null
                    $jobsCompleted++
                }
                elseif ($job.JobStateInfo.State -eq 'Failed')
                {
                    Remove-Job -Name $job.name | Out-Null
                    Write-Warning "{$($job.name)} failed"
                    break
                }

                $status = "Completed $jobsCompleted/$totalJobs jobs in $elapsedTime seconds"
                $percentCompleted = $jobsCompleted / $totalJobs * 100
                try
                {
                    Write-Progress -Activity "TeamsUser Extraction" -PercentComplete $percentCompleted -Status $status
                }
                catch
                {
                    Write-Verbose $_
                }
            }
            $elapsedTime ++
            Start-Sleep -Seconds 1
        } while ($count -ne 0)
        Write-Progress -Activity "TeamsUser Extraction" -PercentComplete 100 -Status "Completed" -Completed
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $result
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
