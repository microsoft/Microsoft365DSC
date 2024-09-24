if (-not ([System.Management.Automation.PSTypeName]'WikiExampleBlockType').Type)
{
    $typeDefinition = @'
    public enum WikiExampleBlockType
    {
        None,
        PSScriptInfo,
        Configuration,
        ExampleCommentHeader
    }
'@
    Add-Type -TypeDefinition $typeDefinition
}

<#
.Description
Get-DscResourceSchemaPropertyContent is used to generate the parameter content
for the wiki page.

.Parameter Property
A hash table with properties that is returned by Get-MofSchemaObject in
the property Attributes.

.Parameter UseMarkdown
If certain text should be output as markdown, for example values of the
hashtable property ValueMap.

.Example
$content = Get-DscResourceSchemaPropertyContent -Property @(
        @{
            Name             = 'StringProperty'
            DataType         = 'String'
            IsArray          = $false
            State            = 'Key'
            Description      = 'Any description'
            EmbeddedInstance = $null
            ValueMap         = $null
        }
    )

Returns the parameter content based on the passed array of parameter metadata.

.Functionality
Internal,Hidden
#>
function Get-DscResourceSchemaPropertyContent
{
    [CmdletBinding()]
    [OutputType([System.String[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable[]]
        $Property,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $UseMarkdown
    )

    $stringArray = [System.String[]] @()

    $stringArray += '| Parameter | Attribute | DataType | Description | Allowed Values |'
    $stringArray += '| --- | --- | --- | --- | --- |'

    foreach ($currentProperty in $Property)
    {
        if ($currentProperty.EmbeddedInstance -eq 'MSFT_Credential')
        {
            $dataType = 'PSCredential'
        }
        elseif (-not [System.String]::IsNullOrEmpty($currentProperty.EmbeddedInstance))
        {
            $dataType = $currentProperty.EmbeddedInstance
        }
        else
        {
            $dataType = $currentProperty.DataType
        }

        # If the attribute is an array, add [] to the DataType string.
        if ($currentProperty.IsArray)
        {
            $dataType = $dataType.ToString() + '[]'
        }

        $propertyLine = "| **$($currentProperty.Name)** " + `
            "| $($currentProperty.State) " + `
            "| $dataType |"

        if (-not [System.String]::IsNullOrEmpty($currentProperty.Description))
        {
            $propertyLine += ' ' + $currentProperty.Description
        }

        $propertyLine += ' |'

        if (-not [System.String]::IsNullOrEmpty($currentProperty.ValueMap))
        {
            $valueMap = $currentProperty.ValueMap

            if ($UseMarkdown.IsPresent)
            {
                $valueMap = $valueMap | ForEach-Object -Process {
                    '`{0}`' -f $_
                }
            }

            $propertyLine += ' ' + ($valueMap -join ', ')
        }

        $propertyLine += ' |'

        $stringArray += $propertyLine
    }

    return (, $stringArray)
}

<#
.Description
The function will read the example PS1 file and convert the
help header into the description text for the example. It will
also surround the example configuration with code marks to
indication it is powershell code.

.Parameter ExamplePath
The path to the example file.

.Parameter ExampleNumber
The (order) number of the example.

.Example
Get-DscResourceWikiExampleContent -ExamplePath 'C:\repos\NetworkingDsc\Examples\Resources\DhcpClient\1-DhcpClient_EnableDHCP.ps1' -ExampleNumber 1

Reads the content of 'C:\repos\NetworkingDsc\Examples\Resources\DhcpClient\1-DhcpClient_EnableDHCP.ps1'
and converts it to markdown in preparation for being added to a resource wiki page.

.Functionality
Internal,Hidden
#>

function Get-DscResourceWikiExampleContent
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ExamplePath,

        [Parameter(Mandatory = $true)]
        [System.Int32]
        $ExampleNumber
    )

    $exampleContent = Get-Content -Path $ExamplePath

    # Use a string builder to assemble the example description and code
    $exampleDescriptionStringBuilder = New-Object -TypeName System.Text.StringBuilder
    $exampleCodeStringBuilder = New-Object -TypeName System.Text.StringBuilder

    <#
        Step through each line in the source example and determine
        the content and act accordingly:
        \<#PSScriptInfo...#\> - Drop block
        \#Requires - Drop Line
        \<#...#\> - Drop .EXAMPLE, .SYNOPSIS and .DESCRIPTION but include all other lines
        Configuration ... - Include entire block until EOF
    #>
    $blockType = [WikiExampleBlockType]::None

    foreach ($exampleLine in $exampleContent)
    {
        Write-Debug -Message ('Processing Line: {0}' -f $exampleLine)

        # Determine the behavior based on the current block type
        switch ($blockType.ToString())
        {
            'PSScriptInfo'
            {
                Write-Debug -Message 'PSScriptInfo Block Processing'

                # Exclude PSScriptInfo block from any output
                if ($exampleLine -eq '#>')
                {
                    Write-Debug -Message 'PSScriptInfo Block Ended'

                    # End of the PSScriptInfo block
                    $blockType = [WikiExampleBlockType]::None
                }
            }

            'Configuration'
            {
                Write-Debug -Message 'Configuration Block Processing'

                # Include all lines in the configuration block in the code output
                $null = $exampleCodeStringBuilder.AppendLine($exampleLine)
            }

            'ExampleCommentHeader'
            {
                Write-Debug -Message 'ExampleCommentHeader Block Processing'

                # Include all lines in Example Comment Header block except for headers
                $exampleLine = $exampleLine.TrimStart()

                if ($exampleLine -notin ('.SYNOPSIS', '.DESCRIPTION', '.EXAMPLE', '#>'))
                {
                    # Not a header so add this to the output
                    $null = $exampleDescriptionStringBuilder.AppendLine($exampleLine)
                }

                if ($exampleLine -eq '#>')
                {
                    Write-Debug -Message 'ExampleCommentHeader Block Ended'

                    # End of the Example Comment Header block
                    $blockType = [WikiExampleBlockType]::None
                }
            }

            default
            {
                Write-Debug -Message 'Not Currently Processing Block'

                # Check the current line
                if ($exampleLine.TrimStart() -eq '<#PSScriptInfo')
                {
                    Write-Debug -Message 'PSScriptInfo Block Started'

                    $blockType = [WikiExampleBlockType]::PSScriptInfo
                }
                elseif ($exampleLine -match 'Configuration')
                {
                    Write-Debug -Message 'Configuration Block Started'

                    $null = $exampleCodeStringBuilder.AppendLine($exampleLine)
                    $blockType = [WikiExampleBlockType]::Configuration
                }
                elseif ($exampleLine.TrimStart() -eq '<#')
                {
                    Write-Debug -Message 'ExampleCommentHeader Block Started'

                    $blockType = [WikiExampleBlockType]::ExampleCommentHeader
                }
            }
        }
    }

    # Assemble the final output
    $null = $exampleStringBuilder = New-Object -TypeName System.Text.StringBuilder
    $null = $exampleStringBuilder.AppendLine("### Example $ExampleNumber")
    $null = $exampleStringBuilder.AppendLine()
    $null = $exampleStringBuilder.AppendLine($exampleDescriptionStringBuilder)
    $null = $exampleStringBuilder.AppendLine('```powershell')
    $null = $exampleStringBuilder.Append($exampleCodeStringBuilder)
    $null = $exampleStringBuilder.Append('```')

    # ALways return CRLF as line endings to work cross platform.
    return ($exampleStringBuilder.ToString() -replace '\r?\n', "`r`n")
}

