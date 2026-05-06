BeforeDiscovery {
    $resourcesPath = Join-Path -Path $PSScriptRoot -ChildPath '../../Modules/Microsoft365DSC/DSCResources'
    $schemaFiles = Get-ChildItem -Path $resourcesPath -Filter '*.schema.mof' -Recurse | ForEach-Object {
        $psm1 = Get-ChildItem -Path $_.Directory.FullName -Filter '*.psm1' -File -ErrorAction SilentlyContinue | Select-Object -First 1
        @{
            ResourceName = $_.Directory.Name
            FullName     = $_.FullName
            Psm1File     = if ($psm1) { $psm1.FullName } else { $null }
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

        # Workaround for OMI_BaseResource inheritance not resolving
        $filePath = (Resolve-Path -Path $FileName).Path
        $tempFilePath = Join-Path -Path $temporaryPath -ChildPath "DscMofHelper_$((New-Guid).Guid).tmp"
        $rawContent = (Get-Content -Path $filePath -Raw) -replace '\s*:\s*OMI_BaseResource'

        Set-Content -LiteralPath $tempFilePath -Value $rawContent -ErrorAction 'Stop'
        $tempFilePath = Convert-Path -Path $tempFilePath

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
            Remove-Item -LiteralPath $tempFilePath -Force -ErrorAction SilentlyContinue
        }

        foreach ($currentCimClass in $class)
        {
            $mainCimClassName = $FileName.Split("\")[-1].Replace(".schema.mof","")
            if ($currentCimClass.CimClassName -ne $mainCimClassName)
            {
                continue
            }

            $attributes = @()
            foreach ($property in $currentCimClass.CimClassProperties)
            {
                $attributes += @{
                    IsMandatory      = $true -eq $property.Qualifiers.Where( { $_.Name -eq 'Key' -or $_.Name -eq 'Required' }).Value
                    Name             = $property.Name
                    DataType         = $property.CimType
                    IsArray          = $property.CimType -gt 16
                    Description      = $property.Qualifiers.Where( { $_.Name -eq 'Description' }).Value
                    EmbeddedInstance = $property.Qualifiers.Where( { $_.Name -eq 'EmbeddedInstance' }).Value
                    ValueMap         = $property.Qualifiers.Where( { $_.Name -eq 'ValueMap' }).Value
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

    function Get-FunctionParameter
    {
        [CmdletBinding()]
        [OutputType([System.Collections.Hashtable[]])]
        param(
            [Parameter(Mandatory = $true)]
            [System.String]
            $FilePath,

            [Parameter(Mandatory = $true)]
            [System.String]
            $FunctionName
        )

        if (-not (Test-Path -Path $FilePath)) { return @() }

        $scriptText = Get-Content -Path $FilePath -Raw
        $tokens = $null
        $errors = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseInput($scriptText, [ref]$tokens, [ref]$errors)

        $funcAsts = $ast.FindAll({ param($n) $n -is [System.Management.Automation.Language.FunctionDefinitionAst] -and $n.Name -eq $FunctionName }, $true)

        if ($funcAsts.Count -eq 0) { return @() }

        $parameters = @()
        foreach ($f in $funcAsts)
        {
            foreach ($p in $f.Body.ParamBlock.Parameters)
            {
                $attributes = $p.Attributes | Where-Object { $_ -is [System.Management.Automation.Language.AttributeAst] }
                $mandatoryAttribute = $attributes | Where-Object { $_.TypeName.Name -eq 'Parameter' } | ForEach-Object { $_.NamedArguments } | Where-Object { $_.ArgumentName -eq 'Mandatory' }
                $validateSetAttribute = $attributes | Where-Object { $_.TypeName.Name -eq 'ValidateSet' }
                $validateRangeAttribute = $attributes | Where-Object { $_.TypeName.Name -eq 'ValidateRange' }

                $isMandatory = $false
                $validateSet = $null
                if ($null -ne $mandatoryAttribute)
                {
                    $isMandatory = $mandatoryAttribute.Argument.VariablePath.UserPath -eq 'true'
                }
                if ($null -ne $validateSetAttribute -or $null -ne $validateRangeAttribute)
                {
                    if ($null -eq $validateSetAttribute)
                    {
                        $lowerBoundary = $validateRangeAttribute.PositionalArguments[0].Value
                        $upperBoundary = $validateRangeAttribute.PositionalArguments[1].Value
                        if (($upperBoundary - $lowerBoundary) -lt 20)
                        {
                            $validateSet = ([System.Linq.Enumerable]::Range($lowerBoundary, $upperBoundary - $lowerBoundary + 1) | ForEach-Object { $_.ToString() })
                        }
                    }
                    else
                    {
                        $validateSet = $validateSetAttribute.PositionalArguments.Value
                    }
                }
                $parameters += @{
                    Name = $p.Name.VariablePath.UserPath
                    IsMandatory = $isMandatory
                    ValidateSet = $validateSet
                }
            }
        }

        ,$parameters
    }
}

Describe -Name "Validate TargetResource function parameters match schema for '<ResourceName>'" -ForEach $schemaFiles {
    Context 'Compare parameters to schema' {
        BeforeAll {
            $mofSchemas = Get-MofSchemaObject -FileName $FullName

            if ($null -eq $mofSchemas)
            {
                throw "No schema could be loaded for resource $ResourceName from file $FullName"
            }

            # Collect schema property names across classes
            $schemaProperties = $mofSchemas | ForEach-Object { $_.Attributes } | ForEach-Object { $_ }
            $schemaPropertyNames = $mofSchemas | ForEach-Object { $_.Attributes } | ForEach-Object { $_.Name } | Select-Object -Unique

            # Functions to check
            $functionsToCheck = @('Get-TargetResource','Set-TargetResource','Test-TargetResource')

            # Allowed parameter names that may exist in functions but not in schema
            $allowedExceptions = @(
                'PsDscRunAsCredential','ConfigurationData','OutputPath','PassThru','Force',
                'Verbose','WarningAction','ErrorAction','WhatIf','Confirm'
            )
        }

        It 'All declared function parameters should be part of the resource schema or an allowed exception' {
            foreach ($func in $functionsToCheck)
            {
                $params = Get-FunctionParameter -FilePath $psm1File -FunctionName $func

                foreach ($p in $params.Name)
                {
                    # Skip common PowerShell parameters and empty names
                    if ([System.String]::IsNullOrEmpty($p)) { continue }

                    $inSchema = $schemaPropertyNames -contains $p
                    $isAllowed = $allowedExceptions -contains $p

                    ($inSchema -or $isAllowed) | Should -BeTrue -Because "$func parameter '$p' is defined for resource $ResourceName and not in allowed exceptions"
                }
            }
        }

        It 'All declared schema properties should be part of all of the TargetResource functions' {
            foreach ($func in $functionsToCheck)
            {
                $params = Get-FunctionParameter -FilePath $psm1File -FunctionName $func
                foreach ($property in $schemaPropertyNames)
                {
                    $inParams = $params.Name -contains $property

                    $inParams | Should -BeTrue -Because "Schema property '$property' is defined as a parameter for function '$func' in resource $ResourceName"
                }
            }
        }

        It 'All declared function parameters should match their required type in the resource schema' {
            foreach ($func in $functionsToCheck)
            {
                $params = Get-FunctionParameter -FilePath $psm1File -FunctionName $func

                foreach ($property in $schemaProperties)
                {
                    $matchingParam = $params | Where-Object { $_.Name -eq $property.Name }
                    if ($matchingParam.Count -eq 0) { continue }

                    # For simplicity, we will just check if the parameter is mandatory when the schema property is required
                    if ($property.IsMandatory)
                    {
                        $matchingParam.IsMandatory | Should -BeTrue -Because "Parameter '$($matchingParam.Name)' in function '$func' for resource $ResourceName should be mandatory as defined in the schema"
                    }
                }
            }
        }

        It 'All declared function parameters with ValidateSet should match the set in the resource schema' {
            foreach ($func in $functionsToCheck)
            {
                $params = Get-FunctionParameter -FilePath $psm1File -FunctionName $func

                foreach ($property in $schemaProperties)
                {
                    $matchingParam = $params | Where-Object { $_.Name -eq $property.Name }
                    if ($matchingParam.Count -eq 0) { continue }

                    if ($property.ValueMap)
                    {
                        $matchingParam.ValidateSet | Should -Not -BeNullOrEmpty -Because "Parameter '$($matchingParam.Name)' in function '$func' for resource $ResourceName should have a ValidateSet as defined in the schema"
                        ($matchingParam.ValidateSet -as [string[]] | Sort-Object) | Should -Be ($property.ValueMap | Sort-Object) -Because "Parameter '$($matchingParam.Name)' in function '$func' for resource $ResourceName should have a ValidateSet that matches the ValueMap defined in the schema"
                    }
                }
            }
        }
    }
}
