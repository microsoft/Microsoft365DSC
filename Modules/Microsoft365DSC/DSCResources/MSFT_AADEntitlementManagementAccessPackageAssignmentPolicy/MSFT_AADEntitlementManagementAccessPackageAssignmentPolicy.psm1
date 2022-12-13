function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $AccessPackageId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AccessReviewSettings,

        [Parameter()]
        [System.Boolean]
        $CanExtend,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Int32]
        $DurationInDays,

        [Parameter()]
        [system.datetimeoffset]
        $ExpirationDateTime,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Questions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RequestApprovalSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RequestorSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomExtensionHandlers,



        #endregion

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

        Select-MgProfile 'beta'
    }
    catch
    {
        Write-Verbose -Message ($_)
    }

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
        $getValue = $null
        $getValue = Get-MgEntitlementManagementAccessPackageAssignmentPolicy `
            -AccessPackageAssignmentPolicyId $id `
            -ExpandProperty CustomExtensionHandlers `
            -ErrorAction SilentlyContinue

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "The access package assignment policy with id {$id} was not found"
            $getValue = Get-MgEntitlementManagementAccessPackageAssignmentPolicy `
                -DisplayNameEq $DisplayName `
                -ExpandProperty CustomExtensionHandlers `
                -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "The access package assignment policy with displayName {$DisplayName} was not found"
            return $nullResult
        }

        Write-Verbose -Message "Found access package assignment policy with id {$($getValue.Id)} and DisplayName {$DisplayName}"

        $formattedAccessReviewSettings=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.AccessReviewSettings
        if ($null -ne $getValue.AccessReviewSettings.StartDateTime )
        {
            #$formattedAccessReviewSettings.StartDateTime=$getValue.AccessReviewSettings.StartDateTime.ToString()
        }
        if ($null -ne $getValue.AccessReviewSettings.Reviewers -and  $getValue.AccessReviewSettings.Reviewers.count -gt 0 )
        {
            $formattedParameters=@()
            foreach($setting in $getValue.AccessReviewSettings.Reviewers)
            {
                $parameter=@{
                    odataType=$setting.AdditionalProperties."@odata.type"
                    IsBackup=$setting.IsBackup
                }
                if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                {
                    $parameter.add('Id',$setting.AdditionalProperties.id)
                }
                if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                {
                    $parameter.add('ManagerLevel',$setting.AdditionalProperties.managerLevel)
                }
                $formattedParameters+=$parameter
            }
            $formattedAccessReviewSettings.Reviewers=$formattedParameters
        }

        $formattedRequestApprovalSettings=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.RequestApprovalSettings
        if ($null -ne $getValue.RequestApprovalSettings.approvalStages -and  $getValue.RequestApprovalSettings.approvalStages.count -gt 0 )
        {
            $approvalStages=@()
            foreach($approvalStage in $getValue.RequestApprovalSettings.approvalStages)
            {
                $formattedApprovalStage=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $approvalStage
                if($null -ne $approvalStage.PrimaryApprovers -and $approvalStage.PrimaryApprovers.count -gt 0)
                {
                    $formattedParameters=@()
                    foreach($setting in $approvalStage.PrimaryApprovers)
                    {
                        $parameter=@{
                            odataType=$setting.AdditionalProperties."@odata.type"
                            IsBackup=$setting.IsBackup
                        }
                        if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                        {
                            $parameter.add('Id',$setting.AdditionalProperties.id)
                        }
                        if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                        {
                            $parameter.add('ManagerLevel',$setting.AdditionalProperties.managerLevel)
                        }
                        $formattedParameters+=$parameter
                    }
                    $formattedApprovalStage.PrimaryApprovers=$formattedParameters
                }

                if($null -ne $approvalStage.EscalationApprovers -and $approvalStage.EscalationApprovers.count -gt 0)
                {
                    $formattedParameters=@()
                    foreach($setting in $approvalStage.EscalationApprovers)
                    {
                        $parameter=@{
                            odataType=$setting.AdditionalProperties."@odata.type"
                            IsBackup=$setting.IsBackup
                        }
                        if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                        {
                            $parameter.add('Id',$setting.AdditionalProperties.id)
                        }
                        if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                        {
                            $parameter.add('ManagerLevel',$setting.AdditionalProperties.managerLevel)
                        }
                        $formattedParameters+=$parameter
                    }
                    $formattedApprovalStage.EscalationApprovers=$formattedParameters
                }

                $approvalStages+=$formattedApprovalStage
            }

            $formattedRequestApprovalSettings.ApprovalStages=$approvalStages
        }

        $formattedRequestorSettings=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.RequestorSettings
        if ($null -ne $getValue.RequestorSettings.allowedRequestors -and  $getValue.RequestorSettings.allowedRequestors.count -gt 0 )
        {
            $formattedParameters=@()
            foreach($setting in $getValue.RequestorSettings.allowedRequestors)
            {
                $parameter=@{
                    odataType=$setting.AdditionalProperties."@odata.type"
                    IsBackup=$setting.IsBackup
                }
                if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                {
                    $parameter.add('Id',$setting.AdditionalProperties.id)
                }
                if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                {
                    $parameter.add('ManagerLevel',$setting.AdditionalProperties.managerLevel)
                }
                $formattedParameters+=$parameter
            }
            $formattedRequestorSettings.AllowedRequestors=$formattedParameters
        }

        $formattedExpirationDateTime=$getValue.ExpirationDateTime
        if($null -ne $getValue.ExpirationDateTime)
        {
            #$formattedExpirationDateTime=$getValue.ExpirationDateTime.ToString()
        }
        $results = @{

            #region resource generator code
            Id                      = $getValue.Id
            AccessPackageId         = $getValue.AccessPackageId
            AccessReviewSettings    = $formattedAccessReviewSettings
            CanExtend               = $getValue.CanExtend
            CustomExtensionHandlers = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.CustomExtensionHandlers
            Description             = $getValue.Description
            DisplayName             = $getValue.DisplayName
            DurationInDays          = $getValue.DurationInDays
            ExpirationDateTime      = $formattedExpirationDateTime
            Questions               = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.Questions
            RequestApprovalSettings = $formattedRequestApprovalSettings
            RequestorSettings       = $formattedRequestorSettings
            Ensure                  = 'Present'
            Credential              = $Credential
            ApplicationId           = $ApplicationId
            TenantId                = $TenantId
            ApplicationSecret       = $ApplicationSecret
            CertificateThumbprint   = $CertificateThumbprint
            ManagedIdentity         = $ManagedIdentity.IsPresent
        }

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ''
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $AccessPackageId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AccessReviewSettings,

        [Parameter()]
        [System.Boolean]
        $CanExtend,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Int32]
        $DurationInDays,

        [Parameter()]
        [system.datetimeoffset]
        $ExpirationDateTime,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Questions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RequestApprovalSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RequestorSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomExtensionHandlers,
        #endregion

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'beta'

        Select-MgProfile 'beta' -ErrorAction Stop
    }
    catch
    {
        Write-Verbose -Message $_
    }

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

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null


    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new access package assignment policy {$DisplayName}"

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $CreateParameters


        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null

        $keys=(([Hashtable]$CreateParameters).clone()).Keys
        foreach($key in $keys)
        {
            #$keyName=$key.substring(0,1).toLower()+$key.substring(1,$key.length-1)
            $keyValue= $CreateParameters.$key
            if($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like "*cimInstance*")
            {
                $keyValue= Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
                $CreateParameters.$key=$keyValue
            }
            #$CreateParameters.remove($key)
            #$CreateParameters.add($keyName,$keyValue)
        }
        #$CreateParameters.add('@odata.type','#microsoft.graph.accessPackageAssignmentPolicy')

        #region resource generator code
        New-MgEntitlementManagementAccessPackageAssignmentPolicy `
            -BodyParameter $CreateParameters

        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the access package assignment policy {$DisplayName}"

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceODataParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null
        $UpdateParameters.Remove('AccessPackageId') | Out-Null

        $keys=(([Hashtable]$UpdateParameters).clone()).Keys
        foreach($key in $keys)
        {
            #$keyName=$key#.substring(0,1).toLower()+$key.substring(1,$key.length-1)
            $keyValue= $UpdateParameters.$key
            if($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like "*cimInstance*")
            {
                $keyValue= Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
                $UpdateParameters.$key=$keyValue
            }
            #$UpdateParameters.remove($key)
            #$UpdateParameters.add($keyName,$keyValue)
        }
        #$UpdateParameters.add('@odata.type','#microsoft.graph.accessPackageAssignmentPolicy')

        #region resource generator code
        write-verbose ($UpdateParameters|convertto-json -depth 20)

        Set-MgEntitlementManagementAccessPackageAssignmentPolicy `
            -BodyParameter $UpdateParameters `
            -AccessPackageAssignmentPolicyId $currentInstance.Id


        #endregion

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the access package assignment policy {$DisplayName}"
        #region resource generator code
        Remove-MgEntitlementManagementAccessPackageAssignmentPolicy -AccessPackageAssignmentPolicyId $currentInstance.Id
        #endregion

    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (

        #region resource generator code
        [Parameter()]
        [System.String]
        $Id,

        [Parameter()]
        [System.String]
        $AccessPackageId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AccessReviewSettings,

        [Parameter()]
        [System.Boolean]
        $CanExtend,

        [Parameter()]
        [System.String]
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Int32]
        $DurationInDays,

        [Parameter()]
        [system.datetimeoffset]
        $ExpirationDateTime,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Questions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RequestApprovalSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $RequestorSettings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CustomExtensionHandlers,
        #endregion

        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Absent', 'Present')]
        $Ensure = $true,

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
        $ManagedIdentity
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

    Write-Verbose -Message "Testing the configuration of the access package policy assignment with {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult=$true

    #Compare Cim instances
    foreach($key in $PSBoundParameters.Keys)
    {
        $source=$PSBoundParameters.$key
        $target=$CurrentValues.$key
        if($source.getType().Name -like "*CimInstance*")
        {
            $source=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult=Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if(-Not $testResult)
            {
                $testResult=$false
                break;
            }

            $ValuesToCheck.Remove($key)|Out-Null

        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys -verbose
    }

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
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'beta'
    Select-MgProfile 'beta' -ErrorAction Stop

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

        #region resource generator code
        [array]$getValue = Get-MgEntitlementManagementAccessPackageAssignmentPolicy `
            -All `
            -ErrorAction Stop
        #endregion


        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            $displayedKey=$config.id
            if(-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey=$config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                id                    = $config.id
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results

            #if ($null -ne $Results.AccessReviewSettings)
            #{
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.AccessReviewSettings -CIMInstanceName MicrosoftGraphassignmentreviewsettings
                if ($complexTypeStringResult)
                {
                    $Results.AccessReviewSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AccessReviewSettings') | Out-Null
                }
            #}
            #if ($null -ne $Results.Questions -and $Results.Questions.count -gt 0)
            #{
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Questions -CIMInstanceName MicrosoftGraphaccesspackagequestion
                if ($complexTypeStringResult)
                {
                    $Results.Questions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Questions') | Out-Null
                }
            #}
            #if ($null -ne $Results.RequestApprovalSettings)
            #{
                $complexMapping=@(
                    @{
                        Name="ApprovalStages"
                        CimInstanceName="MicrosoftGraphapprovalstage1"
                        IsRequired=$false
                    }
                    @{
                        Name="PrimaryApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                    @{
                        Name="EscalationApprovers"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.RequestApprovalSettings `
                    -CIMInstanceName MicrosoftGraphapprovalsettings `
                    -ComplexTypeMapping $complexMapping
                if ($complexTypeStringResult)
                {
                    $Results.RequestApprovalSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('RequestApprovalSettings') | Out-Null
                }
            #}
            #if ($null -ne $Results.RequestorSettings)
            #{
                $complexMapping=@(
                    @{
                        Name="AllowedRequestors"
                        CimInstanceName="MicrosoftGraphuserset"
                        IsRequired=$false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.RequestorSettings `
                    -CIMInstanceName MicrosoftGraphrequestorsettings `
                    -ComplexTypeMapping $complexMapping

                if ($complexTypeStringResult)
                {
                    $Results.RequestorSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('RequestorSettings') | Out-Null
                }
            #}
            #if ($null -ne $Results.CustomExtensionHandlers -and $Results.CustomExtensionHandlers.count -gt 0)
            #{
                $complexMapping=@(
                    @{
                        Name="AuthenticationConfiguration"
                        CimInstanceName="MicrosoftGraphcustomextensionauthenticationconfiguration"
                        IsRequired=$false
                    }
                    @{
                        Name="ClientConfiguration"
                        CimInstanceName="MicrosoftGraphcustomextensionclientconfiguration"
                        IsRequired=$false
                    }
                    @{
                        Name="EndpointConfiguration"
                        CimInstanceName="MicrosoftGraphcustomextensionauthenticationconfiguration"
                        IsRequired=$false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CustomExtensionHandlers `
                    -CIMInstanceName MicrosoftGraphcustomextensionhandler `
                    -ComplexTypeMapping $complexMapping

                if ($complexTypeStringResult)
                {
                    $Results.CustomExtensionHandlers = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CustomExtensionHandlers') | Out-Null
                }
            #}

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($null -ne $Results.AccessReviewSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "AccessReviewSettings"
            }
            if ($null -ne $Results.Questions )
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Questions" -isCIMArray:$true
            }
            if ($null -ne $Results.RequestApprovalSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "RequestApprovalSettings"
            }
            if ($null -ne $Results.RequestorSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "RequestorSettings"
            }
            if ($null -ne $Results.CustomExtensionHandlers)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "CustomExtensionHandlers" -isCIMArray:$true
            }

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
        try
        {
            write-Host  ($_|out-string)
            Write-Verbose -Message $_
            $tenantIdValue = ''
            if (-not [System.String]::IsNullOrEmpty($TenantId))
            {
                $tenantIdValue = $TenantId
            }
            elseif ($null -ne $Credential)
            {
                $tenantIdValue = $Credential.UserName.Split('@')[1]
            }
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return ''
    }
}

function Rename-M365DSCCimInstanceODataParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        #[System.Collections.Hashtable[]]
        $Properties
    )

    $type=$Properties.getType().FullName
    if ($type -like '*[[\]]')
    {
        $values = @()
        foreach ($item in $Properties)
        {
            $values += Rename-M365DSCCimInstanceODataParameter $item
        }
        $Properties=$values
    }
    else
    {
        if($type -like '*CimInstance*' -or $type -like '*Hashtable*'-or $type -like '*Object*')
        {
            $hashProperties = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Properties
            $keys=($hashProperties.clone()).keys
            foreach($key in $keys)
            {
                write-verbose ("Key: "+$key)

                if ($key -eq 'odataType')
                {
                    $hashProperties.add('@odata.type', $hashProperties.odataType)
                    $hashProperties.remove('odataType')
                    $Properties = $hashProperties
                }
                else
                {
                    $property=$Properties.$key
                    if($null -ne $property)
                    {
                        write-verbose ("Key ----- "+$key+": "+($property.getType().FullName))

                        $Properties.$key = Rename-M365DSCCimInstanceODataParameter $hashProperties.$key
                    }
                }
            }
        }
    }

    return $Properties

<#
    $keys=($Properties.clone()).keys
    write-verbose ("properties Type ----- "+$properties.getType().FullName)


    foreach($key in $keys)
    {
        write-verbose ("Key: "+$key)
        $property=$Properties.$key
        if($null -ne $property)
        {
            $propertyType=$property.getType().FullName
            write-verbose ("Key ----- "+$key+": "+($property.getType().FullName))
            if($propertyType -like '*CimInstance*' -or $propertyType -like '*Hashtable*'-or $propertyType -like '*Object*')
            {
                if ($propertyType -like '*[[\]]')
                {
                    $values = @()
                    foreach ($item in $property)
                    {
                        $hashItem = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        $values += Rename-M365DSCCimInstanceODataParameter $hashItem
                    }
                    $Properties.$key=$values
                }
                else
                {
                    write-verbose ("propertyType ----- "+$property.getType().FullName)

                    $hashProperty = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $property
                    write-verbose ("hashPropertyType ----- "+$hashProperty.getType().FullName)

                    $propertyKeys=($hashProperty.clone()).keys
                    foreach($propertyKey in $propertyKeys)
                    {
                        write-verbose ("propertyKey: "+$propertyKey)

                        if ($propertyKey -eq 'odataType')
                        {
                            $hashProperty.add('@odata.type', $hashProperty.odataType)
                            $hashProperty.remove('odataType')
                            $Properties.$key = $hashProperty
                        }
                        else
                        {
                            $childProperty=$hashProperty.$propertyKey
                            if($null -ne $childProperty )
                            {
                                write-verbose ("Child ----- "+$propertyKey+": "+$childProperty.getType().FullName)
                                $childType=$childProperty.getType().FullName
                                if($childType -like '*CimInstance*' -or $childType -like '*Hashtable*' -or $propertyType -like '*Object*')
                                {
                                    $hashProperty.$propertyKey=Rename-M365DSCCimInstanceODataParameter $childProperty
                                    #$property=$hashProperty
                                }

                            }
                        }



                    }
                }
            }
        }
    }
    return $Properties

#>
}
function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable],[hashtable[]])]
    param(
        [Parameter()]
        $ComplexObject
    )

    if($null -eq $ComplexObject)
    {
        return $null
    }


    if($ComplexObject.getType().Fullname -like "*hashtable")
    {
        return $ComplexObject
    }
    if($ComplexObject.getType().Fullname -like "*hashtable[[\]]")
    {
        return ,[hashtable[]]$ComplexObject
    }


    if($ComplexObject.gettype().fullname -like "*[[\]]")
    {
        $results=@()

        foreach($item in $ComplexObject)
        {
            if($item)
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                $results+=$hash
            }
        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[hashtable[]]$results
    }

    $results = @{}

    if($ComplexObject.getType().Name -like 'Dictionary*')
    {
        $ComplexObject=[hashtable]::new($ComplexObject)
        $keys=$ComplexObject.Keys
        foreach ($key in $keys)
        {

            if($null -ne $ComplexObject.$key)
            {
                $keyName = $key#.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

                $keyType=$ComplexObject.$key.gettype().fullname
                if($keyType -like "*CimInstance*" -or $keyType -like "Microsoft.Graph.PowerShell.Models.*" )
                {
                    $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$key

                    $results.Add($keyName, $hash)
                }
                else
                {
                    $results.Add($keyName, $ComplexObject.$key)
                }
            }
        }
        return [hashtable]$results
    }

    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties'}

    foreach ($key in $keys)
    {

        if($null -ne $ComplexObject.$($key.Name))
        {
            $keyName = $key.Name[0].ToString().ToLower() + $key.Name.Substring(1, $key.Name.Length - 1)

            if($ComplexObject.$($key.Name).gettype().fullname -like "*CimInstance*")
            {
                $hash = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject.$($key.Name)

                $results.Add($keyName, $hash)
            }
            else
            {
                $results.Add($keyName, $ComplexObject.$($key.Name))
            }
        }
    }

    return [hashtable]$results
}

function Get-M365DSCDRGComplexTypeToString
{
    [CmdletBinding()]
    #[OutputType([System.String])]
    param(
        [Parameter()]
        $ComplexObject,

        [Parameter(Mandatory = $true)]
        [System.String]
        $CIMInstanceName,

        [Parameter()]
        [Array]
        $ComplexTypeMapping,

        [Parameter()]
        [System.String]
        $Whitespace='',

        [Parameter()]
        [System.uint32]
        $IndentLevel=3,

        [Parameter()]
        [switch]
        $isArray=$false
    )

    if ($null -eq $ComplexObject)
    {
        return $null
    }

    $indent=''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent+='    '
    }
    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like "*[[\]]")
    {
        $currentProperty=@()
        $IndentLevel++
        foreach ($item in $ComplexObject)
        {
            $splat=@{
                'ComplexObject'=$item
                'CIMInstanceName'=$CIMInstanceName
                'IndentLevel'=$IndentLevel
            }
            if ($ComplexTypeMapping)
            {
                $splat.add('ComplexTypeMapping',$ComplexTypeMapping)
            }

            $currentProperty += Get-M365DSCDRGComplexTypeToString -isArray:$true @splat

        }

        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,$currentProperty
    }

    $currentProperty=''
    if($isArray)
    {
        $currentProperty += "`r`n"
        $currentProperty += $indent
    }

    $currentProperty += "MSFT_$CIMInstanceName{`r`n"
    $IndentLevel++
    $indent=''
    for ($i = 0; $i -lt $IndentLevel ; $i++)
    {
        $indent+='    '
    }
    $keyNotNull = 0

    if ($ComplexObject.Keys.count -eq 0)
    {
        return $null
    }

    foreach ($key in $ComplexObject.Keys)
    {
        if ($null -ne $ComplexObject.$key)
        {

            $keyNotNull++
            if ($ComplexObject.$key.GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*" -or $key -in $ComplexTypeMapping.Name)
            {
                $hashPropertyType=$ComplexObject[$key].GetType().Name.tolower()

                $isArray=$false
                if($ComplexObject[$key].GetType().FullName -like "*[[\]]")
                {
                    $isArray=$true
                }
                #overwrite type if object defined in mapping complextypemapping
                if($key -in $ComplexTypeMapping.Name)
                {
                    $hashPropertyType=($ComplexTypeMapping|Where-Object -FilterScript {$_.Name -eq $key}).CimInstanceName
                    $hashProperty=$ComplexObject[$key]
                }
                else
                {
                    $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                }


                if(-not $isArray)
                {
                    $currentProperty += $indent + $key + ' = '
                }

                if($isArray -and $key -in $ComplexTypeMapping.Name )
                {
                    if($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent + $key + ' = '
                        $currentProperty += "@("
                    }
                }

                if ($isArray)
                {
                    $IndentLevel++
                    foreach ($item in $ComplexObject[$key])
                    {
                        write-host ($item.GetType().FullName)

                        write-host ($item|convertTo-Json -depth 20)
                        write-host ($item.keys|out-string)
                        if ($ComplexObject.$key.GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*")
                        {
                            $item=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                        }
                        $currentProperty += Get-M365DSCDRGComplexTypeToString `
                            -ComplexObject $item `
                            -CIMInstanceName $hashPropertyType `
                            -IndentLevel $IndentLevel `
                            -ComplexTypeMapping $ComplexTypeMapping `
                            -IsArray:$true
                    }
                    $IndentLevel--
                }
                else
                {
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                                    -ComplexObject $hashProperty `
                                    -CIMInstanceName $hashPropertyType `
                                    -IndentLevel $IndentLevel `
                                    -ComplexTypeMapping $ComplexTypeMapping
                }
                #if($ComplexObject.$key.GetType().FullName -like "*[[\]]")
                if($isArray)
                {
                    if($ComplexObject.$key.count -gt 0)
                    {
                        $currentProperty += $indent
                        $currentProperty += ')'
                        $currentProperty += "`r`n"
                    }
                }
                $isArray=$PSBoundParameters.IsArray
            }
            else
            {
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($indent)
            }
        }
        else
        {
            $mappedKey=$ComplexTypeMapping|where-object -filterscript {$_.name -eq $key}

            if($mappedKey -and $mappedKey.isRequired)
            {
                if($mappedKey.isArray)
                {
                    $currentProperty += "$indent$key = @()`r`n"
                }
                else
                {
                    $currentProperty += "$indent$key = `$null`r`n"
                }
            }
        }
    }
    $indent=''
    for ($i = 0; $i -lt $IndentLevel-1 ; $i++)
    {
        $indent+='    '
    }
    $currentProperty += "$indent}"
    if($isArray)
    {
        $currentProperty += "`r`n"
    }

    #Indenting last parenthese when the cim instance is an array
    if($IndentLevel -eq 5)
    {
        $indent=''
        for ($i = 0; $i -lt $IndentLevel-2 ; $i++)
        {
            $indent+='    '
        }
        $currentProperty += $indent

    }
    return $currentProperty
}

