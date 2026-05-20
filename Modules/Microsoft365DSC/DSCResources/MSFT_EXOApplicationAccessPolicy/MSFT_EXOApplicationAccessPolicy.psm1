Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOApplicationAccessPolicy'

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
        [ValidateSet('RestrictAccess', 'DenyAccess')]
        [System.String]
        $AccessRight,

        [Parameter()]
        [System.String[]]
        $AppID,

        [Parameter()]
        [System.String]
        $PolicyScopeGroupId,

        [Parameter()]
        [System.String]
        $Description,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting Application Access Policy configuration for $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $ApplicationAccessPolicy = $null
            [Array]$ApplicationAccessPolicy = Get-ApplicationAccessPolicy -Identity $Identity -ErrorAction SilentlyContinue

            $ScopeIdentityValue = $null
            if ($null -eq $ApplicationAccessPolicy)
            {
                $scopeIdentityGroup = $null
                $scopeIdentityGroup = Get-Group -Identity $PolicyScopeGroupId -ErrorAction SilentlyContinue

                if ($null -ne $scopeIdentityGroup)
                {
                    $ScopeIdentityValue = $scopeIdentityGroup.WindowsEmailAddress
                    $ApplicationAccessPolicy = Get-ApplicationAccessPolicy | Where-Object -FilterScript { $AppID -eq $_.AppId -and $_.ScopeIdentity -eq $scopeIdentityGroup }
                }
                else
                {
                    Write-Verbose -Message "Could not find Group with Identity {$PolicyScopeGroupId}"
                }

                if ($null -ne $ApplicationAccessPolicy)
                {
                    Write-Verbose -Message "Found Application Access Policy by Scope {$PolicyScopeGroupId}"
                }
            }
            else
            {
                $ScopeIdentityValue = $ApplicationAccessPolicy.ScopeIdentity
            }

            if ($null -eq $ApplicationAccessPolicy)
            {
                Write-Verbose -Message "Application Access Policy $($Identity) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $ApplicationAccessPolicy = $Script:exportedInstance
            $ScopeIdentityValue = $ApplicationAccessPolicy.ScopeIdentity
        }

        Write-Verbose -Message "Found Application Access Policy {$($Identity)}"

        $ApplicationAccessPolicy = $ApplicationAccessPolicy[0]
        $result = @{
            Identity              = $ApplicationAccessPolicy.Identity
            AccessRight           = $ApplicationAccessPolicy.AccessRight
            AppID                 = $ApplicationAccessPolicy.AppID
            PolicyScopeGroupId    = $ScopeIdentityValue
            Description           = $ApplicationAccessPolicy.Description
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            TenantId              = $TenantId
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
        $Identity,

        [Parameter()]
        [ValidateSet('RestrictAccess', 'DenyAccess')]
        [System.String]
        $AccessRight,

        [Parameter()]
        [System.String[]]
        $AppID,

        [Parameter()]
        [System.String]
        $PolicyScopeGroupId,

        [Parameter()]
        [System.String]
        $Description,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting Application Access Policy configuration for $Identity"

    $currentApplicationAccessPolicyConfig = Get-TargetResource @PSBoundParameters

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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewApplicationAccessPolicyParams = @{
        AccessRight        = $AccessRight
        AppID              = $AppID
        PolicyScopeGroupId = $PolicyScopeGroupId
        Description        = $Description
        Confirm            = $false
    }

    $SetApplicationAccessPolicyParams = @{
        Identity    = $currentApplicationAccessPolicyConfig.Identity
        Description = $Description
        Confirm     = $false
    }

    # CASE: Application Access Policy doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentApplicationAccessPolicyConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' does not exist but it should. Create and configure it."
        # Create Application Access Policy
        New-ApplicationAccessPolicy @NewApplicationAccessPolicyParams

    }
    # CASE: Application Access Policy exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentApplicationAccessPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' exists but it shouldn't. Remove it."
        Remove-ApplicationAccessPolicy -Identity $Identity -Confirm:$false
    }
    # CASE: Application Access Policy exists and it should, but Description attribute has different values than desired (Set-ApplicationAccessPolicy is only able to change description attribute)
    elseif ($Ensure -eq 'Present' -and $currentApplicationAccessPolicyConfig.Ensure -eq 'Present' -and $currentApplicationAccessPolicyConfig.Description -ne $Description)
    {
        Write-Verbose -Message "Application Access Policy '$($currentApplicationAccessPolicyConfig.Identity)' already exists, but needs updating."
        Write-Verbose -Message "Setting Application Access Policy $($currentApplicationAccessPolicyConfig.Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SetApplicationAccessPolicyParams)"
        Set-ApplicationAccessPolicy @SetApplicationAccessPolicyParams
    }
    # CASE: Application Access Policy exists and it should, but has different values than the desired one
    # Set-ApplicationAccessPolicy is only able to change description attribute, therefore re-create policy
    elseif ($Ensure -eq 'Present' -and $currentApplicationAccessPolicyConfig.Ensure -eq 'Present' -and $currentApplicationAccessPolicyConfig.Description -eq $Description)
    {
        Write-Verbose -Message "Re-create Application Access Policy '$($currentApplicationAccessPolicyConfig.Identity)'"
        Remove-ApplicationAccessPolicy -Identity $currentApplicationAccessPolicyConfig.Identity -Confirm:$false
        Write-Verbose -Message 'Removing existing policy was successful'
        Write-Verbose -Message "Creating new instance with parameters: $(Convert-M365DscHashtableToString -Hashtable $NewApplicationAccessPolicyParams)"
        New-ApplicationAccessPolicy @NewApplicationAccessPolicyParams
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
        [ValidateSet('RestrictAccess', 'DenyAccess')]
        [System.String]
        $AccessRight,

        [Parameter()]
        [System.String[]]
        $AppID,

        [Parameter()]
        [System.String]
        $PolicyScopeGroupId,

        [Parameter()]
        [System.String]
        $Description,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

    try
    {
        try
        {
            [array]$AllApplicationAccessPolicies = Get-ApplicationAccessPolicy -ErrorAction Stop
        }
        catch
        {
            if ($_.Exception -like "*The operation couldn't be performed because object*")
            {
                Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for Application Access Policies" -CommitWrite
                return ''
            }
            throw $_
        }

        $dscContent = [System.Text.StringBuilder]::new()
        if ($AllApplicationAccessPolicies.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $i = 1
        foreach ($ApplicationAccessPolicy in $AllApplicationAccessPolicies)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($AllApplicationAccessPolicies.Count)] $($ApplicationAccessPolicy.Identity)" -DeferWrite

            $Params = @{
                Identity              = $ApplicationAccessPolicy.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $ApplicationAccessPolicy
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
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

Export-ModuleMember -Function *-TargetResource
