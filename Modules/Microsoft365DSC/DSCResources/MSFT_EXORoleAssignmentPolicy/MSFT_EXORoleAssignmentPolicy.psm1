function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String[]]
        $Roles,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Getting Role Assignment Policy configuration for $Name"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        $AllRoleAssignmentPolicies = Get-RoleAssignmentPolicy -ErrorAction Stop

        $RoleAssignmentPolicy = $AllRoleAssignmentPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $RoleAssignmentPolicy)
        {
            Write-Verbose -Message "Role Assignment Policy $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name               = $RoleAssignmentPolicy.Name
                Description        = $RoleAssignmentPolicy.Description
                IsDefault          = $RoleAssignmentPolicy.IsDefault
                Roles              = $RoleAssignmentPolicy.AssignedRoles
                Ensure             = 'Present'
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found Role Assignment Policy $($Name)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String[]]
        $Roles,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Setting Role Assignment Policy configuration for $Name"

    $currentRoleAssignmentPolicyConfig = Get-TargetResource @PSBoundParameters

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewRoleAssignmentPolicyParams = @{
        Name        = $Name
        Description = $Description
        IsDefault   = $IsDefault
        Roles       = $Roles
        Confirm     = $false
    }

    $SetRoleAssignmentPolicyParams = @{
        Identity    = $Name
        Name        = $Name
        Description = $Description
        IsDefault   = $IsDefault
        Roles       = $Roles
        Confirm     = $false
    }

    # CASE: Role Assignment Policy doesn't exist but should;
    if ($Ensure -eq "Present" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Role Assignment Policy
        New-RoleAssignmentPolicy @NewRoleAssignmentPolicyParams
    }
    # CASE: Role Assignment Policy exists but it shouldn't;
    elseif ($Ensure -eq "Absent" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Present")
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-RoleAssignmentPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Role Assignment Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq "Present" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Present" -and $null -eq (Compare-Object -ReferenceObject $($currentRoleAssignmentPolicyConfig.Roles) -DifferenceObject $Roles))
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Role Assignment Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetRoleAssignmentPolicyParams)"
        $SetRoleAssignmentPolicyParams.Remove("Roles") | Out-Null
        Set-RoleAssignmentPolicy @SetRoleAssignmentPolicyParams
    }
    # CASE: Role Assignment Policy exists and it should, but Roles attribute has different values than the desired ones
    # Set-RoleAssignmentPolicy cannot change Roles attribute. Therefore we have to remove and recreate the policy if Roles attribute should be changed.
    elseif ($Ensure -eq "Present" -and $currentRoleAssignmentPolicyConfig.Ensure -eq "Present" -and $null -ne (Compare-Object -ReferenceObject $($currentRoleAssignmentPolicyConfig.Roles) -DifferenceObject $Roles))
    {
        Write-Verbose -Message "Role Assignment Policy '$($Name)' already exists, but roles attribute needs updating."
        Write-Verbose -Message "Remove Role AssignmentPolicy before recreating because Roles attribute cannot be change with Set cmdlet"
        Remove-RoleAssignmentPolicy -Identity $Name -Confirm:$false
        New-RoleAssignmentPolicy @NewRoleAssignmentPolicyParams
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.Boolean]
        $IsDefault,

        [Parameter()]
        [System.String[]]
        $Roles,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Testing Role Assignment Policy configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        $GlobalAdminAccount,

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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array]$AllRoleAssignmentPolicies = Get-RoleAssignmentPolicy -ErrorAction

        $dscContent = ""

        if ($AllRoleAssignmentPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($RoleAssignmentPolicy in $AllRoleAssignmentPolicies)
        {
            Write-Host "    |---[$i/$($AllRoleAssignmentPolicies.Length)] $($RoleAssignmentPolicy.Name)" -NoNewLine

            $Params = @{
                Name                  = $RoleAssignmentPolicy.Name
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}

Export-ModuleMember -Function *-TargetResource