Function Get-M365DSCDRGSimpleObjectTypeToString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.String]
        $Key,

        [Parameter(Mandatory = 'true')]
        $Value,

        [Parameter()]
        [System.String]
        $Space="                "

    )

    $returnValue=""
    switch -Wildcard ($Value.GetType().Fullname )
    {
        "*.Boolean"
        {
            $returnValue= $Space + $Key + " = `$" + $Value.ToString() + "`r`n"
        }
        "*.String"
        {
            if($key -eq '@odata.type')
            {
                $key='odataType'
            }
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*.DateTime"
        {
            $returnValue= $Space + $Key + " = '" + $Value + "'`r`n"
        }
        "*[[\]]"
        {
            $returnValue= $Space + $key + " = @("
            $whitespace=""
            $newline=""
            if($Value.count -gt 1)
            {
                $returnValue += "`r`n"
                $whitespace=$Space+"    "
                $newline="`r`n"
            }
            foreach ($item in $Value)
            {
                switch -Wildcard ($item.GetType().Fullname )
                {
                    "*.String"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    "*.DateTime"
                    {
                        $returnValue += "$whitespace'$item'$newline"
                    }
                    Default
                    {
                        $returnValue += "$whitespace$item$newline"
                    }
                }
            }
            if($Value.count -gt 1)
            {
                $returnValue += "$Space)`r`n"
            }
            else
            {
                $returnValue += ")`r`n"

            }
        }
        Default
        {
            $returnValue= $Space + $Key + " = " + $Value + "`r`n"
        }
    }
    return $returnValue
}

