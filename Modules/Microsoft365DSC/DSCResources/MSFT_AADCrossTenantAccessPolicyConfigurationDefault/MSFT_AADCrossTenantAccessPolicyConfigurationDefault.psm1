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
        $ManagedIdentity
    )

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = Get-MgBetaPolicyCrossTenantAccessPolicyDefault -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Cross Tenant Access Configuration Default with TenantId {$PartnerTenantId}"
            return $nullResult
        }

        $B2BCollaborationInboundValue = $null
        if ($null -ne $getValue.B2BCollaborationInbound)
        {
            $B2BCollaborationInboundValue = $getValue.B2BCollaborationInbound
        }
        if ($null -ne $getValue.B2BCollaborationOutbound)
        {
            $B2BCollaborationOutboundValue = $getValue.B2BCollaborationOutbound
        }
        if ($null -ne $getValue.B2BDirectConnectInbound)
        {
            $B2BDirectConnectInboundValue = $getValue.B2BDirectConnectInbound
        }
        if ($null -ne $getValue.B2BDirectConnectOutbound)
        {
            $B2BDirectConnectOutboundValue = $getValue.B2BDirectConnectOutbound
        }
        if ($null -ne $getValue.InboundTrust)
        {
            $InboundTrustValue = $getValue.InboundTrust
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
        $ManagedIdentity
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

    $OperationParams = ([Hashtable]$PSBoundParameters).Clone()
    $OperationParams.Remove("Credential") | Out-Null
    $OperationParams.Remove("ManagedIdentity") | Out-Null
    $OperationParams.Remove("ApplicationId") | Out-Null
    $OperationParams.Remove("TenantId") | Out-Null
    $OperationParams.Remove("CertificateThumbprint") | Out-Null
    $OperationParams.Remove("ApplicationSecret") | Out-Null
    $OperationParams.Remove("Ensure") | Out-Null
    $OperationParams.Remove("IsSingleInstance") | Out-Null

    if ($null -ne $OperationParams.B2BCollaborationInbound)
    {
        $OperationParams.B2BCollaborationInbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BCollaborationInbound)
        $OperationParams.B2BCollaborationInbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BCollaborationInbound)
    }
    if ($null -ne $OperationParams.B2BCollaborationOutbound)
    {
        $OperationParams.B2BCollaborationOutbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BCollaborationOutbound)
        $OperationParams.B2BCollaborationOutbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BCollaborationOutbound)
    }
    if ($null -ne $OperationParams.B2BDirectConnectInbound)
    {
        $OperationParams.B2BDirectConnectInbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BDirectConnectInbound)
        $OperationParams.B2BDirectConnectInbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BDirectConnectInbound)
    }
    if ($null -ne $OperationParams.B2BDirectConnectOutbound)
    {
        $OperationParams.B2BDirectConnectOutbound = (Get-M365DSCAADCrossTenantAccessPolicyB2BSetting -Setting $OperationParams.B2BDirectConnectOutbound)
        $OperationParams.B2BDirectConnectOutbound = (Update-M365DSCSettingUserIdFromUPN -Setting $OperationParams.B2BDirectConnectOutbound)
    }
    if ($null -ne $OperationParams.InboundTrust)
    {
        $OperationParams.InboundTrust = (Get-M365DSCAADCrossTenantAccessPolicyInboundTrust -Setting $OperationParams.InboundTrust)
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Cross Tenant Access Policy Configuration Default"
        Update-MgBetaPolicyCrossTenantAccessPolicyDefault @OperationParams
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Cross Tenant Access Policy Configuration Default is not supported"
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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing configuration of the Azure AD Cross Tenant Access Policy Configuration Default with Tenant Id [$PartnerTenantId]"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                Write-Verbose -Message "Difference found for $key"
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null

        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"
    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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
        $ManagedIdentity
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
        $dscContent = ''
        $Params = @{
            IsSingleInstance      = 'Yes'
            ApplicationSecret     = $ApplicationSecret
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Credential            = $Credential
            Managedidentity       = $ManagedIdentity.IsPresent
        }
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results

        if ($null -ne $Results.B2BCollaborationInbound)
        {
            $Results.B2BCollaborationInbound = Get-M365DSCAADCrossTenantAccessPolicyB2BSettingAsString -Setting $Results.B2BCollaborationInbound
        }
        if ($null -ne $Results.B2BCollaborationOutbound)
        {
            $Results.B2BCollaborationOutbound = Get-M365DSCAADCrossTenantAccessPolicyB2BSettingAsString -Setting $Results.B2BCollaborationOutbound
        }
        if ($null -ne $Results.B2BDirectConnectInbound)
        {
            $Results.B2BDirectConnectInbound = Get-M365DSCAADCrossTenantAccessPolicyB2BSettingAsString -Setting $Results.B2BDirectConnectInbound
        }
        if ($null -ne $Results.B2BDirectConnectOutbound)
        {
            $Results.B2BDirectConnectOutbound = Get-M365DSCAADCrossTenantAccessPolicyB2BSettingAsString -Setting $Results.B2BDirectConnectOutbound
        }
        if ($null -ne $Results.InboundTrust)
        {
            $Results.InboundTrust = Get-M365DSCAADCrossTenantAccessPolicyInboundTrustAsString -Setting $Results.InboundTrust
        }

        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential

        if ($null -ne $Results.B2BCollaborationInbound)
        {
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                -ParameterName 'B2BCollaborationInbound'
        }
        if ($null -ne $Results.B2BCollaborationOutbound)
        {
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                -ParameterName 'B2BCollaborationOutbound'
        }
        if ($null -ne $Results.B2BDirectConnectInbound)
        {
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                -ParameterName 'B2BDirectConnectInbound'
        }
        if ($null -ne $Results.B2BDirectConnectOutbound)
        {
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                -ParameterName 'B2BDirectConnectOutbound'
        }
        if ($null -ne $Results.InboundTrust)
        {
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                -ParameterName 'InboundTrust'
        }

        # Fix OrganizationName variable in CIMInstance
        $currentDSCBlock = $currentDSCBlock.Replace('@$OrganizationName''', "@' + `$OrganizationName")

        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName

        Write-Host $Global:M365DSCEmojiGreenCheckMark

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
                if ($user.TargetType -eq 'User')
                {
                    Write-Verbose -Message "Detected User type with UPN {$($user.Target)}"
                    $user = Get-MgUser -UserId $user.Target -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $userValue = $user.Id
                    }
                }
                elseif ($user.TargetType -eq 'Group')
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
function Get-M365DSCAADCrossTenantAccessPolicyB2BSettingAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        $Setting
    )
    $StringContent = $null
    if ($null -ne $Setting.applications.targets -and $null -ne $Setting.usersAndGroups.targets)
    {
        $StringContent = "MSFT_AADCrossTenantAccessPolicyB2BSetting {`r`n"
        $StringContent += "                Applications = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{`r`n"
        $StringContent += "                    AccessType = '" + $Setting.applications.accessType + "'`r`n"
        $StringContent += "                    Targets    = @(`r`n"

        foreach ($target in $Setting.applications.targets)
        {
            $StringContent += "                        MSFT_AADCrossTenantAccessPolicyTarget{`r`n"
            $StringContent += "                            Target     = '" + $target.target + "'`r`n"
            $StringContent += "                            TargetType = '" + $target.targetType + "'`r`n"
            $StringContent += "                        }`r`n"
        }

        $StringContent += "                    )`r`n"
        $StringContent += "                }`r`n"
        $StringContent += "                UsersAndGroups = MSFT_AADCrossTenantAccessPolicyTargetConfiguration{`r`n"
        $StringContent += "                    AccessType = '" + $Setting.usersAndGroups.accessType + "'`r`n"
        $StringContent += "                    Targets    = @(`r`n"

        foreach ($target in $Setting.usersAndGroups.targets)
        {
            $StringContent += "                        MSFT_AADCrossTenantAccessPolicyTarget{`r`n"
            $StringContent += "                            Target     = '" + $target.target + "'`r`n"
            $StringContent += "                            TargetType = '" + $target.targetType + "'`r`n"
            $StringContent += "                        }`r`n"
        }

        $StringContent += "                    )`r`n"
        $StringContent += "                }`r`n"
        $StringContent += "            }`r`n"
    }

    return $StringContent
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
        AccessType = $Setting.applications.accessType
    }

    if ($null -ne $Setting.applications.targets)
    {
        $targets = @()
        foreach ($currentTarget in $Setting.applications.targets)
        {
            $targets += @{
                Target     = $currentTarget.target
                TargetType = $currentTarget.targetType
            }
        }
        $applications.Add('Targets', $targets)
    }
    #endregion

    #region UsersAndGroups
    $usersAndGroups = @{
        AccessType = $Setting.usersAndGroups.accessType
    }

    if ($null -ne $Setting.usersAndGroups.targets)
    {
        $targets = @()
        foreach ($currentTarget in $Setting.usersAndGroups.targets)
        {
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
                Target     = $targetValue
                TargetType = $currentTarget.targetType
            }
        }
        $usersAndGroups.Add('Targets', $targets)
    }
    #endregion
    $results = @{
        Applications = $applications
        UsersAndGroups = $usersAndGroups
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
        IsCompliantDeviceAccepted           = $Setting.isCompliantDeviceAccepted
        IsHybridAzureADJoinedDeviceAccepted = $Setting.isHybridAzureADJoinedDeviceAccepted
        IsMfaAccepted                       = $Setting.isMfaAccepted
    }

    return $result
}

function Get-M365DSCAADCrossTenantAccessPolicyInboundTrustAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        $Setting
    )

    $StringContent = $null
    if ($null -ne $Setting.IsCompliantDeviceAccepted -or $null -ne $Setting.IsHybridAzureADJoinedDeviceAccepted -or `
        $null -ne $Setting.IsMfaAccepted)
    {
        $StringContent = "MSFT_AADCrossTenantAccessPolicyInboundTrust {`r`n"
        if ($null -ne $Setting.IsCompliantDeviceAccepted)
        {
            $StringContent += "                IsCompliantDeviceAccepted           = `$" + $Setting.IsCompliantDeviceAccepted.ToString() + "`r`n"
        }
        if ($null -ne $Setting.IsHybridAzureADJoinedDeviceAccepted)
        {
            $StringContent += "                IsHybridAzureADJoinedDeviceAccepted = `$" + $Setting.IsHybridAzureADJoinedDeviceAccepted.ToString() + "`r`n"
        }
        if ($null -ne $Setting.IsMfaAccepted)
        {
            $StringContent += "                IsMfaAccepted                       = `$" + $Setting.IsMfaAccepted.ToString() + "`r`n"
        }
        $StringContent += "            }`r`n"
    }

    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
