function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TermsExpiration,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Files,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Azure AD Agreement with DisplayName {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $nullReturn = @{
        DisplayName = $DisplayName
        Ensure = 'Absent'
    }

    try
    {
        if ($null -ne $Id -and $Id -ne '')
        {
            Write-Verbose -Message "Getting Agreement by Id {$Id}"
            $agreement = Get-MgAgreement -AgreementId $Id -ErrorAction SilentlyContinue
        }
        else
        {
            Write-Verbose -Message "Getting Agreement by DisplayName {$DisplayName}"
            $agreement = Get-MgAgreement -Filter "displayName eq '$DisplayName'" -ErrorAction SilentlyContinue
            if ($agreement.Length -gt 1)
            {
                throw "Multiple agreements found with DisplayName '$DisplayName'. Please specify the Id parameter."
            }
        }

        if ($null -eq $agreement)
        {
            Write-Verbose -Message "Agreement with DisplayName {$DisplayName} was not found"
            return $nullReturn
        }

        Write-Verbose -Message "Found existing Azure AD Agreement"

        # Get the files for the agreement
        $agreementFilesValue = @()
        if ($null -ne $agreement.Files)
        {
            foreach ($file in $agreement.Files)
            {
                $agreementFilesValue += @{
                    Id = $file.Id
                    DisplayName = $file.DisplayName
                    FileName = $file.FileName
                    Language = $file.Language
                    IsDefault = $file.IsDefault
                    IsMajorVersion = $file.IsMajorVersion
                    CreatedDateTime = $file.CreatedDateTime
                    FileData = '' # Don't return file data for security reasons
                }
            }
        }

        # Convert TermsExpiration if it exists
        $termsExpirationValue = $null
        if ($null -ne $agreement.TermsExpiration)
        {
            $termsExpirationValue = @{
                Duration = $agreement.TermsExpiration.Duration
                StartDateTime = $agreement.TermsExpiration.StartDateTime
                Frequency = $agreement.TermsExpiration.Frequency
            }
        }

        $result = @{
            DisplayName = $agreement.DisplayName
            Id = $agreement.Id
            IsPerDeviceAcceptanceRequired = $agreement.IsPerDeviceAcceptanceRequired
            IsViewingBeforeAcceptanceRequired = $agreement.IsViewingBeforeAcceptanceRequired
            TermsExpiration = $termsExpirationValue
            UserReacceptRequiredFrequency = $agreement.UserReacceptRequiredFrequency
            Files = $agreementFilesValue
            Ensure = 'Present'
            Credential = $Credential
            ApplicationId = $ApplicationId
            TenantId = $TenantId
            ApplicationSecret = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity = $ManagedIdentity.IsPresent
            AccessTokens = $AccessTokens
        }

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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TermsExpiration,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Files,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of Azure AD Agreement with DisplayName {$DisplayName}"
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $currentAgreement = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Agreement should exist'

        $CreateParameters = @{
            DisplayName = $DisplayName
        }

        if ($BoundParameters.ContainsKey('IsPerDeviceAcceptanceRequired'))
        {
            $CreateParameters.Add('IsPerDeviceAcceptanceRequired', $IsPerDeviceAcceptanceRequired)
        }

        if ($BoundParameters.ContainsKey('IsViewingBeforeAcceptanceRequired'))
        {
            $CreateParameters.Add('IsViewingBeforeAcceptanceRequired', $IsViewingBeforeAcceptanceRequired)
        }

        if ($null -ne $TermsExpiration)
        {
            $CreateParameters.Add('TermsExpiration', @{
                Duration = $TermsExpiration.Duration
                StartDateTime = $TermsExpiration.StartDateTime
                Frequency = $TermsExpiration.Frequency
            })
        }

        if ($BoundParameters.ContainsKey('UserReacceptRequiredFrequency'))
        {
            $CreateParameters.Add('UserReacceptRequiredFrequency', $UserReacceptRequiredFrequency)
        }

        if ($null -ne $Files -and $Files.Length -gt 0)
        {
            $fileArray = @()
            foreach ($file in $Files)
            {
                $fileObj = @{
                    DisplayName = $file.DisplayName
                    FileName = $file.FileName
                    Language = $file.Language
                    IsDefault = $file.IsDefault
                    IsMajorVersion = $file.IsMajorVersion
                }
                
                if ($null -ne $file.FileData -and $file.FileData -ne '')
                {
                    $fileObj.Add('FileData', $file.FileData)
                }
                
                $fileArray += $fileObj
            }
            $CreateParameters.Add('Files', $fileArray)
        }

        if ($currentAgreement.Ensure -eq 'Present')
        {
            Write-Verbose -Message "Updating existing Agreement with Id {$($currentAgreement.Id)}"
            $CreateParameters.Add('AgreementId', $currentAgreement.Id)
            Update-MgAgreement @CreateParameters
        }
        else
        {
            Write-Verbose -Message 'Creating new Agreement'
            New-MgAgreement @CreateParameters
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentAgreement.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Agreement with Id {$($currentAgreement.Id)}"
        Remove-MgAgreement -AgreementId $currentAgreement.Id
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
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $TermsExpiration,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Files,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

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

    Write-Verbose -Message "Testing configuration of Azure AD Agreement with DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $BoundParameters)"

    $ValuesToCheck = ([Hashtable]$BoundParameters).Clone()

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $BoundParameters `
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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        $agreements = Get-MgAgreement -All -ErrorAction Stop
        $dscContent = ''
        $i = 1

        if ($agreements.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckmark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($agreement in $agreements)
        {
            Write-Host "    |---[$i/$($agreements.Count)] $($agreement.DisplayName)" -NoNewline
            $params = @{
                DisplayName = $agreement.DisplayName
                Id = $agreement.Id
                Credential = $Credential
                ApplicationId = $ApplicationId
                TenantId = $TenantId
                ApplicationSecret = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity = $ManagedIdentity.IsPresent
                AccessTokens = $AccessTokens
            }

            $Results = Get-TargetResource @params
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
            Write-Host $Global:M365DSCEmojiGreenCheckmark
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