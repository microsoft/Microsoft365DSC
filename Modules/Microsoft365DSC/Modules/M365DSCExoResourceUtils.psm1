function Write-TokenReplacement
{
    param (
        [Parameter()]
        [System.String]
        $Token,

        # Parameter help description
        [Parameter()]
        [System.String]
        $Value,

        # Parameter help description
        [Parameter()]
        [System.String]
        $FilePath
    )

    $content = Get-Content -Path $FilePath
    $content = $content.Replace($Token, $Value)
    Set-Content -Path $FilePath -Value $content
}

function Get-M365DSCHashAsString
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Values
    )
    $sb = [System.Text.StringBuilder]::New()
    foreach ($key in $Values.Keys)
    {
        switch ($Values.$key.GetType().Name)
        {
            'String'
            {
                $sb.AppendLine("                        $key = `"$($Values.$key)`"") | Out-Null
            }
            'Int32'
            {
                $sb.AppendLine("                        $key = $($Values.$key)") | Out-Null
            }
            'UInt32'
            {
                $sb.AppendLine("                        $key = $($Values.$key)") | Out-Null
            }
            'Boolean'
            {
                $sb.AppendLine("                        $key = `$$($Values.$key)") | Out-Null
            }
            'String[]'
            {
                $stringValue = ''
                foreach ($item in $Values.$key)
                {
                    $stringValue += "`"$item`","
                }
                $stringValue = $stringValue.Substring(0, $stringValue.Length - 1)
                $sb.AppendLine("                        $key = `@($stringValue)") | Out-Null
            }
        }
    }
    return $sb.ToString()
}

function Get-M365DSCFakeValues
{
    [OutputType([System.Collections.Hashtable])]
    param(
        [Parameter(Mandatory = $true)]
        [System.Object[]]
        $ParametersInformation,

        [Parameter()]
        [System.Boolean]
        $IntroduceDrift = $false
    )

    $result = @{}
    foreach ($parameter in $parametersInformation)
    {
        switch ($parameter.Type.Name)
        {
            'String'
            {
                if ($IntroduceDrift)
                {
                    if ($parameter.ValidValues.Length -eq 0)
                    {
                        $result.Add($parameter.Name, 'FakeStringValue')
                    }
                    else
                    {
                        $result.Add($parameter.Name, $parameter.ValidValues[1])
                    }
                }
                else
                {
                    if ($parameter.ValidValues.Length -eq 0)
                    {
                        $result.Add($parameter.Name, 'FakeStringValue2')
                    }
                    else
                    {
                        $result.Add($parameter.Name, $parameter.ValidValues[0])
                    }
                }
            }
            'String[]'
            {
                if ($IntroduceDrift)
                {
                    if ($parameter.ValidValues.Length -eq 0)
                    {
                        $result.Add($parameter.Name, @('FakeStringArrayValue1'))
                    }
                    else
                    {
                        $result.Add($parameter.Name, @($parameter.ValidValues[0]))
                    }
                }
                else
                {
                    if ($parameter.ValidValues.Length -eq 0)
                    {
                        $result.Add($parameter.Name, @('FakeStringArrayValue1', 'FakeStringArrayValue2'))
                    }
                    else
                    {
                        $result.Add($parameter.Name, @($parameter.ValidValues[0], $parameter.ValidValues[1]))
                    }
                }
            }
            'Int32'
            {
                if ($IntroduceDrift)
                {
                    $result.Add($parameter.Name, 7)
                }
                else
                {
                    $result.Add($parameter.Name, 25)
                }
            }
            'UInt32'
            {
                if ($IntroduceDrift)
                {
                    $result.Add($parameter.Name, 7)
                }
                else
                {
                    $result.Add($parameter.Name, 25)
                }
            }
            'Boolean'
            {
                if ($IntroduceDrift)
                {
                    $result.Add($parameter.Name, $false)
                }
                else
                {
                    $result.Add($parameter.Name, $true)
                }
            }
        }
    }
    return $result
}

function New-ExoUnitTest
{
    param (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath,

        [Parameter(Mandatory = $false)]
        [System.String]
        $CmdletNoun = ''
    )

    if ($ResourceName.StartsWith('MSFT_'))
    {
        $ResourceName = $ResourceName.Substring(5)
    }

    if ($CmdletNoun -eq '')
    {
        $CmdletNoun = $ResourceName.Substring(3)
    }

    # Get properties of resource
    $ignoredProperties = @('ErrorVariable', `
            'ErrorAction', `
            'InformationVariable', `
            'InformationAction', `
            'WarningVariable', `
            'WarningAction', `
            'OutVariable', `
            'OutBuffer', `
            'PipelineVariable', `
            'Verbose', `
            'WhatIf', `
            'Debug',
        'Credential',
        'ApplicationId',
        'Ensure',
        'TenantId',
        'CertificateThumbprint',
        'CertificatePath',
        'CertificatePassword',
        'IsSingleInstance')

    try
    {
        Import-Module $('..\DSCResources\MSFT_' + $ResourceName + '\MSFT_' + $ResourceName + '.psm1') -Force -ErrorAction Stop
    }
    catch
    {
        throw "DSC resource $ResourceName not found!"
    }

    # Copy unit test template
    try
    {
        $unitTestPath = "$OutputPath\Microsoft365DSC.$($ResourceName).Tests.ps1"
        Copy-Item -Path ..\..\..\ResourceGenerator\UnitTest.Template.ps1 -Destination $unitTestPath -ErrorAction Stop
    }
    catch
    {
        throw 'Failed to create unit test file!'
    }

    $parameterInformation = @()
    $resourceProperties = (Get-Command Set-TargetResource -Module $("MSFT_$ResourceName")).Parameters
    foreach ($key in $resourceProperties.Keys)
    {
        if ($resourceProperties[$key].Name -notin $ignoredProperties)
        {
            $param = @{Name = $resourceProperties[$key].Name; Type = $resourceProperties[$key].ParameterType; ValidValues = $resourceProperties[$key].Attributes.ValidValues }
            $parameterInformation += $param
        }
    }
    Remove-Module -Name $("MSFT_$ResourceName") -Force -Confirm:$false


    # build unit test
    $fakeValues = Get-M365DSCFakeValues -ParametersInformation $parameterInformation -IntroduceDrift $false
    $fakeValuesString = Get-M365DSCHashAsString -Values $fakeValues
    Write-TokenReplacement -Token '<FakeValues>' -value $fakeValuesString -FilePath $unitTestPath

    $fakeDriftValues = Get-M365DSCFakeValues -ParametersInformation $parameterInformation -IntroduceDrift $true
    $fakeDriftValuesString = Get-M365DSCHashAsString -Values $fakeDriftValues
    Write-TokenReplacement -Token '<DriftValues>' -value $fakeDriftValuesString -FilePath $unitTestPath

    Write-TokenReplacement -Token '<ResourceName>' -value $ResourceName -FilePath $unitTestPath

    Write-TokenReplacement -Token '<GetCmdletName>' -value "Get-$($CmdletNoun)" -FilePath $unitTestPath
    Write-TokenReplacement -Token '<SetCmdletName>' -value "Set-$($CmdletNoun)" -FilePath $unitTestPath
    Write-TokenReplacement -Token '<RemoveCmdletName>' -value "Remove-$($CmdletNoun)" -FilePath $unitTestPath
    Write-TokenReplacement -Token '<NewCmdletName>' -value "New-$($CmdletNoun)" -FilePath $unitTestPath
}

Export-ModuleMember -Function @(
    'New-ExoUnitTest'
)
