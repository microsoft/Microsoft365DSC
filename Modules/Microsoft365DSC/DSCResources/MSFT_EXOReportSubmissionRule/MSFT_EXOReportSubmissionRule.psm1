function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

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

    Write-Verbose -Message "Getting configuration of ReportSubmissionRule"
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
    $nullReturn.IsSingleInstance = 'Yes'

    try
    {
        $ReportSubmissionRule = Get-ReportSubmissionRule -ErrorAction Stop

        if ($null -eq $ReportSubmissionRule)
        {
            Write-Verbose -Message "ReportSubmissionRule does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                IsSingleInstance            = 'Yes'
                Identity                    = $ReportSubmissionRule.Identity
                Comments                    = $ReportSubmissionRule.Comments
                SentTo                      = $ReportSubmissionRule.SentTo
                Credential                  = $Credential
                Ensure                      = 'Present'
                ApplicationId               = $ApplicationId
                CertificateThumbprint       = $CertificateThumbprint
                CertificatePath             = $CertificatePath
                CertificatePassword         = $CertificatePassword
                Managedidentity             = $ManagedIdentity.IsPresent
                TenantId                    = $TenantId
            }

            Write-Verbose -Message "Found ReportSubmissionRule"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
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
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

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
    Write-Verbose -Message "Setting configuration of ReportSubmissionRule"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $currentReportSubmissionRule = Get-TargetResource @PSBoundParameters

    $ReportSubmissionRuleParams = [System.Collections.Hashtable]($PSBoundParameters)
    $ReportSubmissionRuleParams.Remove('Ensure') | Out-Null
    $ReportSubmissionRuleParams.Remove('IsSingleInstance') | Out-Null
    $ReportSubmissionRuleParams.Remove('Credential') | Out-Null
    $ReportSubmissionRuleParams.Remove('ApplicationId') | Out-Null
    $ReportSubmissionRuleParams.Remove('TenantId') | Out-Null
    $ReportSubmissionRuleParams.Remove('CertificateThumbprint') | Out-Null
    $ReportSubmissionRuleParams.Remove('CertificatePath') | Out-Null
    $ReportSubmissionRuleParams.Remove('CertificatePassword') | Out-Null
    $ReportSubmissionRuleParams.Remove('ManagedIdentity') | Out-Null

    if ($Ensure -eq 'Present' -and $currentReportSubmissionRule.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating ReportSubmissionRule"

        $ReportSubmissionRuleParams.Add('Name', $Identity) | Out-Null
        $ReportSubmissionRuleParams.Remove('Identity') | Out-Null
        # There is only one ReportSubmissionPolicy, so we can hardcode the identity.
        $ReportSubmissionRuleParams.Add('ReportSubmissionPolicy', 'DefaultReportSubmissionPolicy') | Out-Null

        New-ReportSubmissionRule @ReportSubmissionRuleParams
    }
    elseif ($Ensure -eq 'Present' -and $currentReportSubmissionRule.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Setting ReportSubmissionRule with values: $(Convert-M365DscHashtableToString -Hashtable $ReportSubmissionRuleParams)"
        Set-ReportSubmissionRule @ReportSubmissionRuleParams -Confirm:$false
    }
    elseif ($Ensure -eq 'Absent' -and $currentReportSubmissionRule.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing ReportSubmissionRule"
        Remove-ReportSubmissionRule -Identity $Identity -Confirm:$false
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

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

    Write-Verbose -Message "Testing configuration of ReportSubmissionRule"

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
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $($TestResult)"

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
        $ReportSubmissionRule = Get-ReportSubmissionRule -ErrorAction Stop
        if ($ReportSubmissionRule.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            return
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $dscContent = ''

        Write-Host "    |---Export ReportSubmissionRule" -NoNewline

        $Params = @{
            Identity              = $ReportSubmissionRule.Identity
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePassword   = $CertificatePassword
            Managedidentity       = $ManagedIdentity.IsPresent
            CertificatePath       = $CertificatePath
            IsSingleInstance      = 'Yes'
        }

        $Results = Get-TargetResource @Params

        $keysToRemove = @()
        foreach ($key in $Results.Keys)
        {
            if ([System.String]::IsNullOrEmpty($Results.$key))
            {
                $keysToRemove += $key
            }
        }
        foreach ($key in $keysToRemove)
        {
            $Results.Remove($key) | Out-Null
        }
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
