Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADPasswordRuleSettings'

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

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $LockoutDurationInSeconds,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheck,

        [Parameter()]
        [System.String[]]
        $BannedPasswordList,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheckOnPremises,

        [Parameter()]
        [ValidateSet('Enforce', 'Audit')]
        [System.String]
        $BannedPasswordCheckOnPremisesMode,

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

    Write-Verbose -Message 'Getting configuration of AzureAD Password Rule Settings'

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

        $nullReturn = $PSBoundParameters
        $nullReturn.Ensure = 'Absent'

        $Policy = Get-MgBetaDirectorySetting -All | Where-Object -FilterScript { $_.DisplayName -eq 'Password Rule Settings' }

        if ($null -eq $Policy)
        {
            return $nullReturn
        }
        else
        {
            Write-Verbose -Message 'Found existing AzureAD DirectorySetting for Password Rule Settings'
            $valueBannedPasswordCheckOnPremisesMode = $Policy.Values | Where-Object -FilterScript { $_.Name -eq 'BannedPasswordCheckOnPremisesMode' }
            $valueEnableBannedPasswordCheckOnPremises = $Policy.Values | Where-Object -FilterScript { $_.Name -eq 'EnableBannedPasswordCheckOnPremises' }
            $valueEnableBannedPasswordCheck = $Policy.Values | Where-Object -FilterScript { $_.Name -eq 'EnableBannedPasswordCheck' }
            $valueLockoutDurationInSeconds = $Policy.Values | Where-Object -FilterScript { $_.Name -eq 'LockoutDurationInSeconds' }
            $valueLockoutThreshold = $Policy.Values | Where-Object -FilterScript { $_.Name -eq 'LockoutThreshold' }
            $valueBannedPasswordList = $Policy.Values | Where-Object -FilterScript { $_.Name -eq 'BannedPasswordList' }

            $result = @{
                IsSingleInstance                    = 'Yes'
                BannedPasswordCheckOnPremisesMode   = $valueBannedPasswordCheckOnPremisesMode.Value
                EnableBannedPasswordCheckOnPremises = [Boolean]::Parse($valueEnableBannedPasswordCheckOnPremises.Value)
                EnableBannedPasswordCheck           = [Boolean]::Parse($valueEnableBannedPasswordCheck.Value)
                LockoutDurationInSeconds            = $valueLockoutDurationInSeconds.Value
                LockoutThreshold                    = $valueLockoutThreshold.Value
                BannedPasswordList                  = $valueBannedPasswordList.Value -split "`t" # list is tab-delimited
                Ensure                              = 'Present'
                ApplicationId                       = $ApplicationId
                TenantId                            = $TenantId
                ApplicationSecret                   = $ApplicationSecret
                CertificateThumbprint               = $CertificateThumbprint
                Credential                          = $Credential
                ManagedIdentity                     = $ManagedIdentity.IsPresent
                AccessTokens                        = $AccessTokens
            }

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

        throw
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

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $LockoutDurationInSeconds,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheck,

        [Parameter()]
        [System.String[]]
        $BannedPasswordList,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheckOnPremises,

        [Parameter()]
        [ValidateSet('Enforce', 'Audit')]
        [System.String]
        $BannedPasswordCheckOnPremisesMode,

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

    Write-Verbose -Message 'Setting configuration of Azure AD Password Rule Settings'

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

    $currentPolicy = Get-TargetResource @PSBoundParameters

    # Policy should exist but it doesn't
    $needToUpdate = $false
    if ($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Absent')
    {
        Write-Verbose "Create new DirectorySetting for 'Password Rule Settings' with default values"
        $template = Get-MgBetaDirectorySettingTemplate -All | Where-Object -FilterScript { $_.Displayname -eq 'Password Rule Settings' }
        # need to build a new array for values since the template-values contain property DefaultValue but Value is required
        $defaultValues = @()
        $template.Values | ForEach-Object {
            $defaultValues += @{
                name  = $_.Name
                value = $_.DefaultValue
            }
        }
        $Policy = New-MgBetaDirectorySetting -TemplateId $template.Id -Values $defaultValues | Out-Null
        $needToUpdate = $true
    }

    $Policy = Get-MgBetaDirectorySetting -All | Where-Object -FilterScript { $_.DisplayName -eq 'Password Rule Settings' }

    if (($Ensure -eq 'Present' -and $currentPolicy.Ensure -eq 'Present') -or $needToUpdate)
    {
        foreach ($property in $Policy.Values)
        {
            if ($property.Name -eq 'LockoutThreshold')
            {
                $entry = $Policy.Values | Where-Object -FilterScript { $_.Name -eq $property.Name }
                $entry.Value = $LockoutThreshold
            }
            elseif ($property.Name -eq 'LockoutDurationInSeconds')
            {
                $entry = $Policy.Values | Where-Object -FilterScript { $_.Name -eq $property.Name }
                $entry.Value = $LockoutDurationInSeconds
            }
            elseif ($property.Value -eq 'EnableBannedPasswordCheck')
            {
                $entry = $Policy.Values | Where-Object -FilterScript { $_.Name -eq $property.Name }
                $entry.Value = [System.Boolean]$EnableBannedPasswordCheck
            }
            elseif ($property.Value -eq 'BannedPasswordList')
            {
                $entry = $Policy.Values | Where-Object -FilterScript { $_.Name -eq $property.Name }
                $entry.Value = $BannedPasswordList -join "`t"
            }
            elseif ($property.Value -eq 'EnableBannedPasswordCheckOnPremises')
            {
                $entry = $Policy.Values | Where-Object -FilterScript { $_.Name -eq $property.Name }
                $entry.Value = [System.Boolean]$EnableBannedPasswordCheckOnPremises
            }
            elseif ($property.Value -eq 'BannedPasswordCheckOnPremisesMode')
            {
                $entry = $Policy.Values | Where-Object -FilterScript { $_.Name -eq $property.Name }
                $entry.Value = $BannedPasswordCheckOnPremisesMode
            }
        }

        Write-Verbose -Message "Updating Policy's Values with $($Policy.Values | Out-String)"
        Update-MgBetaDirectorySetting -DirectorySettingId $Policy.id -Values $Policy.Values | Out-Null
    }
    elseif ($Ensure -eq 'Absent' -and $currentPolicy.Ensure -eq 'Present')
    {
        Write-Verbose -Message "An existing Directory Setting entry exists, and we don't allow to have it removed."
        throw 'The AADPasswordRuleSettings resource cannot delete existing Directory Setting entries. Please specify Present.'
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

        [Parameter()]
        [System.UInt32]
        $LockoutThreshold,

        [Parameter()]
        [System.UInt32]
        $LockoutDurationInSeconds,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheck,

        [Parameter()]
        [System.String[]]
        $BannedPasswordList,

        [Parameter()]
        [System.Boolean]
        $EnableBannedPasswordCheckOnPremises,

        [Parameter()]
        [ValidateSet('Enforce', 'Audit')]
        [System.String]
        $BannedPasswordCheckOnPremisesMode,

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
        if ($null -ne $Global:M365DSCExportResourceInstancesCount)
        {
            $Global:M365DSCExportResourceInstancesCount++
        }

        $Params = @{
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            IsSingleInstance      = 'Yes'
            ApplicationSecret     = $ApplicationSecret
            Credential            = $Credential
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        $dscContent = ''
        $Results = Get-TargetResource @Params
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
