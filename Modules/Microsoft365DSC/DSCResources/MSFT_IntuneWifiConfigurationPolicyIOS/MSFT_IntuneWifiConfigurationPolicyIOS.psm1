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
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $ConnectAutomatically,

        [Parameter()]
        [System.Boolean]
        $ConnectWhenNetworkNameIsHidden,

        [Parameter()]
        [System.Boolean]
        $DisableMacAddressRandomization,

        [Parameter()]
        [System.String]
        $NetworkName,

        [Parameter()]
        [System.String]
        $PreSharedKey,

        [Parameter()]
        [System.String]
        $ProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String]
        $ProxyManualAddress,

        [Parameter()]
        [System.Int32]
        $ProxyManualPort,

        [Parameter()]
        [ValidateSet('none','manual','automatic')]
        [System.String]
        $ProxySettings,

        [Parameter()]
        [System.String]
        $Ssid,

        [Parameter()]
        [ValidateSet('open','wpaPersonal','wpaEnterprise','wep','wpa2Personal','wpa2Enterprise')]
        [System.String]
        $WiFiSecurityType,


        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'v1.0'
        $context=Get-MgContext
        if($null -eq $context)
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters -ProfileName 'beta'
        }
        Select-MgProfile 'beta' -ErrorAction Stop
    }
    catch
    {
        Write-Verbose -Message "Connection to the workload failed."
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
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
        $getValue=$null

        #region resource generator code
        if(-Not [string]::IsNullOrEmpty($DisplayName))
        {
            $getValue = Get-MgDeviceManagementDeviceConfiguration `
                -ErrorAction Stop | Where-Object `
                -FilterScript { `
                    $_.DisplayName -eq "$($DisplayName)" `
                }
        }

        if (-not $getValue)
        {
            [array]$getValue = Get-MgDeviceManagementDeviceConfiguration `
                -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.id -eq $id `
            }
        }
        #endregion


        if ($null -eq $getValue)
        {
            Write-Verbose -Message "Nothing with id {$id} was found"
            return $nullResult
        }

        Write-Verbose -Message "Found something with id {$id}"
        $results = @{

            #region resource generator code
            Id = $getValue.Id
            Description = $getValue.Description
            DisplayName = $getValue.DisplayName
            ConnectAutomatically = $getValue.AdditionalProperties.connectAutomatically
            ConnectWhenNetworkNameIsHidden = $getValue.AdditionalProperties.connectWhenNetworkNameIsHidden
            DisableMacAddressRandomization = $getValue.AdditionalProperties.disableMacAddressRandomization
            NetworkName = $getValue.AdditionalProperties.networkName
            PreSharedKey = $getValue.AdditionalProperties.preSharedKey
            ProxyAutomaticConfigurationUrl = $getValue.AdditionalProperties.proxyAutomaticConfigurationUrl
            ProxyManualAddress = $getValue.AdditionalProperties.proxyManualAddress
            ProxyManualPort = $getValue.AdditionalProperties.proxyManualPort
            ProxySettings = $getValue.AdditionalProperties.proxySettings
            Ssid = $getValue.AdditionalProperties.ssid
            WiFiSecurityType = $getValue.AdditionalProperties.wiFiSecurityType


            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            ApplicationSecret     = $ApplicationSecret
            CertificateThumbprint = $CertificateThumbprint
        }

        $myAssignments=@()
        $myAssignments+=Get-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $getValue.Id -repository 'deviceConfigurations'
        $results.Add('Assignments',$myAssignments)

        return [System.Collections.Hashtable] $results
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $ConnectAutomatically,

        [Parameter()]
        [System.Boolean]
        $ConnectWhenNetworkNameIsHidden,

        [Parameter()]
        [System.Boolean]
        $DisableMacAddressRandomization,

        [Parameter()]
        [System.String]
        $NetworkName,

        [Parameter()]
        [System.String]
        $PreSharedKey,

        [Parameter()]
        [System.String]
        $ProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String]
        $ProxyManualAddress,

        [Parameter()]
        [System.Int32]
        $ProxyManualPort,

        [Parameter()]
        [ValidateSet('none','manual','automatic')]
        [System.String]
        $ProxySettings,

        [Parameter()]
        [System.String]
        $Ssid,

        [Parameter()]
        [ValidateSet('open','wpaPersonal','wpaEnterprise','wep','wpa2Personal','wpa2Enterprise')]
        [System.String]
        $WiFiSecurityType,


        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    try
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters `
            -ProfileName 'v1.0'
        $context=Get-MgContext
        if($null -eq $context)
        {
            $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
                -InboundParameters $PSBoundParameters -ProfileName 'beta'
        }
        Select-MgProfile 'beta' -ErrorAction Stop
    }
    catch
    {
        Write-Verbose -Message $_
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
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


    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        Write-Verbose -Message "Creating {$DisplayName}"
        $PSBoundParameters.Remove("Assignments") | Out-Null

        $CreateParameters = ([Hashtable]$PSBoundParameters).clone()
        $CreateParameters=Rename-M365DSCCimInstanceODataParameter -Properties $CreateParameters

        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($CreateParameters)
        foreach($key in $AdditionalProperties.keys)
        {
            if($key -ne '@odata.type')
            {
                $keyName=$key.substring(0,1).ToUpper()+$key.substring(1,$key.length-1)
                $CreateParameters.remove($keyName)
            }
        }

        $CreateParameters.Remove("Id") | Out-Null
        $CreateParameters.Remove("Verbose") | Out-Null

        foreach($key in ($CreateParameters.clone()).Keys)
        {
            if($CreateParameters[$key].getType().Fullname -like "*CimInstance*")
            {
                $CreateParameters[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $CreateParameters[$key]
            }
        }

        if($AdditionalProperties)
        {
            $CreateParameters.add('AdditionalProperties',$AdditionalProperties)
        }


        #region resource generator code
        $policy=New-MgDeviceManagementDeviceConfiguration @CreateParameters
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }

        if($policy.id)        {
            Update-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $policy.id `
                -Targets $assignmentsHash `
                -Repository deviceConfigurations
        }

        #endregion

    }
    elseif ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Updating {$DisplayName}"
        $PSBoundParameters.Remove("Assignments") | Out-Null

        $UpdateParameters = ([Hashtable]$PSBoundParameters).clone()
        $UpdateParameters=Rename-M365DSCCimInstanceODataParameter -Properties $UpdateParameters

        $AdditionalProperties = Get-M365DSCAdditionalProperties -Properties ($UpdateParameters)
        foreach($key in $AdditionalProperties.keys)
        {
            if($key -ne '@odata.type')
            {
                $keyName=$key.substring(0,1).ToUpper()+$key.substring(1,$key.length-1)
                $UpdateParameters.remove($keyName)
            }
        }

        $UpdateParameters.Remove("Id") | Out-Null
        $UpdateParameters.Remove("Verbose") | Out-Null

        foreach($key in ($UpdateParameters.clone()).Keys)
        {
            if($UpdateParameters[$key].getType().Fullname -like "*CimInstance*")
            {
                $UpdateParameters[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $UpdateParameters[$key]
            }
        }

        if($AdditionalProperties)
        {
            $UpdateParameters.add('AdditionalProperties',$AdditionalProperties)
        }


        #region resource generator code
        Update-MgDeviceManagementDeviceConfiguration @UpdateParameters `
            -DeviceConfigurationId $currentInstance.Id
        $assignmentsHash=@()
        foreach($assignment in $Assignments)
        {
            $assignmentsHash+=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Assignment
        }
        Update-MgDeviceManagementPolicyAssignments -DeviceManagementPolicyId $currentInstance.id `
            -Targets $assignmentsHash `
            -Repository deviceConfigurations

        #endregion

    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing {$DisplayName}"


        #region resource generator code
        #endregion



        #region resource generator code
        Remove-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $currentInstance.Id
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
        $Description,

        [Parameter()]
        [System.String]
        $DisplayName,

        [Parameter()]
        [System.Boolean]
        $ConnectAutomatically,

        [Parameter()]
        [System.Boolean]
        $ConnectWhenNetworkNameIsHidden,

        [Parameter()]
        [System.Boolean]
        $DisableMacAddressRandomization,

        [Parameter()]
        [System.String]
        $NetworkName,

        [Parameter()]
        [System.String]
        $PreSharedKey,

        [Parameter()]
        [System.String]
        $ProxyAutomaticConfigurationUrl,

        [Parameter()]
        [System.String]
        $ProxyManualAddress,

        [Parameter()]
        [System.Int32]
        $ProxyManualPort,

        [Parameter()]
        [ValidateSet('none','manual','automatic')]
        [System.String]
        $ProxySettings,

        [Parameter()]
        [System.String]
        $Ssid,

        [Parameter()]
        [ValidateSet('open','wpaPersonal','wpaEnterprise','wep','wpa2Personal','wpa2Enterprise')]
        [System.String]
        $WiFiSecurityType,


        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $Assignments,

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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of {$id}"

    $CurrentValues = Get-TargetResource @PSBoundParameters
    $ValuesToCheck = ([Hashtable]$PSBoundParameters).clone()

    if($CurrentValues.Ensure -eq "Absent")
    {
        Write-Verbose -Message "Test-TargetResource returned $false"
        return $false
    }
    $testResult=$true

    foreach($key in $PSBoundParameters.Keys)
    {
        if($PSBoundParameters[$key].getType().Name -like "*CimInstance*")
        {

            $CIMArraySource=@()
            $CIMArrayTarget=@()
            $CIMArraySource+=$PSBoundParameters[$key]
            $CIMArrayTarget+=$CurrentValues.$key
            if($CIMArraySource.count -ne $CIMArrayTarget.count)
            {
                Write-Verbose -Message "Configuration drift:Number of items does not match: Source=$($CIMArraySource.count) Target=$($CIMArrayTarget.count)"
                $testResult=$false
                break
            }
            $i=0
            foreach($item in $CIMArraySource )
            {
                $testResult=Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMArraySource[$i]) `
                    -Target ($CIMArrayTarget[$i])

                $i++
                if(-Not $testResult)
                {
                    $testResult=$false
                    break;
                }
            }
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

    #Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    #Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $ValuesToCheck)"

    #Convert any DateTime to String
    foreach ($key in $ValuesToCheck.Keys)
    {
        if(($null -ne $CurrentValues[$key]) `
            -and ($CurrentValues[$key].getType().Name -eq 'DateTime'))
        {
            $CurrentValues[$key]=$CurrentValues[$key].toString()
        }
    }

    if($testResult)
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
        [System.String]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters `
        -ProfileName 'v1.0'
    $context=Get-MgContext
    if($null -eq $context)
    {
        $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
            -InboundParameters $PSBoundParameters -ProfileName 'beta'
    }
    Select-MgProfile 'beta' -ErrorAction Stop

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace("MSFT_", "")
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {

        #region resource generator code
        [array]$getValue = Get-MgDeviceManagementDeviceConfiguration `
            -ErrorAction Stop | Where-Object `
            -FilterScript { `
                $_.AdditionalProperties.'@odata.type' -eq '#microsoft.graph.iosWiFiConfiguration'  `
            }


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
            Write-Host "    |---[$i/$($getValue.Count)] $($config.id)" -NoNewline
            $params = @{
                id           = $config.id
                Ensure                = 'Present'
                Credential            = $Credential
                ApplicationId         = $ApplicationId
                TenantId              = $TenantId
                ApplicationSecret     = $ApplicationSecret
                CertificateThumbprint = $CertificateThumbprint
            }

            $Results = Get-TargetResource @Params
            $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                -Results $Results


        if($Results.Assignments)
        {
            $complexTypeStringResult = Get-M365DSCDRGComplexTypeToString -ComplexObject $Results.Assignments -CIMInstanceName DeviceManagementConfigurationPolicyAssignments
            if ($complexTypeStringResult)
            {
                $Results.Assignments = $complexTypeStringResult
            }
            else
            {
                $Results.Remove('Assignments') | Out-Null
            }
        }

            $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                -ConnectionMode $ConnectionMode `
                -ModulePath $PSScriptRoot `
                -Results $Results `
                -Credential $Credential


        if ($Results.Assignments)
        {
            $isCIMArray=$false
            if($Results.Assignments.getType().Fullname -like "*[[\]]")
            {
                $isCIMArray=$true
            }
            $currentDSCBlock = Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "Assignments" -isCIMArray:$isCIMArray
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
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
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
        return ""
    }
}


