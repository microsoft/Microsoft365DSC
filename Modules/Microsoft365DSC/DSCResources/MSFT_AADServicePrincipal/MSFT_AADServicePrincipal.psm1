function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $AppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

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
        $ManagedIdentity
    )

    Write-Verbose -Message 'Getting configuration of Azure AD ServicePrincipal'
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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
        try
        {
            if (-not [System.String]::IsNullOrEmpty($ObjectID))
            {
                if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
                {
                    $AADServicePrincipal = $Script:exportedInstances | Where-Object -FilterScript {$_.Id -eq $Id}
                }
                else
                {
                    $AADServicePrincipal = Get-MgServicePrincipal -ServicePrincipalId $ObjectId `
                        -Expand 'AppRoleAssignedTo' `
                        -ErrorAction Stop
                }
            }
        }
        catch
        {
            Write-Verbose -Message "Azure AD ServicePrincipal with ObjectID: $($ObjectID) could not be retrieved"
        }

        if ($null -eq $AADServicePrincipal)
        {
            if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
            {
                $AADServicePrincipal = $Script:exportedInstances | Where-Object -FilterScript {$_.AppId -eq $AppId}
            }
            else
            {
                $ObjectGuid = [System.Guid]::empty
                if (-not [System.Guid]::TryParse($AppId, [System.Management.Automation.PSReference]$ObjectGuid))
                {
                    $appInstance = Get-MgApplication -Filter "DisplayName eq '$AppId'"
                    if ($appInstance)
                    {
                        $AADServicePrincipal = Get-MgServicePrincipal -Filter "AppID eq '$($appInstance.AppId)'" `
                                                                    -Expand 'AppRoleAssignedTo'
                    }
                }
                else
                {
                    $AADServicePrincipal = Get-MgServicePrincipal -Filter "AppID eq '$($AppId)'" `
                                                                -Expand 'AppRoleAssignedTo'
                }
            }
        }
        if ($null -eq $AADServicePrincipal)
        {
            return $nullReturn
        }
        else
        {
            $AppRoleAssignedToValues = @()
            foreach ($principal in $AADServicePrincipal.AppRoleAssignedTo)
            {
                $currentAssignment = @{
                    PrincipalType = $null
                    Identity      = $null
                }
                if ($principal.PrincipalType -eq 'User')
                {
                    $user = Get-MgUser -UserId $principal.PrincipalId
                    $currentAssignment.PrincipalType = 'User'
                    $currentAssignment.Identity = $user.UserPrincipalName.Split('@')[0]
                    $AppRoleAssignedToValues += $currentAssignment
                }
                elseif ($principal.PrincipalType -eq 'Group')
                {
                    $group = Get-MgGroup -GroupId $principal.PrincipalId
                    $currentAssignment.PrincipalType = 'Group'
                    $currentAssignment.Identity = $group.DisplayName
                    $AppRoleAssignedToValues += $currentAssignment
                }
            }

            $result = @{
                AppId                     = $AADServicePrincipal.AppId
                AppRoleAssignedTo         = $AppRoleAssignedToValues
                ObjectID                  = $AADServicePrincipal.Id
                DisplayName               = $AADServicePrincipal.DisplayName
                AlternativeNames          = $AADServicePrincipal.AlternativeNames
                AccountEnabled            = [boolean]$AADServicePrincipal.AccountEnabled
                AppRoleAssignmentRequired = $AADServicePrincipal.AppRoleAssignmentRequired
                ErrorUrl                  = $AADServicePrincipal.ErrorUrl
                Homepage                  = $AADServicePrincipal.Homepage
                LogoutUrl                 = $AADServicePrincipal.LogoutUrl
                PublisherName             = $AADServicePrincipal.PublisherName
                ReplyURLs                 = $AADServicePrincipal.ReplyURLs
                SamlMetadataURL           = $AADServicePrincipal.SamlMetadataURL
                ServicePrincipalNames     = $AADServicePrincipal.ServicePrincipalNames
                ServicePrincipalType      = $AADServicePrincipal.ServicePrincipalType
                Tags                      = $AADServicePrincipal.Tags
                Ensure                    = 'Present'
                Credential                = $Credential
                ApplicationId             = $ApplicationId
                ApplicationSecret         = $ApplicationSecret
                TenantId                  = $TenantId
                CertificateThumbprint     = $CertificateThumbprint
                Managedidentity           = $ManagedIdentity.IsPresent
            }
            Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
            return $result
        }
    }
    catch
    {
        Write-Verbose -Message $_
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
        $AppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

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
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    Write-Verbose -Message 'Setting configuration of Azure AD ServicePrincipal'
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

    $currentAADServicePrincipal = Get-TargetResource @PSBoundParameters
    $currentParameters = $PSBoundParameters
    $currentParameters.Remove('ApplicationId') | Out-Null
    $currentParameters.Remove('TenantId') | Out-Null
    $currentParameters.Remove('CertificateThumbprint') | Out-Null
    $currentParameters.Remove('ManagedIdentity') | Out-Null
    $currentParameters.Remove('Credential') | Out-Null
    $currentParameters.Remove('Ensure') | Out-Null
    $currentParameters.Remove('ObjectID') | Out-Null
    $currentParameters.Remove('ApplicationSecret') | Out-Null

    # ServicePrincipal should exist but it doesn't
    if ($Ensure -eq 'Present' -and $currentAADServicePrincipal.Ensure -eq 'Absent')
    {
        if ($null -ne $AppRoleAssignedTo)
        {
            $currentParameters.AppRoleAssignedTo = $AppRoleAssignedToValue
        }
        $ObjectGuid = [System.Guid]::empty
        if (-not [System.Guid]::TryParse($AppId, [System.Management.Automation.PSReference]$ObjectGuid))
        {
            $appInstance = Get-MgApplication -Filter "DisplayName eq '$AppId'"
            $currentParameters.AppId = $appInstance.AppId
        }

        Write-Verbose -Message 'Creating new Service Principal'
        Write-Verbose -Message "With Values: $(Convert-M365DscHashtableToString -Hashtable $currentParameters)"
        New-MgServicePrincipal @currentParameters
    }
    # ServicePrincipal should exist and will be configured to desired state
    elseif ($Ensure -eq 'Present' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Updating existing Service Principal'
        $ObjectGuid = [System.Guid]::empty
        if (-not [System.Guid]::TryParse($AppId, [System.Management.Automation.PSReference]$ObjectGuid))
        {
            $appInstance = Get-MgApplication -Filter "DisplayName eq '$AppId'"
            $currentParameters.AppId = $appInstance.AppId
        }
        Write-Verbose -Message "CurrentParameters: $($currentParameters | Out-String)"
        Write-Verbose -Message "ServicePrincipalID: $($currentAADServicePrincipal.ObjectID)"
        $currentParameters.Remove('AppRoleAssignedTo') | Out-Null
        Update-MgServicePrincipal -ServicePrincipalId $currentAADServicePrincipal.ObjectID @currentParameters

        if ($AppRoleAssignedTo)
        {
            [Array]$currentPrincipals = $currentAADServicePrincipal.AppRoleAssignedTo.Identity
            [Array]$desiredPrincipals = $AppRoleAssignedTo.Identity

            [Array]$differences = Compare-Object -ReferenceObject $currentPrincipals -DifferenceObject $desiredPrincipals
            [Array]$membersToAdd = $differences | Where-Object -FilterScript {$_.SideIndicator -eq '=>'}
            [Array]$membersToRemove = $differences | Where-Object -FilterScript {$_.SideIndicator -eq '<='}

            if ($differences.Count -gt 0)
            {
                if ($membersToAdd.Count -gt 0)
                {
                    $AppRoleAssignedToValues = @()
                    foreach ($assignment in $AppRoleAssignedTo)
                    {
                        $AppRoleAssignedToValues += @{
                            PrincipalType = $assignment.PrincipalType
                            Identity      = $assignment.Identity
                        }
                    }
                    foreach ($member in $membersToAdd)
                    {
                        $assignment = $AppRoleAssignedToValues | Where-Object -FilterScript {$_.Identity -eq $member.InputObject}
                        if ($assignment.PrincipalType -eq 'User')
                        {
                            Write-Verbose -Message "Retrieving user {$($assignment.Identity)}"
                            $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($assignment.Identity)')"
                            $PrincipalIdValue = $user.Id
                        }
                        else
                        {
                            Write-Verbose -Message "Retrieving group {$($assignment.Identity)}"
                            $group = Get-MgGroup -Filter "DisplayName eq '$($assignment.Identity)'"
                            $PrincipalIdValue = $group.Id
                        }

                        $bodyParam = @{
                            principalId = $PrincipalIdValue
                            resourceId  = $currentAADServicePrincipal.ObjectID
                            appRoleId   = "00000000-0000-0000-0000-000000000000"
                        }
                        Write-Verbose -Message "Adding member {$($member.InputObject.ToString())}"
                        New-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $currentAADServicePrincipal.ObjectID `
                            -BodyParameter $bodyParam | Out-Null
                    }
                }

                if ($membersToRemove.Count -gt 0)
                {
                    $AppRoleAssignedToValues = @()
                    foreach ($assignment in $currentAADServicePrincipal.AppRoleAssignedTo)
                    {
                        $AppRoleAssignedToValues += @{
                            PrincipalType = $assignment.PrincipalType
                            Identity      = $assignment.Identity
                        }
                    }
                    foreach ($member in $membersToRemove)
                    {
                        $assignment = $AppRoleAssignedToValues | Where-Object -FilterScript {$_.Identity -eq $member.InputObject}
                        if ($assignment.PrincipalType -eq 'User')
                        {
                            Write-Verbose -Message "Retrieving user {$($assignment.Identity)}"
                            $user = Get-MgUser -Filter "startswith(UserPrincipalName, '$($assignment.Identity)')"
                            $PrincipalIdValue = $user.Id
                        }
                        else
                        {
                            Write-Verbose -Message "Retrieving group {$($assignment.Identity)}"
                            $group = Get-MgGroup -Filter "DisplayName eq '$($assignment.Identity)'"
                            $PrincipalIdValue = $group.Id
                        }
                        Write-Verbose -Message "PrincipalID Value = '$PrincipalIdValue'"
                        Write-Verbose -Message "ServicePrincipalId = '$($currentAADServicePrincipal.ObjectID)'"
                        $allAssignments = Get-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $currentAADServicePrincipal.ObjectID
                        $assignmentToRemove = $allAssignments | Where-Object -FilterScript {$_.PrincipalId -eq $PrincipalIdValue}
                        Write-Verbose -Message "Removing member {$($member.InputObject.ToString())}"
                        Remove-MgServicePrincipalAppRoleAssignedTo -ServicePrincipalId $currentAADServicePrincipal.ObjectID `
                            -AppRoleAssignmentId $assignmentToRemove.Id | Out-Null
                    }
                }
            }
        }
    }
    # ServicePrincipal exists but should not
    elseif ($Ensure -eq 'Absent' -and $currentAADServicePrincipal.Ensure -eq 'Present')
    {
        Write-Verbose -Message 'Removing Service Principal'
        Remove-MgServicePrincipal -ServicePrincipalId $currentAADServicePrincipal.ObjectID
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
        $AppId,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AppRoleAssignedTo,

        [Parameter()]
        [System.String]
        $ObjectId,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.String[]]
        $AlternativeNames,

        [Parameter()]
        [System.Boolean]
        $AccountEnabled,

        [Parameter()]
        [System.Boolean]
        $AppRoleAssignmentRequired,

        [Parameter()]
        [System.String]
        $ErrorUrl,

        [Parameter()]
        [System.String]
        $Homepage,

        [Parameter()]
        [System.String]
        $LogoutUrl,

        [Parameter()]
        [System.String]
        $PublisherName,

        [Parameter()]
        [System.String[]]
        $ReplyUrls,

        [Parameter()]
        [System.String]
        $SamlMetadataURL,

        [Parameter()]
        [System.String[]]
        $ServicePrincipalNames,

        [Parameter()]
        [System.String]
        $ServicePrincipalType,

        [Parameter()]
        [System.String[]]
        $Tags,

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
        $ManagedIdentity
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

    Write-Verbose -Message 'Testing configuration of Azure AD ServicePrincipal'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('CertificateThumbprint') | Out-Null
    $ValuesToCheck.Remove('ManagedIdentity') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('AppId') | Out-Null

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

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
        $ManagedIdentity
    )
    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
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

    $dscContent = ''
    try
    {
        $i = 1
        Write-Host "`r`n" -NoNewline
        $Script:ExportMode = $true
        [array] $Script:exportedInstances = Get-MgServicePrincipal -All:$true `
                                                                   -Filter $Filter `
                                                                   -Expand 'AppRoleAssignedTo' `
                                                                   -ErrorAction Stop
        foreach ($AADServicePrincipal in $Script:exportedInstances)
        {
            Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $($AADServicePrincipal.DisplayName)" -NoNewline
            $Params = @{
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                ApplicationSecret     = $ApplicationSecret
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                Managedidentity       = $ManagedIdentity.IsPresent
                AppID                 = $AADServicePrincipal.AppId
            }
            $Results = Get-TargetResource @Params

            if ($Results.Ensure -eq 'Present')
            {
                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $Results
                if ($Results.AppRoleAssignedTo.Count -gt 0)
                {
                    $Results.AppRoleAssignedTo = Get-M365DSCAzureADServicePrincipalAssignmentAsString -Assignments $Results.AppRoleAssignedTo
                }
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                if ($null -ne $Results.AppRoleAssignedTo)
                {
                    $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                        -ParameterName 'AppRoleAssignedTo'
                }
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName

                Write-Host $Global:M365DSCEmojiGreenCheckMark
                $i++
            }
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

function Get-M365DSCAzureADServicePrincipalAssignmentAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Assignments
    )

    $StringContent = '@('
    foreach ($assignment in $Assignments)
    {
        $StringContent += "MSFT_AADServicePrincipalRoleAssignment {`r`n"
        $StringContent += "                PrincipalType = '" + $assignment.PrincipalType + "'`r`n"
        $StringContent += "                Identity      = '" + $assignment.Identity + "'`r`n"
        $StringContent += "            }`r`n"
    }
    $StringContent += '            )'
    return $StringContent
}

Export-ModuleMember -Function *-TargetResource
