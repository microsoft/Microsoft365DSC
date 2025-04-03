function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnforceSignatureCheck,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $RunAs32Bit,

        [Parameter()]
        [ValidateSet('system', 'user')]
        [System.String]
        $RunAsAccount,

        [Parameter()]
        [System.String]
        $DetectionScriptContent,

        [Parameter()]
        [System.String]
        $Id,
        #endregion

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

    Write-Verbose -Message "Getting configuration of the Intune Device Compliance Script for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        #region resource generator code
        $getValue = Invoke-MgGraphRequest -Method GET -Uri "/beta/deviceManagement/deviceComplianceScripts/$Id" -SkipHttpErrorCheck

        if ($null -eq $getValue -or $null -ne $getValue.error)
        {
            Write-Verbose -Message "Could not find an Intune Device Compliance Script for Windows10 with Id {$Id}"

            if (-not [string]::IsNullOrEmpty($DisplayName))
            {
                $getValue = (Invoke-MgGraphRequest -Method GET `
                    -Uri "/beta/deviceManagement/deviceComplianceScripts?`$filter=displayName eq '$DisplayName'").value
                if ($getValue.Count -gt 0)
                {
                    $getValue = Invoke-MgGraphRequest -Method GET -Uri "/beta/deviceManagement/deviceComplianceScripts/$($getValue.id)"
                }
            }
        }
        #endregion
        if ($getValue.Count -eq 0)
        {
            Write-Verbose -Message "Could not find an Intune Device Compliance Script for Windows10 with DisplayName {$DisplayName}"
            return $nullResult
        }
        $Id = $getValue.Id

        Write-Verbose -Message "An Intune Device Compliance Script for Windows10 with Id {$Id} and DisplayName {$DisplayName} was found."

        #region resource generator code
        $enumRunAsAccount = $null
        if ($null -ne $getValue.RunAsAccount)
        {
            $enumRunAsAccount = $getValue.RunAsAccount.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            Description            = $getValue.Description
            DisplayName            = $getValue.DisplayName
            EnforceSignatureCheck  = $getValue.EnforceSignatureCheck
            RoleScopeTagIds        = $getValue.RoleScopeTagIds
            RunAs32Bit             = $getValue.RunAs32Bit
            RunAsAccount           = $enumRunAsAccount
            DetectionScriptContent = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($getValue.DetectionScriptContent))
            Publisher              = $getValue.Publisher
            Id                     = $getValue.Id
            Ensure                 = 'Present'
            Credential             = $Credential
            ApplicationId          = $ApplicationId
            TenantId               = $TenantId
            ApplicationSecret      = $ApplicationSecret
            CertificateThumbprint  = $CertificateThumbprint
            ManagedIdentity        = $ManagedIdentity.IsPresent
            AccessTokens           = $AccessTokens
            #endregion
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

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnforceSignatureCheck,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $RunAs32Bit,

        [Parameter()]
        [ValidateSet('system', 'user')]
        [System.String]
        $RunAsAccount,

        [Parameter()]
        [System.String]
        $DetectionScriptContent,

        [Parameter()]
        [System.String]
        $Id,
        #endregion

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $BoundParameters.DetectionScriptContent = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($BoundParameters.DetectionScriptContent))

    # Convert all keys to camelCase
    $scriptBody = @{}
    foreach ($key in $BoundParameters.Keys)
    {
        $camelCaseKey = $key.Substring(0, 1).ToLower() + $key.Substring(1)
        $scriptBody[$camelCaseKey] = $BoundParameters[$key]
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Intune Device Compliance Script for Windows10 with DisplayName {$DisplayName}"
        $scriptBody.Remove('Id') | Out-Null
        Invoke-MgGraphRequest -Method POST -Uri '/beta/deviceManagement/deviceComplianceScripts' -Body $($scriptBody | ConvertTo-Json)
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Intune Device Compliance Script for Windows10 with Id {$($currentInstance.Id)}"
        Invoke-MgGraphRequest -Method PATCH -Uri "/beta/deviceManagement/deviceComplianceScripts/$($currentInstance.Id)" -Body $($scriptBody | ConvertTo-Json)
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Intune Device Compliance Script for Windows10 with Id {$($currentInstance.Id)}"
        try
        {
            Invoke-MgGraphRequest -Method DELETE -Uri "/beta/deviceManagement/deviceComplianceScripts/$($currentInstance.Id)" -ErrorAction Stop
        }
        catch
        {
            throw "Failed to delete Intune Device Compliance Script for Windows10 with Id $($currentInstance.Id). Error: $($_.ErrorDetails.Message)"
        }
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Description,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $EnforceSignatureCheck,

        [Parameter()]
        [System.String]
        $Publisher,

        [Parameter()]
        [System.String[]]
        $RoleScopeTagIds,

        [Parameter()]
        [System.Boolean]
        $RunAs32Bit,

        [Parameter()]
        [ValidateSet('system', 'user')]
        [System.String]
        $RunAsAccount,

        [Parameter()]
        [System.String]
        $DetectionScriptContent,

        [Parameter()]
        [System.String]
        $Id,
        #endregion

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
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of the Intune Device Compliance Script for Windows10 with Id {$Id} and DisplayName {$DisplayName}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()
    $testResult = $true

    $ValuesToCheck.Remove('Id') | Out-Null
    $ValuesToCheck = Remove-M365DSCAuthenticationParameter -BoundParameters $ValuesToCheck

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
    }

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
        $uri = if ([string]::IsNullOrEmpty($Filter)) { '/beta/deviceManagement/deviceComplianceScripts' } else { "/beta/deviceManagement/deviceComplianceScripts?`$filter=$Filter" }
        [array]$getValue = (Invoke-MgGraphRequest `
            -Method GET `
            -Uri $uri `
            -ErrorAction Stop).value
        #endregion

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark
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
                Id                    = $config.Id
                DisplayName           = $config.DisplayName
                Ensure                = 'Present'
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
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
