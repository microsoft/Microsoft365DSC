function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Title,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Content,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
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

    try
    {
        Write-Verbose -Message "Getting the SPO Site Script: $Title"

        #
        if ([System.String]::IsNullOrEmpty($Identity))
        {
            [Array]$SiteScripts = Get-PnPSiteScript -ErrorAction Stop | Where-Object -FilterScript { $_.Title -eq $Title }

            $SiteScript = $null
            ##### Check to see if more than one site script is returned
            if ($SiteScripts.Length -gt -1)
            {
                $SiteScript = Get-PnPSiteScript -Identity $SiteScripts[0].Id -ErrorAction Stop
            }

            # No script was returned
            if ($null -eq $SiteScripts)
            {
                Write-Verbose -Message "No Site Script with the Title, {$Title}, was found."
                return $nullReturn
            }
        }
        else
        {
            $SiteScript = Get-PnPSiteScript -Identity $Identity
        }
        ##### End of Check

        return @{
            Identity              = $SiteScript.Id
            Title                 = $SiteScript.Title
            Description           = $SiteScript.Description
            Content               = $SiteScript.Content
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
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
        $Title,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Content,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting Site Script: $Title"

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

    $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
        -InboundParameters $PSBoundParameters

    # region Telemetry
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove('Ensure') | Out-Null
    $CurrentParameters.Remove('Credential') | Out-Null
    $CurrentParameters.Remove('ApplicationSecret') | Out-Null
    # end region

    if ($Ensure -eq 'Present' -and $CurrentValues.Ensure -eq 'Absent')
    {
        # Splatting
        $CreationParams = @{
            Title       = $Title
            Content     = $Content
            Description = $Description
        }

        # Adding the Site Script Again.
        Write-Verbose -Message "Site Script, {$Title}, doesn't exist. Creating it."
        $newSiteScript = Add-PnPSiteScript @CreationParams

        # let's make sure the Site Script gets added
        $siteScript = $null
        $circuitBreaker = 0
        do
        {
            Write-Verbose -Message 'Waiting for another 3 seconds for Site Script to be ready.'
            Start-Sleep -Seconds 3
            try
            {
                $siteScript = Get-PnPSiteScript -Identity $newSiteScript.Id -ErrorAction Stop
            }
            catch
            {
                $siteScript = $null
            }
            $circuitBreaker++
        } while ($null -eq $siteScript -and $circuitBreaker -lt 20)

        Write-Verbose -Message "Site Script, {$Title}, has been successfully created."
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentValues.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing Site Script {$Title}"
        try
        {
            # The Site Script exists and it shouldn't
            [Array]$SiteScripts = Get-PnPSiteScript | Where-Object -FilterScript { $_.Title -eq $Title } -ErrorAction SilentlyContinue

            ##### Check to see if more than one site script is returned
            if ($SiteScripts.Length -gt 0)
            {
                $SiteScript = Get-PnPSiteScript -Identity $SiteScripts[0].Id
            }
            ##### End of Check
        }
        catch
        {
            if ($Error[0].Exception.Message -eq 'Site Script Not Found')
            {
                $Message = "The Site Script, $($Title), does not exist."
                New-M365DSCLogEntry -Message $Message `
                    -Exception $_ `
                    -Source $MyInvocation.MyCommand.ModuleName
                throw $Message
            }
        }
    }
    if ($Ensure -ne 'Absent')
    {
        Write-Verbose -Message "Site Script, {$Title} already exists, updating its settings"

        try
        {
            # The Site Script exists and it shouldn't
            [Array]$SiteScripts = Get-PnPSiteScript | Where-Object -FilterScript { $_.Title -eq $Title } -ErrorAction SilentlyContinue

            ##### Check to see if more than one site script is returned
            if ($SiteScripts.Length -gt 0)
            {
                #
                #the only way to get the $content is to query the site again, but this time with the ID and not the Title like above
                $UpdateParams = @{
                    Id          = $SiteScripts[0].Id
                    Title       = $Title
                    Content     = $Content
                    Description = $Description
                }
            }

            ##### End of Check
            if ($null -ne $UpdateParams)
            {
                $UpdateParams = Remove-NullEntriesFromHashtable -Hash $UpdateParams
                Set-PnPSiteScript @UpdateParams -ErrorAction Stop
            }
        }
        catch
        {
            Write-Warning -Message "Unable to update Site Script, {$Title}"
        }
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
        $Title,

        [Parameter()]
        [System.String]
        $Identity,

        [Parameter()]
        [System.String]
        $Content,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure = 'Present',

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
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

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

    Write-Verbose -Message "Testing configuration for Site Script $Title"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $CurrentValues.Remove('Credential') | Out-Null
    $keysToCheck = $CurrentValues.Keys
    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $keysToCheck

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
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
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

        $dscContent = ''
        $i = 1

        [array]$siteScripts = Get-PnPSiteScript -ErrorAction Stop

        if ($siteScripts.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($script in $siteScripts)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    [$i/$($siteScripts.Length)] $($script.Title)" -NoNewline
            $params = @{
                Identity              = $script.Id
                Title                 = $script.Title
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                Credential            = $Credential
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params
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