function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        $Source,
        [Parameter()]
        $Target
    )

    #Comparing full objects
    if($null -eq  $Source  -and $null -eq $Target)
    {
        return $true
    }

    $sourceValue=""
    $targetValue=""
    if (($null -eq $Source) -xor ($null -eq $Target))
    {
        if($null -eq $Source)
        {
            $sourceValue="Source is null"
        }

        if($null -eq $Target)
        {
            $targetValue="Target is null"
        }
        Write-Verbose -Message "Configuration drift - Complex object: {$sourceValue$targetValue}"
        return $false
    }

    if($Source.getType().FullName -like "*CimInstance[[\]]" -or $Source.getType().FullName -like "*Hashtable[[\]]")
    {
        if($source.count -ne $target.count)
        {
            Write-Verbose -Message "Configuration drift - The complex array have different number of items: Source {$($source.count)} Target {$($target.count)}"
            return $false
        }
        if($source.count -eq 0)
        {
            return $true
        }

        foreach($item in $Source)
        {

            $hashSource=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            foreach($targetItem in $Target)
            {
                $compareResult= Compare-M365DSCComplexObject `
                    -Source $hashSource `
                    -Target $targetItem

                if ($compareResult)
                {
                    break
                }
            }

            if(-not $compareResult)
            {
                Write-Verbose -Message "Configuration drift - The complex array items are not identical"
                return $false
            }
        }
        return $true
    }

    $keys= $Source.Keys|Where-Object -FilterScript {$_ -ne "PSComputerName"}
    foreach ($key in $keys)
    {
        #Matching possible key names between Source and Target
        $skey=$key
        $tkey=$key
        <#if($key -eq 'odataType')
        {
            $skey='@odata.type'
        }
        else
        {
            $tmpkey=$Target.keys|Where-Object -FilterScript {$_ -eq "$key"}
            if($tkey)
            {
                $tkey=$tmpkey|Select-Object -First 1
            }
        }#>

        $sourceValue=$Source.$key
        $targetValue=$Target.$tkey
        #One of the item is null and not the other
        if (($null -eq $Source.$key) -xor ($null -eq $Target.$tkey))
        {

            if($null -eq $Source.$key)
            {
                $sourceValue="null"
            }

            if($null -eq $Target.$tkey)
            {
                $targetValue="null"
            }

            Write-Verbose -Message "Configuration drift - key: $key Source {$sourceValue} Target {$targetValue}"
            return $false
        }

        #Both keys aren't null or empty
        if(($null -ne $Source.$key) -and ($null -ne $Target.$tkey))
        {
            if($Source.$key.getType().FullName -like "*CimInstance*" -or $Source.$key.getType().FullName -like "*hashtable*"  )
            {
                #Recursive call for complex object
                $compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source.$key) `
                    -Target $Target.$tkey

                if(-not $compareResult)
                {

                    Write-Verbose -Message "Configuration drift - complex object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject=$Target.$tkey
                $differenceObject=$Source.$key
                #if($differenceObject.getType().Name -eq 'DateTimeOffset' )
                #{
                #    $differenceObject=$differenceObject.ToString()
                #}

                #Identifying date from the current values
                $targetType=($Target.$tkey.getType()).Name
                if($targetType -like "*Date*")
                {
                    $compareResult=$true
                    $sourceDate= [DateTime]$Source.$key
                    if($sourceDate -ne $targetType)
                    {
                        $compareResult=$null
                    }
                }
                else
                {
                    $compareResult = Compare-Object `
                        -ReferenceObject ($referenceObject) `
                        -DifferenceObject ($differenceObject)
                }

                if ($null -ne $compareResult)
                {
                    #Write-Verbose -Message "Configuration drift - simple object key: $key Source {$sourceValue} Target {$targetValue}"
                    return $false
                }

            }

        }
    }

    return $true
}
function Convert-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    [OutputType([hashtable],[hashtable[]])]
    param(
        [Parameter(Mandatory = 'true')]
        $ComplexObject
    )


    if($ComplexObject.getType().Fullname -like "*[[\]]")
    {
        $results=@()
        foreach($item in $ComplexObject)
        {
            $hash=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
            $results+=$hash
        }

        #Write-Verbose -Message ("Convert-M365DSCDRGComplexTypeToHashtable >>> results: "+(convertTo-JSON $results -Depth 20))
        # PowerShell returns all non-captured stream output, not just the argument of the return statement.
        #An empty array is mangled into $null in the process.
        #However, an array can be preserved on return by prepending it with the array construction operator (,)
        return ,[hashtable[]]$results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject

    if($null -ne $hashComplexObject)
    {

        $results=$hashComplexObject.clone()
        $keys=$hashComplexObject.Keys|Where-Object -FilterScript {$_ -ne 'PSComputerName'}
        foreach ($key in $keys)
        {
            if($hashComplexObject[$key] -and $hashComplexObject[$key].getType().Fullname -like "*CimInstance*")
            {
                $results[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            else
            {
                $propertyName = $key[0].ToString().ToLower() + $key.Substring(1, $key.Length - 1)
                $propertyValue=$results[$key]
                $results.remove($key)|out-null
                $results.add($propertyName,$propertyValue)
            }
        }
    }
    return [hashtable]$results
}

Export-ModuleMember -Function *-TargetResource
