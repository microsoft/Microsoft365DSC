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
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

        [Parameter()]
        [System.String]
        $AcceptanceStatement,

        [Parameter()]
        [System.String]
        $FileData,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Getting configuration for the Azure AD Agreement with DisplayName {$DisplayName}"

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

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
        Ensure      = 'Absent'
    }

    try
    {
        if ($null -ne $Script:exportedInstances -and $Script:exportedInstances.Count -gt 0)
        {
            $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.DisplayName -eq $DisplayName}
        }
        else
        {
            $instance = Get-MgBetaAgreement -Filter "displayName eq '$($DisplayName.Replace("'", "''"))'" -ErrorAction SilentlyContinue
        }

        if ($null -eq $instance)
        {
            Write-Verbose -Message "Could not find Azure AD Agreement with DisplayName {$DisplayName}"
            return $nullReturn
        }

        # Get the file data
        $fileContent = $null
        if ($null -ne $instance.File -and $null -ne $instance.File.Data)
        {
            $fileContent = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($instance.File.Data))
        }

        $results = @{
            DisplayName                          = $instance.DisplayName
            Id                                   = $instance.Id
            IsViewingBeforeAcceptanceRequired    = $instance.IsViewingBeforeAcceptanceRequired
            IsPerDeviceAcceptanceRequired        = $instance.IsPerDeviceAcceptanceRequired
            UserReacceptRequiredFrequency        = $instance.UserReacceptRequiredFrequency
            AcceptanceStatement                  = $instance.AcceptanceStatement
            FileData                             = $fileContent
            FileName                             = $instance.File.Name
            Language                             = $instance.File.Language
            Ensure                               = 'Present'
            Credential                           = $Credential
            ApplicationId                        = $ApplicationId
            TenantId                             = $TenantId
            ApplicationSecret                    = $ApplicationSecret
            CertificateThumbprint                = $CertificateThumbprint
            ManagedIdentity                      = $ManagedIdentity.IsPresent
            AccessTokens                         = $AccessTokens
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
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

        [Parameter()]
        [System.String]
        $AcceptanceStatement,

        [Parameter()]
        [System.String]
        $FileData,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Setting configuration for the Azure AD Agreement with DisplayName {$DisplayName}"

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

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

    $currentInstance = Get-TargetResource @PSBoundParameters

    Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters | Out-Null

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating Azure AD Agreement with DisplayName {$DisplayName}"

        # Prepare the file content
        $fileContent = @{
            data     = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($FileData))
            name     = $FileName
            language = $Language
        }

        $CreateParameters = @{
            displayName                        = $DisplayName
            isViewingBeforeAcceptanceRequired  = $IsViewingBeforeAcceptanceRequired
            isPerDeviceAcceptanceRequired      = $IsPerDeviceAcceptanceRequired
            userReacceptRequiredFrequency      = $UserReacceptRequiredFrequency
            acceptanceStatement                = $AcceptanceStatement
            file                               = $fileContent
        }

        $CreateParameters = Remove-NullEntriesFromHashtable -Hash $CreateParameters

        New-MgBetaAgreement -BodyParameter $CreateParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Azure AD Agreement with DisplayName {$DisplayName}"

        # Prepare the file content if provided
        $fileContent = $null
        if (-not [System.String]::IsNullOrEmpty($FileData))
        {
            $fileContent = @{
                data     = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($FileData))
                name     = $FileName
                language = $Language
            }
        }

        $UpdateParameters = @{
            displayName                        = $DisplayName
            isViewingBeforeAcceptanceRequired  = $IsViewingBeforeAcceptanceRequired
            isPerDeviceAcceptanceRequired      = $IsPerDeviceAcceptanceRequired
            userReacceptRequiredFrequency      = $UserReacceptRequiredFrequency
            acceptanceStatement                = $AcceptanceStatement
        }

        if ($null -ne $fileContent)
        {
            $UpdateParameters.file = $fileContent
        }

        $UpdateParameters = Remove-NullEntriesFromHashtable -Hash $UpdateParameters

        Update-MgBetaAgreement -AgreementId $currentInstance.Id -BodyParameter $UpdateParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Azure AD Agreement with DisplayName {$DisplayName}"
        Remove-MgBetaAgreement -AgreementId $currentInstance.Id
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
        $IsViewingBeforeAcceptanceRequired,

        [Parameter()]
        [System.Boolean]
        $IsPerDeviceAcceptanceRequired,

        [Parameter()]
        [System.String]
        $UserReacceptRequiredFrequency,

        [Parameter()]
        [System.String]
        $AcceptanceStatement,

        [Parameter()]
        [System.String]
        $FileData,

        [Parameter()]
        [System.String]
        $FileName,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    Write-Verbose -Message "Testing configuration for the Azure AD Agreement with DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if ($CurrentValues.Ensure -ne $Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgBetaAgreement -All

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiYellowCircle
        }
        else
        {
            Write-M365DSCHost -Message "Found $($Script:exportedInstances.Count) Azure AD Agreement(s)"
        }

        foreach ($config in $Script:exportedInstances)
        {
            $displayedKey = $config.DisplayName
            Write-M365DSCHost -Message "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -DeferWrite

            $params = @{
                DisplayName           = $config.DisplayName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            $dscContent += $currentDSCBlock
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark
        }
        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource