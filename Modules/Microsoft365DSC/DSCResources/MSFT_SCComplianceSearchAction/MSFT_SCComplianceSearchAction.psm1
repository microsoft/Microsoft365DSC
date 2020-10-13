function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Export', 'Preview', 'Purge', 'Retention')]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SearchName,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [System.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $ActionScope,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Getting configuration of SCComplianceSearchAction for $SearchName - $Action"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    if ($Global:CurrentModeIsExport)
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters `
            -SkipModuleReload $true
    }
    else
    {
        $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
            -InboundParameters $PSBoundParameters
    }
    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $currentAction = Get-CurrentAction -SearchName $SearchName -Action $Action `
            -ErrorAction Stop

        if ($null -eq $currentAction)
        {
            Write-Verbose -Message "SCComplianceSearchAction $ActionName does not exist."
            return $nullReturn
        }
        else
        {
            if ('Purge' -ne $Action)
            {
                $Scenario = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Scenario"
                $FileTypeExclusion = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "File type exclusions for unindexed"
                $EnableDedupe = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Enable dedupe"
                $IncludeCreds = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "SAS token"
                $IncludeSP = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Include SharePoint versions"
                $ScopeValue = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Scope"

                $ActionName = "Export"
                if ('RetentionReports' -eq $Scenario)
                {
                    $ActionName = "Retention"
                }

                $result = @{
                    Action                              = $ActionName
                    SearchName                          = $currentAction.SearchName
                    FileTypeExclusionsForUnindexedItems = $FileTypeExclusion
                    EnableDedupe                        = $EnableDedupe
                    IncludeSharePointDocumentVersions   = $IncludeSP
                    RetryOnError                        = $currentAction.Retry
                    ActionScope                         = $ScopeValue
                    GlobalAdminAccount                  = $GlobalAdminAccount
                    Ensure                              = 'Present'
                }
            }
            else
            {
                $PurgeTP = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Purge Type"
                $result = @{
                    Action             = $currentAction.Action
                    SearchName         = $currentAction.SearchName
                    PurgeType          = $PurgeTP
                    RetryOnError       = $currentAction.Retry
                    GlobalAdminAccount = $GlobalAdminAccount
                    Ensure             = 'Present'
                }
            }

            if ('<Specify -IncludeCredential parameter to show the SAS token>' -eq $IncludeCreds -or 'Purge' -eq $Action)
            {
                $result.Add("IncludeCredential", $false)
            }
            elseif ('Purge' -ne $Action)
            {
                $result.Add("IncludeCredential", $true)
            }

            Write-Verbose "Found existing $Action SCComplianceSearchAction for Search $SearchName"

            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        }
        return $result
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
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Export', 'Preview', 'Purge', 'Retention')]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SearchName,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [System.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $ActionScope,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting configuration of SCComplianceSearchAction for $SearchName - $Action"
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    $CurrentAction = Get-TargetResource @PSBoundParameters

    # Calling the New-ComplianceSearchAction if the action already exists, updates it.
    if ('Present' -eq $Ensure)
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")

        if ($null -ne $ActionScope)
        {
            $CreationParams.Remove("ActionScope")
            $CreationParams.Add("Scope", $ActionScope)
        }

        switch ($Action)
        {
            "Export"
            {
                $CreationParams.Add("Report", $true)
            }
            "Retention"
            {
                $CreationParams.Add("RetentionReport", $true)
            }
            "Purge"
            {
                $CreationParams.Add("Purge", $true)
                $CreationParams.Remove("ActionScope")
                $CreationParams.Remove("Scope")
                $CreationParams.Add("Confirm", $false)
            }
        }

        $CreationParams.Remove("Action")

        Write-Verbose -Message "Creating new Compliance Search Action calling the New-ComplianceSearchAction cmdlet"

        Write-Verbose -Message "Set-TargetResource Creation Parameters: `n $(Convert-M365DscHashtableToString -Hashtable $CreationParams)"

        try
        {
            New-ComplianceSearchAction @CreationParams -ErrorAction Stop
        }
        catch
        {
            if ($_.Exception -like "*Please update the search results to get the most current estimate.*")
            {
                try
                {
                    Write-Verbose "Starting Compliance Search $SearchName"
                    Start-ComplianceSearch -Identity $SearchName

                    $loop = 1
                    do
                    {
                        $status = (Get-ComplianceSearch -Identity $SearchName).Status
                        Write-Verbose -Message "($loop) Waiting for 60 seconds for Compliance Search $SearchName to complete."
                        Start-Sleep -Seconds 60
                        $loop++
                    } while ($status -ne 'Completed' -or $loop -lt 10)
                    New-ComplianceSearchAction @CreationParams -ErrorAction Stop
                }
                catch
                {
                    New-ComplianceSearchAction @CreationParams -ErrorAction Stop
                }
            }
            else
            {
                New-M365DSCLogEntry -Error $_ -Message "Could not create a new SCComplianceSearchAction" -Source $MyInvocation.MyCommand.ModuleName
                Write-Verbose -Message "An error occured creating a new SCComplianceSearchAction"
                throw $_
            }
        }
    }
    elseif (('Absent' -eq $Ensure) -and ('Present' -eq $CurrentTag.Ensure))
    {
        $currentAction = Get-CurrentAction -Action $Action -SearchName $SearchName

        # If the Rule exists and it shouldn't, simply remove it;
        Remove-ComplianceSearchAction -Identity $currentAction.Identity -Confirm:$false
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
        [ValidateSet('Export', 'Preview', 'Purge', 'Retention')]
        $Action,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SearchName,

        [Parameter()]
        [System.String[]]
        $FileTypeExclusionsForUnindexedItems,

        [Parameter()]
        [System.Boolean]
        $EnableDedupe,

        [Parameter()]
        [System.Boolean]
        $IncludeCredential,

        [Parameter()]
        [System.Boolean]
        $IncludeSharePointDocumentVersions,

        [Parameter()]
        [System.String]
        [ValidateSet('SoftDelete', 'HardDelete')]
        $PurgeType,

        [Parameter()]
        [System.Boolean]
        $RetryOnError,

        [Parameter()]
        [System.String]
        [ValidateSet('IndexedItemsOnly', 'UnindexedItemsOnly', 'BothIndexedAndUnindexedItems')]
        $ActionScope,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    Write-Verbose -Message "Testing configuration of SCComplianceSearchAction"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
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
    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    $ConnectionMode = New-M365DSCConnection -Platform 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

    try
    {
        [array]$actions = Get-ComplianceSearchAction -ErrorAction Stop

        if ($actions.Count -gt 0)
        {
            Write-Host "`r`n    Tenant Wide Actions:"
        }
        $i = 1
        $dscContent = ""
        foreach ($action in $actions)
        {
            Write-Host "        |---[$i/$($actions.Length)] $($action.Name)" -NoNewLine
            $Params = @{
                Action             = $action.Action
                SearchName         = $action.SearchName
                GlobalAdminAccount = $GlobalAdminAccount
            }

            $Scenario = Get-ResultProperty -ResultString $action.Results -PropertyName "Scenario"

            if ('RetentionReports' -eq $Scenario)
            {
                $Params.Action = "Retention"
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

        [array]$cases = Get-ComplianceCase -ErrorAction Stop

        $j = 1
        foreach ($case in $cases)
        {
            Write-Host "    Case [$j/$($cases.Count)] $($Case.Name)"

            $actions = Get-ComplianceSearchAction -Case $Case.Name

            $i = 1
            foreach ($action in $actions)
            {
                Write-Host "        |---[$i/$($actions.Length)] $($action.Name)" -NoNewLine

                $Params = @{
                    Action                = $action.Action
                    SearchName            = $action.SearchName
                    GlobalAdminAccount    = $GlobalAdminAccount
                }

                $Scenario = Get-ResultProperty -ResultString $action.Results -PropertyName "Scenario"

                if ('RetentionReports' -eq $Scenario)
                {
                    $Params.Action = "Retention"
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
            $j++
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

function Get-ResultProperty
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResultString,

        [Parameter(Mandatory = $true)]
        [System.String]
        $PropertyName
    )

    $start = $ResultString.IndexOf($PropertyName) + $PropertyName.Length + 2
    if ($start -lt 0 -or $start -gt $ResultString.Length)
    {
        return $null
    }
    $end = $ResultString.IndexOf(';', $start)

    $result = $null
    if ($end -gt $start)
    {
        $result = $ResultString.SubString($start, $end - $start).Trim()

        if ('<null>' -eq $result)
        {
            $result = $null
        }
        elseif ('True' -eq $result)
        {
            $result = $true
        }
        elseif ('False' -eq $result)
        {
            $result = $false
        }
    }

    return $result
}

function Get-CurrentAction
{
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSObject])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SearchName,

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Export', 'Purge', 'Retention')]
        $Action
    )
    # For the sake of retrieving the current action, search by Action = Export;
    if ('Retention' -eq $Action)
    {
        $Action = "Export"
        $Scenario = "RetentionReports"
    }
    elseif ('Export' -eq $Action)
    {
        $Scenario = "GenerateReports"
    }
    # Get the case associated with the Search Instance if any;
    $Cases = Get-ComplianceCase

    foreach ($Case in $Cases)
    {
        $searches = Get-ComplianceSearch -Case $Case.Name | Where-Object { $_.Name -eq $SearchName }

        if ($null -ne $searches)
        {
            $currentAction = Get-ComplianceSearchAction -Case $Case.Name
            break;
        }
    }

    if ($null -eq $currentAction)
    {
        $currentAction = Get-ComplianceSearchAction -Details | Where-Object { $_.SearchName -eq $SearchName -and $_.Action -eq $Action }
    }

    if ('Purge' -ne $Action -and $null -ne $currentAction)
    {
        $currentAction = $currentAction | Where-Object { $_.Results -like "*Scenario: $($Scenario)*" }
    }
    elseif ('Purge' -eq $Action)
    {
        $currentAction = $currentAction | Where-Object { $_.Action -eq 'Purge' }
    }

    return $currentAction
}

Export-ModuleMember -Function *-TargetResource
