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
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Getting configuration of AvailabilityAddressSpace for $($Identity)"

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
            -InboundParameters $PSBoundParameters
    }
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
                GlobalAdminAccount    = $GlobalAdminAccount
                Ensure                = 'Present'
            }

            Write-Verbose -Message "Found AvailabilityAddressSpace $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
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
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Setting configuration of AvailabilityAddressSpace for $($Identity)"

    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
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
    $AvailabilityAddressSpaceParams = $PSBoundParameters
    $AvailabilityAddressSpaceParams.Remove('Ensure') | Out-Null
    $AvailabilityAddressSpaceParams.Remove('GlobalAdminAccount') | Out-Null

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
        $GlobalAdminAccount,

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

    Write-Verbose -Message "Testing configuration of AvailabilityAddressSpace for $($Identity)"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

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
        $GlobalAdminAccount,

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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
            Write-Host "`r`n" -NoNewLine
        }
        $i = 1
        foreach ($AvailabilityAddressSpace in $AvailabilityAddressSpaces)
        {
            Write-Host "    |---[$i/$($AvailabilityAddressSpaces.length)] $($AvailabilityAddressSpace.Identity)" -NoNewLine

            $Params = @{
                Identity              = $AvailabilityAddressSpace.Identity
                GlobalAdminAccount    = $GlobalAdminAccount
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
            }
            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results
            $dscContent += Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -GlobalAdminAccount $GlobalAdminAccount
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            $i++
        }
        return $dscContent
    }
    catch
    {
        Write-Verbose -Message $_
        Add-M365DSCEvent -Message $_ -EntryType 'Error' `
            -EventID 1 -Source $($MyInvocation.MyCommand.Source)
        return ""
    }
}
Export-ModuleMember -Function *-TargetResource
