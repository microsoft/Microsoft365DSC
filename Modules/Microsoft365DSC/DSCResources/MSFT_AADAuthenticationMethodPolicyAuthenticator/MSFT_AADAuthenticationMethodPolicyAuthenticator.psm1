function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FeatureSettings,

        [Parameter()]
        [System.Boolean]
        $IsSoftwareOathEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,
        #endregion

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

        $getValue = $null
        #region resource generator code
        $getValue = Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId $Id -ErrorAction SilentlyContinue

        #endregion
        if ($null -eq $getValue -or $getValue.State -eq 'disabled')
        {
            Write-Verbose -Message "Could not find an Azure AD Authentication Method Policy Authenticator with id {$id}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Authentication Method Policy Authenticator with Id {$Id} was found."

        #region resource generator code
        $complexFeatureSettings = @{}
        $complexCompanionAppAllowedState = @{}
        $complexExcludeTarget = @{}
        if ($getValue.additionalProperties.featureSettings.companionAppAllowedState.excludeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myExcludeTargetsDisplayName = Get-MgGroup -GroupId $getValue.additionalProperties.featureSettings.companionAppAllowedState.excludeTarget.id
            $complexExcludeTarget.Add('Id', $myExcludeTargetsDisplayName.DisplayName)
        }
        else
        {
            if ($getValue.additionalProperties.featureSettings.companionAppAllowedState.excludeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexExcludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexExcludeTarget.Add('Id', 'all_users')
            }
        }
        if ($null -ne $getValue.additionalProperties.featureSettings.companionAppAllowedState.excludeTarget.targetType)
        {
            $complexExcludeTarget.Add('TargetType', $getValue.additionalProperties.featureSettings.companionAppAllowedState.excludeTarget.targetType.toString())
        }
        if ($complexExcludeTarget.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexExcludeTarget = $null
        }
        $complexCompanionAppAllowedState.Add('ExcludeTarget', $complexExcludeTarget)
        $complexIncludeTarget = @{}
        if ($getValue.additionalProperties.featureSettings.companionAppAllowedState.includeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myIncludeTargetsDisplayName = Get-MgGroup -GroupId $getValue.additionalProperties.featureSettings.companionAppAllowedState.includeTarget.id
            $complexIncludeTarget.Add('Id', $myIncludeTargetsDisplayName.DisplayName)
        }
        else
        {
            if ($getValue.additionalProperties.featureSettings.companionAppAllowedState.includeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexIncludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexIncludeTarget.Add('Id', 'all_users')
            }
        }
        if ($null -ne $getValue.additionalProperties.featureSettings.companionAppAllowedState.includeTarget.targetType)
        {
            $complexIncludeTarget.Add('TargetType', $getValue.additionalProperties.featureSettings.companionAppAllowedState.includeTarget.targetType.toString())
        }
        if ($complexIncludeTarget.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexIncludeTarget = $null
        }
        $complexCompanionAppAllowedState.Add('IncludeTarget', $complexIncludeTarget)
        if ($null -ne $getValue.additionalProperties.featureSettings.companionAppAllowedState.state)
        {
            $complexCompanionAppAllowedState.Add('State', $getValue.additionalProperties.featureSettings.companionAppAllowedState.state.toString())
        }
        if ($complexCompanionAppAllowedState.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexCompanionAppAllowedState = $null
        }
        $complexFeatureSettings.Add('CompanionAppAllowedState', $complexCompanionAppAllowedState)
        $complexDisplayAppInformationRequiredState = @{}

        $complexExcludeTarget = @{}
        if ($getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.excludeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myExcludeTargetsDisplayName = Get-MgGroup -GroupId $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.excludeTarget.id
            $complexExcludeTarget.Add('Id', $myExcludeTargetsDisplayName.DisplayName)
        }
        else
        {
            if ($getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.excludeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexExcludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexExcludeTarget.Add('Id', 'all_users')
            }
        }
        if ($null -ne $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.excludeTarget.targetType)
        {
            $complexExcludeTarget.Add('TargetType', $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.excludeTarget.targetType.toString())
        }
        if ($complexExcludeTarget.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexExcludeTarget = $null
        }
        $complexDisplayAppInformationRequiredState.Add('ExcludeTarget', $complexExcludeTarget)
        $complexIncludeTarget = @{}
        if ($getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.includeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myIncludeTargetsDisplayName = Get-MgGroup -GroupId $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.includeTarget.id
            $complexIncludeTarget.Add('Id', $myIncludeTargetsDisplayName.DisplayName)
        }
        else
        {
            if ($getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.includeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexIncludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexIncludeTarget.Add('Id', 'all_users')
            }
        }
        if ($null -ne $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.includeTarget.targetType)
        {
            $complexIncludeTarget.Add('TargetType', $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.includeTarget.targetType.toString())
        }
        if ($complexIncludeTarget.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexIncludeTarget = $null
        }
        $complexDisplayAppInformationRequiredState.Add('IncludeTarget', $complexIncludeTarget)
        if ($null -ne $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.state)
        {
            $complexDisplayAppInformationRequiredState.Add('State', $getValue.additionalProperties.featureSettings.displayAppInformationRequiredState.state.toString())
        }
        if ($complexDisplayAppInformationRequiredState.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexDisplayAppInformationRequiredState = $null
        }
        $complexFeatureSettings.Add('DisplayAppInformationRequiredState', $complexDisplayAppInformationRequiredState)
        $complexDisplayLocationInformationRequiredState = @{}
        $complexExcludeTarget = @{}
        if ($getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.excludeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myExcludeTargetsDisplayName = Get-MgGroup -GroupId $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.excludeTarget.id
            $complexExcludeTarget.Add('Id', $myExcludeTargetsDisplayName.DisplayName)
        }
        else
        {
            if ($getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.excludeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexExcludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexExcludeTarget.Add('Id', 'all_users')
            }
        }
        if ($null -ne $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.excludeTarget.targetType)
        {
            $complexExcludeTarget.Add('TargetType', $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.excludeTarget.targetType.toString())
        }
        if ($complexExcludeTarget.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexExcludeTarget = $null
        }
        $complexDisplayLocationInformationRequiredState.Add('ExcludeTarget', $complexExcludeTarget)
        $complexIncludeTarget = @{}
        if ($getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.includeTarget.id -notmatch 'all_users|00000000-0000-0000-0000-000000000000')
        {
            $myIncludeTargetsDisplayName = Get-MgGroup -GroupId $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.includeTarget.id
            $complexIncludeTarget.Add('Id', $myIncludeTargetsDisplayName.DisplayName)
        }
        else
        {
            if ($getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.includeTarget.id -eq '00000000-0000-0000-0000-000000000000')
            {
                $complexIncludeTarget.Add('Id', '00000000-0000-0000-0000-000000000000')
            }
            else
            {
                $complexIncludeTarget.Add('Id', 'all_users')
            }
        }
        if ($null -ne $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.includeTarget.targetType)
        {
            $complexIncludeTarget.Add('TargetType', $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.includeTarget.targetType.toString())
        }
        if ($complexIncludeTarget.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexIncludeTarget = $null
        }
        $complexDisplayLocationInformationRequiredState.Add('IncludeTarget', $complexIncludeTarget)
        if ($null -ne $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.state)
        {
            $complexDisplayLocationInformationRequiredState.Add('State', $getValue.additionalProperties.featureSettings.displayLocationInformationRequiredState.state.toString())
        }
        if ($complexDisplayLocationInformationRequiredState.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexDisplayLocationInformationRequiredState = $null
        }
        $complexFeatureSettings.Add('DisplayLocationInformationRequiredState', $complexDisplayLocationInformationRequiredState)

        $complexExcludeTargets = @()
        foreach ($currentExcludeTargets in $getValue.excludeTargets)
        {
            $myExcludeTargets = @{}
            if ($currentExcludeTargets.id -ne 'all_users')
            {
                $myExcludeTargetsDisplayName = Get-MgGroup -GroupId $currentExcludeTargets.id -ErrorAction SilentlyContinue

                if ($null -ne $myExcludeTargetsDisplayName)
                {
                    $myExcludeTargets.Add('Id', $myExcludeTargetsDisplayName.DisplayName)
                }
            }
            else
            {
                $myExcludeTargets.Add('Id', $currentExcludeTargets.id)
            }
            if ($null -ne $currentExcludeTargets.targetType)
            {
                $myExcludeTargets.Add('TargetType', $currentExcludeTargets.targetType.toString())
            }
            if ($myExcludeTargets.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexExcludeTargets += $myExcludeTargets
            }
        }
        #endregion

        $complexIncludeTargets = @()
        foreach ($currentIncludeTargets in $getValue.AdditionalProperties.includeTargets)
        {
            $myIncludeTargets = @{}
            if ($currentIncludeTargets.id -ne 'all_users')
            {
                $myIncludeTargetsDisplayName = Get-MgGroup -GroupId $currentIncludeTargets.id -ErrorAction SilentlyContinue
                if ($null -ne $myIncludeTargetsDisplayName)
                {
                    $myIncludeTargets.Add('Id', $myIncludeTargetsDisplayName.DisplayName)
                }
            }
            else
            {
                $myIncludeTargets.Add('Id', $currentIncludeTargets.id)
            }
            if ($null -ne $currentIncludeTargets.targetType)
            {
                $myIncludeTargets.Add('TargetType', $currentIncludeTargets.targetType.toString())
            }
            if ($myIncludeTargets.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexIncludeTargets += $myIncludeTargets
            }
        }

        #region resource generator code
        $enumState = $null
        if ($null -ne $getValue.State)
        {
            $enumState = $getValue.State.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            FeatureSettings       = $complexFeatureSettings
            IsSoftwareOathEnabled = $getValue.AdditionalProperties.isSoftwareOathEnabled
            ExcludeTargets        = $complexExcludeTargets
            IncludeTargets        = $complexIncludeTargets
            State                 = $enumState
            Id                    = $getValue.Id
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            #endregion
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
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $FeatureSettings,

        [Parameter()]
        [System.Boolean]
        $IsSoftwareOathEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion
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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Authentication Method Policy Authenticator with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        # replace group Displayname with group id
        if ($UpdateParameters.featureSettings.companionAppAllowedState.includeTarget.id -and `
            $UpdateParameters.featureSettings.companionAppAllowedState.includeTarget.id -notmatch '00000000-0000-0000-0000-000000000000|all_users' -and
            $UpdateParameters.featureSettings.ContainsKey('companionAppAllowedState'))
        {
            Write-Verbose -Message 'Retrieving companionAppAllowedState include target'
            $Filter = "Displayname eq '$($UpdateParameters.featureSettings.companionAppAllowedState.includeTarget.id)'" | Out-String
            $groupid = (Get-MgGroup -Filter $Filter).id.ToString()
            $UpdateParameters.featureSettings.companionAppAllowedState.includeTarget.foreach('id',$groupid)
        }
        if ($UpdateParameters.featureSettings.companionAppAllowedState.excludeTarget.id -and `
            $UpdateParameters.featureSettings.companionAppAllowedState.excludeTarget.id -notmatch '00000000-0000-0000-0000-000000000000|all_users' -and
            $UpdateParameters.featureSettings.ContainsKey('companionAppAllowedState'))
        {
            Write-Verbose -Message 'Retrieving companionAppAllowedState include target'
            $Filter = "Displayname eq '$($UpdateParameters.featureSettings.companionAppAllowedState.excludeTarget.id)'" | Out-String
            $groupid = (Get-MgGroup -Filter $Filter).id.ToString()
            $UpdateParameters.featureSettings.companionAppAllowedState.excludeTarget.foreach('id',$groupid)
        }
        if ($UpdateParameters.featureSettings.displayAppInformationRequiredState.includeTarget.id -and `
            $UpdateParameters.featureSettings.displayAppInformationRequiredState.includeTarget.id -notmatch '00000000-0000-0000-0000-000000000000|all_users' -and
            $UpdateParameters.featureSettings.ContainsKey('displayAppInformationRequiredState'))
        {
            Write-Verbose -Message 'Retrieving displayAppInformationRequiredState include target'
            $Filter = "Displayname eq '$($UpdateParameters.featureSettings.displayAppInformationRequiredState.includeTarget.id)'" | Out-String
            $groupid = (Get-MgGroup -Filter $Filter).id.ToString()
            $UpdateParameters.featureSettings.displayAppInformationRequiredState.includeTarget.foreach('id',$groupid)
        }
        if ($UpdateParameters.featureSettings.displayAppInformationRequiredState.excludeTarget.id -and `
            $UpdateParameters.featureSettings.displayAppInformationRequiredState.excludeTarget.id -notmatch '00000000-0000-0000-0000-000000000000|all_users' -and
            $UpdateParameters.featureSettings.ContainsKey('displayAppInformationRequiredState'))
        {
            Write-Verbose -Message 'Retrieving displayAppInformationRequiredState exclude target'
            $Filter = "Displayname eq '$($UpdateParameters.featureSettings.displayAppInformationRequiredState.excludeTarget.id)'" | Out-String
            $groupid = (Get-MgGroup -Filter $Filter).id.ToString()
            $UpdateParameters.featureSettings.displayAppInformationRequiredState.excludeTarget.foreach('id',$groupid)
        }
        if ($UpdateParameters.featureSettings.displayLocationInformationRequiredState.includeTarget.id -and `
            $UpdateParameters.featureSettings.displayLocationInformationRequiredState.includeTarget.id -notmatch '00000000-0000-0000-0000-000000000000|all_users' -and
            $UpdateParameters.featureSettings.ContainsKey('displayLocationInformationRequiredState'))
        {
            Write-Verbose -Message 'Retrieving displayLocationInformationRequiredState include target'
            $Filter = "Displayname eq '$($UpdateParameters.featureSettings.displayLocationInformationRequiredState.includeTarget.id)'" | Out-String
            $groupid = (Get-MgGroup -Filter $Filter).id.ToString()
            $UpdateParameters.featureSettings.displayLocationInformationRequiredState.includeTarget.foreach('id',$groupid)
        }
        if ($UpdateParameters.featureSettings.displayLocationInformationRequiredState.excludeTarget.id -and `
            $UpdateParameters.featureSettings.displayLocationInformationRequiredState.excludeTarget.id -notmatch '00000000-0000-0000-0000-000000000000|all_users' -and
            $UpdateParameters.featureSettings.ContainsKey('displayLocationInformationRequiredState'))
        {
            Write-Verbose -Message 'Retrieving displayLocationInformationRequiredState exclude target'
            $Filter = "Displayname eq '$($UpdateParameters.featureSettings.displayLocationInformationRequiredState.excludeTarget.id)'" | Out-String
            $groupid = (Get-MgGroup -Filter $Filter).id.ToString()
            $UpdateParameters.featureSettings.displayLocationInformationRequiredState.excludeTarget.foreach('id',$groupid)
        }

        # DEPRECATED
        if ($UpdateParameters.featureSettings.ContainsKey('NumberMatchingRequiredState'))
        {
            Write-Verbose -Message "The NumberMatchingRequiredState feature is deprecated and will be ignored. Please remove it from your configuration."
            $UpdateParameters.featureSettings.Remove('NumberMatchingRequiredState')
        }

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
            if ($key -eq 'IncludeTargets' -or $key -eq 'ExcludeTargets')
            {
                $i = 0
                foreach ($entry in $UpdateParameters.$key)
                {
                    if ($entry.id -notmatch '^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$|all_users')
                    {
                        $Filter = "Displayname eq '$($entry.id)'" | Out-String
                        $group = Get-MgGroup -Filter $Filter
                        if ($null -ne $group)
                        {
                            $UpdateParameters.$key[$i].foreach('id', $group.id.ToString())
                        }
                        else
                        {
                            Write-Verbose -Message "Couldn't find group with DisplayName {$($entry.id)}"
                        }
                    }
                    $i++
                }
            }
        }
        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.microsoftAuthenticatorAuthenticationMethodConfiguration')
        Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration  `
            -AuthenticationMethodConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Authentication Method Policy Authenticator with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId $currentInstance.Id
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $FeatureSettings,

        [Parameter()]
        [System.Boolean]
        $IsSoftwareOathEnabled,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion

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

    Write-Verbose -Message "Testing configuration of the Azure AD Authentication Method Policy Authenticator with Id {$Id}"

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
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

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
        #region resource generator code
        [array]$getValue = Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId MicrosoftAuthenticator `
            -ErrorAction Stop | Where-Object -FilterScript {$null -ne $_.Id}
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            if ($null -ne $Results.FeatureSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'FeatureSettings'
                        CimInstanceName = 'MicrosoftGraphMicrosoftAuthenticatorFeatureSettings'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'CompanionAppAllowedState'
                        CimInstanceName = 'MicrosoftGraphAuthenticationMethodFeatureConfiguration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'ExcludeTarget'
                        CimInstanceName = 'AADAuthenticationMethodPolicyAuthenticatorFeatureTarget'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'IncludeTarget'
                        CimInstanceName = 'AADAuthenticationMethodPolicyAuthenticatorFeatureTarget'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'DisplayAppInformationRequiredState'
                        CimInstanceName = 'MicrosoftGraphAuthenticationMethodFeatureConfiguration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'DisplayLocationInformationRequiredState'
                        CimInstanceName = 'MicrosoftGraphAuthenticationMethodFeatureConfiguration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'NumberMatchingRequiredState'
                        CimInstanceName = 'MicrosoftGraphAuthenticationMethodFeatureConfiguration'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.FeatureSettings `
                    -CIMInstanceName 'MicrosoftGraphmicrosoftAuthenticatorFeatureSettings' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.FeatureSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('FeatureSettings') | Out-Null
                }
            }
            if ($null -ne $Results.ExcludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExcludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyAuthenticatorExcludeTarget'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ExcludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ExcludeTargets') | Out-Null
                }
            }
            if ($null -ne $Results.IncludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.IncludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyAuthenticatorIncludeTarget'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.IncludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IncludeTargets') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($Results.FeatureSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'FeatureSettings' -IsCIMArray:$False
            }
            if ($Results.ExcludeTargets)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ExcludeTargets' -IsCIMArray:$True
            }
            if ($Results.IncludeTargets)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'IncludeTargets' -IsCIMArray:$True
            }
            $currentDSCBlock = Remove-M365DSCCimInstanceTrailingCharacterFromExport -DSCBlock $currentDSCBlock

            # FIX #3645
            $currentDSCBlock = $currentDSCBlock.Replace("}                    State = 'default'`r`n","}`r`n                    State = 'default'`r`n")
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
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

Export-ModuleMember -Function *-TargetResource
