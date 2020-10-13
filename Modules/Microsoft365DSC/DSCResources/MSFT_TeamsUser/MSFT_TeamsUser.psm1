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
        $GlobalAdminAccount,

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

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        Write-Verbose -Message "Checking for existance of Team User $User"
        $team = Get-TeamByName $TeamName -ErrorAction SilentlyContinue
        if ($null -eq $team)
        {
            return $nullReturn
        }

        Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
        $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
        $data.Add("Resource", $ResourceName)
        $data.Add("Method", $MyInvocation.MyCommand)
        $data.Add("Principal", $GlobalAdminAccount.UserName)
        $data.Add("TenantId", $TenantId)
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

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
            GlobalAdminAccount    = $GlobalAdminAccount
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
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
        $GlobalAdminAccount,

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    $team = Get-TeamByName $TeamName

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("TeamName")
    $CurrentParameters.Add("GroupId", $team.GroupId)
    $CurrentParameters.Remove("GlobalAdminAccount")
    $CurrentParameters.Remove("ApplicationId")
    $CurrentParameters.Remove("TenantId")
    $CurrentParameters.Remove("CertificateThumbprint")
    $CurrentParameters.Remove("Ensure")

    if ($Ensure -eq "Present")
    {
        Write-Verbose -Message "Adding team user $User with role:$Role"
        Add-TeamUser @CurrentParameters
    }
    else
    {
        if ($Role -eq "Member" -and $CurrentParameters.ContainsKey("Role"))
        {
            $CurrentParameters.Remove("Role")
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
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Testing configuration of member $User to Team $TeamName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($null -eq $Role)
    {
        $CurrentValues.Remove("Role")
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
        $GlobalAdminAccount,

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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $result = ""

    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' -InboundParameters $PSBoundParameters
    if ($ConnectionMode -eq 'ServicePrincipal')
    {
        $organization = Get-M365DSCTenantDomain -ApplicationId $ApplicationId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
    }
    else
    {
        $organization = $GlobalAdminAccount.UserName.Split('@')[1]
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
                    $GlobalAdminAccount,

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
                    $content = ""
                    $j = 1
                    $ConnectionMode = New-M365DSCConnection -Platform 'MicrosoftTeams' -InboundParameters $PSBoundParameters

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
                                Write-Information "    > [$j/$totalCount] Team {$($team.DisplayName)}"
                                foreach ($user in $users)
                                {
                                    Write-Information "        - [$i/$($users.Length)] $($user.User)"

                                    if ($ConnectionMode -eq 'Credential')
                                    {
                                        $getParams = @{
                                            TeamName           = $team.DisplayName
                                            User               = $user.User
                                            GlobalAdminAccount = $params.GlobalAdminAccount
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
                                        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
                                        $result.Remove("ApplicationId")
                                        $result.Remove("TenantId")
                                        $result.Remove("CertificateThumbprint")
                                    }
                                    else
                                    {
                                        $result.Remove("GlobalAdminAccount")
                                    }
                                    $content += "        TeamsUser " + (New-GUID).ToString() + "`r`n"
                                    $content += "        {`r`n"
                                    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $params.ScriptRoot
                                    if ($ConnectionMode -eq 'Credential')
                                    {
                                        $partialContent = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
                                    }
                                    else
                                    {
                                        $partialContent = $currentDSCBlock
                                    }
                                    $partialContent += "        }`r`n"
                                    if ($partialContent.ToLower().Contains($params.OrganizationName.ToLower()))
                                    {
                                        $partialContent = $partialContent -ireplace [regex]::Escape($params.OrganizationName), "`$OrganizationName"
                                    }
                                    $content += $partialContent
                                    $i++
                                }
                            }
                            catch
                            {
                                Write-Information $_
                                Write-Information "The current User doesn't have the required permissions to extract Users for Team {$($team.DisplayName)}."
                            }
                            $j++
                        }
                    }
                    return $content
                }
                return $returnValue
            } -ArgumentList @($batch, $PSScriptRoot, $GlobalAdminAccount, $ApplicationId, $TenantId, $CertificateThumbprint, $organization) | Out-Null
            $i++
        }

        try
        {
            Write-Host "    `r`nBroke extraction process down into {$MaxProcesses} jobs of {$($instances[0].Length)} item(s) each" -NoNewLine
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
                    $partialResult = Receive-Job -name $job.name
                    $result += $partialResult
                    Remove-Job -name $job.name
                    $jobsCompleted++
                }
                elseif ($job.JobStateInfo.State -eq 'Failed')
                {
                    Remove-Job -name $job.name
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
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource
