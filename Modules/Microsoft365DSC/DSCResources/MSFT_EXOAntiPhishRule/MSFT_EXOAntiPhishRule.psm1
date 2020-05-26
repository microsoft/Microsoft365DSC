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
        $AntiPhishPolicy,

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

    Write-Verbose -Message "Getting configuration of AntiPhishRule for $Identity"
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
        $AntiPhishRules = Get-AntiPhishRule -ErrorAction SilentlyContinue
    }
    catch
    {
        New-M365DSCLogEntry -Error $_ -Message "Couldn't get AntiPhishRules" -Source $MyInvocation.MyCommand.ModuleName
    }

    if ($null -ne $AntiPhishRules)
    {
        $AntiPhishRule = $AntiPhishRules | Where-Object -FilterScript { $_.Identity -eq $Identity }
        if ($null -eq $AntiPhishRule)
        {
            Write-Verbose -Message "AntiPhishRule $($Identity) does not exist."
            $result = $PSBoundParameters
            $result.Ensure = 'Absent'
            return $result
        }
        else
        {
            $result = @{
                Identity                  = $Identity
                AntiPhishPolicy           = $AntiPhishRule.AntiPhishPolicy
                Comments                  = $AntiPhishRule.Comments
                Enabled                   = $AntiPhishRule.RuleEnabled
                ExceptIfRecipientDomainIs = $AntiPhishRule.ExceptIfRecipientDomainIs
                ExceptIfSentTo            = $AntiPhishRule.ExceptIfSentTo
                ExceptIfSentToMemberOf    = $AntiPhishRule.ExceptIfSentToMemberOf
                Priority                  = $AntiPhishRule.Priority
                RecipientDomainIs         = $AntiPhishRule.RecipientDomainIs
                SentTo                    = $AntiPhishRule.SentTo
                SentToMemberOf            = $AntiPhishRule.SentToMemberOf
                Ensure                    = 'Present'
                GlobalAdminAccount        = $GlobalAdminAccount
            }
            if ('Enabled' -eq $AntiPhishRule.State)
            {
                # Accounts for Get-AntiPhishRule returning 'State' instead of 'Enabled' used by New/Set
                $result.Enabled = $true
            }

            Write-Verbose -Message "Found AntiPhishRule $($Identity)"
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    else
    {
        Write-Verbose -Message "AntiPhishRule $($Identity) does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
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
        $AntiPhishPolicy,

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

    Write-Verbose -Message "Setting configuration of AntiPhishRule for $Identity"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline

    # Make sure that the associated Policy exists;
    $AssociatedPolicy = Get-AntiPhishPolicy -Identity $AntiPhishPolicy -ErrorAction 'SilentlyContinue'
    if ($null -eq $AssociatedPolicy)
    {
        throw "Error attempting to create EXOAntiPhishRule {$Identity}. The specified AntiPhishPolicy {$AntiPhishPolicy} " + `
            "doesn't exist. Make sure you either create it first or specify a valid policy."
    }

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("Ensure") | Out-Null
        $CreationParams.Remove("GlobalAdminAccount") | Out-Null
        $CreationParams.Add("Name", $Identity) | Out-Null
        $CreationParams.Remove("Identity") | Out-Null

        # New-AntiPhishRule has the Enabled parameter, Set-AntiPhishRule does not.
        # There doesn't appear to be any way to change the Enabled state of a rule once created.
        if ($CurrentValues.State -eq 'Disabled')
        {
            Write-Verbose -Message "AntiPhishRule {$Identity} already exists but is disabled, we need to delete it first. Deleting Rule"
            Remove-AntiphishRule -Identity $Identity -Confirm:$false
        }

        Write-Verbose -Message "Creating AntiPhishRule {$Identity}"
        New-AntiPhishRule @CreationParams
    }
    elseif ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Present')
    {
        $UpdateParams = $PSBoundParameters
        $UpdateParams.Remove("Ensure") | Out-Null
        $UpdateParams.Remove("GlobalAdminAccount") | Out-Null
        $UpdateParams.Remove("Enabled") | Out-Null

        # Check to see if the specified policy already has the rule assigned;
        $existingRule = Get-AntiPhishRule | Where-Object -FilterScript {$_.AntiPhishPolicy -eq $AntiPhishPolicy}

        if ($null -ne $existingRule)
        {
            # The rule is already assigned to the policy, do try to update the AntiPhishPolicy parameter;
            $UpdateParams.Remove("AntiPhishPolicy") | Out-Null
        }

        Write-Verbose -Message "Updating AntiPhishRule {$Identity}."
        Set-AntiPhishRule @UpdateParams
    }
    if ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing AntiPhishRule [$Identity]"
        Remove-AntiPhishRule -Identity $Identity -Confirm:$false
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
        $AntiPhishPolicy,

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

    Write-Verbose -Message "Testing configuration of AntiPhishRule for $Identity"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    if ($null -eq $PSBoundParameters.Enabled)
    {
        Write-Verbose "Removing Enabled from the list of Parameters to Test"
        $ValuesToCheck.Remove("Enabled") | Out-Null
    }

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
    $InformationPreference = "Continue"
    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Test-MSCloudLogin -CloudCredential $GlobalAdminAccount `
        -Platform ExchangeOnline `
        -ErrorAction SilentlyContinue

    $AntiPhishRules = Get-AntiphishRule
    $content = ""
    $i = 1
    foreach ($Rule in $AntiPhishRules)
    {
        Write-Information "    [$i/$($AntiPhishRules.Length)] $($Rule.Identity)"

        $Params = @{
            Identity           = $Rule.Identity
            AntiPhishPolicy    = $Rule.AntiPhishPolicy
            GlobalAdminAccount = $GlobalAdminAccount
        }
        $result = Get-TargetResource @Params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        EXOAntiPhishRule " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
}

Export-ModuleMember -Function *-TargetResource
