Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADActivityBasedTimeoutPolicy'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $AzurePortalTimeOut,

        [Parameter()]
        [System.String]
        $DefaultTimeOut,
        #endregion

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

    Write-Verbose -Message "Getting configuration for Activity Based Timeout Policy '$DisplayName'"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.DisplayName -ne $DisplayName)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

            $nullResult = $PSBoundParameters
            $nullResult.Ensure = 'Absent'

            $getValue = $null
            #region resource generator code
            $getValue = Get-MgBetaPolicyActivityBasedTimeoutPolicy -ErrorAction SilentlyContinue
            #endregion
            if ($null -eq $getValue)
            {
                Write-Verbose -Message "Could not find an Azure AD Activity Based Timeout Policy with DisplayName {$DisplayName}"
                return $nullResult
            }
        }
        else
        {
            $getValue = $Script:exportedInstance
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Activity Based Timeout Policy with Id {$Id} and DisplayName {$DisplayName} was found."

        #Azure portal timeout
        $timeout = $getValue.Definition | ConvertFrom-Json
        $AzurePortalTimeOut = ($timeout.ActivityBasedTimeoutPolicy.ApplicationPolicies | Where-Object { $_.ApplicationId -match 'c44b4083-3bb0-49c1-b47d-974e53cbdf3c' }).WebSessionIdleTimeout
        $DefaultTimeOut = ($timeout.ActivityBasedTimeoutPolicy.ApplicationPolicies | Where-Object { $_.ApplicationId -match 'default' }).WebSessionIdleTimeout

        $results = @{
            #region resource generator code
            DisplayName           = $getValue.displayName
            Id                    = $getValue.Id
            AzurePortalTimeOut    = $AzurePortalTimeOut
            DefaultTimeOut        = $DefaultTimeOut
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
            #endregion
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
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $AzurePortalTimeOut,

        [Parameter()]
        [System.String]
        $DefaultTimeOut,
        #endregion

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

    Write-Verbose -Message "Setting configuration for Activity Based Timeout Policy '$DisplayName'"

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

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $AzurePortalTimeOutexist = $false
    $DefaultTimeOutexistst = $false
    if ($BoundParameters.ContainsKey('AzurePortalTimeOut') `
            -and $null -ne $BoundParameters.AzurePortalTimeOut `
            -and -not [System.String]::IsNullOrEmpty($BoundParameters.AzurePortalTimeOut))
    {
        $AzurePortalTimeOutexist = $true
    }
    if ($BoundParameters.ContainsKey('DefaultTimeOut') `
            -and $null -ne $BoundParameters.DefaultTimeOut `
            -and -not [System.String]::IsNullOrEmpty($BoundParameters.DefaultTimeOut))
    {
        $DefaultTimeOutexistst = $true
    }
    $ApplicationPolicies = @()
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Azure AD Activity Based Timeout Policy with DisplayName {$DisplayName}"
        if ($AzurePortalTimeOutexist)
        {
            $ApplicationPolicies += @{
                ApplicationId         = 'c44b4083-3bb0-49c1-b47d-974e53cbdf3c'
                WebSessionIdleTimeout = "$AzurePortalTimeOut"
            }
        }
        if ($DefaultTimeOutexistst)
        {
            $ApplicationPolicies += @{
                ApplicationId         = 'default'
                WebSessionIdleTimeout = "$DefaultTimeOut"
            }
        }
        if ($null -eq $ApplicationPolicies)
        {
            throw 'At least one of the parameters AzurePortalTimeOut or DefaultTimeOut must be specified'
        }
        elseif ($AzurePortalTimeOutexist -or $DefaultTimeOutexistst)
        {
            $policy = @{
                ActivityBasedTimeoutPolicy = @{
                    Version             = 1
                    ApplicationPolicies = @(
                        $ApplicationPolicies
                    )
                }
            }

            $json = $policy | ConvertTo-Json -Depth 10 -Compress
            $params = @{
                definition            = @(
                    "$json"
                )
                displayName           = $DisplayName
                isOrganizationDefault = $true
            }

            New-MgBetaPolicyActivityBasedTimeoutPolicy -BodyParameter $params
        }
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Creating an Azure AD Activity Based Timeout Policy with DisplayName {$DisplayName}"
        if ($AzurePortalTimeOutexist)
        {
            $ApplicationPolicies += @{
                ApplicationId         = 'c44b4083-3bb0-49c1-b47d-974e53cbdf3c'
                WebSessionIdleTimeout = "$AzurePortalTimeOut"
            }
        }
        if ($DefaultTimeOutexistst)
        {
            $ApplicationPolicies += @{
                ApplicationId         = 'default'
                WebSessionIdleTimeout = "$DefaultTimeOut"
            }
        }
        if ($null -eq $ApplicationPolicies)
        {
            throw 'At least one of the parameters AzurePortalTimeOut or DefaultTimeOut must be specified'
        }
        elseif ($AzurePortalTimeOutexist -or $DefaultTimeOutexistst)
        {
            $policy = @{
                ActivityBasedTimeoutPolicy = @{
                    Version             = 1
                    ApplicationPolicies = @(
                        $ApplicationPolicies
                    )
                }
            }

            $json = $policy | ConvertTo-Json -Depth 10 -Compress
            $params = @{
                definition            = @(
                    "$json"
                )
                displayName           = $DisplayName
                isOrganizationDefault = $true
            }

            Update-MgBetaPolicyActivityBasedTimeoutPolicy -ActivityBasedTimeoutPolicyId $currentInstance.Id -BodyParameter $params
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Activity Based Timeout Policy with Id {$($currentInstance.Id)}"
        Remove-MgBetaPolicyActivityBasedTimeoutPolicy -ActivityBasedTimeoutPolicyId $currentInstance.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $AzurePortalTimeOut,

        [Parameter()]
        [System.String]
        $DefaultTimeOut,
        #endregion

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        #region resource generator code
        [array]$getValue = Get-MgBetaPolicyActivityBasedTimeoutPolicy -Filter $Filter `
            -All `
            -ErrorAction Stop
        #endregion

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.Id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
            $Results = Get-TargetResource @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
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
