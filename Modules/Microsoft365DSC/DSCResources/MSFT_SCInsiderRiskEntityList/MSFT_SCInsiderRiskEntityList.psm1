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
        [System.Management.Infrastructure.CimInstance[]]
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
        [System.Management.Infrastructure.CimInstance[]]
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

    Write-Verbose -Message "Start Set-TargetResource"
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
        # Create a new Domain Group
        if ($ListType -eq 'CustomDomainLists')
        {
            $value = @()
            foreach ($domain in $Domains)
            {
                $value += "{`"Dmn`":`"$($domain.Dmn)`",`"isMLSubDmn`":$($domain.isMLSubDmn.ToString().ToLower())}"
            }
            Write-Verbose -Message "Creating new Domain Group {$Name} with values {$($value -join ',')}"
            New-InsiderRiskEntityList -Type 'CustomDomainLists' `
                                      -Name $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -Entities $value | Out-Null
        }
        elseif ($ListType -eq 'CustomFilePathRegexLists')
        {
            $value = @()
            foreach ($filePath in $FilePaths)
            {
                $value += "{`"FlPthRgx`":`"$($filePath.Replace('\', '\\'))`",`"isSrc`":true,`"isTrgt`":true}"
            }
            Write-Verbose -Message "Creating new FilePath Group {$Name} with values {$($value -join ',')}"
            New-InsiderRiskEntityList -Type 'CustomFilePathRegexLists' `
                                      -Name $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -Entities $value | Out-Null
        }
        elseif ($ListType -eq 'CustomFileTypeLists')
        {
            $value = @()
            foreach ($fileType in $FileTypes)
            {
                $value += "{`"Ext`":`"$fileType`"}"
            }
            Write-Verbose -Message "Creating new FileType Group {$Name} with values {$($value -join ',')}"
            New-InsiderRiskEntityList -Type 'CustomFileTypeLists ' `
                                      -Name $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -Entities $value | Out-Null
        }
        elseif ($ListType -eq 'CustomKeywordLists')
        {
            $value = @()
            foreach ($keyword in $Keywords)
            {
                $value += "{`"Name`":`"$keyword`"}"
            }
            Write-Verbose -Message "Creating new Keyword Group {$Name} with values {$($value -join ',')}"
            New-InsiderRiskEntityList -Type 'CustomKeywordLists' `
                                      -Name $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -Entities $value | Out-Null
        }
        elseif ($ListType -eq 'CustomSensitiveInformationTypeLists')
        {
            $value = @()
            foreach ($sit in $SensitiveInformationTypes)
            {
                $value += "{`"Guid`":`"$sit`"}"
            }
            Write-Verbose -Message "Creating new SIT Group {$Name} with values {$($value -join ',')}"
            New-InsiderRiskEntityList -Type 'CustomSensitiveInformationTypeLists' `
                                      -Name $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -Entities $value | Out-Null
        }
        elseif ($ListType -eq 'CustomSiteLists')
        {
            $value = @()
            foreach ($site in $Sites)
            {
                $value += "{`"Url`":`"$($site.Url)`";`"Name`":`"$($site.Name)`";`"Guid`":`"$($site.Guid)`"}"
            }
            Write-Verbose -Message "Creating new Site Group {$Name} with values {$($value -join ',')}"
            New-InsiderRiskEntityList -Type 'CustomSiteLists' `
                                      -Name $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -Entities $value | Out-Null
        }
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        # Update Domain Group
        if ($ListType -eq 'CustomDomainLists')
        {
            $entitiesToAdd = @()
            $entitiesToRemove = @()
            $differences = Compare-Object -ReferenceObject $currentInstance.Domains.Dmn -DifferenceObject $Domains.Dmn
            foreach ($diff in $differences)
            {
                if ($diff.SideIndicator -eq '=>')
                {
                    $instance = $Domains | Where-Object -FilterScript {$_.Dmn -eq $diff.InputObject}
                    $entitiesToAdd += "{`"Dmn`":`"$($instance.Dmn)`",`"isMLSubDmn`":$($instance.isMLSubDmn.ToString().ToLower())}"
                }
                else
                {
                    $instance = $currentInstance.Domains | Where-Object -FilterScript {$_.Dmn -eq $diff.InputObject}
                    $entitiesToRemove += "{`"Dmn`":`"$($instance.Dmn)`",`"isMLSubDmn`":$($instance.isMLSubDmn.ToString().ToLower())}"
                }
            }

            Write-Verbose -Message "Updating Domain Group {$Name}"
            Write-Verbose -Message "Adding entities: $($entitiesToAdd -join ',')"
            Write-Verbose -Message "Removing entities: $($entitiesToRemove -join ',')"

            Set-InsiderRiskEntityList -Identity $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -AddEntities $entitiesToAdd `
                                      -RemoveEntities $entitiesToRemove | Out-Null
        }
        # Update File Path Group
        elseif ($ListType -eq 'CustomFilePathRegexLists')
        {
            $entitiesToAdd = @()
            $entitiesToRemove = @()
            $differences = Compare-Object -ReferenceObject $currentInstance.FilePaths -DifferenceObject $FilePaths
            foreach ($diff in $differences)
            {
                if ($diff.SideIndicator -eq '=>')
                {
                    $entitiesToAdd += "{`"FlPthRgx`":`"$($diff.InputObject.Replace('\', '\\'))`",`"isSrc`":true,`"isTrgt`":true}"
                }
                else
                {
                    $entitiesToRemove += "{`"FlPthRgx`":`"$($diff.InputObject.Replace('\', '\\'))`",`"isSrc`":true,`"isTrgt`":true}"
                }
            }

            Write-Verbose -Message "Updating File Path Group {$Name}"
            Write-Verbose -Message "Adding entities: $($entitiesToAdd -join ',')"
            Write-Verbose -Message "Removing entities: $($entitiesToRemove -join ',')"

            Set-InsiderRiskEntityList -Identity $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -AddEntities $entitiesToAdd `
                                      -RemoveEntities $entitiesToRemove | Out-Null
        }
        # Update File Type Group
        elseif ($ListType -eq 'CustomFileTypeLists')
        {
            $entitiesToAdd = @()
            $entitiesToRemove = @()
            $differences = Compare-Object -ReferenceObject $currentInstance.FileTypes -DifferenceObject $FileTypes
            foreach ($diff in $differences)
            {
                if ($diff.SideIndicator -eq '=>')
                {
                    $entitiesToAdd += "{`"Ext`":`"$($diff.InputObject)`"}"
                }
                else
                {
                    $entitiesToRemove += "{`"Ext`":`"$($diff.InputObject)`"}"
                }
            }

            Write-Verbose -Message "Updating File Type Group {$Name}"
            Write-Verbose -Message "Adding entities: $($entitiesToAdd -join ',')"
            Write-Verbose -Message "Removing entities: $($entitiesToRemove -join ',')"

            Set-InsiderRiskEntityList -Identity $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -AddEntities $entitiesToAdd `
                                      -RemoveEntities $entitiesToRemove | Out-Null
        }
        # Update Keywords Group
        elseif ($ListType -eq 'CustomKeywordLists')
        {
            $entitiesToAdd = @()
            $entitiesToRemove = @()
            $differences = Compare-Object -ReferenceObject $currentInstance.Keywords -DifferenceObject $Keywords
            foreach ($diff in $differences)
            {
                if ($diff.SideIndicator -eq '=>')
                {
                    $entitiesToAdd += "{`"Name`":`"$($diff.InputObject)`"}"
                }
                else
                {
                    $entitiesToRemove += "{`"Name`":`"$($diff.InputObject)`"}"
                }
            }

            Write-Verbose -Message "Updating Keyword Group {$Name}"
            Write-Verbose -Message "Adding entities: $($entitiesToAdd -join ',')"
            Write-Verbose -Message "Removing entities: $($entitiesToRemove -join ',')"

            Set-InsiderRiskEntityList -Identity $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -AddEntities $entitiesToAdd `
                                      -RemoveEntities $entitiesToRemove | Out-Null
        }
        # Update SIT Group
        elseif ($ListType -eq 'CustomSensitiveInformationTypeLists')
        {
            $entitiesToAdd = @()
            $entitiesToRemove = @()
            $differences = Compare-Object -ReferenceObject $currentInstance.SensitiveInformationTypes -DifferenceObject $SensitiveInformationTypes
            foreach ($diff in $differences)
            {
                if ($diff.SideIndicator -eq '=>')
                {
                    $entitiesToAdd += "{`"Guid`":`"$($diff.InputObject)`"}"
                }
                else
                {
                    $entitiesToRemove += "{`"Guid`":`"$($diff.InputObject)`"}"
                }
            }

            Write-Verbose -Message "Updating SIT Group {$Name}"
            Write-Verbose -Message "Adding entities: $($entitiesToAdd -join ',')"
            Write-Verbose -Message "Removing entities: $($entitiesToRemove -join ',')"

            Set-InsiderRiskEntityList -Identity $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -AddEntities $entitiesToAdd `
                                      -RemoveEntities $entitiesToRemove | Out-Null
        }
        # Update Sites Group
        elseif ($ListType -eq 'CustomSiteLists')
        {
            $entitiesToAdd = @()
            $entitiesToRemove = @()
            $differences = Compare-Object -ReferenceObject $currentInstance.Sites.Url -DifferenceObject $Sites.Url
            foreach ($diff in $differences)
            {
                if ($diff.SideIndicator -eq '=>')
                {
                    $entry = $Sites | Where-Object -FilterScript {$_.Url -eq $diff.InputObject}
                    $entitiesToAdd += "{`"Url`":`"$($entry.Url)`";`"Name`":`"$($entry.Name)`";`"Guid`":`"$($entry.Guid)`"}"
                }
                else
                {
                    $entry = $currentInstance.Sites | Where-Object -FilterScript {$_.Url -eq $diff.InputObject}
                    $entitiesToRemove += "{`"Url`":`"$($entry.Url)`";`"Name`":`"$($entry.Name)`";`"Guid`":`"$($entry.Guid)`"}"
                }
            }

            Write-Verbose -Message "Updating Sites Group {$Name}"
            Write-Verbose -Message "Adding entities: $($entitiesToAdd -join ',')"
            Write-Verbose -Message "Removing entities: $($entitiesToRemove -join ',')"

            Set-InsiderRiskEntityList -Identity $Name `
                                      -DisplayName $DisplayName `
                                      -Description $Description `
                                      -AddEntities $entitiesToAdd `
                                      -RemoveEntities $entitiesToRemove | Out-Null
        }
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
        [System.Management.Infrastructure.CimInstance[]]
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
    $ValuesToCheck.Remove('Name') | Out-Null

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
