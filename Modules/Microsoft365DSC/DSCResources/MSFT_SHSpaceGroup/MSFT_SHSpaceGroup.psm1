function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SpaceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupName,

        [Parameter()]
        [System.String[]]
        $Roles,

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

    New-M365DSCConnection -Workload 'EngageHub' `
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
        Write-Verbose -Message "Retrieving space by name {$SpaceName}"
        $spacesUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces"
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $spacesUri -Method GET
        $space = $response.value | Where-Object -FilterScript {$_.name -eq $SpaceName}

        if ($space.Length -gt 1)
        {
            throw "Multiple spaces with name {$SpaceName} were found"
        }
        elseif ($null -eq $space -or $space.Length -eq 0)
        {
            return $nullResult
        }

        $groupsUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces/" + $space.spaceId + "/groups"
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $groupsUri -Method GET
        $instance = $response.value | Where-Object -FilterScript {$_.groupName -eq $GroupName}

        if ($instance.Length -gt 1)
        {
            throw "Multiple groups with name {$GroupName} were found."
        }
        elseif ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            SpaceName             = $SpaceName
            GroupName             = $GroupName
            Roles                 = $instance.roles
            Ensure                = 'Present'
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
        $SpaceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupName,

        [Parameter()]
        [System.String[]]
        $Roles,

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

    Write-Verbose -Message "Retrieving space by name {$SpaceName}"
    $spacesUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces"
    $response = Invoke-M365DSCServicesHubWebRequest -Uri $spacesUri -Method GET
    $space = $response.value | Where-Object -FilterScript {$_.name -eq $SpaceName}

    if ($currentInstance.Ensure -eq 'Present')
    {
        $groupsUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces/" + $space.spaceId + "/groups"
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $groupsUri -Method GET
        $group = $response.value | Where-Object -FilterScript {$_.groupName -eq $GroupName}
    }

    # Retrieve Group ID from Microsoft Graph
    Write-Verbose -Message "Authenticating to Microsoft Graph"
    New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters | Out-Null

    Write-Verbose -Message "Retrieving group id for {$GroupName}"
    $groupInfo = Get-MgGroup -Filter "displayName eq '$GroupName'"
    Write-Verbose -Message "Found group info:`r`n$($groupInfo | Out-String)"
    $groupId = $null
    if ($null -ne $groupInfo)
    {
        $groupId = $groupInfo.Id
        Write-Verbose -Message "Retrieved GroupId {$groupId}"
    }
    else
    {
        throw "Could not retrieve group {$GroupName} from Entra Id."
    }

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating new group {$GroupName} with Roles {$($Roles -join ',')}"
        $body = @{
            DisplayName = $GroupName
            Roles       = $Roles
            GroupId     = $groupId
        }

        $uri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces/" + $space.spaceId + "/groups"
        Write-Verbose -Message "POST request to {$uri}`r`n$(ConvertTo-Json $body -Depth 5)"
        Invoke-M365DSCServicesHubWebRequest -Uri $uri `
                                            -Method POST `
                                            -Body $body
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating group {$GroupName} with Roles {$($Roles -join ',')}"
        $body = @{
            roles = $Roles;
        }

        $uri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces/" + $space.spaceId + "/groups/" + $group.groupId
        Write-Verbose -Message "PATCH request to {$uri}`r`n$(ConvertTo-Json $body -Depth 5)"
        Invoke-M365DSCServicesHubWebRequest -Uri $uri `
                                            -Method PATCH `
                                            -Body $body
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing group {$GroupName}"
        $uri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces/" + $space.spaceId + "/groups/" + $group.groupId
        Invoke-M365DSCServicesHubWebRequest -Uri $uri `
                                            -Method DELETE
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
        $SpaceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GroupName,

        [Parameter()]
        [System.String[]]
        $Roles,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'EngageHub' `
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

        $spacesUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces"
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $spacesUri -Method GET
        $spaces = $response.value

        $dscContent = ''
        if ($spaces.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }

        $j = 1
        foreach ($space in $spaces)
        {
            $displayedKey = $space.name
            Write-M365DSCHost -Message "    |---[$j/$($spaces.Count)] $displayedKey" -DeferWrite

            $groupsUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + "/spaces/" + $space.spaceId + "/groups"
            $response = Invoke-M365DSCServicesHubWebRequest -Uri $groupsUri -Method GET
            $groups = $response.value

            if ($groups.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }

            $i = 1
            foreach ($group in $groups)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $displayedKey = $group.groupName
                Write-M365DSCHost -Message "        |---[$i/$($groups.Count)] $displayedKey" -DeferWrite
                $params = @{
                    SpaceName             = $space.name
                    GroupName             = $group.groupName
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ManagedIdentity       = $ManagedIdentity.IsPresent
                    AccessTokens          = $AccessTokens
                }

                $Results = Get-TargetResource @Params
                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                $i++
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            $j++
        }
        return $dscContent
    }
    catch
    {
        Write-M365DSCHost -Message $Global:M365DSCEmojiRedX -CommitWrite

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
