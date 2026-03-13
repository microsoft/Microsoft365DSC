Confirm-M365DSCModuleDependency -ModuleName 'MSFT_AzureVerifiedIdFaceCheck'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SubscriptionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $VerifiedIdAuthorityId,

        [Parameter()]
        [System.Boolean]
        $FaceCheckEnabled,

        [Parameter()]
        [System.String]
        $VerifiedIdAuthorityLocation,

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

    Write-Verbose -Message "Getting configuration of Azure Verified ID Face Check for Verified ID Authority {$VerifiedIdAuthorityId}"

    try
    {
        $null = New-M365DSCConnection -Workload 'Azure' `
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

        $resourceGroupInstance = Get-AzResourceGroup -Id "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)" -ErrorAction SilentlyContinue
        if ($null -eq $resourceGroupInstance)
        {
            return $nullResult
        }

        $uri = "https://management.azure.com/$($resourceGroupInstance.ResourceId)/providers/Microsoft.VerifiedId/authorities/$($VerifiedIdAuthorityId)?api-version=2024-01-26-preview"
        $response = Invoke-AzRest -Uri $uri -Method Get
        $authorities = ConvertFrom-Json $response.Content

        $EnabledValue = $false
        if ($null -eq $authorities.error -and $null -ne $authorities.id)
        {
            $EnabledValue = $true
        }

        $results = @{
            SubscriptionId              = $SubscriptionId
            ResourceGroupName           = $ResourceGroupName
            VerifiedIdAuthorityId       = $VerifiedIdAuthorityId
            VerifiedIdAuthorityLocation = $authorities.location
            FaceCheckEnabled            = $EnabledValue
            Ensure                      = 'Present'
            Credential                  = $Credential
            ApplicationId               = $ApplicationId
            TenantId                    = $TenantId
            CertificateThumbprint       = $CertificateThumbprint
            ManagedIdentity             = $ManagedIdentity.IsPresent
            AccessTokens                = $AccessTokens
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
        $SubscriptionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $VerifiedIdAuthorityId,

        [Parameter()]
        [System.Boolean]
        $FaceCheckEnabled,

        [Parameter()]
        [System.String]
        $VerifiedIdAuthorityLocation,

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

    Write-Verbose -Message "Setting configuration of Azure Verified ID Face Check for Verified ID Authority {$VerifiedIdAuthorityId}"

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

    $null = New-M365DSCConnection -Workload 'Azure' `
        -InboundParameters $PSBoundParameters
    if ($FaceCheckEnabled)
    {
        Write-Verbose -Message "Enabling FaceCheck on Verified ID Authority {$($VerifiedIDAuthorityId)}"
        $uri = "https://management.azure.com/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/providers/Microsoft.VerifiedId/authorities/$($VerifiedIdAuthorityId)?api-version=2024-01-26-preview"
        $payload = '{"location": "' + $VerifiedIdAuthorityLocation + '"}'
        $response = Invoke-AzRest -Uri $uri -Method Put -Payload $payload
    }
    else
    {
        Write-Verbose -Message "Disabling FaceCheck on Verified ID Authority {$($VerifiedIDAuthorityId)}"
        $uri = "https://management.azure.com/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/providers/Microsoft.VerifiedId/authorities/$($VerifiedIdAuthorityId)?api-version=2024-01-26-preview"
        $payload = '{"location": null}'
        $response = Invoke-AzRest -Uri $uri -Method DELETE
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
        $SubscriptionId,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $VerifiedIdAuthorityId,

        [Parameter()]
        [System.Boolean]
        $FaceCheckEnabled,

        [Parameter()]
        [System.String]
        $VerifiedIdAuthorityLocation,

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

    $ConnectionMode = New-M365DSCConnection -Workload 'AdminAPI' `
        -InboundParameters $PSBoundParameters
    $ConnectionMode = New-M365DSCConnection -Workload 'Azure' `
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
        $headers = @{
            Authorization = (Get-MSCloudLoginConnectionProfile -Workload AdminAPI).AccessToken
        }
        $uri = 'https://verifiedid.did.msidentity.com/v1.0/verifiableCredentials/authorities'
        $response = Invoke-WebRequest -Uri $uri -Method Get -Headers $headers -UseBasicParsing
        $authorities = ConvertFrom-Json $response.Content

        $resourceGroups = Get-AzResourceGroup -ErrorAction Stop
        $i = 1
        $dscContent = ''
        if ($resourceGroups.Length -eq 0)
        {
            Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
        }
        else
        {
            Write-M365DSCHost -Message "`r`n" -DeferWrite
        }
        $j = 1
        foreach ($resourceGroup in $resourceGroups)
        {
            if ($null -ne $Global:M365DSCExportResourceInstancesCount)
            {
                $Global:M365DSCExportResourceInstancesCount++
            }
            $displayedKey = $resourceGroup.ResourceGroupName
            Write-M365DSCHost -Message "    |---[$j/$($resourceGroups.Length)] $displayedKey" -DeferWrite

            if ($authorities.Length -eq 0)
            {
                Write-M365DSCHost -Message $Global:M365DSCEmojiGreenCheckMark -CommitWrite
            }
            else
            {
                Write-M365DSCHost -Message "`r`n" -DeferWrite
            }

            $i = 1
            foreach ($authority in $authorities.value)
            {
                $uri = "https://management.azure.com/$($resourceGroup.ResourceId)/providers/Microsoft.VerifiedId/authorities/$($authority.id)?api-version=2024-01-26-preview"
                $response = Invoke-AzRest -Uri $uri -Method Get

                $Global:M365DSCExportResourceInstancesCount++

                $displayedKey = $authority.name
                Write-M365DSCHost -Message "        |---[$i/$($authorities.value.Length)] $displayedKey" -DeferWrite

                $SubscriptionId = $resourceGroup.ResourceId.Split('/')
                $SubscriptionId = $SubscriptionId[2]

                $params = @{
                    VerifiedIdAuthorityId = $authority.id
                    SubscriptionId        = $SubscriptionId
                    ResourceGroupName     = $resourceGroup.ResourceGroupName
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
        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        throw
    }
}

Export-ModuleMember -Function *-TargetResource
