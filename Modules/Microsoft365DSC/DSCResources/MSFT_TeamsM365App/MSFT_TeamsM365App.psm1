Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsM365App'

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

    Write-Verbose -Message "Getting configuration for Teams M365App $Id"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
                -InboundParameters $PSBoundParameters

            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $nullResult = $PSBoundParameters
            $instance = Get-M365TeamsApp -Id $Id -ErrorAction SilentlyContinue
        }
        else
        {
            $instance = $Script:exportedInstance
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
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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

    Write-Verbose -Message "Setting configuration for Teams M365App $Id"

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
                $groupInfo = Get-MgGroup -Filter "DisplayName eq '$($delta.InputObject -replace "'", "''")'" -ErrorAction Stop
                $groupsToRemove += $groupInfo.Id
            }
            elseif ($delta.SideIndicator -eq '=>')
            {
                $groupInfo = Get-MgGroup -Filter "DisplayName eq '$($delta.InputObject -replace "'", "''")'" -ErrorAction Stop
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
        [array] $Script:exportedInstances = @()
        try
        {
            [array] $Script:exportedInstances = Get-AllM365TeamsApps -ErrorAction Stop
        }
        catch
        {
            Write-Verbose $_
        }

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.Id
            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
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
