Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AzureRoleDefinition'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CustomRoleName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Actions,

        [Parameter()]
        [System.String[]]
        $NotActions,

        [Parameter()]
        [System.String[]]
        $DataActions,

        [Parameter()]
        [System.String[]]
        $NotDataActions,

        [Parameter()]
        [System.String[]]
        $AssignableScopes,

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

    Write-Verbose -Message "Getting configuration of Azure Role Definition with Name {$CustomRoleName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $CustomRoleName)
        {
            $null = New-M365DSCConnection -Workload 'Azure' `
                -InboundParameters $PSBoundParameters

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

            $AzureRoleDefinition = $null
            try
            {
                if (-not [System.String]::IsNullOrEmpty($Id))
                {
                    $AzureRoleDefinition = Get-AzRoleDefinition -Id $Id -ErrorAction SilentlyContinue
                }
            }
            catch
            {
                Write-Verbose -Message "Could not retrieve Azure Role Definition by Id: {$Id}"
            }

            if ($null -eq $AzureRoleDefinition)
            {
                $AzureRoleDefinition = Get-AzRoleDefinition -Name $CustomRoleName -ErrorAction SilentlyContinue
            }

            if ($null -eq $AzureRoleDefinition)
            {
                return $nullReturn
            }

            if (-not $AzureRoleDefinition.IsCustom)
            {
                Write-Verbose -Message "Role definition {$CustomRoleName} is a built-in role. Returning Absent."
                return $nullReturn
            }
        }
        else
        {
            $AzureRoleDefinition = $Script:exportedInstance
        }

        $result = @{
            CustomRoleName        = $AzureRoleDefinition.Name
            Id                    = $AzureRoleDefinition.Id
            Description           = $AzureRoleDefinition.Description
            Actions               = [Array]$AzureRoleDefinition.Actions
            NotActions            = [Array]$AzureRoleDefinition.NotActions
            DataActions           = [Array]$AzureRoleDefinition.DataActions
            NotDataActions        = [Array]$AzureRoleDefinition.NotDataActions
            AssignableScopes      = [Array]$AzureRoleDefinition.AssignableScopes
            IsCustom              = $AzureRoleDefinition.IsCustom
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        return $result
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
        $CustomRoleName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Actions,

        [Parameter()]
        [System.String[]]
        $NotActions,

        [Parameter()]
        [System.String[]]
        $DataActions,

        [Parameter()]
        [System.String[]]
        $NotDataActions,

        [Parameter()]
        [System.String[]]
        $AssignableScopes,

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

    Write-Verbose -Message "Setting configuration of Azure Role Definition with Name {$CustomRoleName}"

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

    $currentInstance = Get-TargetResource @PSBoundParameters

    # Role definition should exist but does not
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Azure Role Definition {$CustomRoleName}"
        $roleObject = @{
            Name             = $CustomRoleName
            Description      = $Description
            Actions          = $Actions
            NotActions       = $NotActions
            DataActions      = $DataActions
            NotDataActions   = $NotDataActions
            AssignableScopes = $AssignableScopes
        }
        New-AzRoleDefinition -Role $roleObject
    }
    # Role definition exists and will be configured to desired state
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Azure Role Definition {$CustomRoleName}"
        $roleObject = @{
            Id               = $currentInstance.Id
            Name             = $CustomRoleName
            Description      = $Description
            Actions          = $Actions
            NotActions       = $NotActions
            DataActions      = $DataActions
            NotDataActions   = $NotDataActions
            AssignableScopes = $AssignableScopes
        }
        Set-AzRoleDefinition -Role $roleObject
    }
    # Role definition exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Azure Role Definition {$CustomRoleName}"
        Remove-AzRoleDefinition -Id $currentInstance.Id -Force
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
        $CustomRoleName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $Actions,

        [Parameter()]
        [System.String[]]
        $NotActions,

        [Parameter()]
        [System.String[]]
        $DataActions,

        [Parameter()]
        [System.String[]]
        $NotDataActions,

        [Parameter()]
        [System.String[]]
        $AssignableScopes,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'Azure' `
        -InboundParameters $PSBoundParameters

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

    $dscContent = ''
    $i = 1
    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-AzRoleDefinition -Custom -ErrorAction Stop

        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($role in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $($role.Name)" -DeferWrite
            $Params = @{
                CustomRoleName        = $role.Name
                Id                    = $role.Id
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $role
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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
