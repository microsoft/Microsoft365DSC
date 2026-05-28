Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOSiteDesignRights'

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

    Write-Verbose -Message "Getting configuration for SPO SiteDesignRights for $SiteDesignTitle"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Title -ne $SiteDesignTitle)
        {
            $null = New-M365DSCConnection -Workload 'PNP' `
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

            Write-Verbose -Message "Getting Site Design Rights for $SiteDesignTitle"
            $siteDesign = Get-PnPSiteDesign -Identity $SiteDesignTitle -ErrorAction Stop
            if ($null -eq $siteDesign)
            {
                throw "Site Design with title $SiteDesignTitle doesn't exist in tenant"
            }
        }
        else
        {
            $siteDesign = $Script:exportedInstance
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
            $curUserPrincipals += $siteDesignRight.PrincipalName.Split('|')[2]
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
            CertificateThumbprint = $CertificateThumbprint
            CertificatePath       = $CertificatePath
            CertificatePassword   = $CertificatePassword
            ManagedIdentity       = $ManagedIdentity.IsPresent
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

    $null = New-M365DSCConnection -Workload 'PNP' `
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
    if ($currentSiteDesignRights.Ensure -eq 'Absent')
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

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $compareParameters = Get-CompareParameters
    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $($MyInvocation.MyCommand.Source).Replace('MSFT_', '') `
        @compareParameters
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

        $dscContent = [System.Text.StringBuilder]::new()
        $i = 1
        if ($siteDesigns.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($siteDesign in $siteDesigns)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "    |---[$i/$($siteDesigns.Count)] $($siteDesign.Title)" -DeferWrite

            $Params = @{
                SiteDesignTitle       = $siteDesign.Title
                Rights                = 'View'
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                Credential            = $Credential
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $siteDesign
            $Results = Get-TargetResource @Params
            if ($Results.Ensure -eq 'Present')
            {
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                [void]$dscContent.Append($currentDSCBlock)

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

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                [void]$dscContent.Append($currentDSCBlock)

                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
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

function Get-CompareParameters
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param()

    return @{
        ExcludedProperties = @('SiteDesignTitle')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
