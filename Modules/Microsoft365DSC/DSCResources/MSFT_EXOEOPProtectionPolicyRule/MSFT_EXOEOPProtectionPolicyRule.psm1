Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOEOPProtectionPolicyRule'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $SentTo,

        [Parameter()]
        [System.String[]]
        $SentToMemberOf,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of EOPProtectionPolicyRule with Identity $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Identity -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

            $instance = Get-EOPProtectionPolicyRule -Identity $Identity -ErrorAction SilentlyContinue
            if ($null -eq $instance)
            {
                Write-Verbose -Message "No EXO EOPProtectionPolicyRule found with Identity {$Identity}"
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message "Found an instance with Identity {$Identity}"

        $results = @{
            Comments                  = $instance.Comments
            ExceptIfRecipientDomainIs = $instance.ExceptIfRecipientDomainIs
            ExceptIfSentTo            = $instance.ExceptIfSentTo
            ExceptIfSentToMemberOf    = $instance.ExceptIfSentToMemberOf
            Identity                  = $instance.Identity
            State                     = $instance.State
            Name                      = $instance.Name
            Priority                  = $instance.Priority
            RecipientDomainIs         = $instance.RecipientDomainIs
            SentTo                    = $instance.SentTo
            SentToMemberOf            = $instance.SentToMemberOf
            Ensure                    = 'Present'
            Credential                = $Credential
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            CertificateThumbprint     = $CertificateThumbprint
            ApplicationSecret         = $ApplicationSecret
            AccessTokens              = $AccessTokens
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
        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $SentTo,

        [Parameter()]
        [System.String[]]
        $SentToMemberOf,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of EOPProtectionPolicyRule with Identity $Identity"

    $null = New-M365DSCConnection -Workload 'ExchangeOnline' `
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

    $currentInstance = Get-TargetResource @PSBoundParameters
    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        #following Microsoft recommendation, we will not create new EOPProtectionPolicyRule, instead we will enable the rule if not already done
        Write-Verbose -Message 'We not create new EOPProtectionPolicyRule if it is not present'
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$Identity}"

        $UpdateParameters = ([Hashtable]$BoundParameters).Clone()
        $UpdateParameters.Remove('State') | Out-Null

        if ($currentInstance.State -ne $State)
        {
            if ($State -eq 'Enabled')
            {
                Enable-EOPProtectionPolicyRule -Identity $Identity
            }
            else
            {
                Disable-EOPProtectionPolicyRule -Identity $Identity
            }
        }

        Set-EOPProtectionPolicyRule @UpdateParameters
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        #following Microsoft recommendation, we will not remove EOPProtectionPolicyRules.
        Write-Verbose -Message 'We will not remove EOPProtectionPolicyRules'
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $Identity,

        [Parameter()]
        [System.String]
        $State,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.Int32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $SentTo,

        [Parameter()]
        [System.String[]]
        $SentToMemberOf,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

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

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
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
        [array]$getValue = Get-EOPProtectionPolicyRule -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Count -eq 0)
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

            $displayedKey = $config.Identity
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ApplicationSecret     = $ApplicationSecret
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        PostProcessing = {
            param($DesiredValues, $CurrentValues, $ValuesToCheck, $ignore)
            foreach ($key in $ValuesToCheck.Keys)
            {
                if ($null -eq $CurrentValues[$key])
                {
                    switch -regex ($key)
                    {
                        '^ExceptIf\w+$|^RecipientDomainIs$|^SentTo(\w+)?$'
                        {
                            $CurrentValues[$key] = @()
                            break
                        }
                    }
                }
            }
            return [System.Tuple[Hashtable, Hashtable, Hashtable]]::new($DesiredValues, $CurrentValues, $ValuesToCheck)
        }
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
