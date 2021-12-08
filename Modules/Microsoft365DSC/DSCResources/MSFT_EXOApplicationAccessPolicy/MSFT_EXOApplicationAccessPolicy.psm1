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
        $CertificatePassword
    )

    Write-Verbose -Message "Getting Application Access Policy configuration for $Identity"
    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        try
        {
            $AllApplicationAccessPolicies = Get-ApplicationAccessPolicy -ErrorAction Stop
        }
        catch
        {
            if ($_.Exception -like "The operation couldn't be performed because object*")
            {
                Write-Verbose "Could not obtain Application Access Policies for Tenant"
                return $nullReturn
            }
        }

        $ApplicationAccessPolicy = $AllApplicationAccessPolicies | Where-Object -FilterScript { $_.Identity -eq $Identity }

        if ($null -eq $ApplicationAccessPolicy)
        {
            Write-Verbose -Message "Application Access Policy $($Identity) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Identity              = $ApplicationAccessPolicy.Identity
                AccessRight           = $ApplicationAccessPolicy.AccessRight
                AppID                 = $ApplicationAccessPolicy.AppID
                PolicyScopeGroupId    = $ApplicationAccessPolicy.ScopeIdentity
                Description           = $ApplicationAccessPolicy.Description
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                TenantId              = $TenantId
            }

            Write-Verbose -Message "Found Application Access Policy $($Identity)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
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
        $CertificatePassword
    )

    Write-Verbose -Message "Setting Application Access Policy configuration for $Identity"

    $currentApplicationAccessPolicyConfig = Get-TargetResource @PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewApplicationAccessPolicyParams = @{
        AccessRight        = $AccessRight
        AppID              = $AppID
        PolicyScopeGroupId = $PolicyScopeGroupId
        Description        = $Description
        Confirm            = $false
    }

    $SetApplicationAccessPolicyParams = @{
        Identity    = $Identity
        Description = $Description
        Confirm     = $false
    }

    # CASE: Application Access Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' does not exist but it should. Create and configure it."
        # Create Application Access Policy
        New-ApplicationAccessPolicy @NewApplicationAccessPolicyParams

    }
    # CASE: Application Access Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' exists but it shouldn't. Remove it."
        Remove-ApplicationAccessPolicy -Identity $Identity -Confirm:$false
    }
    # CASE: Application Access Policy exists and it should, but Description attribute has different values than desired (Set-ApplicationAccessPolicy is only able to change description attribute)
    elseif ($Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Description -ne $Description)
    {
        Write-Verbose -Message "Application Access Policy '$($Identity)' already exists, but needs updating."
        Write-Verbose -Message "Setting Application Access Policy $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $SetApplicationAccessPolicyParams)"
        Set-ApplicationAccessPolicy @SetApplicationAccessPolicyParams
    }
    # CASE: Application Access Policy exists and it should, but has different values than the desired one
    # Set-ApplicationAccessPolicy is only able to change description attribute, therefore re-create policy
    elseif ($Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Ensure -eq "Present" -and $currentApplicationAccessPolicyConfig.Description -eq $Description)
    {
        Write-Verbose -Message "Re-create Application Access Policy '$($Identity)'"
        Remove-ApplicationAccessPolicy -Identity $Identity -Confirm:$false
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
        $CertificatePassword
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing Application Access Policy configuration for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        try
        {
            [array]$AllApplicationAccessPolicies = Get-ApplicationAccessPolicy -ErrorAction SilentlyContinue
        }
        catch
        {
            if ($_.Exception -like "*The operation couldn't be performed because object*")
            {
                Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) The current tenant is not registered to allow for Application Access Policies"
                return ""
            }
            throw $_
        }

        $dscContent = ""
        if ($AllApplicationAccessPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($ApplicationAccessPolicy in $AllApplicationAccessPolicies)
        {
            Write-Host "    |---[$i/$($AllApplicationAccessPolicies.Count)] $($ApplicationAccessPolicy.Identity)" -NoNewline

            $Params = @{
                Identity              = $ApplicationAccessPolicy.Identity
                Credential    = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource

