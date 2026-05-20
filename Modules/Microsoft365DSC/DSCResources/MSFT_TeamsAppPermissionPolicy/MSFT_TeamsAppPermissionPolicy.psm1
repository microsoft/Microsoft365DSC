Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsAppPermissionPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GlobalCatalogAppsType,

        [Parameter()]
        [System.String]
        $PrivateCatalogAppsType,

        [Parameter()]
        [System.String]
        $DefaultCatalogAppsType,

        [Parameter()]
        [System.String[]]
        $GlobalCatalogApps,

        [Parameter()]
        [System.String[]]
        $PrivateCatalogApps,

        [Parameter()]
        [System.String[]]
        $DefaultCatalogApps,

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

    Write-Verbose -Message "Getting configuration for TeamsAppPermissionPolicy $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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
            $nullResult.Ensure = 'Absent'

            $instance = Get-CsTeamsAppPermissionPolicy -Identity $Identity -ErrorAction SilentlyContinue
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        if ($null -eq $instance)
        {
            return $nullResult
        }

        $DefaultCatalogAppsValue = $instance.DefaultCatalogApps.Id
        if ($instance.DefaultCatalogApps.Count -eq 0)
        {
            $DefaultCatalogAppsValue = @()
        }

        $GlobalCatalogAppsValue = $instance.GlobalCatalogApps.Id
        if ($instance.GlobalCatalogApps.Count -eq 0)
        {
            $GlobalCatalogAppsValue = @()
        }

        $PrivateCatalogAppsValue = $instance.PrivateCatalogApps.Id
        if ($instance.PrivateCatalogApps.Count -eq 0)
        {
            $PrivateCatalogAppsValue = @()
        }

        Write-Verbose -Message "Found an instance with Identity {$Identity}"
        $results = @{
            Identity               = $instance.Identity.Replace('Tag:', '')
            Description            = $instance.Description
            GlobalCatalogAppsType  = $instance.GlobalCatalogAppsType
            PrivateCatalogAppsType = $instance.PrivateCatalogAppsType
            DefaultCatalogAppsType = $instance.DefaultCatalogAppsType
            GlobalCatalogApps      = [Array]$GlobalCatalogAppsValue
            PrivateCatalogApps     = [Array]$PrivateCatalogAppsValue
            DefaultCatalogApps     = [Array]$DefaultCatalogAppsValue
            Ensure                 = 'Present'
            Credential             = $Credential
            ApplicationId          = $ApplicationId
            TenantId               = $TenantId
            CertificateThumbprint  = $CertificateThumbprint
            ManagedIdentity        = $ManagedIdentity.IsPresent
            AccessTokens           = $AccessTokens
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
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GlobalCatalogAppsType,

        [Parameter()]
        [System.String]
        $PrivateCatalogAppsType,

        [Parameter()]
        [System.String]
        $DefaultCatalogAppsType,

        [Parameter()]
        [System.String[]]
        $GlobalCatalogApps,

        [Parameter()]
        [System.String[]]
        $PrivateCatalogApps,

        [Parameter()]
        [System.String[]]
        $DefaultCatalogApps,

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

    Write-Verbose -Message "Setting configuration for TeamsAppPermissionPolicy $Identity"

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

    $DefaultCatalogAppsValue = @()
    if ($DefaultCatalogApps.Count -gt 0)
    {
        foreach ($appEntry in $DefaultCatalogApps)
        {
            $DefaultCatalogAppsValue += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.DefaultCatalogApp]::New($appEntry)
        }
    }
    $PrivateCatalogAppsValue = @()
    if ($PrivateCatalogApps.Count -gt 0)
    {
        foreach ($appEntry in $PrivateCatalogApps)
        {
            $PrivateCatalogAppsValue += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.PrivateCatalogApp]::New($appEntry)
        }
    }
    $GlobalCatalogAppsValue = @()
    if ($GlobalCatalogApps.Count -gt 0)
    {
        foreach ($appEntry in $GlobalCatalogApps)
        {
            $GlobalCatalogAppsValue += [Microsoft.Teams.Policy.Administration.Cmdlets.Core.GlobalCatalogApp]::New($appEntry)
        }
    }
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $CreateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $CreateParameters.Remove('Verbose') | Out-Null
        Write-Verbose -Message "Creating a Teams App Permission Policy with Identity {$Identity}"

        $CreateParameters.GlobalCatalogApps = $GlobalCatalogAppsValue
        $CreateParameters.PrivateCatalogApps = $PrivateCatalogAppsValue
        $CreateParameters.DefaultCatalogApps = $DefaultCatalogAppsValue

        New-CsTeamsAppPermissionPolicy @CreateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $UpdateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
        $UpdateParameters.Remove('Verbose') | Out-Null
        Write-Verbose -Message "Updating the Teams App Permission Policy with Identity {$Identity}"

        $UpdateParameters.GlobalCatalogApps = $GlobalCatalogAppsValue
        $UpdateParameters.PrivateCatalogApps = $PrivateCatalogAppsValue
        $UpdateParameters.DefaultCatalogApps = $DefaultCatalogAppsValue

        Set-CsTeamsAppPermissionPolicy @UpdateParameters | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Teams App Permission Policy with Identity {$Identity}"
        Remove-CsTeamsAppPermissionPolicy -Identity $currentInstance.Identity
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
        $Identity,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $GlobalCatalogAppsType,

        [Parameter()]
        [System.String]
        $PrivateCatalogAppsType,

        [Parameter()]
        [System.String]
        $DefaultCatalogAppsType,

        [Parameter()]
        [System.String[]]
        $GlobalCatalogApps,

        [Parameter()]
        [System.String[]]
        $PrivateCatalogApps,

        [Parameter()]
        [System.String[]]
        $DefaultCatalogApps,

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
        $Filter = "*",

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
        [array]$getValue = Get-CsTeamsAppPermissionPolicy -Filter $Filter -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Identity
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Ensure                = 'Present'
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
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
