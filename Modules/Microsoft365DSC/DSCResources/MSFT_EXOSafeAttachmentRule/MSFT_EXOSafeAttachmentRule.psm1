function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Getting configuration of SafeAttachmentRule for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    Write-Verbose -Message "Global ExchangeOnlineSession status:"
    Write-Verbose -Message "$( Get-PSSession -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.Name -eq 'ExchangeOnline' } | Out-String)"

    try
    {
        $SafeAttachmentRules = Get-SafeAttachmentRule
    }
    catch
    {
        Close-SessionsAndReturnError -ExceptionMessage $_.Exception
        $Message = "Error calling {Get-SafeAttachmentRule}"
        New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
    }
    $SafeAttachmentRule = $SafeAttachmentRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
    if (-not $SafeAttachmentRule)
    {
        Write-Verbose -Message "SafeAttachmentRule $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        $result = @{
            Ensure = 'Present'
            Identity                  = $SafeAttachmentRule.Identity
            SafeAttachmentPolicy      = $SafeAttachmentRule.SafeAttachmentPolicy
            Comments                  = $SafeAttachmentRule.Comments
            Enabled                   = $true
            ExceptIfRecipientDomainIs = $SafeAttachmentRule.ExceptIfRecipientDomainIs
            ExceptIfSentTo            = $SafeAttachmentRule.ExceptIfSentTo
            ExceptIfSentToMemberOf    = $SafeAttachmentRule.ExceptIfSentToMemberOf
            Priority                  = $SafeAttachmentRule.Priority
            RecipientDomainIs         = $SafeAttachmentRule.RecipientDomainIs
            SentTo                    = $SafeAttachmentRule.SentTo
            SentToMemberOf            = $SafeAttachmentRule.SentToMemberOf
            GlobalAdminAccount        = $GlobalAdminAccount
        }
        if ('Enabled' -eq $SafeAttachmentRule.State)
        {
            # Accounts for Get-SafeAttachmentRule returning 'State' instead of 'Enabled' used by New/Set
            $result.Enabled = $true
        }
        else
        {
            $result.Enabled = $false
        }

        Write-Verbose -Message "Found SafeAttachmentRule $($Identity)"
        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SafeAttachmentRule for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    $SafeAttachmentRules = Get-SafeAttachmentRule

    $SafeAttachmentRule = $SafeAttachmentRules | Where-Object -FilterScript { $_.Identity -eq $Identity }

    if (('Present' -eq $Ensure ) -and (-not $SafeAttachmentRule))
    {
        New-EXOSafeAttachmentRule -SafeAttachmentRuleParams $PSBoundParameters
    }

    if (('Present' -eq $Ensure ) -and ($SafeAttachmentRule))
    {
        if ($PSBoundParameters.Enabled -and ('Disabled' -eq $SafeAttachmentRule.State))
        {
            # New-SafeAttachmentRule has the Enabled parameter, Set-SafeAttachmentRule does not.
            # There doesn't appear to be any way to change the Enabled state of a rule once created.
            Write-Verbose -Message "Removing SafeAttachmentRule $($Identity) in order to change Enabled state."
            Remove-SafeAttachmentRule -Identity $Identity -Confirm:$false
            New-EXOSafeAttachmentRule -SafeAttachmentRuleParams $PSBoundParameters
        }
        else
        {
            Set-EXOSafeAttachmentRule -SafeAttachmentRuleParams $PSBoundParameters
        }
    }

    if (('Absent' -eq $Ensure ) -and ($SafeAttachmentRule))
    {
        Write-Verbose -Message "Removing SafeAttachmentRule $($Identity)"
        Remove-SafeAttachmentRule -Identity $Identity -Confirm:$false
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $SafeAttachmentPolicy,

        [Parameter()]
        [System.String]
        $Comments,

        [Parameter()]
        [System.Boolean]
        $Enabled = $true,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.String[]]
        $ExceptIfRecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentTo = @(),

        [Parameter()]
        [System.String[]]
        $ExceptIfSentToMemberOf = @(),

        [Parameter()]
        [uint32]
        $Priority,

        [Parameter()]
        [System.String[]]
        $RecipientDomainIs = @(),

        [Parameter()]
        [System.String[]]
        $SentTo = @(),

        [Parameter()]
        [System.String[]]
        $SentToMemberOf = @(),

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration of SafeAttachmentRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Microsoft365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $InformationPreference = 'Continue'
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline `
        -ErrorAction SilentlyContinue
    $content = ''
    if (Confirm-ImportedCmdletIsAvailable -CmdletName Get-SafeAttachmentRule)
    {
        [array]$SafeAttachmentRules = Get-SafeAttachmentRule
        $i = 1
        foreach ($SafeAttachmentRule in $SafeAttachmentRules)
        {
            Write-Information "    [$i/$($SafeAttachmentRules.Length)] $($SafeAttachmentRule.Identity)"
            $params = @{
                Identity             = $SafeAttachmentRule.Identity
                SafeAttachmentPolicy = $SafeAttachmentRule.SafeAttachmentPolicy
                GlobalAdminAccount   = $GlobalAdminAccount
            }
            $result = Get-TargetResource @params
            $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
            $content += "        EXOSafeAttachmentRule " + (New-GUID).ToString() + "`r`n"
            $content += "        {`r`n"
            $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
            $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
            $content += "        }`r`n"
            $i++
        }
    }
    else
    {
        Write-Information "The current tenant doesn't have access to the Safe Attachment Rule API."
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
