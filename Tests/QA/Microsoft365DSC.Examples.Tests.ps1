BeforeDiscovery {
    $examplesPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\Examples'

    # If there are no Examples folder, exit.
    if (-not (Test-Path -Path $examplesPath))
    {
        return
    }

    $exampleFiles = @(Get-ChildItem -Path $examplesPath -Filter '*.ps1' -Recurse)

    $exampleToTest = @()

    foreach ($exampleFile in $exampleFiles)
    {
        $exampleToTest += @{
            ExampleFile            = $exampleFile
            ExampleDescriptiveName = Join-Path -Path (Split-Path $exampleFile.Directory -Leaf) -ChildPath (Split-Path $exampleFile -Leaf)
            ResourceName           = Split-Path $exampleFile.Directory -Leaf
        }
    }

    $resourcesPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\DscResources'

    # If there are no Examples folder, exit.
    if (-not (Test-Path -Path $resourcesPath))
    {
        return
    }

    $resourceFolders = Get-ChildItem -Path $resourcesPath -Directory

    $allResources = @()

    foreach ($resourceFolder in $resourceFolders)
    {
        $allResources += @{
            ResourceFolder = $resourceFolder.FullName
            ResourceName   = $resourceFolder.BaseName -replace '^MSFT_', ''
        }
    }
}

Describe -Name 'Successfully compile examples' {
    BeforeAll {
        function Get-PublishFileName
        {
            [CmdletBinding()]
            [OutputType([System.String])]
            param
            (
                [Parameter(Mandatory = $true)]
                [System.String]
                $Path
            )

            # Get the filename without extension.
            $filenameWithoutExtension = (Get-Item -Path $Path).BaseName

            <#
                Resource modules using auto-documentation uses a numeric value followed
                by a dash ('-') to be able to control the order of the example in
                the documentation. That will not be used when publishing, so remove
                it here from the name that is compared to the configuration name.
            #>
            return $filenameWithoutExtension -replace '^[0-9]+-'
        }
    }

    It "Should compile example '<ExampleDescriptiveName>' correctly" -TestCases $exampleToTest {
        {
            $mockPassword = ConvertTo-SecureString '&iPm%M5q3K$Hhq=wcEK' -AsPlainText -Force
            $mockCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList @('tenantadmin@contoso.onmicrosoft.com', $mockPassword)

            $mockConfigurationData = @{
                AllNodes = @(
                    @{
                        NodeName                    = 'localhost'
                        PsDscAllowPlainTextPassword = $true
                    }
                )
            }

            <#
                Set this first because it is used in the final block,
                and must be set otherwise it fails on not being assigned.
            #>
            $existingCommandName = $null

            try
            {
                . $ExampleFile.FullName

                <#
                    Test for either a configuration named 'Example',
                    or parse the name from the filename and try that
                    as the configuration name (requirement for Azure
                    Automation).
                #>
                $commandName = @(
                    'Example',
                        (Get-PublishFileName -Path $ExampleFile.FullName)
                )

                # Get the first one that matches.
                $existingCommand = Get-ChildItem -Path 'function:' | Where-Object {
                    $_.Name -in $commandName
                } | Select-Object -First 1

                if ($existingCommand)
                {
                    $existingCommandName = $existingCommand.Name

                    $exampleCommand = Get-Command -Name $existingCommandName -ErrorAction 'SilentlyContinue'

                    if ($exampleCommand)
                    {
                        $exampleParameters = @{}

                        # Remove any common parameters that are available.
                        $commandParameters = $exampleCommand.Parameters.Keys | Where-Object -FilterScript {
                                ($_ -notin [System.Management.Automation.PSCmdlet]::CommonParameters) -and `
                            ($_ -notin [System.Management.Automation.PSCmdlet]::OptionalCommonParameters)
                        }

                        foreach ($parameterName in $commandParameters)
                        {
                            $parameterType = $exampleCommand.Parameters[$parameterName].ParameterType.FullName

                            <#
                                    Each credential parameter in the Example function is assigned the
                                    mocked credential. 'PsDscRunAsCredential' is not assigned because
                                    that breaks the example.
                                #>
                            if ($parameterName -ne 'PsDscRunAsCredential' `
                                    -and $parameterType -eq 'System.Management.Automation.PSCredential')
                            {
                                $exampleParameters.Add($parameterName, $mockCredential)
                            }
                            else
                            {
                                <#
                                        Check for mandatory parameters.
                                        Assume the parameters are all in the 'all' parameter set.
                                    #>
                                $isParameterMandatory = $exampleCommand.Parameters[$parameterName].ParameterSets['__AllParameterSets'].IsMandatory
                                if ($isParameterMandatory)
                                {
                                    <#
                                            Convert '1' to the type that the parameter expects.
                                            Using '1' since it can be converted to String, Numeric
                                            and Boolean.
                                        #>
                                    $exampleParameters.Add($parameterName, ('1' -as $parameterType))
                                }
                                elseif ($parameterName -eq 'TenantId')
                                {
                                    $exampleParameters.Add('TenantId', (New-Guid).ToString())
                                }
                            }
                        }

                        <#
                                If there is a $ConfigurationData variable that was dot-sourced
                                then use that as the configuration data instead of the mocked
                                configuration data.
                            #>
                        if (Get-Item -Path variable:ConfigurationData -ErrorAction 'SilentlyContinue')
                        {
                            $mockConfigurationData = $ConfigurationData
                        }

                        & $exampleCommand.Name @exampleParameters -ConfigurationData $mockConfigurationData -OutputPath 'TestDrive:\' -ErrorAction 'Continue' -WarningAction 'SilentlyContinue' | Out-Null
                    }
                }
                else
                {
                    throw ('The example ''{0}'' does not contain a configuration named ''{1}''.' -f $exampleDescriptiveName, ($commandName -join "', or '"))
                }
            }
            finally
            {
                <#
                        Remove the function we dot-sourced so next example file
                        doesn't use the previous Example-function. Using recurse
                        since it saw child functions when copied in helper functions
                        during debugging, it resulted in an interactive prompt.
                    #>
                Remove-Item -Path "function:$existingCommandName" -ErrorAction 'SilentlyContinue' -Recurse -Force

                <#
                        Remove the variable $ConfigurationData if it existed in
                        the file we dot-sourced so next example file doesn't use
                        the previous examples configuration.
                    #>
                Remove-Item -Path 'variable:ConfigurationData' -ErrorAction 'SilentlyContinue'
            }
        } | Should -Not -Throw
    }
}

Describe -Name 'Check examples for all resources' {
    BeforeAll {
        $examplesPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..\Modules\Microsoft365DSC\Examples'

        # If there are no Examples folder, exit.
        if (-not (Test-Path -Path $examplesPath))
        {
            return
        }

        $exampleFiles = @(Get-ChildItem -Path $examplesPath -Filter '*.ps1' -Recurse)

        $exampleToTest = @()

        foreach ($exampleFile in $exampleFiles)
        {
            $exampleToTest += @{
                ExampleFile            = $exampleFile
                ExampleDescriptiveName = Join-Path -Path (Split-Path $exampleFile.Directory -Leaf) -ChildPath (Split-Path $exampleFile -Leaf)
                ResourceName           = Split-Path $exampleFile.Directory -Leaf
            }
        }
    }

    It "An example for '<ResourceName>' should exist" -TestCases $allResources {
        [Array]$res = $exampleToTest | Where-Object -FilterScript { $_.ResourceName -eq $ResourceName }
        $res.Count | Should -BeGreaterOrEqual 1
    }
}
