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
        [System.String]
        $IssueWarningQuota,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
        $MaxSendSize,

        [Parameter()]
        [System.String]
        $ProhibitSendQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.String]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $RoleAssignmentPolicy,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Getting configuration of MailboxPlan for $Identity"

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

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $MailboxPlan = Get-MailboxPlan $Identity -ErrorAction Stop

        if ($null -eq $MailboxPlan)
        {
            Write-Verbose -Message "MailboxPlan $($Identity) does not exist."
            return $nullResult
        }
        else
        {
            $result = @{
                Ensure                   = 'Present'
                Identity                 = $Identity
                IssueWarningQuota        = $MailboxPlan.IssueWarningQuota
                MaxReceiveSize           = $MailboxPlan.MaxReceiveSize
                MaxSendSize              = $MailboxPlan.MaxSendSize
                ProhibitSendQuota        = $MailboxPlan.ProhibitSendQuota
                ProhibitSendReceiveQuota = $MailboxPlan.ProhibitSendReceiveQuota
                RetainDeletedItemsFor    = $MailboxPlan.RetainDeletedItemsFor
                RetentionPolicy          = $MailboxPlan.RetentionPolicy
                RoleAssignmentPolicy     = $MailboxPlan.RoleAssignmentPolicy
                Credential               = $Credential
                ApplicationId            = $ApplicationId
                CertificateThumbprint    = $CertificateThumbprint
                CertificatePath          = $CertificatePath
                CertificatePassword      = $CertificatePassword
                Managedidentity          = $ManagedIdentity.IsPresent
                TenantId                 = $TenantId
            }

            Write-Verbose -Message "Found MailboxPlan $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $IssueWarningQuota,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
        $MaxSendSize,

        [Parameter()]
        [System.String]
        $ProhibitSendQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.String]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $RoleAssignmentPolicy,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Setting configuration of MailboxPlan for $Identity"

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

    $MailboxPlanParams = [System.Collections.Hashtable]($PSBoundParameters)
    $MailboxPlanParams.Remove('Ensure') | Out-Null
    $MailboxPlanParams.Remove('Credential') | Out-Null
    $MailboxPlanParams.Remove('ApplicationId') | Out-Null
    $MailboxPlanParams.Remove('TenantId') | Out-Null
    $MailboxPlanParams.Remove('CertificateThumbprint') | Out-Null
    $MailboxPlanParams.Remove('CertificatePath') | Out-Null
    $MailboxPlanParams.Remove('CertificatePassword') | Out-Null
    $MailboxPlanParams.Remove('Managedidentity') | Out-Null

    $MailboxPlan = Get-MailboxPlan $Identity

    if ($null -ne $MailboxPlan)
    {
        Write-Verbose -Message "Setting MailboxPlan $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $MailboxPlanParams)"
        Set-MailboxPlan @MailboxPlanParams
    }
    else
    {
        throw "The specified Mailbox Plan {$($Identity)} doesn't exist"
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
        [System.String]
        $IssueWarningQuota,

        [Parameter()]
        [System.String]
        $MaxReceiveSize,

        [Parameter()]
        [System.String]
        $MaxSendSize,

        [Parameter()]
        [System.String]
        $ProhibitSendQuota,

        [Parameter()]
        [System.String]
        $ProhibitSendReceiveQuota,

        [Parameter()]
        [System.String]
        $RetainDeletedItemsFor,

        [Parameter()]
        [System.String]
        $RetentionPolicy,

        [Parameter()]
        [System.String]
        $RoleAssignmentPolicy,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Testing configuration of MailboxPlan for $Identity"

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
    $ValuesToCheck.Remove('Managedidentity') | Out-Null

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
        [array]$MailboxPlans = Get-MailboxPlan -ErrorAction Stop

        if ($MailboxPlans.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = ''
        $i = 1
        foreach ($MailboxPlan in $MailboxPlans)
        {
            Write-Host "    |---[$i/$($MailboxPlans.Count)] $($MailboxPlan.Identity.Split('-')[0])" -NoNewline
            $Params = @{
                Identity              = $MailboxPlan.DisplayName
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

Export-ModuleMember -Function *-TargetResource
