Confirm-M365DSCModuleDependency -ModuleName 'MSFT_EXOAtpProtectionPolicyRule'

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
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $SafeLinksPolicy,

        [Parameter()]
        [System.String[]]
        $SentTo,

        [Parameter()]
        [System.String[]]
        $SentToMemberOf,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for ATP Protection Policy Rule with Identity $Identity"

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

            $instance = Get-ATPProtectionPolicyRule -Identity $Identity -ErrorAction SilentlyContinue

            if ($null -eq $instance)
            {
                return $nullResult
            }
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message "Found ATP Protection Policy Rule with Identity $($instance.Identity)"

        $results = @{
            Identity                  = $instance.Identity
            Ensure                    = 'Present'
            Comments                  = $instance.Comments
            Enabled                   = $instance.State -eq 'Enabled'
            ExceptIfRecipientDomainIs = $instance.ExceptIfRecipientDomainIs
            ExceptIfSentTo            = $instance.ExceptIfSentTo
            ExceptIfSentToMemberOf    = $instance.ExceptIfSentToMemberOf
            Name                      = $instance.Name
            Priority                  = $instance.Priority
            RecipientDomainIs         = $instance.RecipientDomainIs
            SafeAttachmentPolicy      = $instance.SafeAttachmentPolicy
            SafeLinksPolicy           = $instance.SafeLinksPolicy
            SentTo                    = $instance.SentTo
            SentToMemberOf            = $instance.SentToMemberOf
            Credential                = $Credential
            ApplicationId             = $ApplicationId
            TenantId                  = $TenantId
            CertificateThumbprint     = $CertificateThumbprint
            ManagedIdentity           = $ManagedIdentity.IsPresent
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $SafeLinksPolicy,

        [Parameter()]
        [System.String[]]
        $SentTo,

        [Parameter()]
        [System.String[]]
        $SentToMemberOf,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration for ATP Protection Policy Rule with Identity $Identity"

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

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $SetParameters.Remove('Identity') | Out-Null
        New-ATPProtectionPolicyRule @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        if ($currentInstance.SafeAttachmentPolicy -ne $SetParameters.SafeAttachmentPolicy)
        {
            throw 'SafeAttachmentPolicy cannot be changed after creation'
        }
        if ($currentInstance.SafeLinksPolicy -ne $SetParameters.SafeLinksPolicy)
        {
            throw 'SafeLinksPolicy cannot be changed after creation'
        }

        # Enabled state can only be changed by the Enabled/Disable-ATPProtectionPolicyRule cmdlets
        if ($currentInstance.Enabled -ne $setParameters.Enabled)
        {
            Write-Verbose -Message "Changing Enabled state of the ATPProtectionPolicyRule $($currentInstance.Identity) from $($currentInstance.Enabled) to $($setParameters.Enabled)"
            if ($setParameters.Enabled)
            {
                Enable-ATPProtectionPolicyRule -Identity $currentInstance.Identity
            }
            else
            {
                Disable-ATPProtectionPolicyRule -Identity $currentInstance.Identity
            }
        }

        $SetParameters.Remove('SafeLinksPolicy') | Out-Null
        $SetParameters.Remove('SafeAttachmentPolicy') | Out-Null
        $SetParameters.Remove('Enabled') | Out-Null

        Set-ATPProtectionPolicyRule @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Remove cmdlet for the resource
        Remove-ATPProtectionPolicyRule -Identity $currentInstance.Identity
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
        $Identity,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled,

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo,

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf,

        [Parameter()]
        [System.String]
        $Name,

        [Parameter()]
        [System.UInt32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs,

        [Parameter()]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $SafeLinksPolicy,

        [Parameter()]
        [System.String[]]
        $SentTo,

        [Parameter()]
        [System.String[]]
        $SentToMemberOf,

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

    ##TODO - Replace workload
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
        $Script:ExportMode = $true
        [array]$rules = Get-ATPProtectionPolicyRule -ErrorAction Stop

        $i = 1
        $dscContent = ''
        if ($rules.Count -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $rules)
        {
            $displayedKey = $config.Identity
            Write-M365DSCHost -Message "    |---[$i/$($rules.Count)] $displayedKey" -DeferWrite
            $params = @{
                Identity              = $config.Identity
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
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
