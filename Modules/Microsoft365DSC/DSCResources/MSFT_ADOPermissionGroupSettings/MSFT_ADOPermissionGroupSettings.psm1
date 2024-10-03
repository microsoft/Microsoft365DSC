function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.String]
        $Descriptor,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AllowPermissions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DenyPermissions,

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

    New-M365DSCConnection -Workload 'AzureDevOPS' `
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
    try
    {
        if ($null -ne $Script:exportedInstances -and $Script:ExportMode)
        {
            if (-not [System.String]::IsNullOrEmpty($Descriptor))
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.descriptor -eq $Descriptor}
            }

            if ($null -eq $instance)
            {
                $instance = $Script:exportedInstances | Where-Object -FilterScript {$_.principalName -eq $PrincipalName}
            }
        }
        else
        {
            $uri = "https://vssps.dev.azure.com/$OrganizationName/_apis/graph/groups?api-version=7.1-preview.1"
            $allInstances = (Invoke-M365DSCAzureDevOPSWebRequest -Uri $uri).value
            if (-not [System.String]::IsNullOrEmpty($Descriptor))
            {
                $instance = $allInstances | Where-Object -FilterScript {$_.descriptor -eq $Descriptor}
            }
            if ($null -eq $instance)
            {
                $instance = $allInstances | Where-Object -FilterScript {$_.principalName -eq $PrincipalName}
            }
        }
        if ($null -eq $instance)
        {
            return $nullResult
        }

        $groupPermissions = Get-M365DSCADOGroupPermission -GroupName $instance.principalName -OrganizationName $OrganizationName

        $results = @{
            OrganizationName      = $OrganizationName
            GroupName             = $instance.principalName
            Descriptor            = $instance.Descriptor
            AllowPermissions      = $groupPermissions.Allow
            DenyPermissions       = $groupPermissions.Deny
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        Write-Verbose -Message $_
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
        $GroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.String]
        $Descriptor,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AllowPermissions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DenyPermissions,

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

    $uri = "https://vssps.dev.azure.com/$($OrganizationName)/_apis/identities?subjectDescriptors=$($currentInstance.Descriptor)&api-version=7.2-preview.1"
    $info = Invoke-M365DSCAzureDevOPSWebRequest -Uri $uri
    $descriptor = $info.value.descriptor

    $body = @{
        value = @()
    }

    foreach ($permission in $AllowPermissions)
    {
        <#$content = @{
        inheritPermissions = $false
        "token": "token1",
        "acesDictionary": {
            "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1": {
            "descriptor": "Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1",
            "allow": 31,
            "deny": 0
            }
        }#>
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
        $GroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationName,

        [Parameter()]
        [System.String]
        $Descriptor,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $AllowPermissions,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $DenyPermissions,

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
    $ConnectionMode = New-M365DSCConnection -Workload 'AzureDevOPS' `
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

        $profileValue = Invoke-M365DSCAzureDevOPSWebRequest -Uri 'https://app.vssps.visualstudio.com/_apis/profile/profiles/me?api-version=5.1'
        $accounts = Invoke-M365DSCAzureDevOPSWebRequest -Uri "https://app.vssps.visualstudio.com/_apis/accounts?api-version=7.1-preview.1&memberId=$($profileValue.id)"

        $i = 1
        $dscContent = ''
        if ($accounts.count -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
            return ''
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($account in $accounts)
        {
            $organization = $account.Value.accountName
            $uri = "https://vssps.dev.azure.com/$organization/_apis/graph/groups?api-version=7.1-preview.1"

            [array] $Script:exportedInstances = (Invoke-M365DSCAzureDevOPSWebRequest -Uri $uri).Value

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
                $displayedKey = $config.principalName
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }
                Write-Host "    |---[$i/$($Script:exportedInstances.Count)] $displayedKey" -NoNewline
                $params = @{
                    OrganizationName      = $Organization
                    GroupName             = $config.principalName
                    Descriptor            = $config.descriptor
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                if (-not $config.principalName.StartsWith("[TEAM FOUNDATION]"))
                {
                    $Results = Get-TargetResource @Params
                    $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                        -Results $Results
                    if ($results.AllowPermissions.Length -gt 0)
                    {
                        $Results.AllowPermissions = Get-M365DSCADOPermissionsAsString $Results.AllowPermissions
                    }

                    if ($results.DenyPermissions.Length -gt 0)
                    {
                        $Results.DenyPermissions = Get-M365DSCADOPermissionsAsString $Results.DenyPermissions
                    }

                    $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                        -ConnectionMode $ConnectionMode `
                        -ModulePath $PSScriptRoot `
                        -Results $Results `
                        -Credential $Credential

                    if ($null -ne $Results.AllowPermissions)
                    {
                        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                            -ParameterName 'AllowPermissions'
                    }
                    if ($null -ne $Results.DenyPermissions)
                    {
                        $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock `
                            -ParameterName 'DenyPermissions'
                    }

                    $dscContent += $currentDSCBlock
                    Save-M365DSCPartialExport -Content $currentDSCBlock `
                        -FileName $Global:PartialExportFileName
                }
                $i++
                Write-Host $Global:M365DSCEmojiGreenCheckMark
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

function Get-M365DSCADOGroupPermission
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OrganizationName
    )

    $results = @{
        Allow = @()
        Deny  = @()
    }

    try
    {
        $uri = "https://vssps.dev.azure.com/$($OrganizationName)/_apis/graph/groups?api-version=7.1-preview.1"
        $groupInfo = Invoke-M365DSCAzureDevOPSWebRequest -Uri $uri
        $mygroup = $groupInfo.value | Where-Object -FilterScript {$_.principalName -eq $GroupName}

        $uri = "https://vssps.dev.azure.com/$($OrganizationName)/_apis/identities?subjectDescriptors=$($mygroup.descriptor)&api-version=7.2-preview.1"
        $info = Invoke-M365DSCAzureDevOPSWebRequest -Uri $uri
        $descriptor = $info.value.descriptor

        $uri = "https://dev.azure.com/$($OrganizationName)/_apis/securitynamespaces?api-version=7.1-preview.1"
        $responseSecurity = Invoke-M365DSCAzureDevOPSWebRequest -Uri $uri
        $securityNamespaces = $responseSecurity.Value

        foreach ($namespace in $securityNamespaces)
        {
            $uri = "https://dev.azure.com/$($OrganizationName)/_apis/accesscontrollists/$($namespace.namespaceId)?api-version=7.2-preview.1"
            $response = Invoke-M365DSCAzureDevOPSWebRequest -Uri $uri

            foreach ($entry in $response.value)
            {
                $token = $entry.token
                foreach ($ace in $entry.acesDictionary)
                {
                    if ($ace.$descriptor)
                    {
                        $allow = $ace.$descriptor.Allow
                        $allowBinary = [Convert]::ToString($allow, 2)

                        $deny = $ace.$descriptor.Deny
                        $denyBinary = [Convert]::ToString($deny, 2)

                        # Breakdown the allow bits
                        $position = -1
                        $bitMaskPositionsFound = @()
                        do
                        {
                            $position = $allowBinary.IndexOf('1', $position + 1)
                            if ($position -ge 0)
                            {
                                $zerosToAdd = $allowBinary.Length - $position - 1
                                $value = '1'
                                for ($i = 1; $i -le $zerosToAdd; $i++)
                                {
                                    $value += '0'
                                }

                                $bitMaskPositionsFound += $value
                            }
                        } while($position -ge 0 -and ($position+1) -le $allowBinary.Length)

                        foreach ($bitmask in $bitMaskPositionsFound)
                        {
                            $associatedAction = $namespace.actions | Where-Object -FilterScript {[Convert]::ToString($_.bit,2) -eq $bitmask}
                            if (-not [System.String]::IsNullOrEmpty($associatedAction.displayName))
                            {
                                $entry = @{
                                    DisplayName = $associatedAction.displayName
                                    Bit         = $associatedAction.bit
                                    NamespaceId = $namespace.namespaceId
                                    Token       = $token
                                }
                                $results.Allow += $entry
                            }
                        }

                        # Breakdown the deny bits
                        $position = -1
                        $bitMaskPositionsFound = @()
                        do
                        {
                            $position = $denyBinary.IndexOf('1', $position + 1)
                            if ($position -ge 0)
                            {
                                $zerosToAdd = $denyBinary.Length - $position - 1
                                $value = '1'
                                for ($i = 1; $i -le $zerosToAdd; $i++)
                                {
                                    $value += '0'
                                }

                                $bitMaskPositionsFound += $value
                            }
                        } while($position -ge 0 -and ($position+1) -le $denyBinary.Length)

                        foreach ($bitmask in $bitMaskPositionsFound)
                        {
                            $associatedAction = $namespace.actions | Where-Object -FilterScript {[Convert]::ToString($_.bit,2) -eq $bitmask}
                            if (-not [System.String]::IsNullOrEmpty($associatedAction.displayName))
                            {
                                $entry = @{
                                    DisplayName = $associatedAction.displayName
                                    Bit         = $associatedAction.bit
                                    NamespaceId = $namespace.namespaceId
                                }
                                $results.Deny += $entry
                            }
                        }
                    }
                }
            }
        }
    }
    catch
    {
        throw $_
    }
    return $results
}

function Get-M365DSCADOPermissionsAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.ArrayList]
        $Permissions
    )

    $StringContent = [System.Text.StringBuilder]::new()
    $StringContent.Append('@(') | Out-Null
    foreach ($permission in $Permissions)
    {
        $StringContent.Append("            MSFT_ADOPermission { `r`n") | Out-Null
        $StringContent.Append("                NamespaceId = '$($permission.NamespaceId)'`r`n") | Out-Null
        $StringContent.Append("                DisplayName = '$($permission.DisplayName.Replace("'", "''"))'`r`n") | Out-Null
        $StringContent.Append("                Bit         = '$($permission.Bit)'`r`n") | Out-Null
        $StringContent.Append("                Token       = '$($permission.Token)'`r`n") | Out-Null
        $StringContent.Append("            }`r`n") | Out-Null
    }
    $StringContent.Append('        )') | Out-Null
    return $StringContent.ToString()
}

Export-ModuleMember -Function *-TargetResource
