Confirm-M365DSCModuleDependency -ModuleName 'MSFT_IntuneManagedInstallerPolicyWindows10'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsIntuneManagedInstaller,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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

    Write-Verbose -Message "Getting configuration of the Intune Managed Installer Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

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

        $getValue = $null
        #region resource generator code
        if (-not [string]::IsNullOrEmpty($Id))
        {
            $getValue = Get-MgBetaDeviceManagementDeviceHealthScript -DeviceHealthScriptId $Id -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue)
        {
            if (-not [string]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Could not find an Intune Managed Installer Policy for Windows10 with Id {$Id}"
            }

            if (-not [string]::IsNullOrEmpty($DisplayName))
            {
                $matchingPolicies = Get-MgBetaDeviceManagementDeviceHealthScript `
                    -All `
                    -Filter "DisplayName eq '$($DisplayName -replace "'", "''")' and deviceHealthScriptType eq 'managedInstallerScript'" `
                    -ErrorAction SilentlyContinue

                if ($null -ne $matchingPolicies)
                {
                    if ($matchingPolicies -is [array] -and $matchingPolicies.Count -gt 1)
                    {
                        throw "Multiple Intune Managed Installer Policies with DisplayName '$DisplayName'. Please specify the Id parameter to identify which policy to manage. Found policies: $($matchingPolicies.Id -join ', ')"
                    }
                    $getValue = Get-MgBetaDeviceManagementDeviceHealthScript -DeviceHealthScriptId $matchingPolicies.Id
                }
            }
        }
        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Intune Managed Installer Policy for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Intune Managed Installer Policy for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        $results = @{
            #region resource generator code
            Description              = $getValue.Description
            DisplayName              = $getValue.DisplayName
            IsIntuneManagedInstaller = $getValue.DetectionScriptParameters[0].AdditionalProperties.defaultValue -eq 'true'
            RoleScopeTagIds          = $getValue.RoleScopeTagIds
            Id                       = $getValue.Id
            Ensure                   = 'Present'
            Credential               = $Credential
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            ApplicationSecret        = $ApplicationSecret
            CertificateThumbprint    = $CertificateThumbprint
            ManagedIdentity          = $ManagedIdentity.IsPresent
            AccessTokens             = $AccessTokens
            #endregion
        }

        $assignmentsValues = Get-MgBetaDeviceManagementDeviceHealthScriptAssignment -DeviceHealthScriptId $Id
        $assignmentResult = @()
        foreach ($assignment in $assignmentsValues)
        {
            $assignmentResult += ConvertFrom-IntunePolicyAssignment -Assignments $assignment
        }
        $results.Add('Assignments', $assignmentResult)

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
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsIntuneManagedInstaller,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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
    $boundParameters.Remove('IsIntuneManagedInstaller') | Out-Null

    $isIntuneManagedInstallerValue = 'false'
    if ($IsIntuneManagedInstaller)
    {
        $isIntuneManagedInstallerValue = 'true'
    }
    $boundParameters.detectionScriptParameters = @(
        @{
            '@odata.type'                    = '#microsoft.graph.deviceHealthScriptStringParameter'
            applyDefaultValueWhenNotAssigned = $true
            defaultValue                     = $isIntuneManagedInstallerValue
            description                      = 'Enable Intune Managed Extension as Managed Installer'
            isRequired                       = $true
            name                             = 'Enabled'
        }
    )
    $boundParameters.enforceSignatureCheck = $true
    $boundParameters.detectionScriptContent = $null
    $boundParameters.remediationScriptContent = $null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Managed Installer Policy for Windows10 with DisplayName {$DisplayName}"
        $boundParameters.Remove('Assignments') | Out-Null

        $createParameters = ([Hashtable]$boundParameters).Clone()
        $createParameters.Remove('Id') | Out-Null
        if ($createParameters.ContainsKey('Description'))
        {
            $createParameters.description = $createParameters.Description
            $createParameters.Remove('Description') | Out-Null
        }
        if ($createParameters.ContainsKey('DisplayName'))
        {
            $createParameters.displayName = $createParameters.DisplayName
            $createParameters.Remove('DisplayName') | Out-Null
        }
        if ($createParameters.ContainsKey('RoleScopeTagIds'))
        {
            $createParameters.roleScopeTagIds = $createParameters.RoleScopeTagIds
            $createParameters.Remove('RoleScopeTagIds') | Out-Null
        }
        $createParameters.deviceHealthScriptType = 'managedInstallerScript'
        $createParameters.detectionScriptContent = 'ZGV0ZWN0aW9uU2NyaXB0Q29udGVudA=='
        $createParameters.remediationScriptContent = 'cmVtZWRpYXRpb25TY3JpcHRDb250ZW50'
        $createParameters.isGlobalScript = $false
        $createParameters.'@odata.type' = '#microsoft.graph.deviceHealthScript'

        #region resource generator code
        $policy = Invoke-MgGraphRequest -Uri '/beta/deviceManagement/deviceHealthScripts' `
            -Method POST `
            -Body $($createParameters | ConvertTo-Json -Depth 10) `
            -SkipHttpErrorCheck

        if ($policy.error)
        {
            Write-Warning -Message "Received error while creating Intune Managed Installer Policy for Windows10: $($policy.error.message)"
            Write-Verbose -Message 'Check if policy was created despite the error.'
            $policy = Get-MgBetaDeviceManagementDeviceHealthScript -Filter "displayName eq '$DisplayName' and deviceHealthScriptType eq 'managedInstallerScript'" -ErrorAction SilentlyContinue

            if ($null -eq $policy)
            {
                throw "Failed to create Intune Managed Installer Policy for Windows10 with DisplayName {$DisplayName}. Error: $($policy.error.message)"
            }
        }

        if ($policy.id)
        {
            $assignmentsHash = @()
            foreach ($assignment in $Assignments)
            {
                $assignmentTarget = ConvertTo-IntunePolicyAssignment -Assignments $Assignments
                $assignmentsHash += @{
                    runRemediationScript = $true
                    target               = $assignmentTarget.target
                }
            }
            Update-DeviceConfigurationPolicyAssignment `
                -DeviceConfigurationPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository 'deviceManagement/deviceHealthScripts' `
                -RootIdentifier 'deviceHealthScriptAssignments'
        }
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Managed Installer Policy for Windows10 with Id {$($currentInstance.Id)}"
        $boundParameters.Remove('Assignments') | Out-Null

        $updateParameters = ([Hashtable]$boundParameters).Clone()

        #region resource generator code
        Update-MgBetaDeviceManagementDeviceHealthScript `
            -DeviceHealthScriptId $currentInstance.Id `
            -BodyParameter $updateParameters

        $assignmentsHash = @()
        foreach ($assignment in $Assignments)
        {
            $assignmentTarget = ConvertTo-IntunePolicyAssignment -Assignments $Assignments
            $assignmentsHash += @{
                runRemediationScript = $assignment.RunRemediationScript
                target               = $assignmentTarget.target
            }
        }
        Update-DeviceConfigurationPolicyAssignment `
            -DeviceConfigurationPolicyId $currentInstance.Id `
            -Targets $assignmentsHash `
            -Repository 'deviceManagement/deviceHealthScripts' `
            -RootIdentifier 'deviceHealthScriptAssignments'
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Managed Installer Policy for Windows10 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaDeviceManagementDeviceHealthScript -DeviceHealthScriptId $currentInstance.Id
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
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsIntuneManagedInstaller,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,
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
        $baseFilter = "deviceHealthScriptType eq 'managedInstallerScript'"
        if (-not [System.String]::IsNullOrEmpty($Filter))
        {
            $Filter = "($Filter) and ($baseFilter)"
        }
        else
        {
            $Filter = $baseFilter
        }
        [array]$getValue = Get-MgBetaDeviceManagementDeviceHealthScript `
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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.DisplayName))
            {
                $displayedKey = $config.DisplayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
            if ($Results.Assignments)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
                if (-not [string]::IsNullOrEmpty($complexTypeStringResult))
                {
                    $Results.Assignments = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Assignments') | Out-Null
                }
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential `
                -NoEscape @('Assignments')

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
