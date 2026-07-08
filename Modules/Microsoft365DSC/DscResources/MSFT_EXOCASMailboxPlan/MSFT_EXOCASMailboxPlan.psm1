Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOCASMailboxPlan'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Getting configuration of CASMailboxPlan for $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $nullResult = @{
                Identity = $Identity
                Ensure   = 'Absent'
            }

            $CASMailboxPlan = Invoke-M365DSCCommand -ScriptBlock { Get-CASMailboxPlan -Identity $Identity } -SuppressNotFoundError
            if ($null -eq $MailboxPlan)
            {
                Write-Verbose -Message "MailboxPlan $($Identity) does not exist."

                # Try and retrieve by Display Name
                if (-not [System.String]::IsNullOrEmpty($DisplayName))
                {
                    $CASMailboxPlan = Invoke-M365DSCCommand -ScriptBlock { Get-CASMailboxPlan -Filter "DisplayName -eq '$DisplayName'" }
                }

                if ($null -eq $MailboxPlan)
                {
                    $CASMailboxPlan = Invoke-M365DSCCommand -ScriptBlock { Get-CASMailboxPlan -Filter "Name -like '$($Identity.Split('-')[0])-*'" }
                    if ($null -eq $CASMailboxPlan)
                    {
                        Write-Verbose -Message "CASMailboxPlan $($Identity) does not exist."
                        return $nullResult
                    }
                }
            }
        }
        else
        {
            $CASMailboxPlan = $Script:exportedInstance
        }

        Write-Verbose -Message "Found CASMailboxPlan $($Identity)"

        $result = @{
            Ensure                = 'Present'
            Identity              = $CASMailboxPlan.Identity
            DisplayName           = $CASMailboxPlan.DisplayName
            ActiveSyncEnabled     = $CASMailboxPlan.ActiveSyncEnabled
            ImapEnabled           = $CASMailboxPlan.ImapEnabled
            OwaMailboxPolicy      = $CASMailboxPlan.OwaMailboxPolicy
            PopEnabled            = $CASMailboxPlan.PopEnabled
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
            TenantId              = $TenantId
            AccessTokens          = $AccessTokens
        }

        return $result
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
        $Identity,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
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

    Write-Verbose -Message "Setting configuration of CASMailboxPlan for $Identity"

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

    $updateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $updateParameters.Remove('DisplayName') | Out-Null

    if ($null -eq $currentInstance -or $currentInstance.Ensure -eq 'Absent')
    {
        throw "The specified CAS Mailbox Plan {$($Identity)} doesn't exist"
    }

    $updateParameters.Identity = $currentInstance.Identity
    Write-Verbose -Message "Setting CASMailboxPlan $Identity with values: $(Convert-M365DscHashtableToString -Hashtable $updateParameters)"
    Invoke-M365DSCCommand -ScriptBlock { Set-CASMailboxPlan @updateParameters }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Boolean]
        $ActiveSyncEnabled = $true,

        [Parameter()]
        [Boolean]
        $ImapEnabled = $false,

        [Parameter()]
        [System.String]
        $OwaMailboxPolicy = 'OwaMailboxPolicy-Default',

        [Parameter()]
        [Boolean]
        $PopEnabled = $true,

        [Parameter()]
        [ValidateSet('Present')]
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
        [array]$CASMailboxPlans = Get-CASMailboxPlan -ErrorAction Stop

        if ($CASMailboxPlans.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        foreach ($CASMailboxPlan in $CASMailboxPlans)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($CASMailboxPlans.Count)] $($CASMailboxPlan.Identity.Split('-')[0])" -DeferWrite
            $Params = @{
                Identity              = $CASMailboxPlan.Identity
                DisplayName           = $CASMailboxPlan.DisplayName
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Script:exportedInstance = $CASMailboxPlan
            $Results = Get-TargetResource @Params
            if ($Results -is [System.Collections.Hashtable] -and $Results.Count -gt 1)
            {
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                [void]$dscContent.Append($currentDSCBlock)

                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite
            }

            $i++
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
