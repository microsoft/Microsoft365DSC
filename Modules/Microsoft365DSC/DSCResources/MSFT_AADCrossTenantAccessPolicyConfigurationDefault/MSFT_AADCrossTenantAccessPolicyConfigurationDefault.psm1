Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADCrossTenantAccessPolicyConfigurationDefault'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BCollaborationInbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BCollaborationOutbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BDirectConnectInbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BDirectConnectOutbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InboundTrust,

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Getting configuration of AzureAD Cross Tenant Access Policy Configuration Default"

    try
    {
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
        $nullResult.Ensure = 'Absent'

        $getValue = Get-MgBetaPolicyCrossTenantAccessPolicyDefault -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Cross Tenant Access Configuration Default"
            return $nullResult
        }

        $B2BCollaborationInboundValue = $null
        if ($null -ne $getValue.B2BCollaborationInbound)
        {
            $B2BCollaborationInboundValue = [ordered]@{
                Applications = [ordered]@{
                    AccessType = $getValue.B2BCollaborationInbound.Applications.AccessType
                    Targets    = [System.Array]$getValue.B2BCollaborationInbound.Applications.Targets
                }
                UsersAndGroups = [ordered]@{
                    AccessType = $getValue.B2BCollaborationInbound.UsersAndGroups.AccessType
                    Targets    = [System.Array] $getValue.B2BCollaborationInbound.UsersAndGroups.Targets
                }
            }

            # Convert users back to UPN
            $newValue = @()
            foreach ($valueEntry in $B2BCollaborationInboundValue.UsersAndGroups.Targets)
            {
                $currentEntry = [ordered]@{
                    Target     = $valueEntry.Target
                    TargetType = $valueEntry.TargetType
                }
                if ($valueEntry.TargetType -eq 'user')
                {
                    $user = Get-MgUser -UserId $valueEntry.Target -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $currentEntry.Target = $user.UserPrincipalName
                    }
                    else
                    {
                        $currentEntry.Target = $valueEntry.Target
                    }
                }
                else
                {
                    $group = [System.Array] (Get-MgGroup -GroupId $valueEntry.Target -ErrorAction SilentlyContinue)
                    if ($null -ne $group -and $group.Length -eq 1)
                    {
                        $currentEntry.Target = $group.DisplayName
                    }
                    else
                    {
                        $currentEntry.Target = $valueEntry.Target
                    }
                }
                $newValue += $currentEntry
            }
            $B2BCollaborationInboundValue.UsersAndGroups.Targets = $newValue
        }
        if ($null -ne $getValue.B2BCollaborationOutbound)
        {
            $B2BCollaborationOutboundValue = [ordered]@{
                Applications = [ordered]@{
                    AccessType = $getValue.B2BCollaborationOutbound.Applications.AccessType
                    Targets    = [System.Array] $getValue.B2BCollaborationOutbound.Applications.Targets
                }
                UsersAndGroups = [ordered]@{
                    AccessType = $getValue.B2BCollaborationOutbound.UsersAndGroups.AccessType
                    Targets    = [System.Array] $getValue.B2BCollaborationOutbound.UsersAndGroups.Targets
                }
            }

            # Convert users back to UPN
            $newValue = @()
            foreach ($valueEntry in $B2BCollaborationOutboundValue.UsersAndGroups.Targets)
            {
                $currentEntry = [ordered]@{
                    Target     = $valueEntry.Target
                    TargetType = $valueEntry.TargetType
                }
                if ($valueEntry.TargetType -eq 'user')
                {
                    $user = Get-MgUser -UserId $valueEntry.Target -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $currentEntry.Target = $user.UserPrincipalName
                    }
                    else
                    {
                        $currentEntry.Target = $valueEntry.Target
                    }
                }
                else
                {
                    $group = [System.Array] (Get-MgGroup -GroupId $valueEntry.Target -ErrorAction SilentlyContinue)
                    if ($null -ne $group -and $group.Length -eq 1)
                    {
                        $currentEntry.Target = $group.DisplayName
                    }
                    else
                    {
                        $currentEntry.Target = $valueEntry.Target
                    }
                }
                $newValue += $currentEntry
            }
            $B2BCollaborationOutboundValue.UsersAndGroups.Targets = $newValue
        }
        if ($null -ne $getValue.B2BDirectConnectInbound)
        {
            $B2BDirectConnectInboundValue = [ordered]@{
                Applications = [ordered]@{
                    AccessType = $getValue.B2BDirectConnectInbound.Applications.AccessType
                    Targets    = [System.Array] $getValue.B2BDirectConnectInbound.Applications.Targets
                }
                UsersAndGroups = [ordered]@{
                    AccessType = $getValue.B2BDirectConnectInbound.UsersAndGroups.AccessType
                    Targets    = [System.Array] $getValue.B2BDirectConnectInbound.UsersAndGroups.Targets
                }
            }
        }
        if ($null -ne $getValue.B2BDirectConnectOutbound)
        {
            $B2BDirectConnectOutboundValue = [ordered]@{
                Applications = [ordered]@{
                    AccessType = $getValue.B2BDirectConnectOutbound.Applications.AccessType
                    Targets    = [System.Array] $getValue.B2BDirectConnectOutbound.Applications.Targets
                }
                UsersAndGroups = [ordered]@{
                    AccessType = $getValue.B2BDirectConnectOutbound.UsersAndGroups.AccessType
                    Targets    = [System.Array] $getValue.B2BDirectConnectOutbound.UsersAndGroups.Targets
                }
            }
            # Convert users back to UPN
            $newValue = @()
            foreach ($valueEntry in $B2BDirectConnectOutboundValue.UsersAndGroups.Targets)
            {
                $currentEntry = [ordered]@{
                    Target     = $valueEntry.Target
                    TargetType = $valueEntry.TargetType
                }
                if ($valueEntry.TargetType -eq 'user')
                {
                    $user = Get-MgUser -UserId $valueEntry.Target -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $currentEntry.Target = $user.UserPrincipalName
                    }
                    else
                    {
                        $currentEntry.Target = $valueEntry.Target
                    }
                }
                else
                {
                    $group = [System.Array] (Get-MgGroup -GroupId $valueEntry.Target -ErrorAction SilentlyContinue)
                    if ($null -ne $group -and $group.Length -eq 1)
                    {
                        $currentEntry.Target = $group.DisplayName
                    }
                    else
                    {
                        $currentEntry.Target = $valueEntry.Target
                    }
                }
                $newValue += $currentEntry
            }
            $B2BDirectConnectOutboundValue.UsersAndGroups.Targets = $newValue
        }
        if ($null -ne $getValue.InboundTrust)
        {
            $InboundTrustValue = [ordered]@{
                IsCompliantDeviceAccepted           = $getValue.InboundTrust.IsCompliantDeviceAccepted
                IsHybridAzureADJoinedDeviceAccepted = $getValue.InboundTrust.IsHybridAzureADJoinedDeviceAccepted
                IsMfaAccepted                       = $getValue.InboundTrust.IsMfaAccepted
            }
        }

        $results = @{
            IsSingleInstance         = 'Yes'
            B2BCollaborationInbound  = $B2BCollaborationInboundValue
            B2BCollaborationOutbound = $B2BCollaborationOutboundValue
            B2BDirectConnectInbound  = $B2BDirectConnectInboundValue
            B2BDirectConnectOutbound = $B2BDirectConnectOutboundValue
            InboundTrust             = $InboundTrustValue
            Ensure                   = 'Present'
            Credential               = $Credential
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            ApplicationSecret        = $ApplicationSecret
            CertificateThumbprint    = $CertificateThumbprint
            ManagedIdentity          = $ManagedIdentity.IsPresent
            AccessTokens             = $AccessTokens
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BCollaborationInbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BCollaborationOutbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BDirectConnectInbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BDirectConnectOutbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InboundTrust,

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Setting configuration of AzureAD Cross Tenant Access Policy Configuration Default"

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

    $OperationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $OperationParams.Remove('IsSingleInstance') | Out-Null

    if ($null -ne $OperationParams.B2BCollaborationInbound)
    {
        $OperationParams.B2BCollaborationInbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BCollaborationInbound)
        $OperationParams.B2BCollaborationInbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BCollaborationInbound)
        $temp = $OperationParams.B2BCollaborationInbound
        $OperationParams.Remove('B2BCollaborationInbound') | Out-Null
        $OperationParams.Add('b2bCollaborationInbound', $temp)
    }
    if ($null -ne $OperationParams.B2BCollaborationOutbound)
    {
        $OperationParams.B2BCollaborationOutbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BCollaborationOutbound)
        $OperationParams.B2BCollaborationOutbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BCollaborationOutbound)
        $temp = $OperationParams.B2BCollaborationOutbound
        $OperationParams.Remove('B2BCollaborationOutbound') | Out-Null
        $OperationParams.Add('b2bCollaborationOutbound', $temp)
    }
    if ($null -ne $OperationParams.B2BDirectConnectInbound)
    {
        $OperationParams.B2BDirectConnectInbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BDirectConnectInbound)
        $OperationParams.B2BDirectConnectInbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BDirectConnectInbound)
        $temp = $OperationParams.B2BDirectConnectInbound
        $OperationParams.Remove('B2BDirectConnectInbound') | Out-Null
        $OperationParams.Add('b2bDirectConnectInbound', $temp)
    }
    if ($null -ne $OperationParams.B2BDirectConnectOutbound)
    {
        $OperationParams.B2BDirectConnectOutbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BDirectConnectOutbound)
        $OperationParams.B2BDirectConnectOutbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BDirectConnectOutbound)
        $temp = $OperationParams.B2BDirectConnectOutbound
        $OperationParams.Remove('B2BDirectConnectOutbound') | Out-Null
        $OperationParams.Add('b2bDirectConnectOutbound', $temp)
    }
    if ($null -ne $OperationParams.InboundTrust)
    {
        $OperationParams.InboundTrust = (Get-M365DSCAADCrossTenantAccessPolicyInboundTrust -Setting $OperationParams.InboundTrust)
        $temp = $OperationParams.InboundTrust
        $OperationParams.Remove('InboundTrust') | Out-Null
        $OperationParams.Add('inboundTrust', $temp)
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $body = ConvertTo-Json $OperationParams -Depth 10
        Write-Verbose -Message "Updating Cross Tenant Access Policy Configuration Default with:`r`n$body"
        $uri = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + 'beta/policies/crossTenantAccessPolicy/default'
        Invoke-MgGraphRequest -Method 'PATCH' -Uri $uri -Body $body
        #Update-MgBetaPolicyCrossTenantAccessPolicyDefault @OperationParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Removing Cross Tenant Access Policy Configuration Default is not supported'
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
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BCollaborationInbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BCollaborationOutbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BDirectConnectInbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $B2BDirectConnectOutbound,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $InboundTrust,

        [Parameter()]
        [System.String]
        [ValidateSet('Present')]
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

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $dscContent = ''
        $Params = @{
            IsSingleInstance      = 'Yes'
            ApplicationSecret     = $ApplicationSecret
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Credential            = $Credential
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        $Results = Get-TargetResource @Params

        if ($null -ne $Results.B2BCollaborationInbound)
        {
            $complexMapping = @(
                @{
                    Name            = 'B2BCollaborationInbound'
                    CimInstanceName = 'AADCrossTenantAccessPolicyB2BSetting'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Applications'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'UsersAndGroups'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Targets'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTarget'
                    IsRequired      = $False
                }
            )
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.B2BCollaborationInbound `
                -CIMInstanceName 'AADCrossTenantAccessPolicyB2BSetting' `
                -ComplexTypeMapping $complexMapping

            if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
            {
                $Results.B2BCollaborationInbound = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('B2BCollaborationInbound') | Out-Null
            }
        }

        if ($null -ne $Results.B2BCollaborationOutbound)
        {
            $complexMapping = @(
                @{
                    Name            = 'B2BCollaborationOutbound'
                    CimInstanceName = 'AADCrossTenantAccessPolicyB2BSetting'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Applications'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'UsersAndGroups'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Targets'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTarget'
                    IsRequired      = $False
                }
            )
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.B2BCollaborationOutbound `
                -CIMInstanceName 'AADCrossTenantAccessPolicyB2BSetting' `
                -ComplexTypeMapping $complexMapping

            if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
            {
                $Results.B2BCollaborationOutbound = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('B2BCollaborationOutbound') | Out-Null
            }
        }

        if ($null -ne $Results.B2BDirectConnectInbound)
        {
            $complexMapping = @(
                @{
                    Name            = 'B2BDirectConnectInbound'
                    CimInstanceName = 'AADCrossTenantAccessPolicyB2BSetting'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Applications'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'UsersAndGroups'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Targets'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTarget'
                    IsRequired      = $False
                }
            )
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.B2BDirectConnectInbound `
                -CIMInstanceName 'AADCrossTenantAccessPolicyB2BSetting' `
                -ComplexTypeMapping $complexMapping

            if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
            {
                $Results.B2BDirectConnectInbound = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('B2BDirectConnectInbound') | Out-Null
            }
        }

        if ($null -ne $Results.B2BDirectConnectOutbound)
        {
            $complexMapping = @(
                @{
                    Name            = 'B2BDirectConnectOutbound'
                    CimInstanceName = 'AADCrossTenantAccessPolicyB2BSetting'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Applications'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'UsersAndGroups'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTargetConfiguration'
                    IsRequired      = $False
                },
                @{
                    Name            = 'Targets'
                    CimInstanceName = 'AADCrossTenantAccessPolicyTarget'
                    IsRequired      = $False
                }
            )
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.B2BDirectConnectOutbound `
                -CIMInstanceName 'AADCrossTenantAccessPolicyB2BSetting' `
                -ComplexTypeMapping $complexMapping

            if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
            {
                $Results.B2BDirectConnectOutbound = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('B2BDirectConnectOutbound') | Out-Null
            }
        }

        if ($null -ne $Results.InboundTrust)
        {
            $complexMapping = @(
                @{
                    Name            = 'InboundTrust'
                    CimInstanceName = 'AADCrossTenantAccessPolicyInboundTrust'
                    IsRequired      = $False
                }
            )
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $Results.InboundTrust `
                -CIMInstanceName 'AADCrossTenantAccessPolicyInboundTrust' `
                -ComplexTypeMapping $complexMapping

            if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
            {
                $Results.InboundTrust = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('InboundTrust') | Out-Null
            }
        }

        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential `
            -NoEscape @('B2BCollaborationInbound', 'B2BCollaborationOutbound', 'B2BDirectConnectInbound', 'B2BDirectConnectOutbound', 'InboundTrust')

        # Fix OrganizationName variable in CIMInstance
        $currentDSCBlock = $currentDSCBlock.Replace('@$OrganizationName''', "@' + `$OrganizationName")

        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName

        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite

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

function Update-M365DSCSettingUserIdFromUPN
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Setting
    )

    if ($null -ne $Setting.UsersAndGroups -and $null -ne $Setting.UsersAndGroups.Targets)
    {
        for ($i = 0; $i -le $Setting.UsersAndGroups.Targets.Length; $i++)
        {
            $user = $Setting.UsersAndGroups.Targets[$i]
            $userValue = $user.Target
            if ($null -ne $userValue)
            {
                if ($user.TargetType -eq 'user')
                {
                    Write-Verbose -Message "Detected User type with UPN {$($user.Target)}"
                    $user = Get-MgUser -UserId $user.Target -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $userValue = $user.Id
                    }
                }
                elseif ($user.TargetType -eq 'group')
                {
                    Write-Verbose -Message "Detected Group type with Name {$($user.Target)}"
                    $group = Get-MgGroup -Filter "DisplayName eq  '$($user.Target)'" -ErrorAction SilentlyContinue
                    if ($null -ne $group)
                    {
                        $userValue = $group.Id
                    }
                }
            }
            if ($null -ne $userValue)
            {
                Write-Verbose -Message "Updating principal to Id {$userValue}"
            }
            if ($null -ne $Setting.UsersAndGroups.Targets[$i].Target)
            {
                $Setting.UsersAndGroups.Targets[$i].Target = $userValue
            }
        }
    }
    return $Setting
}

