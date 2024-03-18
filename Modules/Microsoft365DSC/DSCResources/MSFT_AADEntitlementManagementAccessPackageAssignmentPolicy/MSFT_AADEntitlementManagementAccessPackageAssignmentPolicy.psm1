function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

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

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [Switch]
        $ManagedIdentity
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

        $nullResult = $PSBoundParameters
        $nullResult.Ensure = 'Absent'

        $getValue = $null
        if (-not [System.String]::IsNullOrEmpty($id))
        {
            $getValue = Get-MgBetaEntitlementManagementAccessPackageAssignmentPolicy `
                -AccessPackageAssignmentPolicyId $id `
                -ExpandProperty "customExtensionHandlers(`$expand=customExtension)" `
                -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "The access package assignment policy with id {$id} was not found"
            $getValue = Get-MgBetaEntitlementManagementAccessPackageAssignmentPolicy `
                -DisplayNameEq $DisplayName `
                -ExpandProperty "customExtensionHandlers(`$expand=customExtension)" `
                -ErrorAction SilentlyContinue
        }

        if ($null -eq $getValue)
        {
            Write-Verbose -Message "The access package assignment policy with displayName {$DisplayName} was not found"
            return $nullResult
        }

        Write-Verbose -Message "Found access package assignment policy with id {$($getValue.Id)} and DisplayName {$DisplayName}"

        #region Format AccessReviewSettings
        $formattedAccessReviewSettings = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.AccessReviewSettings -Verbose
        if($null -ne $formattedAccessReviewSettings)
        {
            $formattedAccessReviewSettings.remove('additionalProperties') | Out-Null
        }
        if ($null -ne $formattedAccessReviewSettings.Reviewers -and $formattedAccessReviewSettings.Reviewers.count -gt 0 )
        {
            foreach ($setting in $formattedAccessReviewSettings.Reviewers)
            {
                $setting.add('odataType', $setting.AdditionalProperties.'@odata.type')
                if (-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                {
                    $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue

                    if ($null -ne $user)
                    {
                        $setting.add('Id', $user.UserPrincipalName)
                    }
                }
                if (-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                {
                    $setting.add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                }
                $setting.remove('AdditionalProperties') | Out-Null
            }
        }
        #endregion

        #region Format RequestApprovalSettings
        $formattedRequestApprovalSettings = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.RequestApprovalSettings
        if ($null -ne $formattedRequestApprovalSettings)
        {
            $formattedRequestApprovalSettings.remove('additionalProperties') | Out-Null
        }
        if ($null -ne $formattedRequestApprovalSettings.approvalStages -and $formattedRequestApprovalSettings.approvalStages.count -gt 0 )
        {
            foreach ($approvalStage in $formattedRequestApprovalSettings.approvalStages)
            {
                if ($null -ne $approvalStage.PrimaryApprovers -and $approvalStage.PrimaryApprovers.count -gt 0)
                {
                    foreach ($setting in $approvalStage.PrimaryApprovers)
                    {
                        $setting.add('odataType', $setting.AdditionalProperties.'@odata.type')
                        if (-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                        {
                            $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue
                            if ($null -ne $user)
                            {
                                $setting.add('Id', $user.UserPrincipalName)
                            }
                        }
                        if (-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                        {
                            $setting.add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                        }
                        $setting.remove('additionalProperties') | Out-Null
                    }
                }

                if ($null -ne $approvalStage.EscalationApprovers -and $approvalStage.EscalationApprovers.count -gt 0)
                {
                    foreach ($setting in $approvalStage.EscalationApprovers)
                    {
                        $setting.add('odataType', $setting.AdditionalProperties.'@odata.type')
                        if (-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                        {
                            $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue
                            if ($null -ne $user)
                            {
                                $setting.add('Id', $user.UserPrincipalName)
                            }
                        }
                        if (-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                        {
                            $setting.add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                        }
                        $setting.remove('additionalProperties') | Out-Null
                    }
                }
                $approvalStage.remove('additionalProperties') | Out-Null
            }
        }
        #endregion

        #region Format RequestorSettings
        $formattedRequestorSettings = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.RequestorSettings
        if ($null -ne $formattedRequestorSettings)
        {
            $formattedRequestorSettings.remove('additionalProperties') | Out-Null
        }
        if ($null -ne $formattedRequestorSettings.allowedRequestors -and $formattedRequestorSettings.allowedRequestors.count -gt 0 )
        {
            foreach ($setting in $formattedRequestorSettings.allowedRequestors)
            {
                if (-not $setting.ContainsKey("odataType"))
                {
                    $setting.add('odataType',$setting.AdditionalProperties."@odata.type")
                }
                if(-not [String]::isNullOrEmpty($setting.AdditionalProperties.id))
                {
                    $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $setting.add('Id', $user.UserPrincipalName)
                    }
                }
                if (-not [String]::isNullOrEmpty($setting.AdditionalProperties.managerLevel))
                {
                    $setting.add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                }
                $setting.remove('additionalProperties') | Out-Null
            }
        }
        #endregion

        #region Format Questions
        $formattedQuestions = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.Questions
        foreach ($question in $formattedQuestions)
        {
            if (-not $question.ContainsKey("odataType"))
            {
                $question.add("odataType",$question.AdditionalProperties."@odata.type")
            }
            if ($null -ne $question.Text)
            {
                $question.add('QuestionText', $question.Text)
                $question.remove('Text') | Out-Null
                $question.QuestionText.remove('additionalProperties') | Out-Null
                foreach ($localizedText in $question.QuestionText.localizedTexts)
                {
                    $localizedText.remove('additionalProperties') | Out-Null
                }
            }
            if ($null -ne $question.AdditionalProperties.isSingleLineQuestion)
            {
                $question.add('IsSingleLineQuestion', $question.AdditionalProperties.isSingleLineQuestion)
            }
            if ($null -ne $question.AdditionalProperties.choices)
            {
                $question.add('Choices', [Array]$question.AdditionalProperties.choices)
            }
            if ($null -ne $question.AdditionalProperties.allowsMultipleSelection)
            {
                $question.add('AllowsMultipleSelection', $question.AdditionalProperties.allowsMultipleSelection)
            }
            $question.remove('additionalProperties') | Out-Null
        }
        #endregion

        #region Format CustomExtensionHandlers
        $formattedCustomExtensionHandlers = @()
        foreach ($customExtensionHandler in $getValue.CustomExtensionHandlers)
        {
            $customExt = @{
                #Id              = $customExtensionHandler.Id #Read Only
                Stage           = $customExtensionHandler.Stage
                CustomExtensionId = $customExtensionHandler.CustomExtension.Id
            }
            $formattedCustomExtensionHandlers += $customExt
        }
        #endregion

        $AccessPackageIdValue = $getValue.AccessPackageId
        $ObjectGuid = [System.Guid]::empty
        $isGUID = [System.Guid]::TryParse($AccessPackageIdValue, [System.Management.Automation.PSReference]$ObjectGuid)
        if ($isGUID)
        {
            $accesspackage = Get-MgBetaEntitlementManagementAccessPackage -AccessPackageId $AccessPackageIdValue
            $AccessPackageIdValue = $accesspackage.DisplayName
        }

        $results = @{
            Id                      = $getValue.Id
            AccessPackageId         = $AccessPackageIdValue
            AccessReviewSettings    = $formattedAccessReviewSettings
            CanExtend               = $getValue.CanExtend
            CustomExtensionHandlers = $formattedCustomExtensionHandlers
            Description             = $getValue.Description
            DisplayName             = $getValue.DisplayName
            DurationInDays          = $getValue.DurationInDays
            ExpirationDateTime      = $getValue.ExpirationDateTime
            Questions               = $formattedQuestions
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
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

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

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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
        [Switch]
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $PSBoundParameters.Remove('Ensure') | Out-Null
    $PSBoundParameters.Remove('Credential') | Out-Null
    $PSBoundParameters.Remove('ApplicationId') | Out-Null
    $PSBoundParameters.Remove('ApplicationSecret') | Out-Null
    $PSBoundParameters.Remove('TenantId') | Out-Null
    $PSBoundParameters.Remove('CertificateThumbprint') | Out-Null
    $PSBoundParameters.Remove('ManagedIdentity') | Out-Null
    $PSBoundParameters.Remove('Verbose') | Out-Null

    $keyToRename = @{
        'odataType'    = '@odata.type'
        'QuestionText' = 'text'
    }
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new access package assignment policy {$DisplayName}"

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters -KeyMapping $keyToRename

        $CreateParameters.Remove('Id') | Out-Null
        $CreateParameters.Remove('Verbose') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            $keyValue = $CreateParameters.$key
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
                $CreateParameters.$key = $keyValue
            }
        }

        # Convert back user principal names to Ids
        if ($null -ne $CreateParameters.AccessReviewSettings -and $null -ne $CreateParameters.AccessReviewSettings.Reviewers)
        {
            for ($i = 0; $i -lt $CreateParameters.AccessReviewSettings.Reviewers.Length; $i++)
            {
                $reviewer = $CreateParameters.AccessReviewSettings.Reviewers[$i]
                $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($reviewer.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                if ($null -ne $user)
                {
                    $CreateParameters.AccessReviewSettings.Reviewers[$i].Id = $user.Id
                }
            }
        }
        if ( $null -ne $CreateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers)
        {
            for ($i = 0; $i -lt $CreateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers.Length; $i++)
            {
                $primaryApprover = $CreateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers[$i]
                if ($null -ne $primaryApprover.id)
                {
                    $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($primaryApprover.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $CreateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers[$i].Id = $user.Id
                    }
                }
            }
        }
        if ( $null -ne $CreateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers)
        {
            for ($i = 0; $i -lt $CreateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers.Length; $i++)
            {
                $escalationApprover = $CreateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers[$i]
                if ($null -ne $escalationApprover.id)
                {
                    $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($escalationApprover.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $CreateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers[$i].Id = $user.Id
                    }
                }
            }
        }
        if ($null -ne $CreateParameters.RequestorSettings -and $null -ne $CreateParameters.RequestorSettings.AllowedRequestors)
        {
            for ($i = 0; $i -lt $CreateParameters.RequestorSettings.AllowedRequestors.Length; $i++)
            {
                $requestor = $CreateParameters.RequestorSettings.AllowedRequestors[$i]
                $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($requestor.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                if ($null -ne $user)
                {
                    $CreateParameters.RequestorSettings.AllowedRequestors[$i].Id = $user.Id
                }
            }
        }
        If ($null -ne $CreateParameters.CustomExtensionHandlers -and $CreateParameters.CustomExtensionHandlers.count -gt 0 )
        {
            $formattedCustomExtensionHandlers = @()
            foreach ($customExtensionHandler in $CreateParameters.CustomExtensionHandlers)
            {
                $extensionId= $customExtensionHandler.CustomExtensionId
                $formattedCustomExtensionHandlers += @{
                    stage = $customExtensionHandler.Stage
                    customExtension = @{
                        id = $extensionId
                    }
                }
            }
            $CreateParameters.CustomExtensionHandlers = $formattedCustomExtensionHandlers
        }

        # Check to see if the AccessPackageId is in GUID form. If not, resolve it by name.
        if (-not [System.String]::IsNullOrEmpty($AccessPackageId))
        {
            $ObjectGuid = [System.Guid]::empty
            $isGUID = [System.Guid]::TryParse($AccessPackageId, [System.Management.Automation.PSReference]$ObjectGuid)
            if (-not $isGUID)
            {
                # Retrieve by name
                Write-Verbose -Message "Retrieving Entitlement Management Access Package by Name {$AccessPackageId}"
                $package = Get-MgBetaEntitlementManagementAccessPackage -Filter "displayName eq '$AccessPackageId'"
                if ($null -ne $package)
                {
                    $AccessPackageId = $package.Id
                }
                else
                {
                    throw "Could not retrieve the Access Package using identifier {$AccessPackageId}"
                }
            }
            $CreateParameters.AccessPackageId = $AccessPackageId
        }

        Write-Verbose -Message "Creating with Values: $(Convert-M365DscHashtableToString -Hashtable $CreateParameters)"
        New-MgBetaEntitlementManagementAccessPackageAssignmentPolicy `
            -BodyParameter $CreateParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the access package assignment policy {$DisplayName}"

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters -KeyMapping $keyToRename

        $UpdateParameters.Remove('Id') | Out-Null
        $UpdateParameters.Remove('Verbose') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            $keyValue = $UpdateParameters.$key
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $keyValue = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
                $UpdateParameters.$key = $keyValue
            }
        }

        # Convert back user principal names to Ids
        if ($null -ne $UpdateParameters.AccessReviewSettings -and $null -ne $UpdateParameters.AccessReviewSettings.Reviewers)
        {
            #Write-Verbose -Message "Updating Reviewers' Id"
            for ($i = 0; $i -lt $UpdateParameters.AccessReviewSettings.Reviewers.Length; $i++)
            {
                $reviewer = $UpdateParameters.AccessReviewSettings.Reviewers[$i]
                $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($reviewer.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                if ($null -ne $user)
                {
                    $UpdateParameters.AccessReviewSettings.Reviewers[$i].Id = $user.Id
                }
            }
        }
        if ($null -ne $UpdateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers)
        {
            for ($i = 0; $i -lt $UpdateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers.Length; $i++)
            {
                $primaryApprover = $UpdateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers[$i]
                if ($null -ne $primaryApprover.id)
                {
                    $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($primaryApprover.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $UpdateParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers[$i].Id = $user.Id
                    }
                }
            }
        }
        if ($null -ne $UpdateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers)
        {
            for ($i = 0; $i -lt $UpdateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers.Length; $i++)
            {
                $escalationApprover = $UpdateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers[$i]
                if ($null -ne $escalationApprover.id)
                {
                    $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($escalationApprover.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $UpdateParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers[$i].Id = $user.Id
                    }
                }
            }
        }
        if ($null -ne $UpdateParameters.RequestorSettings -and $null -ne $UpdateParameters.RequestorSettings.AllowedRequestors)
        {
            #Write-Verbose -Message "Updating Requestors' Id"
            for ($i = 0; $i -lt $UpdateParameters.RequestorSettings.AllowedRequestors.Length; $i++)
            {
                #Write-Verbose -Message "Requestor: $($UpdateParameters.RequestorSettings.AllowedRequestors[$i].Id)"
                $requestor = $UpdateParameters.RequestorSettings.AllowedRequestors[$i]
                $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($requestor.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                if ($null -ne $user)
                {
                    $UpdateParameters.RequestorSettings.AllowedRequestors[$i].Id = $user.Id
                }
            }
        }
        If ($null -ne $UpdateParameters.CustomExtensionHandlers -and $UpdateParameters.CustomExtensionHandlers.count -gt 0 )
        {
            $formattedCustomExtensionHandlers = @()
            foreach ($customExtensionHandler in $UpdateParameters.CustomExtensionHandlers)
            {
                $extensionId= $customExtensionHandler.CustomExtensionId
                $formattedCustomExtensionHandlers += @{
                    stage = $customExtensionHandler.Stage
                    customExtension = @{
                        id = $extensionId
                    }
                }
            }
            $UpdateParameters.CustomExtensionHandlers = $formattedCustomExtensionHandlers
        }

        if (-not [System.String]::IsNullOrEmpty($AccessPackageId))
        {
            $ObjectGuid = [System.Guid]::empty
            $isGUID = [System.Guid]::TryParse($AccessPackageId, [System.Management.Automation.PSReference]$ObjectGuid)
            if (-not $isGUID)
            {
                # Retrieve by name
                Write-Verbose -Message "Retrieving Entitlement Management Access Package by Name {$AccessPackageId}"
                $package = Get-MgBetaEntitlementManagementAccessPackage -Filter "displayName eq '$AccessPackageId'"
                if ($null -ne $package)
                {
                    $AccessPackageId = $package.Id
                }
                else
                {
                    throw "Could not retrieve the Access Package using identifier {$AccessPackageId}"
                }
            }
            $UpdateParameters.AccessPackageId = $AccessPackageId
        }

        #write-verbose ($UpdateParameters|convertto-json -Depth 100)
        Set-MgBetaEntitlementManagementAccessPackageAssignmentPolicy `
            -BodyParameter $UpdateParameters `
            -AccessPackageAssignmentPolicyId $currentInstance.Id
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the access package assignment policy {$DisplayName}"
        Remove-MgBetaEntitlementManagementAccessPackageAssignmentPolicy -AccessPackageAssignmentPolicyId $currentInstance.Id
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.String]
        $Id,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DisplayName,

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

        [Parameter()]
        [System.String]
        [ValidateSet('Absent', 'Present')]
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

    if ($CurrentValues.Ensure -ne $PSBoundParameters.Ensure)
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult = $true

    #Compare Cim instances
    foreach ($key in $PSBoundParameters.Keys)
    {
        $source = $PSBoundParameters.$key
        $target = $CurrentValues.$key
        if ($source.getType().Name -like '*CimInstance*')
        {
            $source = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $source

            $testResult = Compare-M365DSCComplexObject `
                -Source ($source) `
                -Target ($target)

            if (-Not $testResult)
            {
                $testResult = $false
                break
            }

            $ValuesToCheck.Remove($key) | Out-Null
        }
    }

    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null
    $ValuesToCheck.Remove('Id') | Out-Null

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    if ($testResult)
    {
        $testResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
            -Source $($MyInvocation.MyCommand.Source) `
            -DesiredValues $PSBoundParameters `
            -ValuesToCheck $ValuesToCheck.Keys
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
        [array]$getValue = Get-MgBetaEntitlementManagementAccessPackageAssignmentPolicy `
            -All `
            -ErrorAction Stop

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
            $displayedKey = $config.id
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                id                    = $config.id
                DisplayName           = $config.displayName
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

            if ($null -ne $Results.AccessReviewSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'Reviewers'
                        CimInstanceName = 'MicrosoftGraphuserset'
                        IsRequired      = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                                                -ComplexObject $Results.AccessReviewSettings `
                                                -CIMInstanceName MicrosoftGraphassignmentreviewsettings `
                                                -ComplexTypeMapping $complexMapping
                if ($complexTypeStringResult)
                {
                    $Results.AccessReviewSettings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AccessReviewSettings') | Out-Null
                }
            }
            if ($null -ne $Results.Questions)
            {
                $complexMapping = @(
                    @{
                        Name            = 'QuestionText'
                        CimInstanceName = 'MicrosoftGraphaccessPackageLocalizedContent'
                        IsRequired      = $false
                    }
                    @{
                        Name            = 'Choices'
                        CimInstanceName = 'MicrosoftGraphaccessPackageAnswerChoice'
                        IsRequired      = $false
                    }
                    @{
                        Name            = 'DisplayValue'
                        CimInstanceName = 'MicrosoftGraphaccessPackageLocalizedContent'
                        IsRequired      = $false
                    }
                    @{
                        Name            = 'localizedTexts'
                        CimInstanceName = 'MicrosoftGraphaccessPackageLocalizedText'
                        IsRequired      = $false
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.Questions `
                    -CIMInstanceName MicrosoftGraphaccesspackagequestion `
                    -ComplexTypeMapping $complexMapping

                if ($complexTypeStringResult)
                {
                    $Results.Questions = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('Questions') | Out-Null
                }
            }
            if ($null -ne $Results.RequestApprovalSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'ApprovalStages'
                        CimInstanceName = 'MicrosoftGraphapprovalstage1'
                        IsRequired      = $false
                    }
                    @{
                        Name            = 'PrimaryApprovers'
                        CimInstanceName = 'MicrosoftGraphuserset'
                        IsRequired      = $false
                    }
                    @{
                        Name            = 'EscalationApprovers'
                        CimInstanceName = 'MicrosoftGraphuserset'
                        IsRequired      = $false
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
            }
            if ($null -ne $Results.RequestorSettings)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AllowedRequestors'
                        CimInstanceName = 'MicrosoftGraphuserset'
                        IsRequired      = $false
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
            }
            if ($null -ne $Results.CustomExtensionHandlers )
            {
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
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential

            if ($null -ne $Results.AccessReviewSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AccessReviewSettings'
                #$currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Reviewers'
            }
            if ($null -ne $Results.Questions )
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'Questions' -IsCIMArray:$true
            }
            if ($null -ne $Results.RequestApprovalSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'RequestApprovalSettings'
            }
            if ($null -ne $Results.RequestorSettings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'RequestorSettings'
            }
            if ($null -ne $Results.CustomExtensionHandlers)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'CustomExtensionHandlers' -IsCIMArray:$true
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
        if ($_.ErrorDetails.Message -like '*User is not authorized to perform the operation.*')
        {
            Write-Host "`r`n    $($Global:M365DSCEmojiYellowCircle) Tenant does not meet license requirement to extract this component."
        }
        else
        {
            Write-Host $Global:M365DSCEmojiRedX

            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential
        }

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
