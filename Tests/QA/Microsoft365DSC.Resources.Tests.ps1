BeforeDiscovery {
    $resourcesPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\DSCResources'
    $schemaFiles = Get-ChildItem -Path $resourcesPath -Filter '*.schema.mof' -Recurse | ForEach-Object {
        @{
            ResourceName = $_.Directory.Name
            FullName     = $_.FullName
        }
    }
}

Describe -Name "Check schema for resource '<ResourceName>'" -ForEach $schemaFiles{
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

    It 'Schema should be read successfully' {
        { Get-MofSchemaObject -FileName $FullName } | Should -Not -Throw
    }

    It 'Schema should have a Key parameter' {
        $mofSchemas = Get-MofSchemaObject -FileName $FullName
        $attributes = ($mofSchemas | Where-Object { [String]::IsNullOrEmpty($_.FriendlyName) -eq $false }).Attributes
        $keyCount = ($attributes | Where-Object { $_.State -eq 'Key' }).Count
        $keyCount | Should -BeGreaterThan 1
    }

    It 'Schema should contain an instance of all used subclasses' {
        $mofSchemas = Get-MofSchemaObject -FileName $FullName

        $errors = 0

        $availableClasses = $mofSchemas.ClassName | Where-Object -FilterScript { $_ -ne $ResourceName }

        foreach ($mofSchema in $mofSchemas)
        {
            foreach ($attribute in $mofSchema.Attributes)
            {
                if ([String]::IsNullOrEmpty($attribute.EmbeddedInstance) -eq $false -and $attribute.EmbeddedInstance -ne "MSFT_Credential")
                {
                    if ($attribute.EmbeddedInstance -notin $availableClasses)
                    {
                        Write-Host "[ERROR] Property $($attribute.Name) in class $($mofSchema.ClassName) / Specified EmbeddedInstance: $($attribute.EmbeddedInstance) not found!" -ForegroundColor Red
                        $errors++
                    }
                }
            }
        }

        $errors | Should -Be 0
    }

}