<#
.Description
The Get-MofSchemaObject method is used to read the text content of the
.schema.mof file that all MOF based DSC resources have. The object that
is returned contains all of the data in the schema so it can be processed
in other scripts.

.Parameter FileName
The full path to the .schema.mof file to process.

.Example
$mof = Get-MofSchemaObject -FileName C:\repos\SharePointDsc\DSCRescoures\MSFT_SPSite\MSFT_SPSite.schema.mof

This example parses a MOF schema file.

.Functionality
Internal,Hidden
#>
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

    if ($IsMacOS)
    {
        throw 'NotImplemented: Currently there is an issue using the type [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache] on macOS. See issue https://github.com/PowerShell/PowerShell/issues/5970 and issue https://github.com/PowerShell/MMI/issues/33.'
    }

    $temporaryPath = Get-TemporaryPath

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

<#
.Description
Get-ResourceExampleAsMarkdown gathers all examples for a resource and returns
them as string build object in markdown format.

.Parameter Path
The path to the source folder, the path will be recursively searched for *.ps1
files. All found files will be assumed that they are examples and that
documentation should be generated for them.

.Example
$examplesMarkdown = Get-ResourceExampleAsMarkdown -Path 'c:\MyProject\source\Examples\Resources\MyResourceName'

This example fetches all examples from the folder 'c:\MyProject\source\Examples\Resources\MyResourceName'
and returns them as a single string in markdown format.

