function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

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

    Write-Verbose -Message "Getting Partner Application configuration for $Name"
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
        $AllPartnerApplications = Get-PartnerApplication -ErrorAction Stop

        $PartnerApplication = $AllPartnerApplications | Where-Object -FilterScript { $_.Name -eq $Name }

        if ($null -eq $PartnerApplication)
        {
            Write-Verbose -Message "Partner Application $($Name) does not exist."
            return $nullReturn
        }
        else
        {
            $result = @{
                Name                                = $PartnerApplication.Name
                ApplicationIdentifier               = $PartnerApplication.ApplicationIdentifier
                AcceptSecurityIdentifierInformation = $PartnerApplication.AcceptSecurityIdentifierInformation
                AccountType                         = $PartnerApplication.AccountType
                Enabled                             = $PartnerApplication.Enabled
                LinkedAccount                       = $PartnerApplication.LinkedAccount
                Ensure                              = 'Present'
                Credential                          = $Credential
                ApplicationId                       = $ApplicationId
                CertificateThumbprint               = $CertificateThumbprint
                CertificatePath                     = $CertificatePath
                CertificatePassword                 = $CertificatePassword
                Managedidentity                     = $ManagedIdentity.IsPresent
                TenantId                            = $TenantId
                AccessTokens                        = $AccessTokens
            }

            Write-Verbose -Message "Found Partner Application $($Name)"
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
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

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

    Write-Verbose -Message "Setting Partner Application configuration for $Name"

    $currentPartnerApplicationConfig = Get-TargetResource @PSBoundParameters

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

    $NewPartnerApplicationParams = @{
        Name                                = $Name
        ApplicationIdentifier               = $ApplicationIdentifier
        AcceptSecurityIdentifierInformation = $AcceptSecurityIdentifierInformation
        Enabled                             = $Enabled
        Confirm                             = $false
    }

    $SetPartnerApplicationParams = @{
        Identity                            = $Name
        Name                                = $Name
        ApplicationIdentifier               = $ApplicationIdentifier
        AcceptSecurityIdentifierInformation = $AcceptSecurityIdentifierInformation
        Enabled                             = $Enabled
        Confirm                             = $false
    }

    if (-not [System.String]::IsNullOrEmpty($AccountType))
    {
        $NewPartnerApplicationParams.Add('AccountType', $AccountType)
        $SetPartnerApplicationParams.Add('AccountType', $AccountType)
    }

    if (-not [System.String]::IsNullOrEmpty($LinkedAccount))
    {
        $NewPartnerApplicationParams.Add('LinkedAccount', $LinkedAccount)
        $SetPartnerApplicationParams.Add('LinkedAccount', $LinkedAccount)
    }

    # CASE: Partner Application doesn't exist but should;
    if ($Ensure -eq 'Present' -and $currentPartnerApplicationConfig.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Partner Application '$($Name)' does not exist but it should. Create and configure it."
        # Create Partner Application
        New-PartnerApplication @NewPartnerApplicationParams

    }
    # CASE: Partner Application exists but it shouldn't;
    elseif ($Ensure -eq 'Absent' -and $currentPartnerApplicationConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Partner Application '$($Name)' exists but it shouldn't. Remove it."
        Remove-PartnerApplication -Identity $Name -Confirm:$false
    }
    # CASE: Partner Application exists and it should, but has different values than the desired ones
    elseif ($Ensure -eq 'Present' -and $currentPartnerApplicationConfig.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Partner Application '$($Name)' already exists, but needs updating."
        Write-Verbose -Message "Setting Partner Application $($Name) with values: $(Convert-M365DscHashtableToString -Hashtable $SetPartnerApplicationParams)"
        Set-PartnerApplication @SetPartnerApplicationParams
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
        $Name,

        [Parameter()]
        [System.String]
        $ApplicationIdentifier,

        [Parameter()]
        [System.Boolean]
        $AcceptSecurityIdentifierInformation,

        [Parameter()]
        [ValidateSet('OrganizationalAccount', 'ConsumerAccount')]
        [System.String]
        $AccountType,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String]
        $LinkedAccount,

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

    Write-Verbose -Message "Testing Partner Application configuration for $Name"

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

    try
    {
        [array]$AllPartnerApplications = Get-PartnerApplication -ErrorAction Stop

        $dscContent = ''
        if ($AllPartnerApplications.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($PartnerApplication in $AllPartnerApplications)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($AllPartnerApplications.Length)] $($PartnerApplication.Name)" -NoNewline

            $Params = @{
                Name                  = $PartnerApplication.Name
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

