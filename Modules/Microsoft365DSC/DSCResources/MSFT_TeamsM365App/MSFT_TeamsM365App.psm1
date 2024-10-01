function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $IsBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'UsersAndGroups', 'NoOne')]
        $AssignmentType,

        [Parameter()]
        [System.String[]]
        $Users,

        [Parameter()]
        [System.String[]]
        $Groups,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters | Out-Null

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.Id -eq $Id}
        }
        else
        {
            $instance = Get-M365TeamsApp -Id $Id -ErrorAction Stop
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $usersValue = @()
        if ($null -ne $instance.AvailableTo.Users)
        {
            foreach ($userEntry in $instance.AvailableTo.Users)
            {
                $userInfo = Get-MgUser -UserId $userEntry.Id
                $usersValue += $userInfo.UserPrincipalName
            }
        }

        $groupsValue = @()
        if ($null -ne $instance.AvailableTo.Groups)
        {
            foreach ($groupEntry in $instance.AvailableTo.Groups)
            {
                $groupInfo = Get-MgGroup -GroupId $groupEntry.Id
                $groupsValue += $groupInfo.DisplayName
            }
        }

        Write-Verbose -Message "Found an instance with Id {$Id}"
        $results = @{
            Id                    = $instance.Id
            IsBlocked             = [Boolean]$instance.IsBlocked
            AssignmentType        = $instance.AvailableTo.AssignmentType
            Users                 = $usersValue
            Groups                = $groupsValue
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $IsBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'UsersAndGroups', 'NoOne')]
        $AssignmentType,

        [Parameter()]
        [System.String[]]
        $Users,

        [Parameter()]
        [System.String[]]
        $Groups,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    Write-Verbose -Message "Updating {$Id}"

    if ($AssignmentType -eq 'UsersAndGroups')
    {
        #region Users
        $usersDelta = Compare-Object -ReferenceObject $currentInstance.Users -DifferenceObject $Users
        $usersToAdd = @()
        $usersToRemove = @()
        foreach ($delta in $usersDelta)
        {
            if ($delta.SideIndicator -eq '<=')
            {
                $userInfo = Get-MgUser -UserId $delta.InputObject -ErrorAction Stop
                $usersToRemove += $userInfo.Id
            }
            elseif ($delta.SideIndicator -eq '=>')
            {
                $userInfo = Get-MgUser -UserId $delta.InputObject -ErrorAction Stop
                $usersToAdd += $userInfo.Id
            }
        }

        if ($usersToRemove.Length -gt 0)
        {
            Write-Verbose -Message "Removing Users Assignments for {$($usersToAdd)}"
            Update-M365TeamsApp -Id $Id `
                                -IsBlocked $IsBlocked `
                                -AppAssignmentType $AssignmentType `
                                -OperationType 'Remove' `
                                -Users $usersToRemove
        }

        if ($usersToAdd.Length -gt 0)
        {
            Write-Verbose -Message "Removing Users Assignments for {$($usersToAdd)}"
            Update-M365TeamsApp -Id $Id `
                                -IsBlocked $IsBlocked `
                                -AppAssignmentType $AssignmentType `
                                -OperationType 'Add' `
                                -Users $usersToAdd
        }
        #endregion

        #region Groups
        $groupsDelta = Compare-Object -ReferenceObject $currentInstance.Groups -DifferenceObject $Groups
        $groupsToAdd = @()
        $groupsToRemove = @()
        foreach ($delta in $groupsDelta)
        {
            if ($delta.SideIndicator -eq '<=')
            {
                $groupInfo = Get-MgGroup -Filter "displayName eq '$($delta.InputObject)'" -ErrorAction Stop
                $groupsToRemove += $groupInfo.Id
            }
            elseif ($delta.SideIndicator -eq '=>')
            {
                $groupInfo = Get-MgGroup -Filter "displayName eq '$($delta.InputObject)'" -ErrorAction Stop
                $groupsToAdd += $groupInfo.Id
            }
        }

        if ($groupsToRemove.Length -gt 0)
        {
            Write-Verbose -Message "Removing Group Assignments for {$($groupsToRemove)}"
            Update-M365TeamsApp -Id $Id `
                                -IsBlocked $IsBlocked `
                                -AppAssignmentType $AssignmentType `
                                -OperationType 'Remove' `
                                -Groups $groupsToRemove
        }

        if ($groupsToAdd.Length -gt 0)
        {
            Write-Verbose -Message "Adding Group Assignments for {$($groupsToAdd)}"
            Update-M365TeamsApp -Id $Id `
                                -IsBlocked $IsBlocked `
                                -AppAssignmentType $AssignmentType `
                                -OperationType 'Add' `
                                -Groups $groupsToAdd
        }
        #endregion
    }
    else
    {
        Write-Verbose -Message "Updating core settings for app {$Id}"
        Update-M365TeamsApp -Id $Id `
                        -IsBlocked $IsBlocked `
                        -AppAssignmentType $AssignmentType
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
        $Id,

        [Parameter()]
        [System.Boolean]
        $IsBlocked,

        [Parameter()]
        [System.String]
        [ValidateSet('Everyone', 'UsersAndGroups', 'NoOne')]
        $AssignmentType,

        [Parameter()]
        [System.String[]]
        $Users,

        [Parameter()]
        [System.String[]]
        $Groups,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of {$Id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-AllM365TeamsApps -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
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