.Functionality
Internal,Hidden
#>
function Get-ResourceExampleAsMarkdown
{
    [CmdletBinding()]
    [OutputType([System.Text.StringBuilder])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path
    )

    $filePath = Join-Path -Path $Path -ChildPath '*.ps1'

    $exampleFiles = @(Get-ChildItem -Path $filePath -File -Recurse -ErrorAction 'SilentlyContinue')

    if ($exampleFiles.Count -gt 0)
    {
        $outputExampleMarkDown = New-Object -TypeName 'System.Text.StringBuilder'

        Write-Verbose -Message ('Found {0} examples.' -f $exampleFiles.Count)

        $null = $outputExampleMarkDown.AppendLine('## Examples')

        $exampleCount = 1

        foreach ($exampleFile in $exampleFiles)
        {
            $exampleContent = Get-DscResourceWikiExampleContent `
                -ExamplePath $exampleFile.FullName `
                -ExampleNumber ($exampleCount++)

            $null = $outputExampleMarkDown.AppendLine()
            $null = $outputExampleMarkDown.AppendLine($exampleContent)
        }
    }
    else
    {
        Write-Warning -Message 'No Example files found.'
    }

    return $outputExampleMarkDown
}

<#
.Description
The Get-TemporaryPath function will return the temporary
path specific to the OS. It will return $ENV:Temp when run
on Windows OS, '/tmp' when run in Linux and $ENV:TMPDIR when
run on MacOS.

.Example
Get-TemporaryPath

Get the temporary path (which will differ between operating system).

.Functionality
Internal,Hidden
#>
function Get-TemporaryPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param ()

    $temporaryPath = $null

    switch ($true)
    {
        (-not (Test-Path -Path variable:IsWindows) -or ((Get-Variable -Name 'IsWindows' -ValueOnly -ErrorAction SilentlyContinue) -eq $true))
        {
            # Windows PowerShell or PowerShell 6+
            $temporaryPath = (Get-Item -Path env:TEMP).Value
        }

        ((Get-Variable -Name 'IsMacOs' -ValueOnly -ErrorAction SilentlyContinue) -eq $true)
        {
            $temporaryPath = (Get-Item -Path env:TMPDIR).Value
        }

        ((Get-Variable -Name 'IsLinux' -ValueOnly -ErrorAction SilentlyContinue) -eq $true)
        {
            $temporaryPath = '/tmp'
        }

        default
        {
            throw 'Cannot set the temporary path. Unknown operating system.'
        }
    }

    return $temporaryPath
}

<#
.Description
The New-DscMofResourceWikiPage cmdlet will review all of the MOF-based and
in a specified module directory and will output the Markdown files to the
specified directory. These help files include details on the property types
for each resource, as well as a text description and examples where they exist.

.Parameter OutputPath
Where should the files be saved to.

.Parameter SourcePath
The path to the root of the DSC resource module (where the PSD1 file is found,
not the folder for and individual DSC resource).

.Parameter Force
Overwrites any existing file when outputting the generated content.

.Example
New-DscMofResourceWikiPage `
    -SourcePath C:\repos\MyResource\source `
    -OutputPath C:\repos\MyResource\output\WikiContent

This example shows how to generate wiki documentation for a specific module.

