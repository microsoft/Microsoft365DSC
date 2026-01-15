Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SPOApp'

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
        $Path,

        [Parameter()]
        [System.Boolean]
        $Publish = $true,

        [Parameter()]
        [System.Boolean]
        $Overwrite = $true,

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

    Write-Verbose -Message "Getting configuration for app $Identity"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Title -ne $Identity)
        {
            $null = New-M365DSCConnection -Workload 'PnP' `
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

            $app = Get-PnPApp -Identity $Identity -ErrorAction SilentlyContinue
        }
        else
        {
            $app = $Script:exportedInstance
        }

        if ($null -eq $app)
        {
            Write-Verbose -Message "The specified app wasn't found."
            return $nullReturn
        }

        return @{
            Identity              = $app.Title
            Path                  = $Path
            Publish               = $app.Deployed
            Overwrite             = $Overwrite
            Ensure                = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificatePassword   = $CertificatePassword
            CertificatePath       = $CertificatePath
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            Credential            = $Credential
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
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter()]
        [System.Boolean]
        $Publish = $true,

        [Parameter()]
        [System.Boolean]
        $Overwrite = $true,

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

    Write-Verbose -Message "Setting configuration for app $Identity"

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

    $currentApp = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentApp.Ensure -eq 'Present' -and $Overwrite -eq $false)
    {
        throw "The app already exists in the Catalog. To overwrite it, please make sure you set the Overwrite property to 'true'."
    }
    elseif ($Ensure -eq 'Present')
    {
        Write-Verbose -Message "Adding app instance $Identity"
        Add-PnPApp -Path $Path -Overwrite:$true
    }
    elseif ($Ensure -eq 'Absent' -and $currentApp.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing app instance $Identity"
        Remove-PnPApp -Identity $Identity
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
        $Path,

        [Parameter()]
        [System.Boolean]
        $Publish = $true,

        [Parameter()]
        [System.Boolean]
        $Overwrite = $true,

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

        $tenantAppCatalogUrl = Get-PnPTenantAppCatalogUrl -ErrorAction Stop

        if (-not [string]::IsNullOrEmpty($tenantAppCatalogUrl))
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'PnP' `
                -InboundParameters $PSBoundParameters `
                -Url $tenantAppCatalogUrl

            if ($ConnectionMode -eq 'Credentials')
            {
                [array]$filesToDownload = Get-AllSPOPackages -Credential $Credential
            }
            else
            {
                # mlh
                [array]$filesToDownload = Get-AllSPOPackages -ApplicationId $ApplicationId -CertificateThumbprint $CertificateThumbprint `
                    -CertificatePassword $CertificatePassword -TenantId $TenantId -CertificatePath $CertificatePath -ManagedIdentity:$ManagedIdentity.IsPresent
            }
            $tenantAppCatalogPath = $tenantAppCatalogUrl.Replace('https://', '')
            $tenantAppCatalogPath = $tenantAppCatalogPath.Replace($tenantAppCatalogPath.Split('/')[0], '')

            $dscContent = ''
            $i = 1

            if ($filesToDownload.Count -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }
            foreach ($file in $filesToDownload)
            {
                Write-M365DSCHost -Message "    |---[$i/$($filesToDownload.Count)] $($file.Name)" -DeferWrite

                $identity = $file.Name.ToLower().Replace('.app', '').Replace('.sppkg', '')
                $app = Get-PnPApp -Identity $identity -ErrorAction SilentlyContinue

                if ($null -eq $app)
                {
                    $identity = $file.Title
                    $app = Get-PnPApp -Identity $file.Title -ErrorAction SilentlyContinue
                }
                if ($null -ne $app)
                {
                    if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                    {
                        $Global:M365DSCExportResourceInstancesCount++
                    }

                    $Params = @{
                        Identity              = $identity
                        Path                  = ("`$PSScriptRoot\" + $file.Name)
                        ApplicationId         = $ApplicationId
                        TenantId              = $TenantId
                        ApplicationSecret     = $ApplicationSecret
                        CertificatePassword   = $CertificatePassword
                        CertificatePath       = $CertificatePath
                        CertificateThumbprint = $CertificateThumbprint
                        ManagedIdentity       = $ManagedIdentity.IsPresent
                        Credential            = $Credential
                        AccessTokens          = $AccessTokens
                    }

                    $Script:exportedInstance = $app
                    $Results = Get-TargetResource @Params
                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential
                    $dscContent += $currentDSCBlock
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                }
                $i++
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }

            foreach ($file in $filesToDownload)
            {
                $appInstanceUrl = $tenantAppCatalogPath + '/AppCatalog/' + $file.Name
                $appFileName = $appInstanceUrl.Split('/')[$appInstanceUrl.Split('/').Length - 1]
                Get-PnPFile -Url $appInstanceUrl -Path $env:Temp -Filename $appFileName -AsFile -Force | Out-Null
            }
        }
        else
        {
            Write-Verbose -Message '    * App Catalog is not configured on tenant. Cannot extract information about SharePoint apps.'
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent
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
        ExcludedProperties = @('Path', 'Publish', 'Overwrite')
    }
}

Export-ModuleMember -Function @('*-TargetResource', 'Get-CompareParameters')
