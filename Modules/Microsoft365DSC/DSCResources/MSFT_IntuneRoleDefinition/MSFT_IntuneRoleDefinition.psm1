function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsBuiltIn,

        [Parameter()]
        [System.String[]]
        $allowedResourceActions,

        [Parameter()]
        [System.String[]]
        $notAllowedResourceActions,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

        Select-MgProfile 'beta'
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

        if($Id -match '^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$')
        {
            $getValue = Get-MgDeviceManagementRoleDefinition -RoleDefinitionId $id -ErrorAction SilentlyContinue
            if($null -ne $getValue){
                Write-Verbose -Message "Found something with id {$id}"
            }
        }
        else
        {
            Write-Verbose -Message "Nothing with id {$id} was found"
            $Filter = "displayName eq '$DisplayName'"
            $getValue = Get-MgDeviceManagementRoleDefinition -Filter $Filter -ErrorAction SilentlyContinue
            if($null -ne $getValue){
                Write-Verbose -Message "Found something with displayname {$DisplayName}"
            }
            else{
                Write-Verbose -Message "Nothing with displayname {$DisplayName} was found"
                return $nullResult
            }
        }

        $results = @{
            Id                    = $getValue.Id
            Description           = $getValue.Description
            DisplayName           = $getValue.DisplayName
            IsBuiltIn             = $getValue.IsBuiltIn
            Ensure                = 'Present'
            roleScopeTagIds       = $getValue.RoleScopeTagIds
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity
        }
        if ($getValue.RolePermissions)
        {
            $results.Add("allowedResourceActions", $getValue.RolePermissions.ResourceActions.AllowedResourceActions)
            $results.Add("notallowedResourceActions", $getValue.RolePermissions.ResourceActions.notAllowedResourceActions)
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsBuiltIn,

        [Parameter()]
        [System.String[]]
        $allowedResourceActions,

        [Parameter()]
        [System.String[]]
        $notAllowedResourceActions,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

        Select-MgProfile 'beta' -ErrorAction Stop
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

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        if($null -ne $roleScopeTagIds){
            $ScopeRoleTags = @()
            foreach($roleScopeTagId in $roleScopeTagIds){
                $Tag = Get-MgDeviceManagementRoleScopeTag -RoleScopeTagId $roleScopeTagId -ErrorAction SilentlyContinue
                if($null -ne $Tag){
                    $ScopeRoleTags += $Tag.Id
                }
            }
        }
        $resourceActions = @{
			'@odata.type'               = "microsoft.graph.resourceAction"
			notAllowedResourceActions   = $notAllowedResourceActions
			allowedResourceActions      = $allowedResourceActions
		}
        $rolepermission = @{
			'@odata.type'               = "microsoft.graph.rolePermission"
			resourceActions             = @($resourceActions)
        }
        $ScopeTagIds                    = $ScopeRoleTags
        $CreateParameters = @{
            '@odata.type' 		        = "#microsoft.graph.roleDefinition"
            displayName 		        = $DisplayName
            description 		        = $Description
            rolePermissions             = @($rolepermission)
            roleScopeTagIds		         = $ScopeTagIds
        }

        $policy=New-MgDeviceManagementRoleDefinition -BodyParameter $CreateParameters

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        if($null -ne $roleScopeTagIds){
            $ScopeRoleTags = @()
            foreach($roleScopeTagId in $roleScopeTagIds){
                $Tag = Get-MgDeviceManagementRoleScopeTag -RoleScopeTagId $roleScopeTagId -ErrorAction SilentlyContinue
                if($null -ne $Tag){
                    $ScopeRoleTags += $Tag.Id
                }
            }
        }
        $resourceActions = @{
			'@odata.type'               = "microsoft.graph.resourceAction"
			notAllowedResourceActions   = $notAllowedResourceActions
			allowedResourceActions      = $allowedResourceActions
		}
        $rolepermission = @{
			'@odata.type'               = "microsoft.graph.rolePermission"
			resourceActions             = @($resourceActions)
        }
        $ScopeTagIds = $ScopeRoleTags
        $UpdateParameters = @{
            '@odata.type' 		        = "#microsoft.graph.roleDefinition"
            displayName 		        = $DisplayName
            description 		        = $Description
            rolePermissions             = @($rolepermission)
            roleScopeTagIds		        = $ScopeTagIds
        }

        Update-MgDeviceManagementRoleDefinition -BodyParameter $UpdateParameters `
            -RoleDefinitionId $currentInstance.Id

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"
        Remove-MgDeviceManagementRoleDefinition -RoleDefinitionId $currentInstance.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $True)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $IsBuiltIn,

        [Parameter()]
        [System.String[]]
        $allowedResourceActions,

        [Parameter()]
        [System.String[]]
        $notAllowedResourceActions,

        [Parameter()]
        [System.String[]]
        $roleScopeTagIds,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if($CurrentValues.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult=$true

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null

    foreach ($key in $ValuesToCheck.Keys)
    {
        if (($null -ne $CurrentValues[$key]) `
                -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key] = $CurrentValues[$key].toString()
        }
    }

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
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'
    Select-MgProfile 'beta' -ErrorAction Stop

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
        [array]$getValue = Get-MgDeviceManagementRoleDefinition `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceAndAppManagementRoleDefinition'  `
            }

        if (-not $getValue)
        {
            [array]$getValue = Get-MgDeviceManagementRoleDefinition
                -ErrorAction Stop
        }
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
            $displayedKey=$config.id
            if(-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey=$config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                id                    = $config.id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
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
        return ''
    }
}
