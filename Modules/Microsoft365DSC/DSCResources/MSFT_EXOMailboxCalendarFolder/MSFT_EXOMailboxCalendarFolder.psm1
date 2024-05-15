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
        [ValidateSet("AvailabilityOnly", "LimitedDetails", "FullDetails")]
        [System.String]
        $DetailLevel = "AvailabilityOnly",

        [Parameter()]
        [ValidateSet("OneDay", "ThreeDays", "OneWeek", "OneMonth", "ThreeMonths", "SixMonths", "OneYear")]
        [System.String]
        $PublishDateRangeFrom = "ThreeMonths",

        [Parameter()]
        [ValidateSet("OneDay", "ThreeDays", "OneWeek", "OneMonth", "ThreeMonths", "SixMonths", "OneYear")]
        [System.String]
        $PublishDateRangeTo,

        [Parameter()]
        [System.Boolean]
        $PublishEnabled,

        [Parameter()]
        [System.Boolean]
        $SearchableUrlEnabled,

        [Parameter()]
        [System.String]
        $SharedCalendarSyncStartDate,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
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
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion
    Write-Verbose -Message "Getting configuration of Calendar Folder for {$Identity}"

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        $folder = Get-MailboxCalendarFolder -Identity $Identity -ErrorAction SilentlyContinue

        if ($null -eq $folder)
        {
            return $nullReturn
        }

        $result = @{
            Identity                    = $folder.Identity
            DetailLevel                 = $folder.DetailLevel
            PublishDateRangeFrom        = $folder.PublishDateRangeFrom
            PublishDateRangeTo          = $folder.PublishDateRangeTo
            PublishEnabled              = [Boolean]$folder.PublishEnabled
            SearchableUrlEnabled        = [Boolean]$folder.SearchableUrlEnabled
            SharedCalendarSyncStartDate = $folder.SharedCalendarSyncStartDate
            Ensure                      = 'Present'
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            CertificateThumbprint       = $CertificateThumbprint
            CertificatePath             = $CertificatePath
            CertificatePassword         = $CertificatePassword
            Managedidentity             = $ManagedIdentity.IsPresent
            TenantId                    = $TenantId
            AccessTokens                = $AccessTokens
        }

        Write-Verbose -Message "Found Calendar Folder for {$Identity}"
        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

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
        $Identity,

        [Parameter()]
        [ValidateSet("AvailabilityOnly", "LimitedDetails", "FullDetails")]
        [System.String]
        $DetailLevel = "AvailabilityOnly",

        [Parameter()]
        [ValidateSet("OneDay", "ThreeDays", "OneWeek", "OneMonth", "ThreeMonths", "SixMonths", "OneYear")]
        [System.String]
        $PublishDateRangeFrom = "ThreeMonths",

        [Parameter()]
        [ValidateSet("OneDay", "ThreeDays", "OneWeek", "OneMonth", "ThreeMonths", "SixMonths", "OneYear")]
        [System.String]
        $PublishDateRangeTo,

        [Parameter()]
        [System.Boolean]
        $PublishEnabled,

        [Parameter()]
        [System.Boolean]
        $SearchableUrlEnabled,

        [Parameter()]
        [System.String]
        $SharedCalendarSyncStartDate,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

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

    $currentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Setting configuration of Calendar Folder for {$Identity}"

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    $UpdateParameters = ([Hashtable]$PSBoundParameters).Clone()
    $UpdateParameters.Remove("Ensure") | Out-Null
    $UpdateParameters.Remove("Credential") | Out-Null
    $UpdateParameters.Remove("ApplicationId") | Out-Null
    $UpdateParameters.Remove("TenantId") | Out-Null
    $UpdateParameters.Remove("CertificateThumbprint") | Out-Null
    $UpdateParameters.Remove("ApplicationSecret") | Out-Null
    $UpdateParameters.Remove("CertificatePath") | Out-Null
    $UpdateParameters.Remove("CertificatePassword") | Out-Null
    $UpdateParameters.Remove("ManagedIdentity") | Out-Null
    $UpdateParameters.Remove('AccessTokens') | Out-Null

    # The SharedCalendarSyncStartDate needs to be used by itself in a subsequent call.
    if ($PSBoundParameters.ContainsKey('SharedCalendarSyncStartDate'))
    {
        Write-Verbose -Message "Updating the Mailbox Calendar Folder SharedCalendarSyncStartDate property for {$Identity}"
        Set-MailboxCalendarFolder -Identity $Identity -SharedCalendarSyncStartDate $SharedCalendarSyncStartDate
        $UpdateParameters.Remove("SharedCalendarSyncStartDate") | Out-Null
    }
    Write-Verbose -Message "Updating the Mailbox Calendar Folder for {$Identity}"
    Set-MailboxCalendarFolder @UpdateParameters
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
        [ValidateSet("AvailabilityOnly", "LimitedDetails", "FullDetails")]
        [System.String]
        $DetailLevel = "AvailabilityOnly",

        [Parameter()]
        [ValidateSet("OneDay", "ThreeDays", "OneWeek", "OneMonth", "ThreeMonths", "SixMonths", "OneYear")]
        [System.String]
        $PublishDateRangeFrom = "ThreeMonths",

        [Parameter()]
        [ValidateSet("OneDay", "ThreeDays", "OneWeek", "OneMonth", "ThreeMonths", "SixMonths", "OneYear")]
        [System.String]
        $PublishDateRangeTo,

        [Parameter()]
        [System.Boolean]
        $PublishEnabled,

        [Parameter()]
        [System.Boolean]
        $SearchableUrlEnabled,

        [Parameter()]
        [System.String]
        $SharedCalendarSyncStartDate,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
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

    Write-Verbose -Message "Testing configuration of Calendar Folder for {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $DesiredValues = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $DesiredValues `
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
        -InboundParameters $PSBoundParameters `
        -SkipModuleReload $true

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
        $mailboxes = Get-Mailbox -ResultSize 'Unlimited' -ErrorAction Stop

        if ($null -eq $mailboxes)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            return ''
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }

        $i = 1
        foreach ($mailbox in $mailboxes)
        {
            # Name of calendar folder depends on the language of the mailbox
            $calendarFolderName = (Get-MailboxFolderStatistics -Identity $($mailbox.UserPrincipalName) -FolderScope Calendar | Where-Object {$_.FolderType -eq 'Calendar'}).Name
            $folderPath = $mailbox.UserPrincipalName + ':\' + $calendarFolderName
            Write-Host "    |---[$i/$($mailboxes.Count)] $($folderPath)" -NoNewline
            $Params = @{
                Identity              = $folderPath
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePassword   = $CertificatePassword
                Managedidentity       = $ManagedIdentity.IsPresent
                CertificatePath       = $CertificatePath
                AccessTokens          = $AccessTokens
            }
            $Results = Get-TargetResource @Params
            if ($Results.SharedCalendarSyncStartDate -eq '01/02/0001 00:00:00')
            {
                $Results.Remove('SharedCalendarSyncStartDate') | Out-Null
            }

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
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