.Functionality
Internal,Hidden
#>
function New-DscMofResourceWikiPage
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $SourcePath,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    $mofSearchPath = Join-Path -Path $SourcePath -ChildPath '\**\*.schema.mof'
    $mofSchemaFiles = @(Get-ChildItem -Path $mofSearchPath -Recurse)

    Write-Verbose -Message ("Found {0} MOF files in path '{1}'." -f $mofSchemaFiles.Count, $SourcePath)

    # Loop through all the Schema files found in the modules folder
    foreach ($mofSchemaFile in $mofSchemaFiles)
    {
        $mofSchemas = Get-MofSchemaObject -FileName $mofSchemaFile.FullName

        $dscResourceName = $mofSchemaFile.Name.Replace('.schema.mof', '')

        <#
            In a resource with one or more embedded instances (CIM classes) this
            will get the main resource CIM class.
        #>
        $resourceSchema = $mofSchemas |
        Where-Object -FilterScript {
                ($_.ClassName -eq $dscResourceName) -and ($null -ne $_.FriendlyName)
        }

        [System.Array] $readmeFile = Get-ChildItem -Path $mofSchemaFile.DirectoryName |
        Where-Object -FilterScript {
            $_.Name -like 'readme.md'
        }

        if ($readmeFile.Count -eq 1)
        {
            Write-Verbose -Message ("Generating wiki page for '{0}'." -f $resourceSchema.FriendlyName)

            $output = New-Object -TypeName System.Text.StringBuilder

            $null = $output.AppendLine("# $($resourceSchema.FriendlyName)")
            $null = $output.AppendLine('')
            $null = $output.AppendLine('## Parameters')
            $null = $output.AppendLine('')

            $propertyContent = Get-DscResourceSchemaPropertyContent -Property $resourceSchema.Attributes -UseMarkdown

            foreach ($line in $propertyContent)
            {
                $null = $output.AppendLine($line)
            }

            <#
                In a resource with one or more embedded instances (CIM classes) this
                will get the embedded instances (CIM classes).
            #>
            $embeddedSchemas = $mofSchemas |
            Where-Object -FilterScript {
                    ($_.ClassName -ne $dscResourceName)
            }

            foreach ($embeddedSchema in $embeddedSchemas)
            {
                $null = $output.AppendLine()
                $null = $output.AppendLine("### $($embeddedSchema.ClassName)")
                $null = $output.AppendLine('')
                $null = $output.AppendLine('#### Parameters')
                $null = $output.AppendLine('')

                $propertyContent = Get-DscResourceSchemaPropertyContent -Property $embeddedSchema.Attributes -UseMarkdown

                foreach ($line in $propertyContent)
                {
                    $null = $output.AppendLine($line)
                }
            }

            $descriptionContent = Get-Content -Path $readmeFile.FullName -Raw

            # Removing Resource name, which will else be added in the middle of the page
            $descriptionContent = $descriptionContent -replace "# $($resourceSchema.FriendlyName)`r`n`r`n", ''
            $null = $output.AppendLine()
            $null = $output.AppendLine($descriptionContent)

            # Add required permissions information
            $settingsFile = Join-Path -Path $mofSchemaFile.DirectoryName -ChildPath 'settings.json'

            $permissionsContent = New-Object -TypeName System.Text.StringBuilder
            $null = $permissionsContent.AppendLine('## Permissions')

            if (Test-Path -Path $settingsFile)
            {
                $settingsContent = Get-Content -Path $settingsFile -Raw
                $settingsJson = ConvertFrom-Json -InputObject $settingsContent

                if ($null -ne $settingsJson.permissions.exchange)
                {
                    $null = $permissionsContent.AppendLine()
                    $null = $permissionsContent.AppendLine('### Exchange')
                    $null = $permissionsContent.AppendLine()
                    $null = $permissionsContent.AppendLine('To authenticate with Microsoft Exchange, this resource required the following permissions:')
                    $null = $permissionsContent.AppendLine()
                    $null = $permissionsContent.AppendLine('#### Roles')
                    $null = $permissionsContent.AppendLine()
                    $null = $permissionsContent.AppendLine("- $($settingsJson.permissions.exchange.requiredroles -join ', ')")
                    $null = $permissionsContent.AppendLine()
                    $null = $permissionsContent.AppendLine('#### Role Groups')
                    $null = $permissionsContent.AppendLine()
                    if ($settingsJson.permissions.exchange.requiredrolegroups.Count -ne 0)
                    {
                        $roleGroups = $settingsJson.permissions.exchange.requiredrolegroups -join ', '
                    }
                    else
                    {
                        $roleGroups = 'None'
                    }
                    $null = $permissionsContent.AppendLine("- $roleGroups")
                }
                else
                {
                    # Microsoft Graph permissions
                    if ($null -ne $settingsJson.permissions.graph)
                    {
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('### Microsoft Graph')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('To authenticate with the Microsoft Graph API, this resource required the following permissions:')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('#### Delegated permissions')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Read**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.graph.delegated.read.Count -eq 0)
                        {
                            $delegatedRead = 'None'
                        }
                        else
                        {
                            $delegatedRead = $settingsJson.permissions.graph.delegated.read.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $delegatedRead")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Update**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.graph.delegated.update.Count -eq 0)
                        {
                            $delegatedUpdate = 'None'
                        }
                        else
                        {
                            $delegatedUpdate = $settingsJson.permissions.graph.delegated.update.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $delegatedUpdate")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('#### Application permissions')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Read**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.graph.application.read.Count -eq 0)
                        {
                            $applicationRead = 'None'
                        }
                        else
                        {
                            $applicationRead = $settingsJson.permissions.graph.application.read.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $applicationRead")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Update**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.graph.application.update.Count -eq 0)
                        {
                            $applicationUpdate = 'None'
                        }
                        else
                        {
                            $applicationUpdate = $settingsJson.permissions.graph.application.update.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $applicationUpdate")
                    }

                    # Microsoft SharePoint permissions
                    if ($null -ne $settingsJson.permissions.sharepoint)
                    {
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('### Microsoft SharePoint')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('To authenticate with the SharePoint API, this resource required the following permissions:')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('#### Delegated permissions')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Read**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.sharepoint.delegated.read.Count -eq 0)
                        {
                            $delegatedRead = 'None'
                        }
                        else
                        {
                            $delegatedRead = $settingsJson.permissions.sharepoint.delegated.read.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $delegatedRead")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Update**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.sharepoint.delegated.update.Count -eq 0)
                        {
                            $delegatedUpdate = 'None'
                        }
                        else
                        {
                            $delegatedUpdate = $settingsJson.permissions.sharepoint.delegated.update.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $delegatedUpdate")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('#### Application permissions')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Read**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.sharepoint.application.read.Count -eq 0)
                        {
                            $applicationRead = 'None'
                        }
                        else
                        {
                            $applicationRead = $settingsJson.permissions.sharepoint.application.read.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $applicationRead")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Update**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.sharepoint.application.update.Count -eq 0)
                        {
                            $applicationUpdate = 'None'
                        }
                        else
                        {
                            $applicationUpdate = $settingsJson.permissions.sharepoint.application.update.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $applicationUpdate")
                    }

                    # ProjectWorkManagement API permissions
                    if ($null -ne $settingsJson.permissions.ProjectWorkManagement)
                    {
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('### ProjectWorkManagement')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('To authenticate with the Microsoft ProjectWorkManagement API, this resource required the following permissions:')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('#### Delegated permissions')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Read**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.ProjectWorkManagement.delegated.read.Count -eq 0)
                        {
                            $delegatedRead = 'None'
                        }
                        else
                        {
                            $delegatedRead = $settingsJson.permissions.ProjectWorkManagement.delegated.read.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $delegatedRead")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Update**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.ProjectWorkManagement.delegated.update.Count -eq 0)
                        {
                            $delegatedUpdate = 'None'
                        }
                        else
                        {
                            $delegatedUpdate = $settingsJson.permissions.ProjectWorkManagement.delegated.update.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $delegatedUpdate")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('#### Application permissions')
                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Read**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.ProjectWorkManagement.application.read.Count -eq 0)
                        {
                            $applicationRead = 'None'
                        }
                        else
                        {
                            $applicationRead = $settingsJson.permissions.ProjectWorkManagement.application.read.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $applicationRead")

                        $null = $permissionsContent.AppendLine()
                        $null = $permissionsContent.AppendLine('- **Update**')
                        $null = $permissionsContent.AppendLine()

                        if ($settingsJson.permissions.ProjectWorkManagement.application.update.Count -eq 0)
                        {
                            $applicationUpdate = 'None'
                        }
                        else
                        {
                            $applicationUpdate = $settingsJson.permissions.ProjectWorkManagement.application.update.name -join ', '
                        }
                        $null = $permissionsContent.AppendLine("    - $applicationUpdate")
                    }
                }
            }
            else
            {
                $null = $permissionsContent.AppendLine()
                $null = $permissionsContent.AppendLine('No permission information available')
            }

            $null = $output.AppendLine($permissionsContent)

            # Adding examples
            $examplesPath = Join-Path -Path $SourcePath -ChildPath ('Examples\Resources\{0}' -f $resourceSchema.FriendlyName)

            $examplesOutput = Get-ResourceExampleAsMarkdown -Path $examplesPath

            if ($examplesOutput.Length -gt 0)
            {
                $null = $output.Append($examplesOutput)
            }

            $outputFileName = "$($resourceSchema.FriendlyName).md"
            $savePath = Join-Path -Path $OutputPath -ChildPath $outputFileName

            Write-Verbose -Message ("Outputting wiki page to '{0}'." -f $savePath)

            $null = Out-File `
                -InputObject ($output.ToString() -replace '\r?\n', "`r`n") `
                -FilePath $savePath `
                -Encoding utf8 `
                -Force:$Force
        }
        elseif ($readmeFile.Count -gt 1)
        {
            Write-Warning -Message ("{1} README.md description files found for '{0}', skipping." -f $resourceSchema.FriendlyName, $readmeFile.Count)
        }
        else
        {
            Write-Warning -Message ("No README.md description file found for '{0}', skipping." -f $resourceSchema.FriendlyName)
        }
    }
}

<#
.Description
The Update-M365DSCResourceDocumentationPage cmdlet will review all of the MOF-based,
class-based and composite resources in a specified module directory and will
output the Markdown files to the specified directory. These help files include
details on the property types for each resource, as well as a text description
and examples where they exist.

.Parameter SourcePath
The path to the root of the DSC resource module (where the PSD1 file is found,
not the folder for an individual DSC resource).

.Parameter Force
Overwrites any existing file when outputting the generated content.

.Example
Update-M365DSCResourceDocumentationPage `
    -SourcePath C:\repos\MyResource\source

This example shows how to generate wiki documentation for a specific module.

.Functionality
Internal
#>
function Update-M365DSCResourceDocumentationPage
{
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '')]
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $SourcePath,

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        $Force
    )

    Write-Output -InputObject 'Generating Resource Documentation pages'

    $tempPath = Join-Path -Path $env:TEMP -ChildPath 'ResourceMarkdown'

    if ((Test-Path -Path $tempPath) -eq $false)
    {
        $null = New-Item -Path $tempPath -ItemType 'Directory'
    }

    $newDscMofResourceWikiPageParameters = @{
        OutputPath = $tempPath
        SourcePath = $SourcePath
        Force      = $Force
    }

    New-DscMofResourceWikiPage @newDscMofResourceWikiPageParameters

    $resourceDocsRoot = Join-Path -Path $PSScriptRoot -ChildPath '..\..\..\docs\docs\resources'

    Write-Output -InputObject '  - Moving generated pages to the Docs folder'

    $files = Get-ChildItem -Path $tempPath
    foreach ($file in $files)
    {
        switch -Wildcard ($file.BaseName)
        {
            'AAD*'
            { $targetFolder = 'azure-ad'
            }
            'Defender*'
            { $targetFolder = 'Defender'
            }
            'EXO*'
            { $targetFolder = 'exchange'
            }
            'Intune*'
            { $targetFolder = 'intune'
            }
            'O365*'
            { $targetFolder = 'office365'
            }
            'OD*'
            { $targetFolder = 'onedrive'
            }
            'Planner*'
            { $targetFolder = 'planner'
            }
            'PP*'
            { $targetFolder = 'power-platform'
            }
            'SC*'
            { $targetFolder = 'security-compliance'
            }
            'SPO*'
            { $targetFolder = 'sharepoint'
            }
            'Teams*'
            { $targetFolder = 'teams'
            }
        }
        $destinationFolder = Join-Path -Path $resourceDocsRoot -ChildPath $targetFolder
        Move-Item -Path $file.FullName -Destination $destinationFolder -Force
    }

    Remove-Item -Path $tempPath -Force -Confirm:$false

    Write-Output -InputObject 'Generation of Resource Documentation pages completed'
}

Export-ModuleMember -Function @(
    'Update-M365DSCResourceDocumentationPage'
)
