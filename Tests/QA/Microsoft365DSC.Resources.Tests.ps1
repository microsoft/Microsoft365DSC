BeforeDiscovery {
    $resourcesPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\DSCResources'
    $schemaFiles = Get-ChildItem -Path $resourcesPath -Filter '*.schema.mof' -Recurse | ForEach-Object {
        @{
            ResourceName = $_.Directory.Name
            FullName     = $_.FullName
        }
    }
}

BeforeAll {
    function Get-MofSchemaObject
    {
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable])]
        param
        (
            [Parameter(Mandatory = $true)]
            [System.String]
            $FileName
        )

        $temporaryPath = (Get-Item -Path env:TEMP).Value

        #region Workaround for OMI_BaseResource inheritance not resolving.

        $filePath = (Resolve-Path -Path $FileName).Path
        $tempFilePath = Join-Path -Path $temporaryPath -ChildPath "DscMofHelper_$((New-Guid).Guid).tmp"
        $rawContent = (Get-Content -Path $filePath -Raw) -replace '\s*:\s*OMI_BaseResource'

        Set-Content -LiteralPath $tempFilePath -Value $rawContent -ErrorAction 'Stop'

        # .NET methods don't like PowerShell drives
        $tempFilePath = Convert-Path -Path $tempFilePath

        #endregion

        try
        {
            $exceptionCollection = [System.Collections.ObjectModel.Collection[System.Exception]]::new()
            $moduleInfo = [System.Tuple]::Create('Module', [System.Version] '1.0.0')

            $class = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportClasses(
                $tempFilePath, $moduleInfo, $exceptionCollection
            )

            if ($null -eq $class)
            {
                throw "No classes found in the schema file"
            }
        }
        catch
        {
            throw "Failed to import classes from file $FileName. Error $_"
        }
        finally
        {
            Remove-Item -LiteralPath $tempFilePath -Force
        }

        foreach ($currentCimClass in $class)
        {
            $attributes = foreach ($property in $currentCimClass.CimClassProperties)
            {
                $state = switch ($property.flags)
                {
                    { $_ -band [Microsoft.Management.Infrastructure.CimFlags]::Key }
                    {
                        'Key'
                    }
                    { $_ -band [Microsoft.Management.Infrastructure.CimFlags]::Required }
                    {
                        'Required'
                    }
                    { $_ -band [Microsoft.Management.Infrastructure.CimFlags]::ReadOnly }
                    {
                        'Read'
                    }
                    default
                    {
                        'Write'
                    }
                }

                @{
                    Name             = $property.Name
                    State            = $state
                    DataType         = $property.CimType
                    ValueMap         = $property.Qualifiers.Where( { $_.Name -eq 'ValueMap' }).Value
                    IsArray          = $property.CimType -gt 16
                    Description      = $property.Qualifiers.Where( { $_.Name -eq 'Description' }).Value
                    EmbeddedInstance = $property.Qualifiers.Where( { $_.Name -eq 'EmbeddedInstance' }).Value
                }
            }

            @{
                ClassName    = $currentCimClass.CimClassName
                Attributes   = $attributes
                ClassVersion = $currentCimClass.CimClassQualifiers.Where( { $_.Name -eq 'ClassVersion' }).Value
                FriendlyName = $currentCimClass.CimClassQualifiers.Where( { $_.Name -eq 'FriendlyName' }).Value
            }
        }
    }
}

Describe -Name "Check schema for resource '<ResourceName>'" -ForEach $schemaFiles {
    BeforeDiscovery {
        function Confirm-MofSchema
        {
            [CmdletBinding()]
            [OutputType([System.Boolean])]
            param
            (
                [Parameter(Mandatory = $true)]
                [System.String]
                $FileName
            )

            $temporaryPath = (Get-Item -Path env:TEMP).Value

            #region Workaround for OMI_BaseResource inheritance not resolving.

            $filePath = (Resolve-Path -Path $FileName).Path
            $tempFilePath = Join-Path -Path $temporaryPath -ChildPath "DscMofHelper_$((New-Guid).Guid).tmp"
            $rawContent = (Get-Content -Path $filePath -Raw) -replace '\s*:\s*OMI_BaseResource'

            Set-Content -LiteralPath $tempFilePath -Value $rawContent -ErrorAction 'Stop'

            # .NET methods don't like PowerShell drives
            $tempFilePath = Convert-Path -Path $tempFilePath

            #endregion

            try
            {
                $exceptionCollection = [System.Collections.ObjectModel.Collection[System.Exception]]::new()
                $moduleInfo = [System.Tuple]::Create('Module', [System.Version] '1.0.0')

                $class = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportClasses(
                    $tempFilePath, $moduleInfo, $exceptionCollection
                )

                if ($null -eq $class)
                {
                    return $false
                }
                else
                {
                    return $true
                }
            }
            catch
            {
                return $false
            }
            finally
            {
                Remove-Item -LiteralPath $tempFilePath -Force
            }
        }

        $skipTest = -not (Confirm-MofSchema -FileName $FullName)
    }

    Context 'Validate if the schema is correct' {
        It 'Schema should be read successfully' {
            { $mofSchemas = Get-MofSchemaObject -FileName $FullName } | Should -Not -Throw
        }
    }

    Context 'Run all schema checks' -Skip:$skipTest {
        BeforeAll {
            $mofSchemas = Get-MofSchemaObject -FileName $FullName
        }

        It 'Schema should have a Key parameter' {
            $attributes = ($mofSchemas | Where-Object { [String]::IsNullOrEmpty($_.FriendlyName) -eq $false }).Attributes
            $keyCount = ($attributes | Where-Object { $_.State -eq 'Key' }).Count
            $keyCount | Should -BeGreaterThan 1
        }

        It 'Schema should contain an instance of all used subclasses' {
            $availableClasses = $mofSchemas.ClassName | Where-Object -FilterScript { $_ -ne $ResourceName }

            foreach ($mofSchema in $mofSchemas)
            {
                foreach ($attribute in $mofSchema.Attributes)
                {
                    if ([String]::IsNullOrEmpty($attribute.EmbeddedInstance) -eq $false -and $attribute.EmbeddedInstance -ne 'MSFT_Credential')
                    {
                        $attribute.EmbeddedInstance | Should -BeIn $availableClasses
                    }
                }
            }
        }

        It 'Schema should have a description for all properties' {
            foreach ($mofSchema in $mofSchemas)
            {
                foreach ($attribute in $mofSchema.Attributes)
                {
                    $attribute.Description | Should -Not -BeNullOrEmpty
                }
            }
        }
    }
}
