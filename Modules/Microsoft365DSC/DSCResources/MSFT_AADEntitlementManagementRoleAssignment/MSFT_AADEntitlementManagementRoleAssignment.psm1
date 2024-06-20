function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [System.String]
        $DirectoryScopeId,
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message ($_)
    }

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
    try
    {
        $getValue = $null

        if (-not [System.String]::IsNullOrEmpty($Id))
        {
            $getValue = Get-MgBetaRoleManagementEntitlementManagementRoleAssignment -UnifiedRoleAssignmentId $Id
        }

        $user = Get-mguser -UserId $Principal
        $roleInfo = Get-MgBetaRoleManagementEntitlementManagementRoleDefinition -Filter "DisplayName eq '$RoleDefinition'"

        if ($null -eq $getValue)
        {
            if(-not [System.String]::IsNullOrEmpty($Id))
            {
                Write-Verbose -Message "Nothing with id {$Id} was found"
            }

            if (-Not [string]::IsNullOrEmpty($Principal))
            {
                $PrincipalId = $null
                if ($null -ne $user)
                {
                    $PrincipalId = $user.Id
                }

                $RoleDefinitionId = $null
                if ($null -ne $roleInfo)
                {
                    $RoleDefinitionId = $roleInfo.Id
                }
                $getValue = Get-MgBetaRoleManagementEntitlementManagementRoleAssignment -Filter "PrincipalId eq '$PrincipalId' and RoleDefinitionId eq '$RoleDefinitionId'"
            }
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "No existing assignments were found"
            return $nullResult
        }

        Write-Verbose -Message "Found existing role assignment with ID {$($getValue.id)}."

        $results = @{
            Id                    = $getValue.Id
            Principal             = $user.UserPrincipalName
            RoleDefinition        = $roleInfo.DisplayName
            DisplayName           = $getValue.DisplayName
            AppScopeId            = $getValue.AppScopeId
            DirectoryScopeId      = $getValue.DirectoryScopeId
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [System.String]
        $DirectoryScopeId,
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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters
    }
    catch
    {
        Write-Verbose -Message $_
    }

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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('AccessTokens') | Out-Null

    $setParameters = ([Hashtable]$PSBoundParameters).clone()
    $userInfo = Get-MgUser -UserId $Principal
    $roleInfo = Get-MgBetaRoleManagementEntitlementManagementRoleDefinition -Filter "DisplayName eq '$RoleDefinition'"
    $setParameters.Add('PrincipalId', $userInfo.Id)
    $setParameters.Add('RoleDefinitionId', $roleInfo.Id)
    $setParameters.Remove('Principal') | Out-Null
    $setParameters.Remove('RoleDefinition') | Out-Null
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $setParameters.Remove('Id') | Out-Null
        Write-Verbose -Message "Creating a new Entitlement Management Role Assignment with:`r`n$($setParameters | Out-String)"
        New-MgBetaRoleManagementEntitlementManagementRoleAssignment @setParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Entitlement Management Role Assignments cannot be updated."
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Remove-MgBetaRoleManagementEntitlementManagementRoleAssignment -UnifiedRoleAssignmentId $currentInstance.Id
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
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Principal,

        [Parameter(Mandatory)]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $AppScopeId,

        [Parameter()]
        [System.String]
        $DirectoryScopeId,
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

    Write-Verbose -Message "Testing configuration of Assignment"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -eq 'Absent' -and $Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Test-TargetResource returned $true"
        return $true
    }
    $testResult = $true

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
        [array]$getValue = Get-MgBetaRoleManagementEntitlementManagementRoleAssignment `
            -All `
            -ErrorAction Stop

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
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $roleInfo = Get-MgBetaRoleManagementEntitlementManagementRoleDefinition -UnifiedRoleDefinitionId $config.RoleDefinitionId
            $params = @{
                Id                    = $config.Id
                Principal             = $config.PrincipalId
                RoleDefinition        = $roleInfo.DisplayName
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
        if ($_.ErrorDetails.Message -like '*User is not authorized to perform the operation.*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) Tenant does not meet license requirement to extract this component or the user has not been granted the proper permissions."
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
