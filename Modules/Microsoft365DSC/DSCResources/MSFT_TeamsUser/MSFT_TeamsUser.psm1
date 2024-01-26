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
        [ValidateSet('Guest', 'Member', 'Owner')]
        $Role = 'Member',

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
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting configuration of member $User to Team $TeamName"

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

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
            Write-Verbose 'Retrieving user without a specific Role specified'
            $allMembers = Get-TeamUser -GroupId $team.GroupId -ErrorAction SilentlyContinue
        }
        catch
        {
            Write-Warning "The current user doesn't have the rights to access the list of members for Team {$($TeamName)}."
            Write-Verbose -Message $_
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
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        [ValidateSet('Guest', 'Member', 'Owner')]
        $Role = 'Member',

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
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Setting configuration of member $User to Team $TeamName"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

    $team = Get-TeamByName ([System.Net.WebUtility]::UrlEncode($TeamName))

    Write-Verbose -Message "Retrieve team GroupId: $($team.GroupId)"

    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove('TeamName') | Out-Null
    $CurrentParameters.Add('GroupId', $team.GroupId)
    $CurrentParameters.Remove('Credential') | Out-Null
    $CurrentParameters.Remove('ApplicationId') | Out-Null
    $CurrentParameters.Remove('TenantId') | Out-Null
    $CurrentParameters.Remove('CertificateThumbprint') | Out-Null
    $CurrentParameters.Remove('Ensure') | Out-Null
    $CurrentParameters.Remove('ManagedIdentity') | Out-Null

    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Adding team user $User with role:$Role"
        Add-TeamUser @CurrentParameters
    }
    else
    {
        if ($Role -eq 'Member' -and $CurrentParameters.ContainsKey('Role'))
        {
            $CurrentParameters.Remove('Role') | Out-Null
            Write-Verbose -Message 'Removed role parameter'
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
        [ValidateSet('Guest', 'Member', 'Owner')]
        $Role = 'Member',

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

    Write-Verbose -Message "Testing configuration of member $User to Team $TeamName"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($null -eq $Role)
    {
        $CurrentValues.Remove('Role') | Out-Null
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('Ensure', `
            'User', `
            'Role')

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
        [Switch]
        $ManagedIdentity
    )
    $InformationPreference = 'Continue'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' -InboundParameters $PSBoundParameters

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

    try
    {
        [array]$instances = Get-Team
        if ($instances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = [System.Text.StringBuilder]::new()
        $j = 1
        foreach ($item in $instances)
        {
            foreach ($team in $item)
            {
                try
                {
                    [Array]$users = Get-TeamUser -GroupId $team.GroupId
                    $k = 1
                    $totalCount = $instances.Length
                    if ($null -eq $totalCount)
                    {
                        $totalCount = 1
                    }
                    Write-Host "    > [$j/$totalCount] Team {$($team.DisplayName)}"
                    foreach ($user in $users)
                    {
                        Write-Host "        - [$k/$($users.Length)] $($user.User)" -NoNewline

                        $getParams = @{
                            TeamName              = $team.DisplayName
                            User                  = $user.User
                            Credential            = $Credential
                            ApplicationId         = $ApplicationId
                            TenantId              = $TenantId
                            CertificateThumbprint = $CertificateThumbprint
                            ManagedIdentity       = $ManagedIdentity.IsPresent
                        }
                        $results = Get-TargetResource @getParams
                        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                            -Results $Results
                        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                            -ConnectionMode $ConnectionMode `
                            -ModulePath $PSScriptRoot `
                            -Results $Results `
                            -Credential $Credential
                        $dscContent.Append($currentDSCBlock) | Out-Null
                        Save-M365DSCPartialExport -Content $currentDSCBlock `
                            -FileName $Global:PartialExportFileName
                        Write-Host $Global:M365DSCEmojiGreenCheckMark
                        $k++
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
        return $dscContent.ToString()
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
