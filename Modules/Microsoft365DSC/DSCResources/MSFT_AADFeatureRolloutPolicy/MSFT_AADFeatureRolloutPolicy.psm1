Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADFeatureRolloutPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String[]]
        $AppliesTo,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('passthroughAuthentication', 'seamlessSso', 'passwordHashSync', 'emailAsAlternateId', 'unknownFutureValue', 'certificateBasedAuthentication')]
        [System.String]
        $Feature,

        [Parameter()]
        [System.Boolean]
        $IsAppliedToOrganization,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

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

    Write-Verbose -Message "Getting configuration of Azure AD Policy Feature Rollout Policy with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Id -ne $Id)
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
            if (-not [System.String]::IsNullOrEmpty($Id))
            {
                $getValue = Get-MgBetaPolicyFeatureRolloutPolicy `
                    -FeatureRolloutPolicyId $Id `
                    -ExpandProperty 'AppliesTo' `
                    -ErrorAction SilentlyContinue
            }
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Policy Feature Rollout Policy with Id {$Id}"

                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $getValue = Get-MgBetaPolicyFeatureRolloutPolicy `
                        -Filter "DisplayName eq '$($DisplayName -replace "'", "''")'" `
                        -ExpandProperty 'AppliesTo' `
                        -ErrorAction SilentlyContinue
                }
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        #endregion

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Policy Feature Rollout Policy with DisplayName {$DisplayName}."
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Policy Feature Rollout Policy with Id {$Id} and DisplayName {$DisplayName} was found"

        #region resource generator code
        $enumFeature = $null
        if ($null -ne $getValue.Feature)
        {
            $enumFeature = $getValue.Feature.ToString()
        }
        #endregion

        $batchRequests = @()
        foreach ($group in $getValue.AppliesTo)
        {
            $batchRequests += @{
                id     = $group.Id
                method = 'GET'
                url    = "/groups/$($group.Id)?`$select=id,displayName"
            }
        }
        $batchResponses = Invoke-M365DSCGraphBatchRequest -Requests $batchRequests
        $groupDisplayNames = @($batchResponses.body.displayName | Sort-Object)

        $results = @{
            #region resource generator code
            AppliesTo               = $groupDisplayNames
            Description             = $getValue.Description
            DisplayName             = $getValue.DisplayName
            Feature                 = $enumFeature
            IsAppliedToOrganization = $getValue.IsAppliedToOrganization
            IsEnabled               = $getValue.IsEnabled
            Id                      = $getValue.Id
            Ensure                  = 'Present'
            Credential              = $Credential
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            ApplicationSecret       = $ApplicationSecret
            CertificateThumbprint   = $CertificateThumbprint
            ManagedIdentity         = $ManagedIdentity.IsPresent
            #endregion
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
        #region resource generator code
        [Parameter()]
        [System.String[]]
        $AppliesTo,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('passthroughAuthentication', 'seamlessSso', 'passwordHashSync', 'emailAsAlternateId', 'unknownFutureValue', 'certificateBasedAuthentication')]
        [System.String]
        $Feature,

        [Parameter()]
        [System.Boolean]
        $IsAppliedToOrganization,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

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

    if ($PSBoundParameters.ContainsKey('AppliesTo'))
    {
        $BoundParameters.Remove('AppliesTo') | Out-Null
        $delta = Compare-Object -ReferenceObject $AppliesTo -DifferenceObject $currentInstance.AppliesTo
        $groupsToRemove = $delta | Where-Object { $_.SideIndicator -eq '=>' }
        $groupsToAdd = $delta | Where-Object { $_.SideIndicator -eq '<=' }

        $batchRequestsToRemove = @()
        foreach ($groupDisplayName in $groupsToRemove.InputObject)
        {
            $batchRequestsToRemove += @{
                id     = $groupDisplayName
                method = 'GET'
                url    = "/groups?`$filter=displayName eq '$($groupDisplayName -replace "'", "''")'&`$select=id"
            }
        }
        $batchResponsesToRemove = Invoke-M365DSCGraphBatchRequest -Requests $batchRequestsToRemove
        $groupIdsToRemove = $batchResponsesToRemove.body.value.id
        foreach ($groupToRemove in $groupIdsToRemove)
        {
            Write-Verbose -Message "Removing Group with Id [$groupToRemove] from AAD Feature Rollout Policy [$DisplayName]"
            Remove-MgBetaPolicyFeatureRolloutPolicyApplyToByRef `
                -FeatureRolloutPolicyId $currentInstance.Id `
                -DirectoryObjectId $groupToRemove
        }

        $batchRequestsToAdd = @()
        foreach ($groupDisplayName in $groupsToAdd.InputObject)
        {
            $batchRequestsToAdd += @{
                id     = $groupDisplayName
                method = 'GET'
                url    = "/groups?`$filter=displayName eq '$($groupDisplayName -replace "'", "''")'&`$select=id"
            }
        }
        $batchResponsesToAdd = Invoke-M365DSCGraphBatchRequest -Requests $batchRequestsToAdd
        $groupIdsToAdd = $batchResponsesToAdd.body.value.id
        foreach ($groupToAdd in $groupIdsToAdd)
        {
            Write-Verbose -Message "Adding Group with Id [$groupToAdd] to AAD Feature Rollout Policy [$DisplayName]"
            New-MgBetaPolicyFeatureRolloutPolicyApplyToByRef `
                -FeatureRolloutPolicyId $currentInstance.Id `
                -BodyParameter @{
                    '@odata.id' = (Get-MSCloudLoginConnectionProfile -Workload MicrosoftGraph).ResourceUrl + "v1.0/directoryObjects/$groupToAdd"
                }
        }
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Azure AD Policy Feature Rollout Policy with DisplayName {$DisplayName}"

        $createParameters = ([Hashtable]$BoundParameters).Clone()
        $createParameters.Remove('Id') | Out-Null

        #region resource generator code
        $policy = New-MgBetaPolicyFeatureRolloutPolicy -BodyParameter $createParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Policy Feature Rollout Policy with Id {$($currentInstance.Id)}"

        $updateParameters = ([Hashtable]$BoundParameters).Clone()
        $updateParameters.Remove('Id') | Out-Null
        $updateParameters.Remove('Feature') | Out-Null

        #region resource generator code
        Update-MgBetaPolicyFeatureRolloutPolicy `
            -FeatureRolloutPolicyId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Policy Feature Rollout Policy with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaPolicyFeatureRolloutPolicy -FeatureRolloutPolicyId $currentInstance.Id
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
        [System.String[]]
        $AppliesTo,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [ValidateSet('passthroughAuthentication', 'seamlessSso', 'passwordHashSync', 'emailAsAlternateId', 'unknownFutureValue', 'certificateBasedAuthentication')]
        [System.String]
        $Feature,

        [Parameter()]
        [System.Boolean]
        $IsAppliedToOrganization,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

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
        [array]$getValue = Get-MgBetaPolicyFeatureRolloutPolicy `
            -Filter $Filter `
            -ExpandProperty 'AppliesTo' `
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
