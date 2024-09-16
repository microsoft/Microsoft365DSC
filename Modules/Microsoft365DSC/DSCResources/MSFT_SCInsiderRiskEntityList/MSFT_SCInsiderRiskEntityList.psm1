function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ListType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Domains,

        [Parameter()]
        [System.String[]]
        $FilePaths,

        [Parameter()]
        [System.String[]]
        $FileTypes,

        [Parameter()]
        [System.String[]]
        $Keywords,

        [Parameter()]
        [System.String[]]
        $SensitiveInformationTypes,

        [Parameter()]
        [System.String[]]
        $Sites,

        [Parameter()]
        [System.String[]]
        $TrainableClassifiers,

        [Parameter()]
        [System.String[]]
        $ExceptionKeyworkGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedClassifierGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedDomainGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedFilePathGroup,

        [Parameter()]
        [System.String[]]
        $ExcludedFileTypeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedKeyworkGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedSensitiveInformationTypeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedSiteGroups,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    ##TODO - Replace the workload by the one associated to your resource
    New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $instance = Get-InsiderRiskEntityList -Identity $Name -ErrorAction Stop

        if ($null -eq $instance)
        {
            return $nullResult
        }

        # CustomDomainLists
        $DmnValues = @()
        if ($instance.ListType -eq 'CustomDomainLists' -or `
            $instance.Name -eq 'IrmWhitelistDomains')
        {
            foreach ($entity in $instance.Entities)
            {
                $entity = ConvertFrom-Json $entity
                $current = @{
                    Dmn        = $entity.Dmn
                    isMLSubDmn = $entity.isMLSubDmn
                }
                $DmnValues += $current
            }
        }

        # CustomFilePathRegexLists
        $FilePathValues = @()
        if ($instance.ListType -eq 'CustomFilePathRegexLists' -or `
            $instance.Name -eq 'IrmCustomExWinFilePaths')
        {
            foreach ($entity in $instance.Entities)
            {
                $entity = ConvertFrom-Json $entity
                $FilePathValues += $entity.FlPthRgx
            }
        }

        # CustomFileTypeLists
        $FileTypeValues = @()
        if ($instance.ListType -eq 'CustomFileTypeLists')
        {
            foreach ($entity in $instance.Entities)
            {
                $entity = ConvertFrom-Json $entity
                $FileTypeValues += $entity.Ext
            }
        }

        # CustomKeywordLists
        $KeywordValues = @()
        if ($instance.ListType -eq 'CustomKeywordLists' -or `
            $instance.Name -eq 'IrmExcludedKeywords' -or $instance.Name -eq 'IrmNotExcludedKeywords')
        {
            foreach ($entity in $instance.Entities)
            {
                $entity = ConvertFrom-Json $entity
                $KeywordValues += $entity.Name
            }
        }

        # CustomSensitiveInformationTypeLists
        $SITValues = @()
        if ($instance.ListType -eq 'CustomSensitiveInformationTypeLists' -or `
            $instance.Name -eq 'IrmCustomExSensitiveTypes')
        {
            foreach ($entity in $instance.Entities)
            {
                $entity = ConvertFrom-Json $entity
                $SITObject = Get-DLPSensitiveInformationType -Identity $entity.GUID
                $SITValues += $SITObject.Name
            }
        }

        # CustomSiteLists
        $SiteValues = @()
        if ($instance.ListType -eq 'CustomSiteLists' -or `
            $instance.Name -eq 'IrmExcludedSites')
        {
            foreach ($entity in $instance.Entities)
            {
                $entity = ConvertFrom-Json $entity
                $SiteValues += $entity.Url
            }
        }

        # CustomMLClassifierTypeLists
        $TrainableClassifierValues = @()
        if ($instance.ListType -eq 'CustomMLClassifierTypeLists' -or $instance.Name -eq 'IrmCustomExMLClassifiers')
        {
            foreach ($entity in $instance.Entities)
            {
                $entity = ConvertFrom-Json $entity
                $SiteValues += $entity.Url
            }
        }

        # Global Exclusions - Excluded Keyword Groups
        $excludedKeywordGroupValue = @()
        if ($instance.Name -eq 'IrmXSGExcludedKeywords')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $excludedKeywordGroupValue += $group.DisplayName
            }
        }

        # Global Exclusions - Exception Keyword Groups
        $exceptionKeywordGroupValue = @()
        if ($instance.Name -eq 'IrmXSGExceptionKeywords')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $exceptionKeywordGroupValue += $group.DisplayName
            }
        }

        # Global Exclusions - Excluded Classifier Groups
        $excludedClassifierGroupValue = @()
        if ($instance.Name -eq 'IrmXSGMLClassifierTypes')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $excludedClassifierGroupValue += $group.DisplayName
            }
        }

        # Global Exclusions - Excluded Domain Groups
        $excludedDomainGroupValue = @()
        if ($instance.Name -eq 'IrmXSGDomains')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $excludedDomainGroupValue += $group.DisplayName
            }
        }

        # Global Exclusions - Excluded File Path Groups
        $excludedFilePathGroupValue = @()
        if ($instance.Name -eq 'IrmXSGFilePaths')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $excludedFilePathGroupValue += $group.DisplayName
            }
        }

        # Global Exclusions - Excluded Site Groups
        $excludedSiteGroupValue = @()
        if ($instance.Name -eq 'IrmXSGSites')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $excludedSiteGroupValue += $group.DisplayName
            }
        }

        # Global Exclusions - Excluded Sensitive Info Type Groups
        $excludedSITGroupValue = @()
        if ($instance.Name -eq 'IrmXSGSensitiveInfoTypes')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $excludedSITGroupValue += $group.DisplayName
            }
        }

        # Global Exclusions - Excluded File Type Groups
        $excludedFileTypeGroupValue = @()
        if ($instance.Name -eq 'IrmXSGFiletypes')
        {
            $entities = $instance.Entities
            foreach ($entity in $entities)
            {
                $entity = ConvertFrom-Json $entity
                $group = Get-InsiderRiskEntityList -Identity $entity.GroupId
                $excludedFileTypeGroupValue += $group.DisplayName
            }
        }

        $results = @{
            DisplayName                            = $instance.DisplayName
            Name                                   = $instance.Name
            Description                            = $instance.Description
            ListType                               = $instance.ListType
            Domains                                = $DmnValues
            FilePaths                              = $FilePathValues
            FileTypes                              = $FileTypeValues
            Keywords                               = $KeywordValues
            SensitiveInformationTypes              = $SITValues
            Sites                                  = $SiteValues
            #TrainableClassifiers                  =
            ExcludedKeyworkGroups                  = $excludedKeywordGroupValue
            ExceptionKeyworkGroups                 = $exceptionKeywordGroupValue
            ExcludedClassifierGroups               = $excludedClassifierGroupValue
            ExcludedDomainGroups                   = $excludedDomainGroupValue
            ExcludedFilePathGroup                  = $excludedFilePathGroupValue
            ExcludedSiteGroups                     = $excludedSiteGroupValue
            ExcludedSensitiveInformationTypeGroups = $excludedSITGroupValue
            ExcludedFileTypeGroups                 = $excludedFileTypeGroupValue
            Ensure                                 = 'Present'
            Credential                             = $Credential
            ApplicationId                          = $ApplicationId
            TenantId                               = $TenantId
            CertificateThumbprint                  = $CertificateThumbprint
            ManagedIdentity                        = $ManagedIdentity.IsPresent
            AccessTokens                           = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $ListType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Domains,

        [Parameter()]
        [System.String[]]
        $FilePaths,

        [Parameter()]
        [System.String[]]
        $FileTypes,

        [Parameter()]
        [System.String[]]
        $Keywords,

        [Parameter()]
        [System.String[]]
        $SensitiveInformationTypes,

        [Parameter()]
        [System.String[]]
        $Sites,

        [Parameter()]
        [System.String[]]
        $TrainableClassifiers,

        [Parameter()]
        [System.String[]]
        $ExceptionKeyworkGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedClassifierGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedDomainGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedFilePathGroup,

        [Parameter()]
        [System.String[]]
        $ExcludedFileTypeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedKeyworkGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedSensitiveInformationTypeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedSiteGroups,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $setParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        ##TODO - Replace by the New cmdlet for the resource
        New-Cmdlet @SetParameters
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Update/Set cmdlet for the resource
        Set-cmdlet @SetParameters
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        ##TODO - Replace by the Remove cmdlet for the resource
        Remove-cmdlet @SetParameters
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

        [Parameter(Mandatory = $true)]
        [System.String]
        $ListType,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Domains,

        [Parameter()]
        [System.String[]]
        $FilePaths,

        [Parameter()]
        [System.String[]]
        $FileTypes,

        [Parameter()]
        [System.String[]]
        $Keywords,

        [Parameter()]
        [System.String[]]
        $SensitiveInformationTypes,

        [Parameter()]
        [System.String[]]
        $Sites,

        [Parameter()]
        [System.String[]]
        $TrainableClassifiers,

        [Parameter()]
        [System.String[]]
        $ExceptionKeyworkGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedClassifierGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedDomainGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedFilePathGroup,

        [Parameter()]
        [System.String[]]
        $ExcludedFileTypeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedKeyworkGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedSensitiveInformationTypeGroups,

        [Parameter()]
        [System.String[]]
        $ExcludedSiteGroups,

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).Clone()

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $testResult"

    return $testResult
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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'SecurityComplianceCenter' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = @()
        $availableTypes = @('HveLists', 'DomainLists', 'CriticalAssetLists', 'WindowsFilePathRegexLists', 'SensitiveTypeLists', 'SiteLists', 'KeywordLists', `
                            'CustomDomainLists', 'CustomSiteLists', 'CustomKeywordLists', 'CustomFileTypeLists', 'CustomFilePathRegexLists', `
                            'CustomSensitiveInformationTypeLists', 'CustomMLClassifierTypeLists', 'GlobalExclusionSGMapping', 'DlpPolicyLists')

        # Retrieve entries for each type
        foreach ($listType in $availableTypes)
        {
            $Script:exportedInstances += Get-InsiderRiskEntityList -Type $listType -ErrorAction Stop
        }

        $i = 1
        $dscContent = ''
        if ($Script:exportedInstances.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $Script:exportedInstances)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            $displayedKey = $config.ListType + ' - ' + $config.Name
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
            $params = @{
                DisplayName           = $config.DisplayName
                Name                  = $config.Name
                ListType              = $config.ListType
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
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
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
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
