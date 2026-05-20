Confirm-M365DSCModuleDependency -ModuleName 'MSFT_SHSpaceUser'

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
        $Email,

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

    Write-Verbose -Message "Getting SHSpaceUser configuration for Space: $SpaceName, Email: $Email"

    try
    {
        $null = New-M365DSCConnection -Workload 'EngageHub' `
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

        Write-Verbose -Message "Retrieving space by name {$SpaceName}"
        $spacesUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces'
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $spacesUri -Method GET
        $space = $response.value | Where-Object -FilterScript { $_.name -eq $SpaceName }

        if ($space.Length -gt 1)
        {
            throw "Multiple spaces with name {$SpaceName} were found"
        }
        elseif ($null -eq $space -or $space.Length -eq 0)
        {
            return $nullResult
        }

        $usersUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces/' + $space.spaceId + '/users'
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $usersUri -Method GET
        $instance = $response.value | Where-Object -FilterScript { $_.email -eq $Email }

        if ($instance.Length -gt 1)
        {
            throw "Multiple users with email {$Email} were found."
        }
        elseif ($null -eq $instance)
        {
            return $nullResult
        }

        $results = @{
            SpaceName             = $SpaceName
            Email                 = $instance.email
            Roles                 = $instance.roles
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ManagedIdentity       = $ManagedIdentity.IsPresent
            AccessTokens          = $AccessTokens
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
        [Parameter(Mandatory = $true)]
        [System.String]
        $SpaceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Email,

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

    Write-Verbose -Message "Setting SHSpaceUser configuration for Space: $SpaceName, Email: $Email"

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

    Write-Verbose -Message "Retrieving space by name {$SpaceName}"
    $spacesUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces'
    $response = Invoke-M365DSCServicesHubWebRequest -Uri $spacesUri -Method GET
    $space = $response.value | Where-Object -FilterScript { $_.name -eq $SpaceName }

    if ($currentInstance.Ensure -eq 'Present')
    {
        $usersUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces/' + $space.spaceId + '/users'
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $usersUri -Method GET
        $user = $response.value | Where-Object -FilterScript { $_.email -eq $Email }
    }

    # CREATE
    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Adding new user {$Email} with Roles {$($Roles -join ',')}"
        $body = @{
            email = $Email
            roles = $Roles
        }

        $uri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces/' + $space.spaceId + '/users'
        Write-Verbose -Message "POST request to {$uri}:`r`n$(ConvertTo-Json $body -Depth 5)"
        Invoke-M365DSCServicesHubWebRequest -Uri $uri `
            -Method POST `
            -Body $body
    }
    # UPDATE
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        $body = @{
            roles = $Roles
            email = $Email
        }

        $uri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces/' + $space.spaceId + '/users/' + $user.id
        Write-Verbose -Message "PATCH request to {$uri}:`r`n$(ConvertTo-Json $body -Depth 5)"
        Invoke-M365DSCServicesHubWebRequest -Uri $uri `
            -Method PATCH `
            -Body $body
    }
    # REMOVE
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing user {$Email}"
        $uri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces/' + $space.spaceId + '/users/' + $user.id
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
        $Email,

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
        $spacesUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces'
        $response = Invoke-M365DSCServicesHubWebRequest -Uri $spacesUri -Method GET
        $spaces = $response.value

        $dscContent = [System.Text.StringBuilder]::new()
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

            $usersUri = (Get-MSCloudLoginConnectionProfile -Workload EngageHub).APIUrl + '/spaces/' + $space.spaceId + '/users'
            $response = Invoke-M365DSCServicesHubWebRequest -Uri $usersUri -Method GET
            $users = $response.value

            if ($users.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }

            $i = 1
            foreach ($user in $users)
            {
                if ($null -ne $Global:M365DSCExportResourceInstancesCount)
                {
                    $Global:M365DSCExportResourceInstancesCount++
                }

                $displayedKey = $user.email
                Write-M365DSCHost -Message "        |---[$i/$($users.Count)] $displayedKey" -DeferWrite
                $params = @{
                    SpaceName             = $space.name
                    Email                 = $user.email
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
                [void]$dscContent.Append($currentDSCBlock)
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
                $i++
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
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
