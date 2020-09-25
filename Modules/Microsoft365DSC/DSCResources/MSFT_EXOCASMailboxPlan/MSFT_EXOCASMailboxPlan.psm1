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
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Getting configuration of CASMailboxPlan for $Identity"
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
    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'

    try
    {
        $CASMailboxPlans = Get-CASMailboxPlan -ErrorAction Stop
        if ($Identity.Contains('-'))
        {
            $CASMailboxPlan = $CASMailboxPlans | Where-Object -FilterScript { $_.Identity -eq $Identity }
        }
        else
        {
            $CASMailboxPlan = $CASMailboxPlans | Where-Object -FilterScript { $_.Identity -like ($Identity + '-*') }
        }

        if ($null -eq $CASMailboxPlan)
        {
            Write-Verbose -Message "CASMailboxPlan $($Identity) does not exist."
            return $nullResult
        }
        else
        {
            $result = @{
                Ensure             = 'Present'
                Identity           = $Identity
                ActiveSyncEnabled  = $CASMailboxPlan.ActiveSyncEnabled
                ImapEnabled        = $CASMailboxPlan.ImapEnabled
                OwaMailboxPolicy   = $CASMailboxPlan.OwaMailboxPolicy
                PopEnabled         = $CASMailboxPlan.PopEnabled
                GlobalAdminAccount = $GlobalAdminAccount
            }

            Write-Verbose -Message "Found CASMailboxPlan $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Setting configuration of CASMailboxPlan for $Identity"
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

    $CASMailboxPlanParams = $PSBoundParameters
    $CASMailboxPlanParams.Remove('Ensure') | Out-Null
    $CASMailboxPlanParams.Remove('GlobalAdminAccount') | Out-Null

    $CASMailboxPlans = Get-CASMailboxPlan
    $CASMailboxPlan = $CASMailboxPlans | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if ($null -ne $CASMailboxPlan)
    {
        Write-Verbose -Message "Setting CASMailboxPlan $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $CASMailboxPlanParams)"
        Set-CASMailboxPlan @CASMailboxPlanParams
    }
    else
    {
        throw "The specified CAS Mailbox Plan {$($Identity)} doesn't exist"
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
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Testing configuration of CASMailboxPlan for $Identity"

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
        [array]$CASMailboxPlans = Get-CASMailboxPlan -ErrorAction Stop

        if ($CASMailboxPlans.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewLine
        }
        $dscContent = ""
        $i = 1
        foreach ($CASMailboxPlan in $CASMailboxPlans)
        {
            Write-Host "    |---[$i/$($CASMailboxPlans.Count)] $($CASMailboxPlan.Identity.Split('-')[0])" -NoNewLine
            $Params = @{
                Identity              = $CASMailboxPlan.Identity
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
