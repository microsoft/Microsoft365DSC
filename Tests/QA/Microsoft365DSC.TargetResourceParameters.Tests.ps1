BeforeDiscovery {
    $resourcesPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\DSCResources'
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
                    Name             = $property.Name
                    DataType         = $property.CimType
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

    function Get-FunctionParameterNames
    {
        [CmdletBinding()]
        [OutputType([System.String[]])]
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
                $parameters += $p.Name.VariablePath.UserPath
            }
        }

        return ($parameters | Select-Object -Unique)
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
                $params = Get-FunctionParameterNames -FilePath $psm1File -FunctionName $func

                foreach ($p in $params)
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
                $params = Get-FunctionParameterNames -FilePath $psm1File -FunctionName $func
                foreach ($property in $schemaPropertyNames)
                {
                    $inParams = $params -contains $property

                    $inParams | Should -BeTrue -Because "Schema property '$property' is defined as a parameter for function '$func' in resource $ResourceName"
                }
            }
        }
    }
}
