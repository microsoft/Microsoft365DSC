function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SiteDesignTitle,

        [Parameter()]
        [System.String[]]
        $UserPrincipals,

        [Parameter(Mandatory = $true)]
        [ValidateSet('View', 'None')]
        [System.String]
        $Rights,

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

    Write-Verbose -Message "Getting configuration for SPO SiteDesignRights for $SiteDesignTitle"

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

    $nullReturn = $PSBoundParameters
    $nullReturn.Ensure = 'Absent'

    try
    {
        Write-Verbose -Message "Getting Site Design Rights for $SiteDesignTitle"

        $siteDesign = Get-PnPSiteDesign -Identity $SiteDesignTitle -ErrorAction Stop
        if ($null -eq $siteDesign)
        {
            throw "Site Design with title $SiteDesignTitle doesn't exist in tenant"
        }

        Write-Verbose -Message "Site Design ID is $($siteDesign.Id)"

        $siteDesignRights = Get-PnPSiteDesignRights -Identity $siteDesign.Id -ErrorAction SilentlyContinue | `
                Where-Object -FilterScript { $_.Rights -eq $Rights }

        if ($null -eq $siteDesignRights)
        {
            Write-Verbose -Message "No Site Design Rights exist for site design $SiteDesignTitle."
            return $nullReturn
        }

        $curUserPrincipals = @()

        foreach ($siteDesignRight in $siteDesignRights)
        {
            $curUserPrincipals += $siteDesignRight.PrincipalName.split('|')[2]
        }

        Write-Verbose -Message "Site Design Rights User Principals = $($curUserPrincipals)"
        return @{
            SiteDesignTitle       = $SiteDesignTitle
            UserPrincipals        = $curUserPrincipals
            Rights                = $Rights
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
        $SiteDesignTitle,

        [Parameter()]
        [System.String[]]
        $UserPrincipals,

        [Parameter(Mandatory = $true)]
        [ValidateSet('View', 'None')]
        [System.String]
        $Rights,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'PNP' `
        -InboundParameters $PSBoundParameters

    $cursiteDesign = Get-PnPSiteDesign -Identity $SiteDesignTitle
    if ($null -eq $cursiteDesign)
    {
        throw "Site Design with title $SiteDesignTitle doesn't exist in tenant"
    }

    $currentSiteDesignRights = Get-TargetResource @PSBoundParameters
    $CurrentParameters = $PSBoundParameters

    if ($currentSiteDesignRights.Ensure -eq 'Present')
    {
        $difference = Compare-Object -ReferenceObject $currentSiteDesignRights.UserPrincipals -DifferenceObject $CurrentParameters.UserPrincipals

        if ($difference.InputObject)
        {
            Write-Verbose -Message 'Detected a difference in the current design rights of user principals and the desired one'
            $principalsToRemove = @()
            $principalsToAdd = @()
            foreach ($diff in $difference)
            {
                if ($diff.SideIndicator -eq '<=')
                {
                    $principalsToRemove += $diff.InputObject
                }
                elseif ($diff.SideIndicator -eq '=>')
                {
                    $principalsToAdd += $diff.InputObject
                }
            }

            if ($principalsToAdd.Count -gt 0 -and $Ensure -eq 'Present')
            {
                Write-Verbose -Message "Granting SiteDesign rights on site design $SiteDesignTitle"
                Grant-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $principalsToAdd -Rights $Rights
            }

            if ($principalsToRemove.Count -gt 0)
            {
                Write-Verbose -Message "Revoking SiteDesign rights on $principalsToRemove for site design $SiteDesignTitle with Id $($cursiteDesign.Id)"
                Revoke-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $principalsToRemove
            }
        }
    }
    if ($Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Revoking SiteDesign rights on  $UserPrincipals for site design $SiteDesignTitle"
        Revoke-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $UserPrincipals
    }

    #No site design rights currently exist so add them
    If ($currentSiteDesignRights.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Granting SiteDesign rights on site design $SiteDesignTitle"
        Grant-PnPSiteDesignRights -Identity $cursiteDesign.Id -Principals $UserPrincipals -Rights $Rights
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
        $SiteDesignTitle,

        [Parameter()]
        [System.String[]]
        $UserPrincipals,

        [Parameter(Mandatory = $true)]
        [ValidateSet('View', 'None')]
        [System.String]
        $Rights,

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

    Write-Verbose -Message "Testing configuration for SPO SiteDesignRights for $SiteDesignTitle"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck @('UserPrincipals', `
            'Rights', `
            'Ensure')

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

        [array]$siteDesigns = Get-PnPSiteDesign -ErrorAction Stop

        $dscContent = ''
        $i = 1
        if ($siteDesigns.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($siteDesign in $siteDesigns)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-Host "    |---[$i/$($siteDesigns.Count)] $($siteDesign.Title)" -NoNewline

            $Params = @{
                SiteDesignTitle       = $siteDesign.Title
                Rights                = 'View'
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
            if ($Results.Ensure -eq 'Present')
            {
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
            }

            $Params = @{
                SiteDesignTitle       = $siteDesign.Title
                Rights                = 'None'
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificatePassword   = $CertificatePassword
                CertificatePath       = $CertificatePath
                CertificateThumbprint = $CertificateThumbprint
                Credential            = $Credential
                ManagedIdentity       = $ManagedIdentity
                AccessTokens          = $AccessTokens
            }
            $Results = Get-TargetResource @Params
            if ($Results.Ensure -eq 'Present')
            {
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
            }
            Write-Host $Global:M365DSCEmojiGreenCheckmark
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
