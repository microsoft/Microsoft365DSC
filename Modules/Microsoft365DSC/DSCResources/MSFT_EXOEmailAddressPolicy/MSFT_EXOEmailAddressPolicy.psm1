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

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

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

    Write-Verbose -Message "Getting Email Address Policy configuration for $Name"
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
        $AllEmailAddressPolicies = Get-EmailAddressPolicy -ErrorAction Stop

        $EmailAddressPolicy = $AllEmailAddressPolicies | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $EmailAddressPolicy)
        {
            Write-Verbose -Message "Email Address Policy $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                              = $EmailAddressPolicy.Name
                Priority                          = $EmailAddressPolicy.Priority
                EnabledEmailAddressTemplates      = $EmailAddressPolicy.EnabledEmailAddressTemplates
                EnabledPrimarySMTPAddressTemplate = $EmailAddressPolicy.EnabledPrimarySMTPAddressTemplate
                ManagedByFilter                   = $EmailAddressPolicy.ManagedByFilter
                Ensure                            = 'Present'
                Credential                        = $Credential
                ApplicationId                     = $ApplicationId
                CertificateThumbprint             = $CertificateThumbprint
                CertificatePath                   = $CertificatePath
                CertificatePassword               = $CertificatePassword
                Managedidentity                   = $ManagedIdentity.IsPresent
                TenantId                          = $TenantId
                AccessTokens                      = $AccessTokens
            }

            Write-Verbose -Message "Found Email Address Policy $($Name)"
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

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

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

    Write-Verbose -Message "Setting Email Address Policy configuration for $Name"

    $currentEmailAddressPolicyConfig = Get-TargetResource @PSBoundParameters

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

    $NewEmailAddressPolicyParams = @{
        Name                              = $Name
        Priority                          = $Priority
        EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
        EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
        ManagedByFilter                   = $ManagedByFilter
        IncludeUnifiedGroupRecipients     = $true
        Confirm                           = $false
    }

    $SetEmailAddressPolicyParams = @{
        Identity                          = $Name
        Priority                          = $Priority
        EnabledEmailAddressTemplates      = $EnabledEmailAddressTemplates
        EnabledPrimarySMTPAddressTemplate = $EnabledPrimarySMTPAddressTemplate
        Confirm                           = $false
    }

    # EnabledEmailAddressTemplates and EnabledPrimarySMTPAddressTemplate cannot used at the same time.
    # If both parameters are specified, EnabledPrimarySMTPAddressTemplate will be removed and only
    # EnabledEmailAddressTemplates will be used.
    if ($null -ne $EnabledEmailAddressTemplates)
    {
        $NewEmailAddressPolicyParams.Remove('EnabledPrimarySMTPAddressTemplate')
        $SetEmailAddressPolicyParams.Remove('EnabledPrimarySMTPAddressTemplate')
    }

    # CASE: Email Address Policy doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentEmailAddressPolicyConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Email Address Policy '$($Name)' does not exist but it should. Create and configure it."
        # Create Email Address Policy
        New-EmailAddressPolicy @NewEmailAddressPolicyParams

    }
    # CASE: Email Address Policy exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentEmailAddressPolicyConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Email Address Policy '$($Name)' exists but it shouldn't. Remove it."
        Remove-EmailAddressPolicy -Identity $Name -Confirm:$false
    }
    # CASE: Email Address Policy exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentEmailAddressPolicyConfig.Ensure -eq 'Present')
    {
        if ($Identity -ne 'Default Policy')
        {
            Write-Verbose -Message "Email Address Policy '$($Name)' already exists, but needs updating."
            Write-Verbose -Message "Setting Email Address Policy $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetEmailAddressPolicyParams)"
            Set-EmailAddressPolicy @SetEmailAddressPolicyParams
        }
        else
        {
            Write-Verbose -Message 'Cannot update the Default Email Address Policy.'
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
        [ValidateLength(1, 64)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Priority,

        [Parameter()]
        [System.String[]]
        $EnabledEmailAddressTemplates,

        [Parameter()]
        [System.String[]]
        $EnabledPrimarySMTPAddressTemplate,

        [Parameter()]
        [System.String]
        $ManagedByFilter,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing Email Address Policy configuration for $Name"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

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

    if ($null -eq (Get-Command Get-EmailAddressPolicy -ErrorAction SilentlyContinue))
    {
        Write-Host "`r`n    $($Global:M365DSCEmojiRedX) The specified account doesn't have permissions to access Email Address Policy"
        return ''
    }

    try
    {
        [array]$AllEmailAddressPolicies = Get-EmailAddressPolicy -ErrorAction Stop

        $dscContent = ''
        if ($AllEmailAddressPolicies.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($EmailAddressPolicy in $AllEmailAddressPolicies)
        {
            Write-Host "    |---[$i/$($AllEmailAddressPolicies.Count)] $($EmailAddressPolicy.Name)" -NoNewline

            $Params = @{
                Name                  = $EmailAddressPolicy.Name
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

