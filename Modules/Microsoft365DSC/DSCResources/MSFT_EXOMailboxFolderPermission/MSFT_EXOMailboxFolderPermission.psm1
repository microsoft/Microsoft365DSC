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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UserPermissions,

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

    New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters | Out-Null

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
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            $instances = $Script:exportedInstances | Where-Object -FilterScript {$_.Identity -eq $Identity}
        }
        else
        {
            $instances = Get-MailboxFolderPermission -Identity $Identity -ErrorAction Stop
        }
        if ($null -eq $instances)
        {
            return $nullResult
        }

        [Array]$permissionsObj = @()

        foreach($mailboxfolderPermission in $instances){
            $currentPermission = @{}
            $currentPermission.Add('User', $mailboxFolderPermission.User.ToString())
            $currentPermission.Add('AccessRights', $mailboxFolderPermission.AccessRights)
            if($null -ne $mailboxFolderPermission.SharingPermissionFlags) {
                $currentPermission.Add('SharingPermissionFlags', $mailboxFolderPermission.SharingPermissionFlags)
            }
            $permissionsObj += $currentPermission
        }

        $results = @{
            Identity                 = $Identity
            UserPermissions          = [Array]$permissionsObj
            Ensure                   = 'Present'
            Credential               = $Credential
            ApplicationId            = $ApplicationId
            TenantId                 = $TenantId
            CertificateThumbprint    = $CertificateThumbprint
            ManagedIdentity          = $ManagedIdentity.IsPresent
            AccessTokens             = $AccessTokens
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UserPermissions,

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
    $currentMailboxFolderPermissions = $currentInstance.UserPermissions

    if ($Ensure -eq 'Present' -and $currentValues.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "There was some error in fetching the mailbox folder permissions for the folder {$Identity}."
        return
    }
    elseif ($Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Supplying Ensure = 'Absent' doesn't remove the permissions for the current mailbox folder. Send an array of required permissions instead."
        return
    }

    # Remove all the current existing pemrissions on this folder.
    # Skip removing the default and anonymous permissions, as can't be removed, and should just be directly updated.
    foreach($currentUserPermission in $currentMailboxFolderPermissions) {
        if($currentUserPermission.User.ToString().ToLower() -ne "default" -and $currentUserPermission.User.ToString().ToLower() -ne "anonymous"){
            Remove-MailboxFolderPermission -Identity $Identity -User $currentUserPermission.User -Confirm:$false
        }
    }

    # Add the desired state permissions on the mailbox folder
    # For Default and anonymous users, as the permissions were not removed, we just need to call set.
    foreach($userPermission in $UserPermissions) {
        if($userPermission.User.ToString().ToLower() -eq "default" -or $userPermission.User.ToString().ToLower() -eq "anonymous"){
            if ($userPermission.SharingPermissionFlags -eq ""){
                Set-MailboxFolderPermission -Identity $Identity -User $userPermission.User -AccessRights $userPermission.AccessRights
            }
            else {
                Set-MailboxFolderPermission -Identity $Identity -User $userPermission.User -AccessRights $userPermission.AccessRights -SharingPermissionFlags $userPermission.SharingPermissionFlags
            }
        }
        else {
            if ($userPermission.SharingPermissionFlags -eq ""){
                Add-MailboxFolderPermission -Identity $Identity -User $userPermission.User -AccessRights $userPermission.AccessRights
            }
            else {
                Add-MailboxFolderPermission -Identity $Identity -User $userPermission.User -AccessRights $userPermission.AccessRights -SharingPermissionFlags $userPermission.SharingPermissionFlags
            }
        }
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
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $UserPermissions,

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

    $testTargetResource = $true
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($null -ne $source -and $source.GetType().Name -like '*CimInstance*')
        {
            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-not $testResult)
            {
                $testTargetResource = $false
            }
            else {
                $ValuesToCheck.Remove($key) | Out-Null
            }
        }
    }

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
    -Source $($MyInvocation.MyCommand.Source) `
    -DesiredValues $PSBoundParameters `
    -ValuesToCheck $ValuesToCheck.Keys `
    -IncludedDrifts $driftedParams

    if(-not $TestResult)
    {
        $testTargetResource = $false
    }

    Write-Verbose -Message "Test-TargetResource returned $testTargetResource"

    return $testTargetResource
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        # Ensure the cmdlet is available
        $cmdletInfo = Get-Command Get-MailboxFolder -ErrorAction SilentlyContinue

        if ($null -eq $cmdletInfo)
        {
            Write-Host "    `r`n$($Global:M365DSCEmojiYellowCircle) The Get-MailboxFolder cmdlet is not avalaible. Service Principals do not have mailboxes."
            return ''
        }

        [Array]$mailboxFolders = Get-MailboxFolder -Recurse

        if ($mailboxes.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        $j = 1
        foreach ($mailboxFolder in $mailboxFolders)
        {
            Write-Host "        |---[$j/$($mailboxFolders.count)] $($mailboxFolder.Identity)" -NoNewline
            Write-Host "`r`n" -NoNewline

            $Params = @{
                Identity              = $mailboxFolder.Identity
                UserPermissions       = $null
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $MailboxFolderPermissions = Get-TargetResource @Params

            $Result = $MailboxFolderPermissions
            $Result = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Result
            if ($Result.UserPermissions.Count -gt 0)
            {
                $Result.UserPermissions = Get-M365DSCEXOUserPermissionsList $Result.UserPermissions
            }
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Result `
                -Credential $Credential

            if ($null -ne $Result.UserPermissions)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                    -ParameterName 'UserPermissions'
            }

            $dscContent += $currentDSCBlock

            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName

            $j++
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

function Get-M365DSCEXOUserPermissionsList
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Permissions
    )

    $StringContent = '@('
    foreach ($permission in $Permissions)
    {
        $StringContent += "MSFT_EXOMailboxFolderUserPermission {`r`n"
        $StringContent += "                User                   = '" + $permission.User + "'`r`n"
        $StringContent += "                AccessRights           = '" + $permission.AccessRights + "'`r`n"
        if($null -ne $permission.SharingPermissionFlags){
        #     $StringContent += "                SharingPermissionFlags = `$null" + "`r`n"
        # } else {
            $StringContent += "                SharingPermissionFlags = '" + $permission.SharingPermissionFlags + "'`r`n"
        }
        $StringContent += "            }`r`n"
    }
    $StringContent += '            )'
    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
