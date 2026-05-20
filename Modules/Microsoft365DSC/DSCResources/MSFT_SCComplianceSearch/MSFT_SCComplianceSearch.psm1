Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SCComplianceSearch'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter()]
        [System.String]
        $Case,

        [Parameter()]
        [System.Boolean]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.String[]]
        $HoldNames,

        [Parameter()]
        [System.Boolean]
        $IncludeUserAppContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationExclusion,

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

    Write-Verbose -Message "Getting configuration of SCComplianceSearch for $Name"

    try
    {
        if (-not $Script:exportedInstance -or $Script:exportedInstance.Name -ne $Name)
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

            if ($null -eq $Case)
            {
                $Search = Invoke-M365DSCCommand -ScriptBlock { Get-ComplianceSearch -Identity $Name -ErrorAction Stop } -SuppressNotFoundError
            }
            else
            {
                $Search = Invoke-M365DSCCommand -ScriptBlock { Get-ComplianceSearch -Identity $Name -Case $Case -ErrorAction Stop } -SuppressNotFoundError
            }

            if ($null -eq $Search)
            {
                Write-Verbose -Message "SCComplianceSearch $($Name) does not exist."
                return $nullReturn
            }
        }
        else
        {
            $Search = $Script:exportedInstance
        }

        Write-Verbose "Found existing SCComplianceSearch $($Name)"

        $result = @{
            Name                                  = $Name
            Case                                  = $Case
            AllowNotFoundExchangeLocationsEnabled = $Search.AllowNotFoundExchangeLocationsEnabled
            ContentMatchQuery                     = $Search.ContentMatchQuery
            Description                           = $Search.Description
            ExchangeLocation                      = $Search.ExchangeLocation
            ExchangeLocationExclusion             = $Search.ExchangeLocationExclusion
            HoldNames                             = $Search.HoldNames
            IncludeUserAppContent                 = $Search.IncludeUserAppContent
            Language                              = $Search.Language.TwoLetterISOLanguageName
            PublicFolderLocation                  = $Search.PublicFolderLocation
            SharePointLocation                    = $Search.SharePointLocation
            SharePointLocationExclusion           = $Search.SharePointLocationExclusion
            Credential                            = $Credential
            ApplicationId                         = $ApplicationId
            TenantId                              = $TenantId
            CertificateThumbprint                 = $CertificateThumbprint
            CertificatePath                       = $CertificatePath
            CertificatePassword                   = $CertificatePassword
            Ensure                                = 'Present'
            AccessTokens                          = $AccessTokens
        }

        $nullParams = @()
        foreach ($parameter in $result.Keys)
        {
            if ($null -eq $result.$parameter)
            {
                $nullParams += $parameter
            }
        }

        foreach ($paramToRemove in $nullParams)
        {
            $result.Remove($paramToRemove)
        }

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
        $Name,

        [Parameter()]
        [System.String]
        $Case,

        [Parameter()]
        [System.Boolean]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.String[]]
        $HoldNames,

        [Parameter()]
        [System.Boolean]
        $IncludeUserAppContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationExclusion,

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

    Write-Verbose -Message "Setting configuration of SCComplianceSearch for $Name"

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

    $CurrentSearch = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq 'Present' -and $CurrentSearch.Ensure -eq 'Absent')
    {
        $CreationParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        Write-Verbose "Creating new Compliance Search $Name calling the New-ComplianceSearch cmdlet."
        New-ComplianceSearch @CreationParams
    }
    elseif ($Ensure -eq 'Present' -and $CurrentSearch.Ensure -eq 'Present')
    {
        $SetParams = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

        # Remove unused parameters for Set-ComplianceSearch cmdlet
        $SetParams.Remove('Name')
        $SetParams.Remove('Case')

        Set-ComplianceSearch @SetParams -Identity $Name
    }
    elseif ($Ensure -eq 'Absent' -and $CurrentSearch.Ensure -eq 'Present')
    {
        # If the Search exists and it shouldn't, simply remove it;
        Remove-ComplianceSearch -Identity $Name -Confirm:$false
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
        $Name,

        [Parameter()]
        [System.String]
        $Case,

        [Parameter()]
        [System.Boolean]
        $AllowNotFoundExchangeLocationsEnabled,

        [Parameter()]
        [System.String]
        $ContentMatchQuery,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String[]]
        $ExchangeLocation,

        [Parameter()]
        [System.String[]]
        $ExchangeLocationExclusion,

        [Parameter()]
        [System.String[]]
        $HoldNames,

        [Parameter()]
        [System.Boolean]
        $IncludeUserAppContent,

        [Parameter()]
        [System.String]
        $Language,

        [Parameter()]
        [System.String[]]
        $PublicFolderLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocation,

        [Parameter()]
        [System.String[]]
        $SharePointLocationExclusion,

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
        [array]$searches = Get-ComplianceSearch -ErrorAction Stop

        if ($searches.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n    * Searches not assigned to an eDiscovery Case`r`n" -DeferWrite
        }
        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        foreach ($search in $searches)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            Write-M365DSCHost -Message "        |---[$i/$($searches.Name.Count)] $($search.Name)" -DeferWrite

            $Script:exportedInstance = $search
            $Results = Get-TargetResource @PSBoundParameters -Name $search.Name
            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            [void]$dscContent.Append($currentDSCBlock)
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            $i++
        }

        $cases = Get-ComplianceCase
        $j = 1

        foreach ($case in $cases)
        {
            $searches = Get-ComplianceSearch -Case $case.Name

            Write-M365DSCHost -Message "`r`n    * [$j/$($cases.Length)] Searches assigned to case $($case.Name)`r`n" -DeferWrite
            $i = 1
            foreach ($search in $searches)
            {
                $Params = @{
                    Name                  = $search.Name
                    Case                  = $case.Name
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    CertificatePath       = $CertificatePath
                    CertificatePassword   = $CertificatePassword
                    AccessTokens          = $AccessTokens
                }
                Write-M365DSCHost -Message "        |---[$i/$($searches.Name.Count)] $($search.Name)" -DeferWrite
                $Results = Get-TargetResource @Params

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

Export-ModuleMember -Function *-TargetResource
