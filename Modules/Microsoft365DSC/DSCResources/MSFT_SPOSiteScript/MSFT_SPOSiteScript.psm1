function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory)]
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = "Absent"

    try
    {
        Write-Verbose -Message "Getting the SPO Site Script: $Title"

        #
        if ([System.String]::IsNullOrEmpty($Identity))
        {
            [Array]$SiteScripts = Get-PnPSiteScript -ErrorAction Stop | Where-Object -FilterScript { $_.Title -eq $Title }

            $SiteScript = $null
            ##### Check to see if more than one site script is returned
            if ($SiteScripts.Length -gt -1){
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
            GlobalAdminAccount    = $GlobalAdminAccount
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
        }
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Setting Site Script: $Title"

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $MyInvocation.MyCommand.ModuleName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PnP' `
        -InboundParameters $PSBoundParameters

    # region Telemetry
    $CurrentValues = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("Ensure") | Out-Null
    $CurrentParameters.Remove("GlobalAdminAccount") | Out-Null
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
            Write-Verbose -Message "Waiting for another 3 seconds for Site Script to be ready."
            Start-Sleep -Seconds 3
            try
            {
                $siteScript = Get-PnPSiteScript -Identity $newSiteScript.Id  -ErrorAction Stop
            }
            catch
            {
                $siteScript = $null
            }
            $circuitBreaker++
        } while ($null -eq $siteScript -and $circuitBreaker -lt 20)

        Write-Verbose -Message "Site Script, {$Title}, has been successfully created."
    }
    elseif ($Ensure -eq "Absent" -and $CurrentValues.Ensure -eq 'Present')
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
            if ($Error[0].Exception.Message -eq "Site Script Not Found")
            {
                $Message = "The Site Script, $($Title), does not exist."
                New-M365DSCLogEntry -Error $_ -Message $Message -Source $MyInvocation.MyCommand.ModuleName
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
                    Id          = $SiteScript[0].Id
                    Title       = $Title
                    Content     = $Content
                    Description = $Description
                }
            }

            ##### End of Check
            $UpdateParams = Remove-NullEntriesFromHashtable -Hash $UpdateParams
            Set-PnPSiteScript @UpdateParams -ErrorAction Stop
        }
        catch
        {
            Write-Verbose -Message "Unable to update Site Script, {$Title}"
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
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

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
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing configuration for Site Script $Title"
    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $CurrentValues.Remove("GlobalAdminAccount") | Out-Null
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
        $GlobalAdminAccount,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $InformationPreference = 'Continue'

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add("Resource", $ResourceName)
    $data.Add("Method", $MyInvocation.MyCommand)
    $data.Add("Principal", $GlobalAdminAccount.UserName)
    $data.Add("TenantId", $TenantId)
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $ConnectionMode = New-M365DSCConnection -Platform 'PNP' `
        -InboundParameters $PSBoundParameters

    $content = ""
    $i = 1
    try
    {
        [array]$siteScripts = Get-PnPSiteScript -ErrorAction Stop

        foreach ($script in $siteScripts)
        {
            Write-Information "    [$i/$($siteScripts.Length)] $($script.Title)"
            $params = @{
                Identity              = $script.Id
                Title                 = $script.Title
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                CertificateThumbprint = $CertificateThumbprint
                GlobalAdminAccount    = $GlobalAdminAccount
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

Export-ModuleMember -Function *-TargetResource
