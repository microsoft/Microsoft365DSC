function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $AdDomainName,

        [Parameter()]
        [System.String]
        $AdDomainPassword,

        [Parameter()]
        [System.String]
        $AdDomainUsername,

        [Parameter(Mandatory = $true)]
        [ValidateSet('hybridAzureADJoin', 'azureADJoin')]
        [System.String]
        $ConnectionType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubnetId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubscriptionName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $VirtualNetworkId,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,
        #endregion

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

    Write-Verbose -Message "Getting configuration for the Intune Azure Network Connection for Windows365 with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters
            $null = New-M365DSCConnection -Workload 'Azure' `
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

            $getValue = $null

            #region resource generator code
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection -CloudPcOnPremisesConnectionId $Id -ErrorAction SilentlyContinue
            }

            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Azure Network Connection for Windows365 with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ErrorAction SilentlyContinue
                }
            }
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Intune Azure Network Connection for Windows365 with DisplayName {$DisplayName}."
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Azure Network Connection for Windows365 with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $enumConnectionType = $null
        if ($null -ne $getValue.ConnectionType)
        {
            $enumConnectionType = $getValue.ConnectionType.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AdDomainName          = $getValue.AdDomainName
            AdDomainUsername      = $getValue.AdDomainUsername
            ConnectionType        = $enumConnectionType
            DisplayName           = $getValue.DisplayName
            OrganizationalUnit    = $getValue.OrganizationalUnit
            ResourceGroupId       = $getValue.ResourceGroupId.Replace("/subscriptions/$($getValue.SubscriptionId)/", "/subscriptions/$($getValue.SubscriptionName)/")
            RoleScopeTagIds       = $getValue.ScopeIds
            SubnetId              = $getValue.SubnetId.Replace("/subscriptions/$($getValue.SubscriptionId)/", "/subscriptions/$($getValue.SubscriptionName)/")
            SubscriptionName      = $getValue.SubscriptionName
            VirtualNetworkId      = $getValue.VirtualNetworkId.Replace("/subscriptions/$($getValue.SubscriptionId)/", "/subscriptions/$($getValue.SubscriptionName)/")
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            #endregion
        }

        if ($enumConnectionType -eq 'azureADJoin')
        {
            $results.Remove('AdDomainName')
            $results.Remove('AdDomainUsername')
            $results.Remove('OrganizationalUnit')
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

        throw
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $AdDomainName,

        [Parameter()]
        [System.String]
        $AdDomainPassword,

        [Parameter()]
        [System.String]
        $AdDomainUsername,

        [Parameter(Mandatory = $true)]
        [ValidateSet('hybridAzureADJoin', 'azureADJoin')]
        [System.String]
        $ConnectionType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubnetId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubscriptionName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $VirtualNetworkId,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,
        #endregion

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

    Write-Verbose -Message "Setting configuration of the Intune Azure Network Connection for Windows365 with Id {$Id} and DisplayName {$DisplayName}"

    if ($Type -eq 'hybridAzureADJoin' -and ($PSBoundParameters.ContainsKey('AdDomainName') -or $PSBoundParameters.ContainsKey('AdDomainPassword') -or $PSBoundParameters.ContainsKey('AdDomainUsername')))
    {
        throw 'AdDomainName, AdDomainPassword and AdDomainUsername are required for hybridAzureADJoin'
    }

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
    $boundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    $subscription = Get-AzSubscription -SubscriptionName $SubscriptionName -ErrorAction SilentlyContinue
    if ($null -eq $subscription)
    {
        throw "Could not find a subscription with name '$SubscriptionName'. Please verify the SubscriptionName is correct and that the identity has access to it."
    }
    $boundParameters.Remove('SubscriptionName') | Out-Null
    $boundParameters.Add('SubscriptionId', $subscription.Id)
    $boundParameters.ResourceGroupId = $boundParameters.ResourceGroupId.Replace("/subscriptions/$SubscriptionName/", "/subscriptions/$($subscription.Id)/")
    $boundParameters.SubnetId = $boundParameters.SubnetId.Replace("/subscriptions/$SubscriptionName/", "/subscriptions/$($subscription.Id)/")
    $boundParameters.VirtualNetworkId = $boundParameters.VirtualNetworkId.Replace("/subscriptions/$SubscriptionName/", "/subscriptions/$($subscription.Id)/")

    if ($boundParameters.ContainsKey('RoleScopeTagIds'))
    {
        $boundParameters.Add('ScopeIds', $boundParameters['RoleScopeTagIds'])
        $boundParameters.Remove('RoleScopeTagIds') | Out-Null
    }

    if ($Type -eq 'azureADJoin')
    {
        $boundParameters.Remove('AdDomainName') | Out-Null
        $boundParameters.Remove('AdDomainPassword') | Out-Null
        $boundParameters.Remove('AdDomainUsername') | Out-Null
        $boundParameters.Remove('OrganizationalUnit') | Out-Null
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Azure Network Connection for Windows365 with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters = Rename-M365DSCCimInstanceParameter -Properties $createParameters
        $createParameters.Remove('Id') | Out-Null
        $createParameters.Add('ManagedBy', 'windows365')

        #region resource generator code
        $null = New-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection -BodyParameter $createParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Azure Network Connection for Windows365 with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$boundParameters).Clone()
        $updateParameters = Rename-M365DSCCimInstanceParameter -Properties $updateParameters
        $updateParameters.Remove('Id') | Out-Null

        #region resource generator code
        try
        {
            Update-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection `
                -CloudPcOnPremisesConnectionId $currentInstance.Id `
                -BodyParameter $updateParameters `
                -ErrorAction Stop
        }
        catch
        {
            throw "Failed to update the Intune Azure Network Connection for Windows365 with Id {$($currentInstance.Id)}. Please make sure it is not referenced by any Cloud Provisioning Policies or in checking state. Error: $($_.Exception.Message)"
        }

        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Azure Network Connection for Windows365 with Id {$($currentInstance.Id)}"
        #region resource generator code
        try
        {
            Remove-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection -CloudPcOnPremisesConnectionId $currentInstance.Id -ErrorAction Stop
        }
        catch
        {
            throw "Failed to remove the Intune Azure Network Connection for Windows365 with Id {$($currentInstance.Id)}. Please make sure it is not referenced by any Cloud Provisioning Policies or in checking state. Error: $($_.Exception.Message)"
        }
        #endregion
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $AdDomainName,

        [Parameter()]
        [System.String]
        $AdDomainPassword,

        [Parameter()]
        [System.String]
        $AdDomainUsername,

        [Parameter(Mandatory = $true)]
        [ValidateSet('hybridAzureADJoin', 'azureADJoin')]
        [System.String]
        $ConnectionType,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $OrganizationalUnit,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubnetId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SubscriptionName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $VirtualNetworkId,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,
        #endregion

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

    $excludedProperties = @()
    if ($ConnectionType -eq 'azureADJoin')
    {
        $excludedProperties += @('AdDomainName', 'AdDomainUsername', 'OrganizationalUnit')
    }

    $compareParameters = Get-CompareParameters
    $compareParameters.ExcludedProperties += $excludedProperties
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
    $null = New-M365DSCConnection -Workload 'Azure' `
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
        #region resource generator code
        [array]$getValue = Get-MgBetaDeviceManagementVirtualEndpointOnPremiseConnection `
            -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

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
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            elseif (-not [string]::IsNullOrEmpty($config.name))
            {
                $displayedKey = $config.name
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                ConnectionType        = $config.ConnectionType
                ResourceGroupId       = $config.ResourceGroupId
                SubnetId              = $config.SubnetId
                SubscriptionName      = $config.SubscriptionName
                VirtualNetworkId      = $config.VirtualNetworkId
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('SubscriptionName', 'AdDomainPassword')
        IncludedProperties = @('ResourceGroupId', 'SubnetId', 'SubscriptionName', 'VirtualNetworkId')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
