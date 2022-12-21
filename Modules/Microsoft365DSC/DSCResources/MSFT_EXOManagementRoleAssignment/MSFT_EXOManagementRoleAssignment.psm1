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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Role,

        [Parameter()]
        [System.String]
        $App,

        [Parameter()]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $SecurityGroup,

        [Parameter()]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $CustomRecipientWriteScope,

        [Parameter()]
        [System.String]
        $CustomResourceScope,

        [Parameter()]
        [System.String]
        $ExclusiveRecipientWriteScope,

        [Parameter()]
        [System.String]
        $RecipientAdministrativeUnitScope,

        [Parameter()]
        [System.String]
        $RecipientOrganizationalUnitScope,

        [Parameter()]
        [System.String]
        $RecipientRelativeWriteScope,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Getting Management Role Assignment for $Name"
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $roleAssignment = Get-ManagementRoleAssignment -Identity $Name -ErrorAction Stop

        if ($null -eq $roleAssignment)
        {
            Write-Verbose -Message "Management Role Assignment $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                             = $roleAssignment.Name
                CustomRecipientWriteScope        = $roleAssignment.CustomRecipientWriteScope
                CustomResourceScope              = $roleAssignment.CustomResourceScope
                ExclusiveRecipientWriteScope     = $roleAssignment.ExclusiveRecipientWriteScope
                RecipientAdministrativeUnitScope = $roleAssignment.RecipientAdministrativeUnitScope
                RecipientOrganizationalUnitScope = $roleAssignment.RecipientOrganizationalUnitScope
                RecipientRelativeWriteScope      = $roleAssignment.RecipientRelativeWriteScope
                Role                             = $roleAssignment.Role
                Ensure                           = 'Present'
                Credential                       = $Credential
                ApplicationId                    = $ApplicationId
                CertificateThumbprint            = $CertificateThumbprint
                CertificatePath                  = $CertificatePath
                CertificatePassword              = $CertificatePassword
                Managedidentity                  = $ManagedIdentity.IsPresent
                TenantId                         = $TenantId
            }

            if ($roleAssignment.RoleAssigneeType -eq 'SecurityGroup' -or $roleAssignment.RoleAssigneeType -eq 'RoleGroup')
            {
                $result.Add('SecurityGroup', $roleAssignment.RoleAssignee)
            }
            elseif ($roleAssignment.RoleAssigneeType -eq 'RoleAssignmentPolicy')
            {
                $result.Add('Policy', $roleAssignment.RoleAssignee)
            }
            elseif ($roleAssignment.RoleAssigneeType -eq 'ServicePrincipal')
            {
                $result.Add('App', $roleAssignment.RoleAssignee)
            }
            elseif ($roleAssignment.RoleAssigneeType -eq 'User')
            {
                $result.Add('User', $roleAssignment.RoleAssignee)
            }

            Write-Verbose -Message "Found Management Role Assignment $($Name)"
            return $result
        }
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Role,

        [Parameter()]
        [System.String]
        $App,

        [Parameter()]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $SecurityGroup,

        [Parameter()]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $CustomRecipientWriteScope,

        [Parameter()]
        [System.String]
        $CustomResourceScope,

        [Parameter()]
        [System.String]
        $ExclusiveRecipientWriteScope,

        [Parameter()]
        [System.String]
        $RecipientAdministrativeUnitScope,

        [Parameter()]
        [System.String]
        $RecipientOrganizationalUnitScope,

        [Parameter()]
        [System.String]
        $RecipientRelativeWriteScope,

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
        $ManagedIdentity
    )

    Write-Verbose -Message "Setting Management Role Assignment for $Name"

    $currentManagementRoleConfig = Get-TargetResource @PSBoundParameters

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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $NewManagementRoleParams = ([Hashtable]$PSBoundParameters).Clone()
    $NewManagementRoleParams.Remove('Ensure') | Out-Null
    $NewManagementRoleParams.Remove('Credential') | Out-Null
    $NewManagementRoleParams.Remove('ApplicationId') | Out-Null
    $NewManagementRoleParams.Remove('TenantId') | Out-Null
    $NewManagementRoleParams.Remove('CertificateThumbprint') | Out-Null
    $NewManagementRoleParams.Remove('CertificatePath') | Out-Null
    $NewManagementRoleParams.Remove('CertificatePassword') | Out-Null
    $NewManagementRoleParams.Remove('ManagedIdentity') | Out-Null

    # CASE: Management Role doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentManagementRoleConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Management Role Assignment'$($Name)' does not exist but it should. Create and configure it."
        # Create Management Role
        New-ManagementRoleAssignment @NewManagementRoleParams
    }
    # CASE: Management Role exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentManagementRoleConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Management Role Assignment'$($Name)' exists but it shouldn't. Remove it."
        Remove-ManagementRoleAssignment -Identity $Name -Confirm:$false -Force
    }
    # CASE: Management Role exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentManagementRoleConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Management Role Assignment'$($Name)' already exists, but needs updating."
        $NewManagementRoleParams.Add('Identity', $Name)
        $NewManagementRoleParams.Remove('Name') | Out-Null
        $NewManagementRoleParams.Remove('User') | Out-Null
        $NewManagementRoleParams.Remove('Role') | Out-Null
        $NewManagementRoleParams.Remove('Computer') | Out-Null
        $NewManagementRoleParams.Remove('App') | Out-Null
        $NewManagementRoleParams.Remove('Policy') | Out-Null
        $NewManagementRoleParams.Remove('SecurityGroup') | Out-Null
        Set-ManagementRoleAssignment @NewManagementRoleParams
    }

    # Wait for the permission to be applied
    $testResults = $false
    $retries = 6
    do
    {
        Write-Verbose -Message "Testing to ensure changes were applied."
        $testResults = Test-TargetResource @PSBoundParameters
        if (-not $testResults)
        {
            Start-Sleep -Seconds 10
        }
        $retries--
    } while (-not $testResults -and $retries -gt 0)

    # Need to force reconnect to Exchange for the new permissions to kick in.
    if ($null -ne $Global:MSCloudLoginConnectionProfile.ExchangeOnline)
    {
        Write-Verbose -Message "Disconnecting from Exchange Online"
        $Global:MSCloudLoginConnectionProfile.ExchangeOnline.Disconnect()
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $Role,

        [Parameter()]
        [System.String]
        $App,

        [Parameter()]
        [System.String]
        $Policy,

        [Parameter()]
        [System.String]
        $SecurityGroup,

        [Parameter()]
        [System.String]
        $User,

        [Parameter()]
        [System.String]
        $CustomRecipientWriteScope,

        [Parameter()]
        [System.String]
        $CustomResourceScope,

        [Parameter()]
        [System.String]
        $ExclusiveRecipientWriteScope,

        [Parameter()]
        [System.String]
        $RecipientAdministrativeUnitScope,

        [Parameter()]
        [System.String]
        $RecipientOrganizationalUnitScope,

        [Parameter()]
        [System.String]
        $RecipientRelativeWriteScope,

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
        $ManagedIdentity
    )
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

    Write-Verbose -Message "Testing Management Role Assignment for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('User') | Out-Null
    $ValuesToCheck.Remove('Role') | Out-Null
    $ValuesToCheck.Remove('Computer') | Out-Null
    $ValuesToCheck.Remove('App') | Out-Null
    $ValuesToCheck.Remove('Policy') | Out-Null
    $ValuesToCheck.Remove('SecurityGroup') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('CertificatePath') | Out-Null
    $ValuesToCheck.Remove('CertificatePassword') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null

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
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        [array]$roleAssignments = Get-ManagementRoleAssignment | Where-Object -FilterScript { $_.RoleAssigneeType -eq 'ServicePrincipal' -or `
                $_.RoleAssigneeType -eq 'User' -or $_.RoleAssigneeType -eq 'RoleAssignmentPolicy' -or $_.RoleAssigneeType -eq 'SecurityGroup' `
                -or $_.RoleAssigneeType -eq 'RoleGroup'}

        $dscContent = ''

        if ($roleAssignments.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($assignment in $roleAssignments)
        {
            Write-Host "    |---[$i/$($roleAssignments.Count)] $($assignment.Name)" -NoNewline

            $Params = @{
                Name                  = $assignment.Name
                Role                  = $assignment.Role
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
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

