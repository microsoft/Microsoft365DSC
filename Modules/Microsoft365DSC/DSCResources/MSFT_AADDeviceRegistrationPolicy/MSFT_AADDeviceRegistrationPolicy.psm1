function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Boolean]
        $AzureADJoinIsAdminConfigurable,

        [Parameter()]
        [ValidateSet('All', 'Selected', 'None')]
        [System.String]
        $AzureADAllowedToJoin,

        [Parameter()]
        [System.String[]]
        $AzureADAllowedToJoinUsers,

        [Parameter()]
        [System.String[]]
        $AzureADAllowedToJoinGroups,

        [Parameter()]
        [System.Boolean]
        $MultiFactorAuthConfiguration,

        [Parameter()]
        [System.Boolean]
        $LocalAdminsEnableGlobalAdmins,

        [Parameter()]
        [System.Boolean]
        $LocalAdminPasswordIsEnabled,

        [Parameter()]
        [ValidateSet('All', 'Selected', 'None')]
        [System.String]
        $AzureAdJoinLocalAdminsRegisteringMode,

        [Parameter()]
        [System.String[]]
        $AzureAdJoinLocalAdminsRegisteringGroups,

        [Parameter()]
        [System.String[]]
        $AzureAdJoinLocalAdminsRegisteringUsers,

        [Parameter()]
        [System.UInt32]
        $UserDeviceQuota,

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

        $getValue = Get-MgBetaPolicyDeviceRegistrationPolicy -ErrorAction Stop

        $AzureADAllowedToJoin = 'None'
        $AzureADAllowedToJoinUsers = @()
        $AzureADAllowedToJoinGroups = @()
        if ($getValue.AzureADJoin.AllowedToJoin.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.allDeviceRegistrationMembership')
        {
            $AzureADAllowedToJoin = 'All'
        }
        elseif ($getValue.AzureADJoin.AllowedToJoin.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.enumeratedDeviceRegistrationMembership')
        {
            $AzureADAllowedToJoin = 'Selected'

            foreach ($userId in $getValue.AzureAdJoin.AllowedToJoin.AdditionalProperties.users)
            {
                $userInfo = Get-MgUser -UserId $userId
                $AzureADAllowedToJoinUsers += $userInfo.UserPrincipalName
            }

            foreach ($groupId in $getValue.AzureAdJoin.AllowedToJoin.AdditionalProperties.groups)
            {
                $groupInfo = Get-MgGroup -GroupId $groupId
                $AzureADAllowedToJoinGroups += $groupInfo.DisplayName
            }
        }

        $AzureAdJoinLocalAdminsRegisteringUsers = @()
        $AzureAdJoinLocalAdminsRegisteringGroups = @()
        $AzureAdJoinLocalAdminsRegisteringMode = 'All'

        if ($getValue.AzureAdJoin.LocalAdmins.RegisteringUsers.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.noDeviceRegistrationMembership')
        {
            $AzureAdJoinLocalAdminsRegisteringMode = 'None'
        }
        elseif ($getValue.AzureAdJoin.LocalAdmins.RegisteringUsers.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.enumeratedDeviceRegistrationMembership')
        {
            $AzureAdJoinLocalAdminsRegisteringMode = 'Selected'
            foreach ($userId in $getValue.AzureAdJoin.LocalAdmins.RegisteringUsers.AdditionalProperties.users)
            {
                $userInfo = Get-MgUser -UserId $userId
                $AzureAdJoinLocalAdminsRegisteringUsers += $userInfo.UserPrincipalName
            }

            foreach ($groupId in $getValue.AzureAdJoin.LocalAdmins.RegisteringUsers.AdditionalProperties.groups)
            {
                $groupInfo = Get-MgGroup -GroupId $groupId
                $AzureAdJoinLocalAdminsRegisteringGroups += $groupInfo.DisplayName
            }
        }

        $MultiFactorAuthConfiguration = $false
        if ($getValue.MultiFactorAuthConfiguration -eq 'required')
        {
            $MultiFactorAuthConfiguration = $true
        }
        $LocalAdminsEnableGlobalAdmins = $true
        if (-not $getValue.AzureAdJoin.LocalAdmins.EnableGlobalAdmins)
        {
            $LocalAdminsEnableGlobalAdmins = $false
        }
        $results = @{
            IsSingleInstance                        = 'Yes'
            AzureADAllowedToJoin                    = $AzureADAllowedToJoin
            AzureADAllowedToJoinGroups              = $AzureADAllowedToJoinGroups
            AzureADAllowedToJoinUsers               = $AzureADAllowedToJoinUsers
            UserDeviceQuota                         = $getValue.UserDeviceQuota
            MultiFactorAuthConfiguration            = $MultiFactorAuthConfiguration
            LocalAdminsEnableGlobalAdmins           = $LocalAdminsEnableGlobalAdmins
            LocalAdminPasswordIsEnabled             = [Boolean]$getValue.LocalAdminPassword.IsEnabled
            AzureAdJoinLocalAdminsRegisteringMode   = $AzureAdJoinLocalAdminsRegisteringMode
            AzureAdJoinLocalAdminsRegisteringGroups = $AzureAdJoinLocalAdminsRegisteringGroups
            AzureAdJoinLocalAdminsRegisteringUsers  = $AzureAdJoinLocalAdminsRegisteringUsers
            Credential                              = $Credential
            ApplicationId                           = $ApplicationId
            TenantId                                = $TenantId
            ApplicationSecret                       = $ApplicationSecret
            CertificateThumbprint                   = $CertificateThumbprint
            Managedidentity                         = $ManagedIdentity.IsPresent
            AccessTokens                            = $AccessTokens
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
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Boolean]
        $AzureADJoinIsAdminConfigurable,

        [Parameter()]
        [ValidateSet('All', 'Selected', 'None')]
        [System.String]
        $AzureADAllowedToJoin,

        [Parameter()]
        [System.String[]]
        $AzureADAllowedToJoinUsers,

        [Parameter()]
        [System.String[]]
        $AzureADAllowedToJoinGroups,

        [Parameter()]
        [System.Boolean]
        $MultiFactorAuthConfiguration,

        [Parameter()]
        [System.Boolean]
        $LocalAdminsEnableGlobalAdmins,

        [Parameter()]
        [System.Boolean]
        $LocalAdminPasswordIsEnabled,

        [Parameter()]
        [ValidateSet('All', 'Selected', 'None')]
        [System.String]
        $AzureAdJoinLocalAdminsRegisteringMode,

        [Parameter()]
        [System.String[]]
        $AzureAdJoinLocalAdminsRegisteringGroups,

        [Parameter()]
        [System.String[]]
        $AzureAdJoinLocalAdminsRegisteringUsers,

        [Parameter()]
        [System.UInt32]
        $UserDeviceQuota,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $MultiFactorAuthConfigurationValue = "notRequired"
    if ($MultiFactorAuthConfiguration)
    {
        $MultiFactorAuthConfigurationValue = 'required'
    }

    $azureADRegistrationAllowedToRegister = "#microsoft.graph.noDeviceRegistrationMembership"
    if ($AzureAdJoinLocalAdminsRegisteringMode -eq 'All')
    {
        $azureADRegistrationAllowedToRegister = "#microsoft.graph.allDeviceRegistrationMembership"
    }
    elseif ($AzureAdJoinLocalAdminsRegisteringMode -eq 'Selected')
    {
        $azureADRegistrationAllowedToRegister = "#microsoft.graph.enumeratedDeviceRegistrationMembership"

        $azureADRegistrationAllowedUsers = @()
        foreach ($user in $AzureAdJoinLocalAdminsRegisteringUsers)
        {
            $userInfo = Get-MgUser -UserId $user
            $azureADRegistrationAllowedUsers += $userInfo.Id
        }

        $azureADRegistrationAllowedGroups = @()
        foreach ($group in $AzureAdJoinLocalAdminsRegisteringGroups)
        {
            $groupInfo = Get-MgGroup -Filter "DisplayName eq '$group'"
            $azureADRegistrationAllowedGroups += $groupInfo.Id
        }
    }

    $localAdminAllowedMode = "#microsoft.graph.noDeviceRegistrationMembership"
    if ($AzureAdJoinLocalAdminsRegisteringMode -eq 'All')
    {
        $localAdminAllowedMode = "#microsoft.graph.allDeviceRegistrationMembership"
    }
    elseif ($AzureAdJoinLocalAdminsRegisteringMode -eq 'Selected')
    {
        $localAdminAllowedMode = "#microsoft.graph.enumeratedDeviceRegistrationMembership"

        $localAdminAllowedUsers = @()
        foreach ($user in $AzureAdJoinLocalAdminsRegisteringUsers)
        {
            $userInfo = Get-MgUser -UserId $user
            $localAdminAllowedUsers += $userInfo.Id
        }

        $localAdminAllowedGroups = @()
        foreach ($group in $AzureAdJoinLocalAdminsRegisteringGroups)
        {
            $groupInfo = Get-MgGroup -Filter "DisplayName eq '$group'"
            $localAdminAllowedGroups += $groupInfo.Id
        }
    }

    $updateParameters = @{
        userDeviceQuota = $UserDeviceQuota
        multiFactorAuthConfiguration = $MultiFactorAuthConfigurationValue
        azureADJoin = @{
            isAdminConfigurable =$AzureADJoinIsAdminConfigurable
            allowedToJoin = @{
                '@odata.type' = $azureADRegistrationAllowedToRegister
                users = $AzureADAllowedToJoinUsers
                groups = $AzureADAllowedToJoinGroups
            }
            localAdmins = @{
                enableGlobalAdmins = $LocalAdminsEnableGlobalAdmins
                registeringUsers = @{
                    '@odata.type' = $localAdminAllowedMode
                    users = $localAdminAllowedUsers
                    groups = $localAdminAllowedGroups
                }
            }
        }
        localAdminPassword = @{
            isEnabled = $LocalAdminPasswordIsEnabled
        }
        azureADRegistration = @{
            isAdminConfigurable = $false
            allowedToRegister = @{
                '@odata.type' = "#microsoft.graph.allDeviceRegistrationMembership"
            }
        }
    }
    $uri = $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.ResourceUrl + 'beta/policies/deviceRegistrationPolicy'
    Write-Verbose -Message "Updating Device Registration Policy with payload:`r`n$(ConvertTo-Json $updateParameters -Depth 10)"
    Invoke-MgGraphRequest -Method PUT -Uri $uri -Body $updateParameters
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter()]
        [Boolean]
        $AzureADJoinIsAdminConfigurable,

        [Parameter()]
        [ValidateSet('All', 'Selected', 'None')]
        [System.String]
        $AzureADAllowedToJoin,

        [Parameter()]
        [System.String[]]
        $AzureADAllowedToJoinUsers,

        [Parameter()]
        [System.String[]]
        $AzureADAllowedToJoinGroups,

        [Parameter()]
        [System.Boolean]
        $MultiFactorAuthConfiguration,

        [Parameter()]
        [System.Boolean]
        $LocalAdminsEnableGlobalAdmins,

        [Parameter()]
        [System.Boolean]
        $LocalAdminPasswordIsEnabled,

        [Parameter()]
        [ValidateSet('All', 'Selected', 'None')]
        [System.String]
        $AzureAdJoinLocalAdminsRegisteringMode,

        [Parameter()]
        [System.String[]]
        $AzureAdJoinLocalAdminsRegisteringGroups,

        [Parameter()]
        [System.String[]]
        $AzureAdJoinLocalAdminsRegisteringUsers,

        [Parameter()]
        [System.UInt32]
        $UserDeviceQuota,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of the Device Registration Policy"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

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
        $params = @{
            IsSingleInstance      = 'Yes'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
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

        $dscContent = $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        $i++
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $dscContent
    }
    catch
    {
        if ($_.ErrorDetails.Message -like "*Insufficient privileges*")
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) Insufficient permissions or license to export Attribute Sets."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX
            New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
