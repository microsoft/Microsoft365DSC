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
        [ValidateSet('Absent', 'Present')]
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
        [ValidateSet('Absent', 'Present')]
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
        [ValidateSet('Absent', 'Present')]
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

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
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

function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    if ($ComplexObject.gettype().fullname -like '*[[\]]')
    {
        $results = @()

        foreach ($item in $ComplexObject)
        {
            if ($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results += $hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }

    if ($ComplexObject.getType().fullname -like '*Dictionary*')
    {
        $results = @{}

        $ComplexObject = [hashtable]::new($ComplexObject)
        $keys = $ComplexObject.Keys
        foreach ($key in $keys)
        {
            if ($null -ne $ComplexObject.$key)
            {
                $keyName = $key

                $keyType = $ComplexObject.$key.gettype().fullname

                if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' -or $keyType -like '*[[\]]')
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key

                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return [hashtable]$results
    }

    $results = @{}

    if ($ComplexObject.getType().Fullname -like '*hashtable')
    {
        $keys = $ComplexObject.keys
    }
    else
    {
        $keys = $ComplexObject | Get-Member | Where-Object -FilterScript { $_.MemberType -eq 'Property' }
    }

    foreach ($key in $keys)
    {
        $keyName = $key
        if ($ComplexObject.getType().Fullname -notlike '*hashtable')
        {
            $keyName = $key.Name
        }

        if ($null -ne $ComplexObject.$keyName)
        {
            $keyType = $ComplexObject.$keyName.gettype().fullname
            if ($keyType -like '*CimInstance*' -or $keyType -like '*Dictionary*' -or $keyType -like 'Microsoft.Graph.PowerShell.Models.*' )
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$keyName

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$keyName)
            }
        }
    }

    return [hashtable]$results
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if ($null -eq $Source -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue = ''
    $targetValue = ''
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if ($null -eq $Source)
        {
            $sourceValue = 'Source is null'
        }

        if ($null -eq $Target)
        {
            $targetValue = 'Target is null'
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if ($Source.getType().FullName -like '*CimInstance[[\]]' -or $Source.getType().FullName -like '*Hashtable[[\]]')
    {
        if ($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if ($source.count -eq 0)
        {
            return $true
        }

        foreach ($item in $Source)
        {

            $hashSource = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach ($targetItem in $Target)
            {
                $compareResult = Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    Write-Verbose -Message 'Compare-M365DSCComplexObject: Diff found'
                    break
                }
            }

            if (-not $compareResult)
            {
                Write-Verbose -Message 'Configuration drift - The complex array items are not identical'
                return $false
            }
        }
        return $true
    }

    $keys = $Source.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $skey = $key
        $tkey = $key

        $sourceValue = $Source.$key
        $targetValue = $Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $Target.$tkey))
        {

            if ($null -eq $Source.$key)
            {
                $sourceValue = 'null'
            }

            if ($null -eq $Target.$tkey)
            {
                $targetValue = 'null'
            }

            #Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if (($null -ne $Source.$key) -and ($null -ne $Target.$tkey))
        {
            if ($Source.$key.getType().FullName -like '*CimInstance*' -or $Source.$key.getType().FullName -like '*hashtable*'  )
            {
                #Recursive call for complex object
                $compareResult = Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$key) `
                    -Target $Target.$tkey

                if (-not $compareResult)
                {

                    #Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject = $Target.$tkey
                $differenceObject = $Source.$key

                #Identifying date from the current values
                $targetType = ($Target.$tkey.getType()).Name
                if ($targetType -like '*Date*')
                {
                    $compareResult = $true
                    $sourceDate = [DateTime]$Source.$key
                    if ($sourceDate -ne $targetType)
                    {
                        $compareResult = $null
                    }
                }
                else
                {
                    $compareResult = Compare-Object `
                        -ReferenceObject ($referenceObject) `
                        -DifferenceObject ($differenceObject)
                }

                if ($null -ne $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
        }
    }

    return $true
}
function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable], [hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )


    if ($ComplexObject.getType().Fullname -like '*[[\]]')
    {
        $results = @()
        foreach ($item in $ComplexObject)
        {
            $hash = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results += $hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return , [hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if ($null -ne $hashComplexObject)
    {

        $results = $hashComplexObject.clone()
        $keys = $hashComplexObject.Keys | Where-Object -FilterScript { $_ -ne 'PSComputerName' }
        foreach ($key in $keys)
        {
            if ($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like '*CimInstance*')
            {
                $results[$key] = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue = $results[$key]
                $results.remove($key) | Out-Null
                $results.add($propertyName, $propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
