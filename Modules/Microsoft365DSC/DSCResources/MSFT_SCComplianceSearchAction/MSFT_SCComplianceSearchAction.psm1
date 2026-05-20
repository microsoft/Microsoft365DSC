Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SCComplianceSearchAction'

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
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of SCComplianceSearchAction for $SearchName - $Action"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Action -ne $Action)
        {
            $null = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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

            $nullReturn = $PSBoundParameters
            $nullReturn.Ensure = 'Absent'

            $currentAction = Invoke-M365DSCCommand -ScriptBlock { Get-CurrentAction -SearchName $SearchName -Action $Action `
                -ErrorAction Stop } -SuppressNotFoundError

            if ($null -eq $currentAction)
            {
                Write-Verbose -Message "SCComplianceSearchAction $ActionName does not exist."
                return $nullReturn
            }
        }
        else
        {
            $currentAction = $Script:exportedInstance
        }

        if ($Action -eq 'Export' -or $Action -eq 'Retention')
        {
            $Scenario = Get-ResultProperty -ResultString $currentAction.Results -PropertyName 'Scenario'
            $FileTypeExclusion = Get-ResultProperty -ResultString $currentAction.Results -PropertyName 'File type exclusions for unindexed'
            $EnableDedupe = Get-ResultProperty -ResultString $currentAction.Results -PropertyName 'Enable dedupe'
            $IncludeCreds = Get-ResultProperty -ResultString $currentAction.Results -PropertyName 'SAS token'
            $IncludeSP = Get-ResultProperty -ResultString $currentAction.Results -PropertyName 'Include SharePoint versions'
            $ScopeValue = Get-ResultProperty -ResultString $currentAction.Results -PropertyName 'Scope'

            $ActionName = $Action
            if ('RetentionReports' -eq $Scenario)
            {
                $ActionName = 'Retention'
            }

            $result = @{
                Action                              = $ActionName
                SearchName                          = $currentAction.SearchName
                FileTypeExclusionsForUnindexedItems = $FileTypeExclusion
                EnableDedupe                        = $EnableDedupe
                IncludeSharePointDocumentVersions   = $IncludeSP
                RetryOnError                        = $currentAction.Retry
                ActionScope                         = $ScopeValue
                Credential                          = $Credential
                ApplicationId                       = $ApplicationId
                TenantId                            = $TenantId
                CertificateThumbprint               = $CertificateThumbprint
                CertificatePath                     = $CertificatePath
                CertificatePassword                 = $CertificatePassword
                Ensure                              = 'Present'
                AccessTokens                        = $AccessTokens
            }
            if ($ActionName -eq 'Preview')
            {
                $result.Remove('EnableDedupe') | Out-Null
            }
        }
        elseif ($Action -eq 'Purge')
        {
            $PurgeTP = Get-ResultProperty -ResultString $currentAction.Results -PropertyName 'Purge Type'
            $result = @{
                Action                = $currentAction.Action
                SearchName            = $currentAction.SearchName
                PurgeType             = $PurgeTP
                RetryOnError          = $currentAction.Retry
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                Ensure                = 'Present'
                AccessTokens          = $AccessTokens
            }
        }
        else
        {
            $result = @{
                Action                = $currentAction.Action
                SearchName            = $currentAction.SearchName
                RetryOnError          = $currentAction.Retry
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                Ensure                = 'Present'
                AccessTokens          = $AccessTokens
            }
        }

        if ('<Specify -IncludeCredential parameter to show the SAS token>' -eq $IncludeCreds -or 'Purge' -eq $Action)
        {
            $result.Add('IncludeCredential', $false)
        }
        elseif ('Purge' -ne $Action)
        {
            $result.Add('IncludeCredential', $true)
        }

        Write-Verbose "Found existing $Action SCComplianceSearchAction for Search $SearchName"

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
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of SCComplianceSearchAction for $SearchName - $Action"

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

    $CurrentAction = Get-TargetResource @PSBoundParameters

    # Calling the New-ComplianceSearchAction if the action already exists, updates it.
    if ('Present' -eq $Ensure)
    {
        $CreationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        if ($null -ne $ActionScope)
        {
            $CreationParams.Remove('ActionScope')
            $CreationParams.Add('Scope', $ActionScope)
        }

        switch ($Action)
        {
            'Export'
            {
                $CreationParams.Add('Report', $true)
            }
            'Retention'
            {
                $CreationParams.Add('RetentionReport', $true)
            }
            'Purge'
            {
                $CreationParams.Add('Purge', $true)
                $CreationParams.Remove('ActionScope') | Out-Null
                $CreationParams.Remove('Scope') | Out-Null
                $CreationParams.Add('Confirm', $false)
            }
            'Preview'
            {
                $CreationParams.Add('Preview', $true)
                $CreationParams.Remove('Scope') | Out-Null
                $CreationParams.Add('Confirm', $false)
                $CreationParams.Remove('EnableDedupe') | Out-Null
            }
        }

        $CreationParams.Remove('Action')

        Write-Verbose -Message 'Creating new Compliance Search Action calling the New-ComplianceSearchAction cmdlet'

        Write-Verbose -Message "Set-TargetResource Creation Parameters: `n $(Convert-M365DscHashtableToString -Hashtable $CreationParams)"

        try
        {
            New-ComplianceSearchAction @CreationParams -ErrorAction Stop
        }
        catch
        {
            if ($_.Exception -like '*Please update the search results to get the most current estimate.*')
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
                New-M365DSCLogEntry -Message 'Could not create a new SCComplianceSearchAction' `
                    -Exception $_ `
                    -Source $MyInvocation.MyCommand.ModuleName
                Write-Verbose -Message 'An error occured creating a new SCComplianceSearchAction'
                throw $_
            }
        }
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentAction.Ensure -eq 'Present')
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
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
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
        [array]$actions = Get-ComplianceSearchAction -ErrorAction Stop

        if ($actions.Count -gt 0)
        {
            Write-M365DSCHost -Message "`r`n    Tenant Wide Actions:"
        }
        else
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        foreach ($action in $actions)
        {
            Write-M365DSCHost -Message "        |---[$i/$($actions.Length)] $($action.Name)" -DeferWrite
            $Params = @{
                Action     = $action.Action
                SearchName = $action.SearchName
            }

            $Scenario = Get-ResultProperty -ResultString $action.Results -PropertyName 'Scenario'

            if ('RetentionReports' -eq $Scenario)
            {
                $Params.Action = 'Retention'
            }
            $Script:exportedInstance = $action
            $Results = Get-TargetResource @PSBoundParameters @Params
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }

        [array]$cases = Get-ComplianceCase -ErrorAction Stop

        $j = 1
        foreach ($case in $cases)
        {
            Write-M365DSCHost -Message "    Case [$j/$($cases.Count)] $($Case.Name)"

            $actions = Get-ComplianceSearchAction -Case $Case.Name

            $i = 1
            foreach ($action in $actions)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                Write-M365DSCHost -Message "        |---[$i/$($actions.Length)] $($action.Name)" -DeferWrite

                $Params = @{
                    Action     = $action.Action
                    SearchName = $action.SearchName
                }

                $Scenario = Get-ResultProperty -ResultString $action.Results -PropertyName 'Scenario'

                if ('RetentionReports' -eq $Scenario)
                {
                    $Params.Action = 'Retention'
                }
                $Results = Get-TargetResource @PSBoundParameters @Params

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                [void]$dscContent.Append($currentDSCBlock)
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
                $i++
            }
            $j++
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
        $Action
    )
    # For the sake of retrieving the current action, search by Action = Export;
    if ('Retention' -eq $Action)
    {
        $Action = 'Export'
        $Scenario = 'RetentionReports'
    }
    elseif ('Export' -eq $Action)
    {
        $Scenario = 'GenerateReports'
    }
    # Get the case associated with the Search Instance if any;
    $Cases = Get-ComplianceCase

    foreach ($Case in $Cases)
    {
        $searches = Get-ComplianceSearch -Case $Case.Name | Where-Object { $_.Name -eq $SearchName }

        if ($null -ne $searches)
        {
            $currentAction = Get-ComplianceSearchAction -Case $Case.Name
            break
        }
    }

    if ($null -eq $currentAction)
    {
        $currentAction = Get-ComplianceSearchAction | Where-Object { $_.SearchName -eq $SearchName -and $_.Action -eq $Action }
    }

    if ('Purge' -ne $Action -and $null -ne $currentAction -and -not [System.String]::IsNullOrEmpty($Scenario))
    {
        $currentAction = $currentAction | Where-Object { $_.Results -like "*Scenario: $($Scenario)*" }
    }
    elseif ('Purge' -eq $Action)
    {
        $currentAction = $currentAction | Where-Object { $_.Action -eq 'Purge' }
    }
    elseif ('Preview' -eq $Action)
    {
        $currentAction = $currentAction | Where-Object { $_.Action -eq 'Preview' }
    }

    return $currentAction
}

Export-ModuleMember -Function *-TargetResource
