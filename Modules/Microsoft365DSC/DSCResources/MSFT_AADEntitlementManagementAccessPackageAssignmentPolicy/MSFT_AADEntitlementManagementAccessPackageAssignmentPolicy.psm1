Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AADEntitlementManagementAccessPackageAssignmentPolicy'

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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration of Azure AD Entitlement Management Access Package Assignment Policy with Id {$Id} and DisplayName {$DisplayName}"

    try
    {
        $null = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        $formattedAccessReviewSettings = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.AccessReviewSettings
        if ($null -ne $formattedAccessReviewSettings -and $formattedAccessReviewSettings.Count -ne 0)
        {
            $formattedAccessReviewSettings.Remove('additionalProperties') | Out-Null
            if (-not [System.String]::IsNullOrEmpty($formattedAccessReviewSettings.StartDateTime))
            {
                $formattedAccessReviewSettings.StartDateTime = $getValue.AccessReviewSettings.StartDateTime.ToString("o")
            }
        }
        else
        {
            $formattedAccessReviewSettings = $null
        }

        if ($null -ne $formattedAccessReviewSettings.Reviewers -and $formattedAccessReviewSettings.Reviewers.Count -gt 0 )
        {
            foreach ($setting in $formattedAccessReviewSettings.Reviewers)
            {
                $setting.Add('odataType', $setting.AdditionalProperties.'@odata.type')
                if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.id))
                {
                    $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue

                    if ($null -ne $user)
                    {
                        $setting.Add('Id', $user.UserPrincipalName)
                    }
                }
                if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.managerLevel))
                {
                    $setting.Add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                }
                $setting.Remove('AdditionalProperties') | Out-Null
            }
        }
        #endregion

        #region Format RequestApprovalSettings
        $formattedRequestApprovalSettings = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.RequestApprovalSettings
        if ($null -ne $formattedRequestApprovalSettings)
        {
            $formattedRequestApprovalSettings.Remove('additionalProperties') | Out-Null
        }
        if ($null -ne $formattedRequestApprovalSettings.approvalStages -and $formattedRequestApprovalSettings.approvalStages.Count -gt 0 )
        {
            foreach ($approvalStage in $formattedRequestApprovalSettings.approvalStages)
            {
                if ($null -ne $approvalStage.PrimaryApprovers -and $approvalStage.PrimaryApprovers.Count -gt 0)
                {
                    foreach ($setting in $approvalStage.PrimaryApprovers)
                    {
                        $setting.Add('odataType', $setting.AdditionalProperties.'@odata.type')
                        if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.id))
                        {
                            $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue
                            if ($null -ne $user)
                            {
                                $setting.Add('Id', $user.UserPrincipalName)
                            }
                        }
                        if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.managerLevel))
                        {
                            $setting.Add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                        }
                        $setting.Remove('additionalProperties') | Out-Null
                    }
                }

                if ($null -ne $approvalStage.EscalationApprovers -and $approvalStage.EscalationApprovers.Count -gt 0)
                {
                    foreach ($setting in $approvalStage.EscalationApprovers)
                    {
                        $setting.Add('odataType', $setting.AdditionalProperties.'@odata.type')
                        if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.id))
                        {
                            $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue
                            if ($null -ne $user)
                            {
                                $setting.Add('Id', $user.UserPrincipalName)
                            }
                        }
                        if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.managerLevel))
                        {
                            $setting.Add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                        }
                        $setting.Remove('additionalProperties') | Out-Null
                    }
                }
                $approvalStage.Remove('additionalProperties') | Out-Null
            }
        }
        #endregion

        #region Format RequestorSettings
        $formattedRequestorSettings = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.RequestorSettings
        if ($null -ne $formattedRequestorSettings)
        {
            $formattedRequestorSettings.Remove('additionalProperties') | Out-Null
        }
        if ($null -ne $formattedRequestorSettings.allowedRequestors -and $formattedRequestorSettings.allowedRequestors.Count -gt 0 )
        {
            foreach ($setting in $formattedRequestorSettings.allowedRequestors)
            {
                if (-not $setting.ContainsKey('odataType'))
                {
                    $setting.Add('odataType', $setting.AdditionalProperties.'@odata.type')
                }
                if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.id))
                {
                    # Check the @odata.type to determine if this is a user or group
                    $odataType = $setting.AdditionalProperties.'@odata.type'

                    if ($odataType -eq '#microsoft.graph.singleUser')
                    {
                        # Handle single user - try to resolve to UserPrincipalName
                        $user = Get-MgUser -UserId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue
                        if ($null -ne $user)
                        {
                            $setting.Add('Id', $user.UserPrincipalName)
                        }
                        else
                        {
                            # If user not found, keep the original ID (could be UPN already)
                            $setting.Add('Id', $setting.AdditionalProperties.id)
                        }
                    }
                    elseif ($odataType -eq '#microsoft.graph.groupMembers')
                    {
                        # Handle group members - try to resolve group to DisplayName, fallback to GUID
                        $group = Get-MgGroup -GroupId $setting.AdditionalProperties.id -ErrorAction SilentlyContinue
                        if ($null -ne $group)
                        {
                            $setting.Add('Id', $group.DisplayName)
                        }
                        else
                        {
                            # If group not found, keep the GUID
                            $setting.Add('Id', $setting.AdditionalProperties.id)
                        }
                    }
                    else
                    {
                        # For other types (requestorManager, etc.), keep the original ID
                        $setting.Add('Id', $setting.AdditionalProperties.id)
                    }
                }
                if (-not [System.String]::IsNullOrEmpty($setting.AdditionalProperties.managerLevel))
                {
                    $setting.Add('ManagerLevel', $setting.AdditionalProperties.managerLevel)
                }
                $setting.Remove('additionalProperties') | Out-Null
            }
        }
        #endregion

        #region Format Questions
        [array]$formattedQuestions = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $getValue.Questions
        foreach ($question in $formattedQuestions)
        {
            if (-not $question.ContainsKey('odataType'))
            {
                $question.Add('odataType', $question.AdditionalProperties.'@odata.type')
            }
            if ($null -ne $question.Text)
            {
                $question.Add('QuestionText', $question.Text)
                $question.Remove('Text') | Out-Null
                $question.QuestionText.Remove('additionalProperties') | Out-Null
                foreach ($localizedText in $question.QuestionText.localizedTexts)
                {
                    $localizedText.Remove('additionalProperties') | Out-Null
                }
            }
            if ($null -ne $question.AdditionalProperties.isSingleLineQuestion)
            {
                $question.Add('IsSingleLineQuestion', $question.AdditionalProperties.isSingleLineQuestion)
            }
            if ($null -ne $question.AdditionalProperties.choices)
            {
                $question.Add('Choices', [Array]$question.AdditionalProperties.choices)
            }
            if ($null -ne $question.AdditionalProperties.allowsMultipleSelection)
            {
                $question.Add('AllowsMultipleSelection', $question.AdditionalProperties.allowsMultipleSelection)
            }
            $question.Remove('additionalProperties') | Out-Null
        }
        #endregion

        #region Format CustomExtensionHandlers
        $formattedCustomExtensionHandlers = @()
        foreach ($customExtensionHandler in $getValue.CustomExtensionHandlers)
        {
            $customExt = @{
                #Id              = $customExtensionHandler.Id #Read Only
                Stage             = $customExtensionHandler.Stage
                CustomExtensionId = $customExtensionHandler.CustomExtension.Id
            }
            $formattedCustomExtensionHandlers += $customExt
        }
        #endregion

        $AccessPackageIdValue = $getValue.AccessPackageId
        $isGUID = [System.Guid]::TryParse($AccessPackageIdValue, [ref][System.Guid]::Empty)
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
            AccessTokens            = $AccessTokens
        }

        return $results
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
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Setting configuration of AzureAD Entitlement Management Access Package Assignment Policy for DisplayName {$DisplayName}"

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

    $keyToRename = @{
        'odataType'    = '@odata.type'
        'QuestionText' = 'text'
    }

    $commonParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $commonParameters = Rename-M365DSCCimInstanceParameter -Properties $commonParameters -KeyMapping $keyToRename

    if ($null -ne $commonParameters.AccessReviewSettings -and $null -ne $commonParameters.AccessReviewSettings.Reviewers)
    {
        for ($i = 0; $i -lt $commonParameters.AccessReviewSettings.Reviewers.Length; $i++)
        {
            $reviewer = $commonParameters.AccessReviewSettings.Reviewers[$i]
            $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($reviewer.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
            if ($null -ne $user)
            {
                $commonParameters.AccessReviewSettings.Reviewers[$i].Id = $user.Id
            }
        }
    }

    if ($null -ne $commonParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers)
    {
        for ($i = 0; $i -lt $commonParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers.Length; $i++)
        {
            $primaryApprover = $commonParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers[$i]
            if ($null -ne $primaryApprover.id)
            {
                $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($primaryApprover.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                if ($null -ne $user)
                {
                    $commonParameters.RequestApprovalSettings.ApprovalStages.PrimaryApprovers[$i].Id = $user.Id
                }
            }
        }
    }

    if ($null -ne $commonParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers)
    {
        for ($i = 0; $i -lt $commonParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers.Length; $i++)
        {
            $escalationApprover = $commonParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers[$i]
            if ($null -ne $escalationApprover.id)
            {
                $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($escalationApprover.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                if ($null -ne $user)
                {
                    $commonParameters.RequestApprovalSettings.ApprovalStages.EscalationApprovers[$i].Id = $user.Id
                }
            }
        }
    }

    if ($null -ne $commonParameters.RequestorSettings -and $null -ne $commonParameters.RequestorSettings.AllowedRequestors)
    {
        for ($i = 0; $i -lt $commonParameters.RequestorSettings.AllowedRequestors.Length; $i++)
        {
            $requestor = $commonParameters.RequestorSettings.AllowedRequestors[$i]
            $odataType = $requestor.'@odata.type'

            if ($odataType -eq '#microsoft.graph.singleUser')
            {
                # Handle single user - convert UPN to GUID
                if ($requestor.Id -like '*@*')
                {
                    $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($requestor.Id.Split('@')[0])')" -ErrorAction SilentlyContinue
                    if ($null -ne $user)
                    {
                        $commonParameters.RequestorSettings.AllowedRequestors[$i].Id = $user.Id
                    }
                }
                # If already a GUID, leave as-is
            }
            elseif ($odataType -eq '#microsoft.graph.groupMembers')
            {
                # Handle group members - convert DisplayName to GUID if needed
                $isGUID = [System.Guid]::TryParse($requestor.Id, [ref][System.Guid]::Empty)

                if (-not $isGUID)
                {
                    # Try to resolve by DisplayName
                    $group = Get-MgGroup -Filter "displayName eq '$($requestor.Id.Replace("'", "''"))'" -ErrorAction SilentlyContinue
                    if ($null -ne $group)
                    {
                        $commonParameters.RequestorSettings.AllowedRequestors[$i].Id = $group.Id
                    }
                }
                # If already a GUID, leave as-is
            }
            # For other types (requestorManager, etc.), leave ID as-is
        }
    }

    if ($null -ne $commonParameters.CustomExtensionHandlers -and $commonParameters.CustomExtensionHandlers.Count -gt 0 )
    {
        $formattedCustomExtensionHandlers = @()
        foreach ($customExtensionHandler in $commonParameters.CustomExtensionHandlers)
        {
            $extensionId = $customExtensionHandler.CustomExtensionId
            $formattedCustomExtensionHandlers += @{
                stage           = $customExtensionHandler.Stage
                customExtension = @{
                    id = $extensionId
                }
            }
        }
        $commonParameters.CustomExtensionHandlers = $formattedCustomExtensionHandlers
    }

    # Check to see if the AccessPackageId is in GUID form. If not, resolve it by name.
    if (-not [System.String]::IsNullOrEmpty($AccessPackageId))
    {
        $isGUID = [System.Guid]::TryParse($AccessPackageId, [ref][System.Guid]::Empty)
        if (-not $isGUID)
        {
            # Retrieve by name
            Write-Verbose -Message "Retrieving Entitlement Management Access Package by Name {$AccessPackageId}"
            $package = Get-MgBetaEntitlementManagementAccessPackage -Filter "DisplayName eq '$($AccessPackageId -replace "'", "''")'"
            if ($null -eq $package)
            {
                throw "Could not retrieve the Access Package using identifier {$AccessPackageId}"
            }
            $AccessPackageId = $package.Id
        }
        $commonParameters.AccessPackageId = $AccessPackageId
    }

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating a new access package assignment policy {$DisplayName}"

        $CreateParameters = $commonParameters
        $CreateParameters.Remove('Id') | Out-Null

        New-MgBetaEntitlementManagementAccessPackageAssignmentPolicy `
            -BodyParameter $CreateParameters
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the access package assignment policy {$DisplayName}"

        $UpdateParameters = $commonParameters
        $UpdateParameters.Remove('Id') | Out-Null

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

    $result = Test-M365DSCTargetResource -DesiredValues $PSBoundParameters `
        -ResourceName $ResourceName
    return $result
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.String]
        $Filter,

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
            -Filter $Filter `
            -ErrorAction Stop

        $i = 1
        $dscContent = [System.Text.StringBuilder]::new()
        if ($getValue.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        foreach ($config in $getValue)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }

            $displayedKey = $config.id
            if (-not [System.String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                id                    = $config.id
                DisplayName           = $config.displayName
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Results = Get-TargetResource @Params

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
                -Credential $Credential `
                -NoEscape @('AccessReviewSettings', 'Questions', 'RequestApprovalSettings', 'RequestorSettings', 'CustomExtensionHandlers')

            [void]$dscContent.Append($currentDSCBlock)
            Save-M365DSCPartialExport -Content $currentDSCBlock `
                -FileName $Global:PartialExportFileName
            $i++
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        return $dscContent.ToString()
    }
    catch
    {
        if ($_.ErrorDetails.Message -like '*User is not authorized to perform the operation.*')
        {
            Write-M365DSCHost -Message "`r`n    $($Global:M365DSCEmojiYellowCircle) Tenant does not meet license requirement to extract this component."
            return ''
        }
        else
        {
            New-M365DSCLogEntry -Message 'Error during Export:' `
                -Exception $_ `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId `
                -Credential $Credential

            throw
        }
    }
}

Export-ModuleMember -Function *-TargetResource
