function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        [ValidateSet('Export', 'Purge', 'Retention')]
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

    Write-Verbose -Message "Getting configuration of SCComplianceSearchAction for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $currentAction = Get-CurrentAction -SearchName $SearchName -Action $Action

    if ($null -eq $currentAction)
    {
        Write-Verbose -Message "SCComplianceSearchAction $ActionName does not exist."
        $result = $PSBoundParameters
        $result.Ensure = 'Absent'
        return $result
    }
    else
    {
        if ('Purge' -ne $Action)
        {
            $Scenario          = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Scenario"
            $FileTypeExclusion = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "File type exclusions for unindexed"
            $EnableDedupe      = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Enable dedupe"
            $IncludeCreds      = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "SAS token"
            $IncludeSP         = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Include SharePoint versions"
            $ScopeValue        = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Scope"

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
            $PurgeTP           = Get-ResultProperty -ResultString $currentAction.Results -PropertyName "Purge Type"
            $result = @{
                Action                              = $currentAction.Action
                SearchName                          = $currentAction.SearchName
                PurgeType                           = $PurgeTP
                RetryOnError                        = $currentAction.Retry
                GlobalAdminAccount                  = $GlobalAdminAccount
                Ensure                              = 'Present'
            }
        }

        if ('<Specify -IncludeCredential parameter to show the SAS token>' -eq $IncludeCreds)
        {
            $result.Add("IncludeCredential", $false)
        }
        else
        {
            $result.Add("IncludeCredential", $true)
        }

        Write-Verbose "Found existing $Action SCComplianceSearchAction for Search $SearchName"

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-O365DscHashtableToString -Hashtable $result)"
        return $result
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        [ValidateSet('Export', 'Purge', 'Retention')]
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

    Write-Verbose -Message "Setting configuration of SCComplianceSearchAction for $Name"

    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
                      -Platform SecurityComplianceCenter

    $CurrentAction = Get-TargetResource @PSBoundParameters

    # Calling the New-ComplianceSearchAction if the action already exists, updates it.
    if (('Present' -eq $Ensure))
    {
        $CreationParams = $PSBoundParameters
        $CreationParams.Remove("GlobalAdminAccount")
        $CreationParams.Remove("Ensure")

        if ($null -ne $ActionScope)
        {
            $CreationParams.Remove("ActionScope")
            $CreationParams.Add("Scope", $ActionScope)
        }
        Write-Verbose "Creating new Compliance Search Action calling the New-ComplianceSearchAction cmdlet."
        New-ComplianceSearchAction @CreationParams
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
        [Parameter(Mandatory=$true)]
        [System.String]
        [ValidateSet('Export', 'Purge', 'Retention')]
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
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('GlobalAdminAccount') | Out-Null

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
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
    Test-MSCloudLogin -Platform SecurityComplianceCenter `
                      -CloudCredential $GlobalAdminAccount

    $actions = Get-ComplianceSearchAction

    $i = 1
    $content = ""
    foreach ($action in $actions)
    {
        Write-Information "    [$i/$($actions.Length)] $($action.Name)"
        $params = @{
            Action             = $action.Action
            SearchName         = $action.SearchName
            GlobalAdminAccount = $GlobalAdminAccount
        }

        $Scenario = Get-ResultProperty -ResultString $action.Results -PropertyName "Scenario"

        if ('RetentionReports' -eq $Scenario)
        {
            $params.Action = "Retention"
        }

        $result = Get-TargetResource @params
        $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
        $content += "        SCComplianceSearchAction " + (New-GUID).ToString() + "`r`n"
        $content += "        {`r`n"
        $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
        $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
        $content += "        }`r`n"
        $i++
    }
    return $content
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
    $end   = $ResultString.IndexOf(';', $start)

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

    $currentAction = Get-ComplianceSearchAction -Details | Where-Object {$_.SearchName -eq $SearchName -and $_.Action -eq $Action}

    if ('Purge' -ne $Action -and $null -ne $currentAction)
    {
        $currentAction = $currentAction | Where-Object {$_.Results -like "*Scenario: $($Scenario)*"}
    }

    return $currentAction
}

Export-ModuleMember -Function *-TargetResource
