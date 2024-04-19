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
        $DisplayName,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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

    $nullResult = @{
        Identity = $Identity
    }

    try
    {
        $MailboxPlan = Get-MailboxPlan -Identity $Identity -ErrorAction Stop

        if ($null -eq $MailboxPlan)
        {
            if (-not [System.String]::IsNullOrEmpty($DisplayName))
            {
                Write-Verbose -Message "Couldn't find MailboxPlan by Identity {$Identity}. Trying by DisplayName."
                $MailboxPlan = Get-MailboxPlan -Identity $DisplayName
            }
            else
            {
                $MailboxPlan = Get-MailboxPlan -Filter "Name -like '$($Identity.Split('-')[0])*'"
            }

            if ($null -eq $MailboxPlan)
            {
                return $nullResult
            }
        }

        $result = @{
            Identity                 = $Identity
            DisplayName              = $MailboxPlan.DisplayName
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
            AccessTokens             = $AccessTokens
        }

        Write-Verbose -Message "Found MailboxPlan $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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
        [System.String]
        $DisplayName,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
    $MailboxPlanParams.Remove('ManagedIdentity') | Out-Null
    $MailboxPlanParams.Remove('AccessTokens') | Out-Null

    $MailboxPlan = Get-MailboxPlan -Identity $Identity

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
        $DisplayName,

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
    $ValuesToCheck.Remove('Ensure') | Out-Null

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
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
                Identity              = $MailboxPlan.Identity
                DisplayName           = $MailboxPlan.DisplayName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params

            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
            {
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
            }
            else
            {
                Write-Host $Global:M365DSCEmojiRedX
            }

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