function Get-M365DSCAADCrossTenantAccessPolicyB2BSetting
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Setting
    )

    #region Applications
    $applications = @{
        accessType = $Setting.applications.accessType
    }

    if ($null -ne $Setting.applications.targets)
    {
        $targets = @()
        foreach ($currentTarget in $Setting.applications.targets)
        {
            $targets += @{
                target     = $currentTarget.target
                targetType = $currentTarget.targetType
            }
        }
        $applications.Add('targets', $targets)
    }
    #endregion

    #region UsersAndGroups
    $usersAndGroups = @{
        accessType = $Setting.usersAndGroups.accessType
    }

    if ($null -ne $Setting.usersAndGroups.targets)
    {
        $targets = @()
        foreach ($currentTarget in $Setting.usersAndGroups.targets)
        {
            $user  = $null
            $group = $null
            if ($currentTarget.targetType -eq 'User')
            {
                $user = Get-MgUser -UserId $currentTarget.target -ErrorAction SilentlyContinue
            }
            elseif ($currentTarget.targetType -eq 'Group')
            {
                $group = Get-MgGroup -GroupId $currentTarget.target -ErrorAction SilentlyContinue
            }

            $targetValue = $currentTarget.target
            if ($null -ne $user)
            {
                $targetValue = $user.UserPrincipalName
            }
            elseif ($null -ne $group)
            {
                $targetValue = $group.DisplayName
            }
            $targets += @{
                target     = $targetValue
                targetType = $currentTarget.targetType
            }
        }
        $usersAndGroups.Add('targets', $targets)
    }
    #endregion
    $results = @{
        applications   = $applications
        usersAndGroups = $usersAndGroups
    }

    return $results
}

function Get-M365DSCAADCrossTenantAccessPolicyInboundTrust
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Setting
    )

    $result = @{
        isCompliantDeviceAccepted           = $Setting.isCompliantDeviceAccepted
        isHybridAzureADJoinedDeviceAccepted = $Setting.isHybridAzureADJoinedDeviceAccepted
        isMfaAccepted                       = $Setting.isMfaAccepted
    }

    return $result
}

Export-ModuleMember -Function *-TargetResource
