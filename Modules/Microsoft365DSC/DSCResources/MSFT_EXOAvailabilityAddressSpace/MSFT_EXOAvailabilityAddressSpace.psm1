function Get-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Getting configuration of AvailabilityAddressSpace for $($Identity)"
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        try
        {
            $AvailabilityAddressSpaces = Get-AvailabilityAddressSpace -ErrorAction Stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't get AvailabilityAddressSpaces" -Source $MyInvocation.MyCommand.ModuleName
        }

        $AvailabilityAddressSpace = $AvailabilityAddressSpaces | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $AvailabilityAddressSpace)
        {
            Write-Verbose -Message "AvailabilityAddressSpace $($Identity) does not exist."
            return $nullReturn
        }
        else
        {


            if ($Null -eq $AvailabilityAddressSpace.TargetAutodiscoverEpr -or $AvailabilityAddressSpace.TargetAutodiscoverEpr -eq "" )
            {
                $TargetAutodiscoverEpr = ""
            }
            else
            {
                $TargetAutodiscoverEpr = $AvailabilityAddressSpace.TargetAutodiscoverEpr.tostring()
            }

            $result = @{
                Identity              = $Identity
                AccessMethod          = $AvailabilityAddressSpace.AccessMethod
                Credentials           = $AvailabilityAddressSpace.Credentials
                ForestName            = $AvailabilityAddressSpace.ForestName
                TargetAutodiscoverEpr = $TargetAutodiscoverEpr
                Credential            = $Credential
                Ensure                = 'Present'
                ApplicationId         = $ApplicationId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                TenantId              = $TenantId
            }

            Write-Verbose -Message "Found AvailabilityAddressSpace $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullReturn
    }
}

function Set-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Setting configuration of AvailabilityAddressSpace for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    try
    {
        $AvailabilityAddressSpaces = Get-AvailabilityAddressSpace -ea stop
    }
    catch
    {
        New-M365DSCLogEntry -Error $_ -Message "Couldn't get AvailabilityAddressSpaces" -Source $MyInvocation.MyCommand.ModuleName
    }

    $AvailabilityAddressSpace = $AvailabilityAddressSpaces | Where-Object -FilterScript { $_.Identity -eq $Identity }
    $AvailabilityAddressSpaceParams = [System.Collections.Hashtable]($PSBoundParameters)
    $AvailabilityAddressSpaceParams.Remove('Ensure') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('Credential') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('ApplicationId') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('TenantId') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('CertificateThumbprint') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('CertificatePath') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('CertificatePassword') | Out-Null

    if (('Present' -eq $Ensure ) -and ($null -eq $AvailabilityAddressSpace))
    {
        Write-Verbose -Message "Creating AvailabilityAddressSpace $($Identity)."
        # AvailabilityAddressSpace doe not have a new-AvailabilityAddressSpace cmdlet but instead uses an add-AvailabilityAddressSpace cmdlet
        try
        {
            add-AvailabilityAddressSpace @AvailabilityAddressSpaceParams -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't add new AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif (('Present' -eq $Ensure ) -and ($Null -ne $AvailabilityAddressSpace))
    {
        Write-Verbose -Message "Setting AvailabilityAddressSpace $($Identity) with values: $(Convert-M365DscHashtableToString -Hashtable $AvailabilityAddressSpaceParams)"
        # AvailabilityAddressSpace is a special case in that it does not have a "set-AvailabilityAddressSpace" cmdlet. To change values of an existing AvailabilityAddressSpace it must be removed and then added again with add-AvailabilityAddressSpace
        try
        {
            Remove-AvailabilityAddressSpace -identity $Identity -Confirm:$false -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't remove AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }

        try
        {
            add-AvailabilityAddressSpace @AvailabilityAddressSpaceParams -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't add new AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
    elseif (('Absent' -eq $Ensure ) -and ($null -ne $AvailabilityAddressSpace))
    {
        Write-Verbose -Message "Removing AvailabilityAddressSpace $($Identity)"
        try
        {
            Remove-AvailabilityAddressSpace -identity $Identity -Confirm:$false -ea stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't remove AvailabilityAddressSpace" -Source $MyInvocation.MyCommand.ModuleName
        }
    }
}
function Test-TargetResource
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingPlainTextForPassword", "")]
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [ValidateSet('PerUserFB', 'OrgWideFB', 'OrgWideFBBasic', 'InternalProxy')]
        [System.String]
        $AccessMethod,

        [Parameter()]
        [System.String]
        $Credentials,

        [Parameter()]
        [System.String]
        $ForestName,

        [Parameter()]
        [System.String]
        $TargetAutodiscoverEpr,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

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
        $CertificatePassword
    )
    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of AvailabilityAddressSpace for $($Identity)"

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
        $CertificatePassword
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace "MSFT_", ""
    $CommandName  = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        if ($null -eq (Get-Command Get-AvailabilityAddressSpace -ErrorAction SilentlyContinue))
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiRedX) The specified account doesn't have permissions to access Availibility Address Space"
            return ""
        }
        try
        {
            [array]$AvailabilityAddressSpaces = Get-AvailabilityAddressSpace -ErrorAction stop
        }
        catch
        {
            New-M365DSCLogEntry -Error $_ -Message "Couldn't get AvailabilityAddressSpaces" -Source $MyInvocation.MyCommand.ModuleName
        }

        $dscContent = ""
        if ($AvailabilityAddressSpaces.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        $i = 1
        foreach ($AvailabilityAddressSpace in $AvailabilityAddressSpaces)
        {
            Write-Host "    |---[$i/$($AvailabilityAddressSpaces.length)] $($AvailabilityAddressSpace.Identity)" -NoNewline

            $Params = @{
                Identity              = $AvailabilityAddressSpace.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
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
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ""
    }
}
Export-ModuleMember -Function *-TargetResource
