Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADAgreement'

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

    Write-Verbose -Message "Getting configuration for the Azure AD Agreement with DisplayName {$DisplayName}"

    try
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
            Ensure      = 'Absent'
        }

        if ($null -ne $Script:exportedInstances -and $Script:exportedInstances.Count -gt 0)
        {
            $instance = $Script:exportedInstances | Where-Object -FilterScript { $_.DisplayName -eq $DisplayName }
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
            DisplayName                       = $instance.DisplayName
            Id                                = $instance.Id
            IsViewingBeforeAcceptanceRequired = $instance.IsViewingBeforeAcceptanceRequired
            IsPerDeviceAcceptanceRequired     = $instance.IsPerDeviceAcceptanceRequired
            UserReacceptRequiredFrequency     = $instance.UserReacceptRequiredFrequency
            AcceptanceStatement               = $instance.AcceptanceStatement
            FileData                          = $fileContent
            FileName                          = $instance.File.Name
            Language                          = $instance.File.Language
            Ensure                            = 'Present'
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            TenantId                          = $TenantId
            ApplicationSecret                 = $ApplicationSecret
            CertificateThumbprint             = $CertificateThumbprint
            ManagedIdentity                   = $ManagedIdentity.IsPresent
            AccessTokens                      = $AccessTokens
        }

        return $results
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

    $currentInstance = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        # Prepare the file content
        $fileContent = @()
        $fileContent += @{
            fileData  = @{
                data = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($FileData))
            }
            fileName  = $FileName
            language  = $Language
            isDefault = $true
        }

        $CreateParameters = @{
            displayName                       = $DisplayName
            isViewingBeforeAcceptanceRequired = $IsViewingBeforeAcceptanceRequired
            isPerDeviceAcceptanceRequired     = $IsPerDeviceAcceptanceRequired
            userReacceptRequiredFrequency     = $UserReacceptRequiredFrequency
            acceptanceStatement               = $AcceptanceStatement
            files                             = $fileContent
        }

        $CreateParameters = Remove-NullEntriesFromHashtable -Hash $CreateParameters
        Write-Verbose -Message "Creating Azure AD Agreement with DisplayName {$DisplayName} with:`r`n$(ConvertTo-Json $CreateParameters -Depth 5)"

        Invoke-MgGraphRequest -Uri '/beta/agreements' -Method POST -Body ($CreateParameters | ConvertTo-Json -Depth 5) | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        # Prepare the file content if provided
        $fileContent = $null
        if (-not [System.String]::IsNullOrEmpty($FileData))
        {
            $fileContent = @()
            $fileContent += @{
                fileData = @{
                    data = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($FileData))
                }
                fileName = $FileName
                language = $Language
            }
        }

        $UpdateParameters = @{
            displayName                       = $DisplayName
            isViewingBeforeAcceptanceRequired = $IsViewingBeforeAcceptanceRequired
            isPerDeviceAcceptanceRequired     = $IsPerDeviceAcceptanceRequired
            userReacceptRequiredFrequency     = $UserReacceptRequiredFrequency
            acceptanceStatement               = $AcceptanceStatement
        }

        if ($null -ne $fileContent)
        {
            $UpdateParameters.files = $fileContent
        }

        $UpdateParameters = Remove-NullEntriesFromHashtable -Hash $UpdateParameters
        Write-Verbose -Message "Updating Azure AD Agreement with ID {$($currentInstance.Id)} with:`r`n$(ConvertTo-Json $UpdateParameters -Depth 5)"
        Invoke-MgGraphRequest -Method PATCH `
            -Uri "/beta/agreements/$($currentInstance.Id)" `
            -Body ($UpdateParameters | ConvertTo-Json -Depth 5) | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Azure AD Agreement with DisplayName {$DisplayName} with ID {$($currentInstance.Id)}"
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
        [System.String]
        $Filter,

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
        [array] $Script:exportedInstances = Get-MgBetaAgreement -Filter $Filter -All

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckmark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
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
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
