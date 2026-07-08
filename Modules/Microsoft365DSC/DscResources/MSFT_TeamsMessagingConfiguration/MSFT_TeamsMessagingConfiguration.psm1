Confirm-M365DSCModuleDependency -ModuleName 'MSFT_TeamsMessagingConfiguration'

function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter()]
        [System.Boolean]
        $EnableVideoMessageCaptions,

        [Parameter()]
        [System.Boolean]
        $EnableInOrganizationChatControl,

        [Parameter()]
        [System.Boolean]
        $CustomEmojis,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $Storyline,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MessagingNotes,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $FileTypeCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $UrlReputationCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ContentBasedPhishingCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ReportIncorrectSecurityDetections,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message "Getting configuration for the Teams Messaging Configuration"

    try
    {
        if (-not $Script:exportedInstance)
        {
            $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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

            $instance = Get-CsTeamsMessagingConfiguration -Identity 'Global'
        }
        else
        {
            $instance = $Script:exportedInstance
        }

        Write-Verbose -Message 'A Teams Messaging Configuration with Identity {Global} was found'
        $results = @{
            ContentBasedPhishingCheck         = $instance.ContentBasedPhishingCheck
            CustomEmojis                      = $instance.CustomEmojis
            EnableInOrganizationChatControl   = $instance.EnableInOrganizationChatControl
            EnableVideoMessageCaptions        = $instance.EnableVideoMessageCaptions
            FileTypeCheck                     = $instance.FileTypeCheck
            MessagingNotes                    = $instance.MessagingNotes
            ReportIncorrectSecurityDetections = $instance.ReportIncorrectSecurityDetections
            Storyline                         = $instance.Storyline
            UrlReputationCheck                = $instance.UrlReputationCheck
            IsSingleInstance                  = 'Yes'
            Credential                        = $Credential
            ApplicationId                     = $ApplicationId
            TenantId                          = $TenantId
            CertificateThumbprint             = $CertificateThumbprint
            CertificatePath                   = $CertificatePath
            CertificatePassword               = $CertificatePassword
            ManagedIdentity                   = $ManagedIdentity.IsPresent
            AccessTokens                      = $AccessTokens
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
        [System.Boolean]
        $EnableVideoMessageCaptions,

        [Parameter()]
        [System.Boolean]
        $EnableInOrganizationChatControl,

        [Parameter()]
        [System.Boolean]
        $CustomEmojis,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $Storyline,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MessagingNotes,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $FileTypeCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $UrlReputationCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ContentBasedPhishingCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ReportIncorrectSecurityDetections,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $null = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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

    $updateParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters
    $updateParameters.Remove('IsSingleInstance') | Out-Null
    Write-Verbose -Message 'Updating the Teams Messaging Configuration with Identity {Global}'

    Set-CsTeamsMessagingConfiguration @updateParameters -Identity 'Global' | Out-Null
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter()]
        [System.Boolean]
        $EnableVideoMessageCaptions,

        [Parameter()]
        [System.Boolean]
        $EnableInOrganizationChatControl,

        [Parameter()]
        [System.Boolean]
        $CustomEmojis,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $Storyline,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $MessagingNotes,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $FileTypeCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $UrlReputationCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ContentBasedPhishingCheck,

        [Parameter()]
        [ValidateSet('Disabled', 'Enabled')]
        [System.String]
        $ReportIncorrectSecurityDetections,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Yes')]
        [System.String]
        $IsSingleInstance,

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

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
        [System.String]
        $Filter = "*",

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
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftTeams' `
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
        [array]$getValue = Get-CsTeamsMessagingConfiguration -Filter $Filter -ErrorAction Stop

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

            $displayedKey = $config.Identity
            if (-not [String]::IsNullOrEmpty($config.displayName))
            {
                $displayedKey = $config.displayName
            }
            Write-M365DSCHost -Message "    |---[$i/$($getValue.Count)] $displayedKey" -DeferWrite
            $params = @{
                IsSingleInstance      = 'Yes'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                CertificateThumbprint = $CertificateThumbprint
                CertificatePath       = $CertificatePath
                CertificatePassword   = $CertificatePassword
                ManagedIdentity       = $ManagedIdentity.IsPresent
                AccessTokens          = $AccessTokens
            }

            $Script:exportedInstance = $config
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

