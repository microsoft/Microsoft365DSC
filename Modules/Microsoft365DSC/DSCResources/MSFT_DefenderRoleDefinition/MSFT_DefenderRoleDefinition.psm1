Confirm-M365DSCModuleDependency -ModuleName 'MSFT_DefenderRoleDefinition'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RolePermissions,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of the Defender Role Definition with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/roleManagement/defender/roleDefinitions/$Id"
                $response = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction Stop
                [array]$definition = $response.value
            }
            if ($null -eq $definition -or $definition.Length -eq 0)
            {
                Write-Verbose -Message "No Defender Role Definition {$Id} was found by Identity. Trying to retrieve by DisplayName"
                $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/roleManagement/defender/roleDefinitions/?`$filter=displayName eq '$DisplayName'"
                $response = Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction SilentlyContinue
                [Array]$definition = $response.value
            }

            if ($null -ne $definition -and $definition.Length -gt 1)
            {
                throw "Multiple definitions with display name {$DisplayName} were found. Please ensure only one instance exists."
            }
            elseif ($null -eq $definition -or $definition.Length -eq 0)
            {
                Write-Verbose -Message "No Defender Role Definition {$DisplayName} was found by Display Name. Instance doesn't exist."
                return $nullResult
            }
        }
        else
        {
            $definition = $Script:exportedInstance
        }

        $rolePermissionsValue = $null
        if ($definition.RolePermissions.Length -gt 0)
        {
            $rolePermissionsValue = @(
                @{
                        allowedResourceActions = $definition.RolePermissions.allowedResourceActions
                }
            )
        }

        return @{
            Id                    = $definition.Id
            DisplayName           = $definition.DisplayName
            Description           = $definition.Description
            RolePermissions       = $rolePermissionsValue
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            ApplicationSecret     = $ApplicationSecret
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RolePermissions,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of the Defender Role Definition with DisplayName {$DisplayName}"

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

    $currentDefinition = Get-TargetResource @PSBoundParameters
    if ($Ensure -eq 'Present' -and $currentDefinition.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new Defender Role Definition {$DisplayName}"

        $newParams = @{
            displayName = $DisplayName
            description = $Description
            rolePermissions = @(
                @{
                    allowedResourceActions = [Array]($RolePermissions.allowedResourceActions)
                }
            )
        }

        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/roleManagement/defender/roleDefinitions"
        $response = Invoke-MgGraphRequest -Method POST -Uri $uri -Body $newParams
    }
    elseif ($Ensure -eq 'Present' -and $currentDefinition.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing Defender Role Definition {$DisplayName}"

        $updateParams = @{
            displayName = $DisplayName
            description = $Description
            rolePermissions = @(
                @{
                    allowedResourceActions = [Array]($RolePermissions.allowedResourceActions)
                }
            )
        }

        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/roleManagement/defender/roleDefinitions/$($currentDefinition.Id)"
        $response = Invoke-MgGraphRequest -Method PATCH -Uri $uri -Body $updateParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentDefinition.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Defender Role Definition {$DisplayName}"
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/roleManagement/defender/roleDefinitions/$($currentDefinition.Id)"
        $response = Invoke-MgGraphRequest -Method DELETE -Uri $uri
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $RolePermissions,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment
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
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "beta/roleManagement/defender/roleDefinitions"
        [array]$roleDefinitions = (Invoke-MgGraphRequest -Method GET -Uri $uri -ErrorAction Stop).value

        $i = 1
        $dscContent = ''
        if ($roleDefinitions.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($role in $roleDefinitions)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($roleDefinitions.Count)] $($role.displayName)" -DeferWrite
            $params = @{
                Id                    = $role.id
                DisplayName           = $role.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationID         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $role
            $Results = Get-TargetResource @Params

            if ($Results.RolePermissions)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.RolePermissions `
                                                                             -CIMInstanceName 'DefenderRoleDefinitionRolePermissions'
                if ($complexTypeStringResult)
                {
                    $Results.RolePermissions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('RolePermissions') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('RolePermissions')
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
