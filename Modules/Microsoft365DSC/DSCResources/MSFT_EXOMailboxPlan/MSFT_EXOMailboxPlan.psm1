Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOMailboxPlan'

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

            $nullResult = @{
                Identity = $Identity
                Ensure   = 'Absent'
            }

            $MailboxPlan = Get-MailboxPlan -Identity $Identity -ErrorAction SilentlyContinue
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
        }
        else
        {
            $MailboxPlan = $Script:exportedInstance
        }

        Write-Verbose -Message "Found MailboxPlan $($Identity)"

        $result = @{
            Ensure                   = 'Present'
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
            ManagedIdentity          = $ManagedIdentity.IsPresent
            TenantId                 = $TenantId
            AccessTokens             = $AccessTokens
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

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $updateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $updateParameters.Remove('DisplayName') | Out-Null

    $MailboxPlan = Get-MailboxPlan -Identity $Identity

    if ($null -ne $MailboxPlan)
    {
        Write-Verbose -Message "Setting MailboxPlan $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $updateParameters)"
        Set-MailboxPlan @updateParameters
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
        [array]$MailboxPlans = Get-MailboxPlan -ErrorAction Stop

        if ($MailboxPlans.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $dscContent = ''
        $i = 1
        foreach ($MailboxPlan in $MailboxPlans)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($MailboxPlans.Count)] $($MailboxPlan.Identity.Split('-')[0])" -DeferWrite
            $Params = @{
                Identity              = $MailboxPlan.Identity
                DisplayName           = $MailboxPlan.DisplayName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $MailboxPlan
            $Results = Get-TargetResource @Params
            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
            {
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock

                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
            }

            $i++
        }
        return $dscContent
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
