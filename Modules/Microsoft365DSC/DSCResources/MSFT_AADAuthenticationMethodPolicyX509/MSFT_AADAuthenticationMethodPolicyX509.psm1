function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationModeConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateUserBindings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion

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
        #region resource generator code
        $getValue = Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId $Id -ErrorAction SilentlyContinue

        #endregion
        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Could not find an Azure AD Authentication Method Policy X509 with id {$id}"
            return $nullResult
        }
        $Id = $getValue.Id
        Write-Verbose -Message "An Azure AD Authentication Method Policy X509 with Id {$Id} was found."

        #region resource generator code
        $complexAuthenticationModeConfiguration = @{}
        $complexRules = @()
        if ($getValue.AdditionalProperties.authenticationModeConfiguration.rules.length -ne 0){
            foreach ($currentRules in $getValue.AdditionalProperties.authenticationModeConfiguration.rules)
            {
                $myRules = @{}
                $myRules.Add('Identifier', $currentRules.identifier)
                if ($null -ne $currentRules.x509CertificateAuthenticationMode)
                {
                    $myRules.Add('X509CertificateAuthenticationMode', $currentRules.x509CertificateAuthenticationMode.toString())
                }
                if ($null -ne $currentRules.x509CertificateRuleType)
                {
                    $myRules.Add('X509CertificateRuleType', $currentRules.x509CertificateRuleType.toString())
                }
                if ($myRules.values.Where({ $null -ne $_ }).count -gt 0)
                {
                    $complexRules += $myRules
                }
                $complexAuthenticationModeConfiguration.Add('Rules', $complexRules)
            }
        }
        else {
            $complexAuthenticationModeConfiguration.Add('Rules', @(''))
        }

        if ($null -ne $getValue.AdditionalProperties.authenticationModeConfiguration.x509CertificateAuthenticationDefaultMode)
        {
            $complexAuthenticationModeConfiguration.Add('X509CertificateAuthenticationDefaultMode', $getValue.AdditionalProperties.authenticationModeConfiguration.x509CertificateAuthenticationDefaultMode.toString())
        }
        if ($complexAuthenticationModeConfiguration.values.Where({ $null -ne $_ }).count -eq 0)
        {
            $complexAuthenticationModeConfiguration = $null
        }

        $complexCertificateUserBindings = @()
        foreach ($currentcertificateUserBindings in $getValue.AdditionalProperties.certificateUserBindings)
        {
            $mycertificateUserBindings = @{}
            $mycertificateUserBindings.Add('Priority', $currentcertificateUserBindings.priority)
            $mycertificateUserBindings.Add('UserProperty', $currentcertificateUserBindings.userProperty)
            $mycertificateUserBindings.Add('X509CertificateField', $currentcertificateUserBindings.x509CertificateField)
            if ($mycertificateUserBindings.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexCertificateUserBindings += $mycertificateUserBindings
            }
        }

        $complexExcludeTargets = @()
        foreach ($currentExcludeTargets in $getValue.excludeTargets)
        {
            $myExcludeTargets = @{}
            if ($currentExcludeTargets.id -ne 'all_users'){
                $myExcludeTargetsDisplayName = get-MgGroup -GroupId $currentExcludeTargets.id
                $myExcludeTargets.Add('Id', $myExcludeTargetsDisplayName.DisplayName)
            }
            else{
                $myExcludeTargets.Add('Id', $currentExcludeTargets.id)
            }
            if ($null -ne $currentExcludeTargets.targetType)
            {
                $myExcludeTargets.Add('TargetType', $currentExcludeTargets.targetType.toString())
            }
            if ($myExcludeTargets.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexExcludeTargets += $myExcludeTargets
            }
        }
        #endregion

        $complexIncludeTargets = @()
        foreach ($currentIncludeTargets in $getValue.AdditionalProperties.includeTargets)
        {
            $myIncludeTargets = @{}
            if ($currentIncludeTargets.id -ne 'all_users'){
                $myIncludeTargetsDisplayName = get-MgGroup -GroupId $currentIncludeTargets.id
                $myIncludeTargets.Add('Id', $myIncludeTargetsDisplayName.DisplayName)
            }
            else{
                $myIncludeTargets.Add('Id', $currentIncludeTargets.id)
            }
            if ($null -ne $currentIncludeTargets.targetType)
            {
                $myIncludeTargets.Add('TargetType', $currentIncludeTargets.targetType.toString())
            }
            if ($null -ne $currentIncludeTargets.isRegistrationRequired)
            {
                $myIncludeTargets.Add('isRegistrationRequired', [Boolean]$currentIncludeTargets.isRegistrationRequired)
            }
            if ($myIncludeTargets.values.Where({ $null -ne $_ }).count -gt 0)
            {
                $complexIncludeTargets += $myIncludeTargets
            }
        }
        #region resource generator code
        $enumState = $null
        if ($null -ne $getValue.State)
        {
            $enumState = $getValue.State.ToString()
        }
        #endregion

        $results = @{
            #region resource generator code
            AuthenticationModeConfiguration = $complexAuthenticationModeConfiguration
            CertificateUserBindings         = $complexCertificateUserBindings
            ExcludeTargets                  = $complexExcludeTargets
            IncludeTargets                  = $complexIncludeTargets
            State                           = $enumState
            Id                              = $getValue.Id
            Ensure                          = 'Present'
            Credential                      = $Credential
            ApplicationId                   = $ApplicationId
            TenantId                        = $TenantId
            ApplicationSecret               = $ApplicationSecret
            CertificateThumbprint           = $CertificateThumbprint
            Managedidentity                 = $ManagedIdentity.IsPresent
            #endregion
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
        #region resource generator code
        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationModeConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateUserBindings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion
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

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating an Azure AD Authentication Method Policy X509 with id {$id}"

        $CreateParameters = ([Hashtable]$BoundParameters).clone()
        $CreateParameters = Rename-M365DSCCimInstanceParameter -Properties $CreateParameters
        $CreateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$CreateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $CreateParameters.$key -and $CreateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $CreateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters.$key
            }
            if ($key -eq 'IncludeTargets')
            {
                $i = 0
                foreach ($entry in $CreateParameters.$key){
                    if ($entry.id -notmatch '^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$|all_users')
                    {
                        $Filter = "Displayname eq '$($entry.id)'" | Out-String
                        $CreateParameters.$key[$i].foreach('id',(Get-MgGroup -Filter $Filter).id.ToString())
                    }
                    $i++
                }
            }
            if ($key -eq 'ExcludeTargets')
            {
                $i = 0
                foreach ($entry in $CreateParameters.$key){
                    if ($entry.id -notmatch '^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$|all_users')
                    {
                        $Filter = "Displayname eq '$($entry.id)'" | Out-String
                        $CreateParameters.$key[$i].foreach('id',(Get-MgGroup -Filter $Filter).id.ToString())
                    }
                    $i++
                }
            }
        }
        #region resource generator code
        $CreateParameters.Add('@odata.type', '#microsoft.graph.x509CertificateAuthenticationMethodConfiguration')
        $policy = New-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -BodyParameter $CreateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating the Azure AD Authentication Method Policy X509 with Id {$($currentInstance.Id)}"

        $UpdateParameters = ([Hashtable]$BoundParameters).clone()
        $UpdateParameters = Rename-M365DSCCimInstanceParameter -Properties $UpdateParameters

        $UpdateParameters.Remove('Id') | Out-Null

        $keys = (([Hashtable]$UpdateParameters).clone()).Keys
        foreach ($key in $keys)
        {
            if ($null -ne $UpdateParameters.$key -and $UpdateParameters.$key.getType().Name -like '*cimInstance*')
            {
                $UpdateParameters.$key = Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters.$key
            }
            if ($key -eq 'ExcludeTargets' -or $key -eq 'IncludeTargets')
            {
                $i = 0
                foreach ($entry in $UpdateParameters.$key)
                {
                    if ($entry.id -notmatch '^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$|all_users')
                    {
                        $Filter = "Displayname eq '$($entry.id)'"
                        Write-Verbose -Message "Retrieving {$key} Group with DisplayName {$($entry.id)}"
                        $GroupInstance = Get-MgGroup -Filter $Filter -ErrorAction SilentlyContinue
                        if ($null -ne $GroupInstance)
                        {
                            Write-Verbose -Message "Found {$key} Group {$($GroupInstance.id.ToString())}"
                            $UpdateParameters.$key[$i].id = $GroupInstance.id.ToString()
                        }
                    }
                    $i++
                }
            }
        }
        #region resource generator code
        $UpdateParameters.Add('@odata.type', '#microsoft.graph.x509CertificateAuthenticationMethodConfiguration')
        Write-Verbose -Message "Updating with Values: $(Convert-M365DscHashtableToString -Hashtable $UpdateParameters)"
        Update-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration  `
            -AuthenticationMethodConfigurationId $currentInstance.Id `
            -BodyParameter $UpdateParameters
        #endregion
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing the Azure AD Authentication Method Policy X509 with Id {$($currentInstance.Id)}"
        #region resource generator code
        Remove-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration -AuthenticationMethodConfigurationId $currentInstance.Id
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
        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationModeConfiguration,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $CertificateUserBindings,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $ExcludeTargets,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $IncludeTargets,

        [Parameter()]
        [ValidateSet('enabled', 'disabled')]
        [System.String]
        $State,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Id,

        #endregion

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

    Write-Verbose -Message "Testing configuration of the Azure AD Authentication Method Policy X509 with Id {$Id}"

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

    $ValuesToCheck.remove('Id') | Out-Null
    $ValuesToCheck.Remove('Credential') | Out-Null
    $ValuesToCheck.Remove('ApplicationId') | Out-Null
    $ValuesToCheck.Remove('TenantId') | Out-Null
    $ValuesToCheck.Remove('ApplicationSecret') | Out-Null

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
        #region resource generator code
        [array]$getValue = Get-MgBetaPolicyAuthenticationMethodPolicyAuthenticationMethodConfiguration `
            -AuthenticationMethodConfigurationId X509Certificate `
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
            $displayedKey = $config.Id
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey" -NoNewline
            $params = @{
                Id                    = $config.Id
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
            if ($null -ne $Results.AuthenticationModeConfiguration)
            {
                $complexMapping = @(
                    @{
                        Name            = 'AuthenticationModeConfiguration'
                        CimInstanceName = 'MicrosoftGraphX509CertificateAuthenticationModeConfiguration'
                        IsRequired      = $False
                    }
                    @{
                        Name            = 'Rules'
                        CimInstanceName = 'MicrosoftGraphX509CertificateRule'
                        IsRequired      = $False
                    }
                )
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.AuthenticationModeConfiguration `
                    -CIMInstanceName 'MicrosoftGraphx509CertificateAuthenticationModeConfiguration' `
                    -ComplexTypeMapping $complexMapping

                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.AuthenticationModeConfiguration = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('AuthenticationModeConfiguration') | Out-Null
                }
            }
            if ($null -ne $Results.CertificateUserBindings)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.CertificateUserBindings `
                    -CIMInstanceName 'MicrosoftGraphx509CertificateUserBinding'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.CertificateUserBindings = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('CertificateUserBindings') | Out-Null
                }
            }
            if ($null -ne $Results.ExcludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.ExcludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyX509ExcludeTarget'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.ExcludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('ExcludeTargets') | Out-Null
                }
            }

            if ($null -ne $Results.IncludeTargets)
            {
                $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString `
                    -ComplexObject $Results.IncludeTargets `
                    -CIMInstanceName 'AADAuthenticationMethodPolicyX509IncludeTarget'
                if (-Not [String]::IsNullOrWhiteSpace($complexTypeStringResult))
                {
                    $Results.IncludeTargets = $complexTypeStringResult
                }
                else
                {
                    $Results.Remove('IncludeTargets') | Out-Null
                }
            }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential
            if ($Results.AuthenticationModeConfiguration)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'AuthenticationModeConfiguration' -IsCIMArray:$False
            }
            if ($Results.CertificateUserBindings)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'CertificateUserBindings' -IsCIMArray:$True
                $currentDSCBlock = $currentDSCBlock.Replace('CertificateUserBindings         = @("', 'CertificateUserBindings         = @(')
                $currentDSCBlock = $currentDSCBlock.Replace("            `",`"`r`n", '')
            }
            if ($Results.ExcludeTargets)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'ExcludeTargets' -IsCIMArray:$True
            }
            If ($Results.IncludeTargets)
            {
                $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName 'IncludeTargets' -IsCIMArray:$True
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

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