function Get-M365DSCDRGComplexTypeToHashtable
{
    [CmdletBinding()]
    param(
        [Parameter()]
        $ComplexObject
    )

    if($null -eq $ComplexObject)
    {
        return $null
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
        if($results.count -eq 0)
        {
            return $null
        }
        return $results
    }

    $results = @{}
    $keys = $ComplexObject | Get-Member | Where-Object -FilterScript {$_.MemberType -eq 'Property' -and $_.Name -ne 'AdditionalProperties'}

    foreach ($key in $keys)
    {
        if($ComplexObject.$($key.Name))
        {
            $results.Add($key.Name, $ComplexObject.$($key.Name))
        }
    }
    if($results.count -eq 0)
    {
        return $null
    }
    return $results
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
        [System.String]
        $Whitespace="",

        [Parameter()]
        [switch]
        $isArray=$false
    )
    if ($null -eq $ComplexObject)
    {
        return $null
    }

    #If ComplexObject  is an Array
    if ($ComplexObject.GetType().FullName -like "*[[\]]")
    {
        $currentProperty=@()
        foreach ($item in $ComplexObject)
        {
            $currentProperty += Get-M365DSCDRGComplexTypeToString `
                -ComplexObject $item `
                -isArray:$true `
                -CIMInstanceName $CIMInstanceName `
                -Whitespace "                "

        }
        if ([string]::IsNullOrEmpty($currentProperty))
        {
            return $null
        }
        return $currentProperty

    }

    #If ComplexObject is a single CIM Instance
    if(-Not (Test-M365DSCComplexObjectHasValues -ComplexObject $ComplexObject))
    {
        return $null
    }
    $currentProperty=""
    if($isArray)
    {
        $currentProperty += "`r`n"
    }
    $currentProperty += "$whitespace`MSFT_$CIMInstanceName{`r`n"
    $keyNotNull = 0
    foreach ($key in $ComplexObject.Keys)
    {
        if ($ComplexObject[$key])
        {
            $keyNotNull++

            if ($ComplexObject[$key].GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*")
            {
                $hashPropertyType=$ComplexObject[$key].GetType().Name.tolower()
                $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]

                if (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty)
                {
                    $Whitespace+="            "
                    if(-not $isArray)
                    {
                        $currentProperty += "                " + $key + " = "
                    }
                    $currentProperty += Get-M365DSCDRGComplexTypeToString `
                                    -ComplexObject $hashProperty `
                                    -CIMInstanceName $hashPropertyType `
                                    -Whitespace $Whitespace
                }
            }
            else
            {
                if(-not $isArray)
                {
                    $Whitespace= "            "
                }
                $currentProperty += Get-M365DSCDRGSimpleObjectTypeToString -Key $key -Value $ComplexObject[$key] -Space ($Whitespace+"    ")
            }
        }
    }
    $currentProperty += "            }"

    if ($keyNotNull -eq 0)
    {
        $currentProperty = $null
    }

    return $currentProperty
}
function Test-M365DSCComplexObjectHasValues
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $ComplexObject
    )
    $keys=$ComplexObject.keys
    $hasValue=$false
    foreach($key in $keys)
    {
        if($ComplexObject[$key])
        {
            if($ComplexObject[$key].GetType().FullName -like "Microsoft.Graph.PowerShell.Models.*")
            {
                $hash=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject[$key]
                if(-Not $hash)
                {
                    return $false
                }
                $hasValue=Test-M365DSCComplexObjectHasValues -ComplexObject ($hash)
            }
            else
            {
                $hasValue=$true
                return $hasValue
            }
        }
    }
    return $hasValue
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
function Rename-M365DSCCimInstanceODataParameter
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )
        $CIMparameters=$Properties.getEnumerator()|Where-Object -FilterScript {$_.value.GetType().Fullname -like '*CimInstance*'}
        foreach($CIMParam in $CIMparameters)
        {
            if($CIMParam.value.GetType().Fullname -like '*[[\]]')
            {
                $CIMvalues=@()
                foreach($item in $CIMParam.value)
                {
                    $CIMHash= Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $item
                    $keys=($CIMHash.clone()).keys
                    if($keys -contains 'odataType')
                    {
                        $CIMHash.add('@odata.type',$CIMHash.odataType)
                        $CIMHash.remove('odataType')
                    }
                    $CIMvalues+=$CIMHash
                }
                $Properties.($CIMParam.key)=$CIMvalues
            }
            else
            {
                $CIMHash= Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $CIMParam.value
                $keys=($CIMHash.clone()).keys
                if($keys -contains 'odataType')
                {
                    $CIMHash.add('@odata.type',$CIMHash.odataType)
                    $CIMHash.remove('odataType')
                    $Properties.($CIMParam.key)=$CIMHash
                }
            }
        }
        return $Properties
}
function Get-M365DSCAdditionalProperties
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = 'true')]
        [System.Collections.Hashtable]
        $Properties
    )

    $additionalProperties=@(
        "ConnectAutomatically"
        "ConnectWhenNetworkNameIsHidden"
        "DisableMacAddressRandomization"
        "NetworkName"
        "PreSharedKey"
        "ProxyAutomaticConfigurationUrl"
        "ProxyManualAddress"
        "ProxyManualPort"
        "ProxySettings"
        "Ssid"
        "WiFiSecurityType"

    )
    $results = @{"@odata.type" = "#microsoft.graph.iosWiFiConfiguration" }
    $cloneProperties=$Properties.clone()
    foreach ($property in $cloneProperties.Keys)
    {
        if ($property -in ($additionalProperties) )
        {
            $propertyName = $property[0].ToString().ToLower() + $property.Substring(1, $property.Length - 1)
            if($properties.$property -and $properties.$property.getType().FullName -like "*CIMInstance*")
            {
                if($properties.$property.getType().FullName -like "*[[\]]")
                {
                    $array=@()
                    foreach($item in $properties.$property)
                    {
                        $array+=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $item

                    }
                    $propertyValue=$array
                }
                else
                {
                    $propertyValue=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $properties.$property
                }

            }
            else
            {
                $propertyValue = $properties.$property
            }


            $results.Add($propertyName, $propertyValue)

        }
    }
    if($results.Count -eq 1)
    {
        return $null
    }
    return $results
}
function Compare-M365DSCComplexObject
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param(
        [Parameter()]
        [System.Collections.Hashtable]
        $Source,
        [Parameter()]
        [System.Collections.Hashtable]
        $Target
    )

    $keys= $Source.Keys|Where-Object -FilterScript {$_ -ne "PSComputerName"}
    foreach ($key in $keys)
    {
        write-verbose -message "Comparing key: {$key}"
        $skey=$key
        if($key -eq 'odataType')
        {
            $skey='@odata.type'
        }

        #Marking Target[key] to null if empty complex object or array
        if($null -ne $Target[$key])
        {
            switch -Wildcard ($Target[$key].getType().Fullname )
            {
                "Microsoft.Graph.PowerShell.Models.*"
                {
                    $hashProperty=Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key]
                    if(-not (Test-M365DSCComplexObjectHasValues -ComplexObject $hashProperty))
                    {
                        $Target[$key]=$null
                    }
                }
                "*[[\]]"
                {
                    if($Target[$key].count -eq 0)
                    {
                        $Target[$key]=$null
                    }
                }
            }
        }
        $sourceValue=$Source[$key]
        $targetValue=$Target[$key]
        #One of the item is null
        if (($null -eq $Source[$skey]) -xor ($null -eq $Target[$key]))
        {
            if($null -eq $Source[$skey])
            {
                $sourceValue="null"
            }

            if($null -eq $Target[$key])
            {
                $targetValue="null"
            }
            Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
            return $false
        }
        #Both source and target aren't null or empty
        if(($null -ne $Source[$skey]) -and ($null -ne $Target[$key]))
        {
            if($Source[$skey].getType().FullName -like "*CimInstance*")
            {
                #Recursive call for complex object
                $compareResult= Compare-M365DSCComplexObject `
                    -Source (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Source[$skey]) `
                    -Target (Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $Target[$key])

                if(-not $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
                    return $false
                }
            }
            else
            {
                #Simple object comparison
                $referenceObject=$Target[$key]
                $differenceObject=$Source[$skey]

                $compareResult = Compare-Object `
                    -ReferenceObject ($referenceObject) `
                    -DifferenceObject ($differenceObject)

                if ($null -ne $compareResult)
                {
                    Write-Verbose -Message "Configuration drift - key: $key Source{$sourceValue} Target{$targetValue}"
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
            if(Test-M365DSCComplexObjectHasValues -ComplexObject $hash)
            {
                $results+=$hash
            }
        }
        if($results.count -eq 0)
        {
            return $null
        }
        return $Results
    }
    $hashComplexObject = Get-M365DSCDRGComplexTypeToHashtable -ComplexObject $ComplexObject
    if($hashComplexObject)
    {
        $results=$hashComplexObject.clone()
        $keys=$hashComplexObject.Keys|Where-Object -FilterScript {$_ -ne 'PSComputerName'}
        foreach ($key in $keys)
        {
            if(($null -ne $hashComplexObject[$key]) -and ($hashComplexObject[$key].getType().Fullname -like "*CimInstance*"))
            {
                $results[$key]=Convert-M365DSCDRGComplexTypeToHashtable -ComplexObject $hashComplexObject[$key]
            }
            if($null -eq $results[$key])
            {
                $results.remove($key)|out-null
            }

        }
    }
    return $results
}
function Get-MgDeviceManagementPolicyAssignments
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementPolicyId,

        [Parameter()]
        [ValidateSet('deviceCompliancePolicies','intents','configurationPolicies','deviceConfigurations')]
        [System.String]
        $Repository='configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0','beta')]
        [System.String]
        $APIVersion='beta'
    )
    try
    {
        $deviceManagementPolicyAssignments=@()

        $Uri="https://graph.microsoft.com/$APIVersion/deviceManagement/$Repository/$DeviceManagementPolicyId/assignments"
        $results=Invoke-MgGraphRequest -Method GET  -Uri $Uri -ErrorAction Stop
        foreach($result in $results.value.target)
        {
            $deviceManagementPolicyAssignments+=@{
                dataType=$result."@odata.type"
                groupId=$result.groupId
                collectionId=$result.collectionId
                deviceAndAppManagementAssignmentFilterType=$result.deviceAndAppManagementAssignmentFilterType
                deviceAndAppManagementAssignmentFilterId=$result.deviceAndAppManagementAssignmentFilterId
            }
        }

        while($results."@odata.nextLink")
        {
            $Uri=$results."@odata.nextLink"
            $results=Invoke-MgGraphRequest -Method GET -Uri $Uri -ErrorAction Stop
            foreach($result in $results.value.target)
            {
                $deviceManagementPolicyAssignments+=@{
                    dataType=$result."@odata.type"
                    groupId=$result.groupId
                    collectionId=$result.collectionId
                    deviceAndAppManagementAssignmentFilterType=$result.deviceAndAppManagementAssignmentFilterType
                    deviceAndAppManagementAssignmentFilterId=$result.deviceAndAppManagementAssignmentFilterId
                }
            }
        }
        return $deviceManagementPolicyAssignments
    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }


}
function Update-MgDeviceManagementPolicyAssignments
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory = 'true')]
        [System.String]
        $DeviceManagementPolicyId,

        [Parameter()]
        [Array]
        $Targets,

        [Parameter()]
        [ValidateSet('deviceCompliancePolicies','intents','configurationPolicies','deviceConfigurations')]
        [System.String]
        $Repository='configurationPolicies',

        [Parameter()]
        [ValidateSet('v1.0','beta')]
        [System.String]
        $APIVersion='beta'
    )
    try
    {
        $deviceManagementPolicyAssignments=@()

        $Uri="https://graph.microsoft.com/$APIVersion/deviceManagement/$Repository/$DeviceManagementPolicyId/assign"

        foreach($target in $targets)
        {
            $formattedTarget=@{"@odata.type"=$target.dataType}
            if($target.groupId)
            {
                $formattedTarget.Add('groupId',$target.groupId)
            }
            if($target.collectionId)
            {
                $formattedTarget.Add('collectionId',$target.collectionId)
            }
            if($target.deviceAndAppManagementAssignmentFilterType)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterType',$target.deviceAndAppManagementAssignmentFilterType)
            }
            if($target.deviceAndAppManagementAssignmentFilterId)
            {
                $formattedTarget.Add('deviceAndAppManagementAssignmentFilterId',$target.deviceAndAppManagementAssignmentFilterId)
            }
            $deviceManagementPolicyAssignments+=@{'target'= $formattedTarget}
        }
        $body=@{'assignments'=$deviceManagementPolicyAssignments}|ConvertTo-Json -Depth 20
        #write-verbose -Message $body
        Invoke-MgGraphRequest -Method POST -Uri $Uri -Body $body -ErrorAction Stop

    }
    catch
    {
        try
        {
            Write-Verbose -Message $_
            $tenantIdValue = ""
            $tenantIdValue = $Credential.UserName.Split('@')[1]
            Add-M365DSCEvent -Message $_ -EntryType 'Error' `
                -EventID 1 -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $tenantIdValue
        }
        catch
        {
            Write-Verbose -Message $_
        }
        return $null
    }


}
Export-ModuleMember -Function *-TargetResource
