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
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.String[]]
        $ResourceScopesDisplayNames,

        [Parameter()]
        [System.String]
        $ScopeType,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersDisplayNames,

        [Parameter()]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $RoleDefinitionDisplayName,

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
            $getValue = Get-MgDeviceManagementRoleAssignment -DeviceAndAppManagementRoleAssignmentId $id -ErrorAction SilentlyContinue
            if($null -ne $getValue){
                Write-Verbose -Message "Found something with id {$id}"
            }
        }
        else
        {
            Write-Verbose -Message "Nothing with id {$id} was found"
            $Filter = "displayName eq '$DisplayName'"
            $getValue = Get-MgDeviceManagementRoleAssignment -Filter $Filter -ErrorAction SilentlyContinue
            if($null -ne $getValue){
                Write-Verbose -Message "Found something with displayname {$DisplayName}"
            }
            else{
                Write-Verbose -Message "Nothing with displayname {$DisplayName} was found"
                return $nullResult
            }
        }

        #Get Roledefinition first, loop through all roledefinitions and find the assignment match the id
        $tempRoleDefinitions = Get-MgDeviceManagementRoleDefinition
        foreach($tempRoleDefinition in $tempRoleDefinitions)
        {
            $item = Get-MgDeviceManagementRoleDefinitionRoleAssignment -RoleDefinitionId $tempRoleDefinition.Id | Where-Object {$_.Id -eq $getValue.Id}
            if($null -ne $item)
            {
                $RoleDefinition = $tempRoleDefinition.Id
                $RoleDefinitionDisplayName = $tempRoleDefinition.DisplayName
                break
            }
        }

        #$RoleDefinitionid = Get-MgDeviceManagementRoleAssignment -DeviceAndAppManagementRoleAssignmentId $getvalue.Id -ExpandProperty *

        $ResourceScopesDisplayNames = @()
        foreach($ResourceScope in $getValue.ResourceScopes)
        {
            $ResourceScopesDisplayNames += (Get-MgGroup -GroupId $ResourceScope).DisplayName
        }

        $MembersDisplayNames = @()
        foreach($tempMember in $getValue.Members)
        {
            $MembersDisplayNames += (Get-MgGroup -GroupId $tempMember).DisplayName
        }

        Write-Verbose -Message "Found something with id {$id}"

        $results = @{
            Id = $getValue.Id
            Description                 = $getValue.Description
            DisplayName                 = $getValue.DisplayName
            ResourceScopes              = $getValue.ResourceScopes
            ResourceScopesDisplayNames  = $ResourceScopesDisplayNames
            ScopeType                   = $getValue.ScopeType
            Members                     = $getValue.Members
            MembersDisplayNames         = $MembersDisplayNames
            RoleDefinition              = $RoleDefinition
            RoleDefinitionDisplayName   = $RoleDefinitionDisplayName
            Ensure                      = 'Present'
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            TenantId                    = $TenantId
            ApplicationSecret           = $ApplicationSecret
            CertificateThumbprint       = $CertificateThumbprint
            ManagedIdentity             = $ManagedIdentity.IsPresent
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
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.String[]]
        $ResourceScopesDisplayNames,

        [Parameter()]
        [System.String]
        $ScopeType,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersDisplayNames,

        [Parameter()]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $RoleDefinitionDisplayName,

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

    if(!($RoleDefinition -match "^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$")){
        [string]$roleDefinition = $null
        $Filter = "displayName eq '$RoleDefinitionDisplayName'"
        $RoleDefinitionId = Get-MgDeviceManagementRoleDefinition -Filter $Filter -ErrorAction SilentlyContinue
        if($null -ne $RoleDefinitionId){
            $roleDefinition = $RoleDefinitionId.Id
        }
        else{
            Write-Verbose -Message "Nothing with displayname {$RoleDefinitionDisplayName} was found"
        }
    }

    [array]$members = @()
    foreach($MembersDisplayName in $membersDisplayNames){
        $Filter = "displayName eq '$MembersDisplayName'"
        $MemberId = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if($null -ne $MemberId){
            if($Members -notcontains $MemberId.Id){
                $Members += $MemberId.Id
            }
        }
        else{
            Write-Verbose -Message "Nothing with displayname {$MembersDisplayName} was found"
        }
    }

    [array]$resourceScopes = @()
    foreach($ResourceScopesDisplayName in $ResourceScopesDisplayNames){
        $Filter = "displayName eq '$ResourceScopesDisplayName'"
        $ResourceScopeId = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if($null -ne $ResourceScopeId){
            if($ResourceScopes -notcontains $ResourceScopeId.Id){
                $ResourceScopes += $ResourceScopeId.Id
            }
        }
        else{
            Write-Verbose -Message "Nothing with displayname {$ResourceScopesDisplayName} was found"
        }
    }
    if($ScopeType -match "AllDevices|AllLicensedUsers|AllDevicesAndLicensedUsers"){
        $ResourceScopes = $null
    }
    else{
        $ScopeType = "resourceScope"
        $ResourceScopes = $ResourceScopes
    }
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"

        $CreateParameters = @{
            description = $Description
            displayName = $DisplayName
            resourceScopes = $ResourceScopes
            scopeType = $ScopeType
            members = $Members
            '@odata.type' = '#microsoft.graph.deviceAndAppManagementRoleAssignment'
            'roleDefinition@odata.bind' = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('$roleDefinition')"
        }
        $policy=New-MgDeviceManagementRoleAssignment -BodyParameter $CreateParameters

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"

        $UpdateParameters = @{
            description = $Description
            displayName = $DisplayName
            resourceScopes = $ResourceScopes
            scopeType = $ScopeType
            members = $Members
            '@odata.type' = '#microsoft.graph.deviceAndAppManagementRoleAssignment'
            'roleDefinition@odata.bind' = "https://graph.microsoft.com/beta/deviceManagement/roleDefinitions('$roleDefinition')"
        }

        Update-MgDeviceManagementRoleAssignment -BodyParameter $UpdateParameters `
            -DeviceAndAppManagementRoleAssignmentId $currentInstance.Id

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"
        Remove-MgDeviceManagementRoleAssignment -DeviceAndAppManagementRoleAssignmentId $currentInstance.Id
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
        [System.String[]]
        $ResourceScopes,

        [Parameter()]
        [System.String[]]
        $ResourceScopesDisplayNames,

        [Parameter()]
        [System.String]
        $ScopeType,

        [Parameter()]
        [System.String[]]
        $Members,

        [Parameter()]
        [System.String[]]
        $MembersDisplayNames,

        [Parameter()]
        [System.String]
        $RoleDefinition,

        [Parameter()]
        [System.String]
        $RoleDefinitionDisplayName,

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

    Write-Verbose -Message "Testing configuration of {$id - $displayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if(!($RoleDefinition -match '^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$')){
        [string]$roleDefinition = $null
        $Filter = "displayName eq '$RoleDefinitionDisplayName'"
        $RoleDefinitionId = Get-MgDeviceManagementRoleDefinition -Filter $Filter -ErrorAction SilentlyContinue
        if($null -ne $RoleDefinitionId){
            $roleDefinition = $RoleDefinitionId.Id
            $PSBoundParameters.Set_Item('RoleDefinition',$roleDefinition)
        }
        else{
            Write-Verbose -Message "Nothing with displayname {$RoleDefinitionDisplayName} was found"
        }
    }

    foreach($MembersDisplayName in $membersDisplayNames){
        $Filter = "displayName eq '$MembersDisplayName'"
        $newMemeber = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if($null -ne $newMemeber){
            if($Members -notcontains $newMemeber.Id){
                $Members += $newMemeber.Id
            }
        }
        else{
            Write-Verbose -Message "Nothing with displayname {$RoleDefinitionDisplayName} was found"
        }
    }
    $PSBoundParameters.Set_Item('Members',$Members)

    foreach($ResourceScopesDisplayName in $resourceScopesDisplayNames){
        $Filter = "displayName eq '$ResourceScopesDisplayName'"
        $newResourceScope = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
        if($null -ne $newResourceScope){
            if($ResourceScopes -notcontains $newResourceScope.Id){
                $ResourceScopes += $newResourceScope.Id
            }
        }
        else{
            Write-Verbose -Message "Nothing with displayname {$RoleDefinitionDisplayName} was found"
        }
    }
    $PSBoundParameters.Set_Item('ResourceScopes',$ResourceScopes)

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
    $ValuesToCheck.Remove('ResourceScopesDisplayNames') | Out-Null
    $ValuesToCheck.Remove('membersDisplayNames') | Out-Null

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
        [array]$getValue = Get-MgDeviceManagementRoleAssignment `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.deviceAndAppManagementRoleAssignment'  `
            }

        if (-not $getValue)
        {
            [array]$getValue = Get-MgDeviceManagementRoleAssignment `
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
                ManagedIdentity       = $ManagedIdentity.IsPresent
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
