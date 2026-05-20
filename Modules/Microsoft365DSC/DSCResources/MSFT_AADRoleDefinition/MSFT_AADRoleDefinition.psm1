Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADRoleDefinition'

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
        [System.String[]]
        $ResourceScopes,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsEnabled,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $RolePermissions,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $Version,

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

    Write-Verbose -Message "Getting configuration of Azure AD Role Definition with DisplayName {$DisplayName}"

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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            try
            {
                if (($null -ne $Id) -and ($Id -ne ''))
                {
                    $AADRoleDefinition = Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "Id eq '$($Id)'"
                }
            }
            catch
            {
                Write-Verbose -Message "Could not retrieve AAD roledefinition by Id: {$Id}"
            }
            if ($null -eq $AADRoleDefinition)
            {
                $AADRoleDefinition = Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'"
            }
            if ($null -eq $AADRoleDefinition)
            {
                return $nullReturn
            }
        }
        else
        {
            $AADRoleDefinition = $Script:exportedInstance
        }
        $result = @{
            Id                    = $AADRoleDefinition.Id
            DisplayName           = $AADRoleDefinition.DisplayName
            Description           = $AADRoleDefinition.Description
            ResourceScopes        = $AADRoleDefinition.ResourceScopes
            IsEnabled             = $AADRoleDefinition.IsEnabled
            RolePermissions       = [Array]$AADRoleDefinition.RolePermissions.AllowedResourceActions
            TemplateId            = $AADRoleDefinition.TemplateId
            Version               = $AADRoleDefinition.Version
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            ApplicationSecret     = $ApplicationSecret
            TenantId              = $TenantId
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ResourceScopes,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsEnabled,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $RolePermissions,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $Version,

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

    Write-Verbose -Message 'Setting configuration of Azure AD role definition'

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

    $currentAADRoleDef = Get-TargetResource @PSBoundParameters
    $currentParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $currentParameters.Remove('RolePermissions') | Out-Null
    $currentParameters.Remove('ResourceScopes') | Out-Null

    $rolePermissionsObj = @()
    $rolePermissionsObj += @{'allowedResourceActions' = $rolePermissions }
    $resourceScopesObj = @()
    $resourceScopesObj += $ResourceScopes

    $currentParameters.Add('RolePermissions', $rolePermissionsObj) | Out-Null
    if ($ResourceScopes.Length -gt 0)
    {
        $currentParameters.Add('ResourceScopes', $resourceScopesObj) | Out-Null
    }

    # Role definition should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADRoleDef.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating New AzureAD role defition {$DisplayName} with parameters:"
        Write-Verbose -Message (Convert-M365DscHashtableToString -Hashtable $currentParameters)
        $currentParameters.Remove('Id') | Out-Null
        New-MgBetaRoleManagementDirectoryRoleDefinition @currentParameters
    }
    # Role definition should exist and will be configured to desired state
    if ($Ensure -eq 'Present' -and $currentAADRoleDef.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating existing AzureAD role definition {$DisplayName}"
        $currentParameters.Add('UnifiedRoleDefinitionId', $currentAADRoleDef.Id)
        $currentParameters.Remove('Id') | Out-Null
        Update-MgBetaRoleManagementDirectoryRoleDefinition @currentParameters
    }
    # Role definition exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADRoleDef.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AzureAD role definition {$DisplayName}"
        Remove-MgBetaRoleManagementDirectoryRoleDefinition -UnifiedRoleDefinitionId $currentAADRoleDef.Id
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
        [System.String[]]
        $ResourceScopes,

        [Parameter(Mandatory = $true)]
        [System.Boolean]
        $IsEnabled,

        [Parameter(Mandatory = $true)]
        [System.String[]]
        $RolePermissions,

        [Parameter()]
        [System.String]
        $TemplateId,

        [Parameter()]
        [System.String]
        $Version,

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $dscContent = [System.Text.StringBuilder]::new()
    $i = 1
    try
    {
        [array] $exportedInstances = Get-MgBetaRoleManagementDirectoryRoleDefinition -Filter $Filter -All -ErrorAction Stop
        if ($exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($AADRoleDefinition in $exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($exportedInstances.Count)] $($AADRoleDefinition.DisplayName)" -DeferWrite
            $Params = @{
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                DisplayName           = $AADRoleDefinition.DisplayName
                Id                    = $AADRoleDefinition.Id
                IsEnabled             = $true
                RolePermissions       = @('temp')
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $AADRoleDefinition
            $Results = Get-TargetResource @Params
            if ($Results.Ensure -eq 'Present' -and ([array]$results.RolePermissions).Length -gt 0)
            {
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                [void]$dscContent.Append($currentDSCBlock)
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }

            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('TemplateId')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
