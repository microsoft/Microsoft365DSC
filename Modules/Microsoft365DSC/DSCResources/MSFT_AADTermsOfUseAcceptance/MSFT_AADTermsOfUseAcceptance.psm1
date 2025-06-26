function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AgreementId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UserId,

        [Parameter()]
        [System.String]
        $AgreementFileId,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $UserDisplayName,

        [Parameter()]
        [System.String]
        $UserEmail,

        [Parameter()]
        [System.String]
        $RecordedDateTime,

        [Parameter()]
        [System.String]
        $ExpirationDateTime,

        [Parameter()]
        [ValidateSet('accepted', 'declined')]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $DeviceId,

        [Parameter()]
        [System.String]
        $DeviceDisplayName,

        [Parameter()]
        [System.String]
        $DeviceOSType,

        [Parameter()]
        [System.String]
        $DeviceOSVersion,

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

    try
    {
        New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters | Out-Null

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
        $CommandName = $MyInvocation.MyCommand
        $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
            -CommandName $CommandName `
            -Parameters $PSBoundParameters
        Add-M365DSCTelemetryEvent -Data $data
        #endregion

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        # Get all agreement acceptances for the specified agreement
        $agreementAcceptances = Get-MgAgreementAcceptance -AgreementId $AgreementId -All -ErrorAction SilentlyContinue

        # Find the specific acceptance for the user
        $instance = $agreementAcceptances | Where-Object { $_.UserId -eq $UserId }

        if ($null -eq $instance)
        {
            return $nullResult
        }

        Write-Verbose -Message "Found Terms of Use acceptance for Agreement {$AgreementId} and User {$UserId}"

        $results = @{
            AgreementId         = $instance.AgreementId
            UserId              = $instance.UserId
            AgreementFileId     = $instance.AgreementFileId
            UserPrincipalName   = $instance.UserPrincipalName
            UserDisplayName     = $instance.UserDisplayName
            UserEmail           = $instance.UserEmail
            RecordedDateTime    = if ($instance.RecordedDateTime) { $instance.RecordedDateTime.ToString('yyyy-MM-ddTHH:mm:ss.fffZ') } else { $null }
            ExpirationDateTime  = if ($instance.ExpirationDateTime) { $instance.ExpirationDateTime.ToString('yyyy-MM-ddTHH:mm:ss.fffZ') } else { $null }
            State               = $instance.State
            DeviceId            = $instance.DeviceId
            DeviceDisplayName   = $instance.DeviceDisplayName
            DeviceOSType        = $instance.DeviceOSType
            DeviceOSVersion     = $instance.DeviceOSVersion
            Ensure              = 'Present'
            Credential          = $Credential
            ApplicationId       = $ApplicationId
            TenantId            = $TenantId
            ApplicationSecret   = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity     = $ManagedIdentity.IsPresent
            AccessTokens        = $AccessTokens
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
        $AgreementId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UserId,

        [Parameter()]
        [System.String]
        $AgreementFileId,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $UserDisplayName,

        [Parameter()]
        [System.String]
        $UserEmail,

        [Parameter()]
        [System.String]
        $RecordedDateTime,

        [Parameter()]
        [System.String]
        $ExpirationDateTime,

        [Parameter()]
        [ValidateSet('accepted', 'declined')]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $DeviceId,

        [Parameter()]
        [System.String]
        $DeviceDisplayName,

        [Parameter()]
        [System.String]
        $DeviceOSType,

        [Parameter()]
        [System.String]
        $DeviceOSVersion,

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

    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParams = ([Hashtable]$PSBoundParameters).Clone()
    $setParams = Remove-M365DSCAuthenticationParameter -BoundParameters $setParams

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating Terms of Use acceptance for Agreement {$AgreementId} and User {$UserId}"

        $createParams = @{
            AgreementId = $AgreementId
        }

        $bodyParams = @{
            UserId = $UserId
        }

        if ($PSBoundParameters.ContainsKey('AgreementFileId'))
        {
            $bodyParams.AgreementFileId = $AgreementFileId
        }
        if ($PSBoundParameters.ContainsKey('UserPrincipalName'))
        {
            $bodyParams.UserPrincipalName = $UserPrincipalName
        }
        if ($PSBoundParameters.ContainsKey('UserDisplayName'))
        {
            $bodyParams.UserDisplayName = $UserDisplayName
        }
        if ($PSBoundParameters.ContainsKey('UserEmail'))
        {
            $bodyParams.UserEmail = $UserEmail
        }
        if ($PSBoundParameters.ContainsKey('RecordedDateTime'))
        {
            $bodyParams.RecordedDateTime = [DateTime]::Parse($RecordedDateTime)
        }
        if ($PSBoundParameters.ContainsKey('ExpirationDateTime'))
        {
            $bodyParams.ExpirationDateTime = [DateTime]::Parse($ExpirationDateTime)
        }
        if ($PSBoundParameters.ContainsKey('State'))
        {
            $bodyParams.State = $State
        }
        if ($PSBoundParameters.ContainsKey('DeviceId'))
        {
            $bodyParams.DeviceId = $DeviceId
        }
        if ($PSBoundParameters.ContainsKey('DeviceDisplayName'))
        {
            $bodyParams.DeviceDisplayName = $DeviceDisplayName
        }
        if ($PSBoundParameters.ContainsKey('DeviceOSType'))
        {
            $bodyParams.DeviceOSType = $DeviceOSType
        }
        if ($PSBoundParameters.ContainsKey('DeviceOSVersion'))
        {
            $bodyParams.DeviceOSVersion = $DeviceOSVersion
        }

        New-MgAgreementAcceptance @createParams -BodyParameter $bodyParams | Out-Null
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating Terms of Use acceptance for Agreement {$AgreementId} and User {$UserId}"

        # Get the acceptance ID for updating
        $agreementAcceptances = Get-MgAgreementAcceptance -AgreementId $AgreementId -All
        $instance = $agreementAcceptances | Where-Object { $_.UserId -eq $UserId }
        
        if ($instance)
        {
            $updateParams = @{
                AgreementId = $AgreementId
                AgreementAcceptanceId = $instance.Id
            }

            $bodyParams = @{}

            if ($PSBoundParameters.ContainsKey('AgreementFileId') -and $AgreementFileId -ne $currentInstance.AgreementFileId)
            {
                $bodyParams.AgreementFileId = $AgreementFileId
            }
            if ($PSBoundParameters.ContainsKey('UserPrincipalName') -and $UserPrincipalName -ne $currentInstance.UserPrincipalName)
            {
                $bodyParams.UserPrincipalName = $UserPrincipalName
            }
            if ($PSBoundParameters.ContainsKey('UserDisplayName') -and $UserDisplayName -ne $currentInstance.UserDisplayName)
            {
                $bodyParams.UserDisplayName = $UserDisplayName
            }
            if ($PSBoundParameters.ContainsKey('UserEmail') -and $UserEmail -ne $currentInstance.UserEmail)
            {
                $bodyParams.UserEmail = $UserEmail
            }
            if ($PSBoundParameters.ContainsKey('ExpirationDateTime') -and $ExpirationDateTime -ne $currentInstance.ExpirationDateTime)
            {
                $bodyParams.ExpirationDateTime = [DateTime]::Parse($ExpirationDateTime)
            }
            if ($PSBoundParameters.ContainsKey('State') -and $State -ne $currentInstance.State)
            {
                $bodyParams.State = $State
            }
            if ($PSBoundParameters.ContainsKey('DeviceId') -and $DeviceId -ne $currentInstance.DeviceId)
            {
                $bodyParams.DeviceId = $DeviceId
            }
            if ($PSBoundParameters.ContainsKey('DeviceDisplayName') -and $DeviceDisplayName -ne $currentInstance.DeviceDisplayName)
            {
                $bodyParams.DeviceDisplayName = $DeviceDisplayName
            }
            if ($PSBoundParameters.ContainsKey('DeviceOSType') -and $DeviceOSType -ne $currentInstance.DeviceOSType)
            {
                $bodyParams.DeviceOSType = $DeviceOSType
            }
            if ($PSBoundParameters.ContainsKey('DeviceOSVersion') -and $DeviceOSVersion -ne $currentInstance.DeviceOSVersion)
            {
                $bodyParams.DeviceOSVersion = $DeviceOSVersion
            }

            if ($bodyParams.Count -gt 0)
            {
                Update-MgAgreementAcceptance @updateParams -BodyParameter $bodyParams | Out-Null
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Terms of Use acceptance for Agreement {$AgreementId} and User {$UserId}"

        # Get the acceptance ID for removal
        $agreementAcceptances = Get-MgAgreementAcceptance -AgreementId $AgreementId -All
        $instance = $agreementAcceptances | Where-Object { $_.UserId -eq $UserId }
        
        if ($instance)
        {
            Remove-MgAgreementAcceptance -AgreementId $AgreementId -AgreementAcceptanceId $instance.Id | Out-Null
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
        [System.String]
        $AgreementId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $UserId,

        [Parameter()]
        [System.String]
        $AgreementFileId,

        [Parameter()]
        [System.String]
        $UserPrincipalName,

        [Parameter()]
        [System.String]
        $UserDisplayName,

        [Parameter()]
        [System.String]
        $UserEmail,

        [Parameter()]
        [System.String]
        $RecordedDateTime,

        [Parameter()]
        [System.String]
        $ExpirationDateTime,

        [Parameter()]
        [ValidateSet('accepted', 'declined')]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $DeviceId,

        [Parameter()]
        [System.String]
        $DeviceDisplayName,

        [Parameter()]
        [System.String]
        $DeviceOSType,

        [Parameter()]
        [System.String]
        $DeviceOSVersion,

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of Terms of Use acceptance for Agreement {$AgreementId} and User {$UserId}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array] $agreements = Get-MgAgreement -All

        $i = 1
        $dscContent = ''
        if ($agreements.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        foreach ($agreement in $agreements)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($agreements.Count)] $($agreement.DisplayName)" -NoNewline

            try
            {
                [array] $acceptances = Get-MgAgreementAcceptance -AgreementId $agreement.Id -All -ErrorAction SilentlyContinue
            }
            catch
            {
                Write-Host $Global:M365DSCEmojiRedX
                $acceptances = @()
            }

            $j = 1
            foreach ($acceptance in $acceptances)
            {
                Write-Host "        |---[$j/$($acceptances.Count)] User: $($acceptance.UserPrincipalName)" -NoNewline

                $params = @{
                    AgreementId           = $agreement.Id
                    UserId                = $acceptance.UserId
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    ApplicationSecret     = $ApplicationSecret
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Results = Get-TargetResource @params

                if ($Results.Ensure -eq 'Present')
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
                }

                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $j++
            }
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

        return ""
    }
}

Export-ModuleMember -Function *-TargetResource