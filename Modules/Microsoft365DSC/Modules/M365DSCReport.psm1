# Automatically initialize accelerator on module import
Initialize-M365DSCDllLoader -ErrorAction SilentlyContinue

$Script:ReportCSS = @'
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f8f9fa;
        color: #212529;
        margin: 0;
        padding: 20px;
    }
    .report-container {
        max-width: 1200px;
        margin: auto;
        background-color: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 5px;
        padding: 40px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    h1, h2, h3 {
        color: #005a9e;
    }
    h1 {
        text-align: center;
        border-bottom: 2px solid #005a9e;
        padding-bottom: 10px;
        margin-top: 0;
    }
    h2 {
        border-bottom: 1px solid #ccc;
        padding-bottom: 5px;
        margin-top: 0;
    }
    table .resource-icon {
        width: 20%;
        text-align: center;
        vertical-align: middle;
    }
    .comparison-text {
        text-align: center;
        font-style: italic;
        color: #4d6477;
        margin: 40px 0 20px 0;
    }
    .comparison-text ul {
        display: inline-block;
        text-align: left;
        margin-top: 5px;
        padding-left: 20px;
    }
    .logo-container {
        text-align: center;
        margin-bottom: 20px;
    }
    .workload-section {
        margin-bottom: 30px;
    }
    .workload-header {
        background-color: #f0f0f0;
        padding: 15px;
        border-left: 4px solid #005a9e;
        margin-bottom: 15px;
        border-radius: 3px;
    }
    .workload-header h3 {
        margin: 0;
        color: #005a9e;
    }
    .workload-header img {
        height: 40px;
        width: auto;
    }
    .toc {
        background-color: #e9ecef;
        padding: 5px 15px 5px;
        border-radius: 5px;
        border: 1px solid #dee2e6;
    }
    .toc ul {
        list-style-type: none;
        padding: 0;
        margin: 0;
    }
    .toc li {
        margin-bottom: 10px;
    }
    .toc a {
        text-decoration: none;
        color: #005a9e;
        font-weight: bold;
    }
    .toc a:hover {
        text-decoration: underline;
    }
    .resource-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        border: 1px solid #dee2e6;
        h1, h2, h3 {
            color: #ffffff;
        }
    }
    .resource-table th, .resource-table td {
        padding: 8px 12px;
        text-align: left;
        border: 1px solid #dee2e6;
    }
    .resource-table .resource-header {
        background-color: #005a9e;
        color: #ffffff;
        text-align: center;
    }
    .drift-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        border: 1px solid #dee2e6;
        h1, h2, h3 {
            color: #ffffff;
        }
    }
    .drift-table th, .drift-table td {
        padding: 8px 12px;
        text-align: left;
        border: 1px solid #dee2e6;
    }
    .drift-table .drift-header {
        background-color: #005a9e;
        color: #ffffff;
        text-align: center;
    }
    .drift-table .drift-subheader {
        background-color: #e9ecef;
        font-weight: bold;
        text-align: center;
    }
    .property-name {
        text-align: left;
        font-weight: bold;
        width: 25%;
    }
    .property-value {
        text-align: left;
        width: 75%;
        max-width: 600px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .drift-table .value-cell {
        width: 27.5%;
    }
    .level-L1 { background-color: #F6CECE; }
    .level-L2 { background-color: #F7F8E0; }
    .level-L3 { background-color: #FFFFFF; }
    .emoticon { font-size: 1.2em; }
    .no-discrepancies {
        text-align: center;
        font-size: 1.2em;
        color: #28a745;
        margin-top: 20px;
        padding: 20px;
        background-color: #e9f7ef;
        border: 1px solid #a3d9b8;
        border-radius: 5px;
    }
</style>
'@

# Shared lookup table mapping resource name prefixes to workload names and icon file names.
# Order matters: longer/more-specific prefixes must come before shorter ones (e.g. 'SPO' before 'SH').
$Script:WorkloadMapping = [ordered]@{
    'AAD'      = @{ WorkloadName = 'Azure Active Directory'; IconName = 'AzureAD.jpg' }
    'ADO'      = @{ WorkloadName = 'Azure DevOps';           IconName = 'AzureDevOps.png' }
    'Azure'    = @{ WorkloadName = 'Azure';                  IconName = 'Azure.png' }
    'Defender' = @{ WorkloadName = 'Microsoft Defender';      IconName = 'SecurityAndCompliance.png' }
    'EXO'      = @{ WorkloadName = 'Exchange Online';        IconName = 'Exchange.jpg' }
    'Intune'   = @{ WorkloadName = 'Intune';                 IconName = 'Intune.jpg' }
    'O365'     = @{ WorkloadName = 'Office 365';             IconName = 'Office365.jpg' }
    'OD'       = @{ WorkloadName = 'OneDrive';               IconName = 'OneDrive.jpg' }
    'Planner'  = @{ WorkloadName = 'Planner';                IconName = 'Planner.png' }
    'PP'       = @{ WorkloadName = 'Power Platform';         IconName = 'PowerApps.jpg' }
    'SC'       = @{ WorkloadName = 'Security & Compliance';  IconName = 'SecurityAndCompliance.png' }
    'Sentinel' = @{ WorkloadName = 'Sentinel';               IconName = $null }
    'SH'       = @{ WorkloadName = 'Services Hub';           IconName = $null }
    'SPO'      = @{ WorkloadName = 'SharePoint Online';      IconName = 'SharePoint.jpg' }
    'Teams'    = @{ WorkloadName = 'Microsoft Teams';        IconName = 'Teams.jpg' }
}

<#
.DESCRIPTION
    This function generates HTML workload sections by grouping resources

.FUNCTIONALITY
    Internal, Hidden
#>
function New-M365DSCWorkloadSection
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Array]
        $Resources,

        [Parameter(Mandatory = $true)]
        [ScriptBlock]
        $ResourceRenderer
    )

    $output = [System.Text.StringBuilder]::new()

    # Group by workload
    $resourcesByWorkload = @{}
    foreach ($resource in $Resources)
    {
        $workload = Get-M365WorkloadName -ResourceName $resource.ResourceName
        if (-not $resourcesByWorkload.ContainsKey($workload))
        {
            $resourcesByWorkload[$workload] = @()
        }
        $resourcesByWorkload[$workload] += $resource
    }

    # Process each workload group
    foreach ($workload in ($resourcesByWorkload.Keys | Sort-Object))
    {
        $workloadResources = $resourcesByWorkload[$workload]
        $firstResource = $workloadResources[0]

        [void]$output.AppendLine("<div class='workload-section'>")
        [void]$output.AppendLine("<div class='workload-header'>")
        $iconPath = Get-IconPath -ResourceName $firstResource.ResourceName
        [void]$output.AppendLine("<img src='$iconPath' alt='$workload' style='vertical-align: middle; margin-right: 10px;' />")
        [void]$output.AppendLine("<h3 style='display: inline;'>$workload</h3>")
        [void]$output.AppendLine('</div>')

        foreach ($resource in $workloadResources)
        {
            $resourceOutput = & $ResourceRenderer $resource
            [void]$output.Append($resourceOutput)
        }

        [void]$output.AppendLine('</div>')
    }

    return $output.ToString()
}

<#
.DESCRIPTION
    This function creates a new Markdown document from the specified exported configuration

.FUNCTIONALITY
    Internal, Hidden
#>
function New-M365DSCConfigurationToMarkdown
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [Array]
        $ParsedContent,

        [Parameter()]
        [System.String]
        $OutputPath,

        [Parameter()]
        [System.String]
        $TemplateName,

        [Parameter()]
        [Switch]
        $SortProperties
    )

    $crlf = "`r`n"
    if ([System.String]::IsNullOrEmpty($TemplateName))
    {
        $TemplateName = 'Configuration Report'
    }

    Write-Output 'Generating Markdown report'
    $fullMD = '# ' + $TemplateName + $crlf

    $totalCount = $parsedContent.Count
    $currentCount = 0
    foreach ($resource in $parsedContent)
    {
        # Create a new table for each resource
        $percentage = [math]::Round(($currentCount / $totalCount) * 100, 2)
        Write-Progress -Activity 'Processing generated DSC Object' -Status ("{0:N2}% completed - $($resource.ResourceName)" -f $percentage) -PercentComplete $percentage

        $fullMD += '## ' + $resource.ResourceInstanceName + $crlf
        $fullMD += "|Item|Value|`r`n"
        $fullMD += "|:---|:---|`r`n"
        if ($SortProperties)
        {
            $properties = $resource.Keys | Sort-Object
        }
        else
        {
            $properties = $resource.Keys
        }

        foreach ($property in $properties)
        {
            if ($property -ne 'ResourceName' `
                -and $property -ne 'ApplicationId' `
                -and $property -ne 'CertificateThumbprint' `
                -and $property -ne 'TenantId')
            {
                # Create each row in the table
                # This first bit is the property in column 1
                $partMD += '|**' + $property + '**|'
                $value = "`$null"
                # And then the value in column 2
                if ($null -ne $resource.$property)
                {
                    if ($resource.$property.GetType().Name -eq 'Object[]')
                    {
                        if ($resource.$property -and ($resource.$property[0].GetType().Name -eq 'Hashtable' -or
                                $resource.$property[0].GetType().Name -eq 'OrderedDictionary'))
                        {
                            $value = ''
                            foreach ($entry in $resource.$property)
                            {
                                foreach ($key in $entry.Keys)
                                {
                                    $value += "$key = $($entry.$key)<br>"
                                }
                                $value += '<br>'
                            }
                        }
                        else
                        {
                            $temp = $resource.$property -join ','
                            [array]$components = $temp.Split(',')
                            if ($components.Length -gt 0 -and
                                -not [System.String]::IsNullOrEmpty($temp))
                            {
                                $Value = ''
                                foreach ($comp in $components)
                                {
                                    $value += "$comp<br>"
                                }
                                $value += '<br>'
                            }
                        }
                    }
                    else
                    # strings are easy
                    {
                        if (-not [System.String]::IsNullOrEmpty($resource.$property))
                        {
                            $value = ($resource.$property).ToString() + '|'
                        }
                    }
                }
                $partMD += $value + $crlf
            }
        }

        $fullMD += $partMD + $crlf
        $partMD = ''

        $currentCount++
    }

    if (-not [System.String]::IsNullOrEmpty($OutputPath))
    {
        Write-Output 'Saving Markdown report'
        $fullMD | Out-File $OutputPath
    }

    Write-Output 'Completed generating Markdown report'
}


<#
.DESCRIPTION
    This function creates a new HTML document from the specified exported configuration

.FUNCTIONALITY
    Internal, Hidden
#>
function New-M365DSCConfigurationToHTML
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [Array]
        $ParsedContent,

        [Parameter()]
        [System.String]
        $OutputPath,

        [Parameter()]
        [System.String]
        $TemplateName,

        [Parameter()]
        [switch]
        $SortProperties
    )

    # Always sort properties by default
    $SortProperties = $true

    if ([System.String]::IsNullOrEmpty($TemplateName))
    {
        $TemplateName = 'Configuration Report'
    }

    Write-Output 'Generating HTML report'
    $fullHTML = '<!DOCTYPE html>'
    $fullHTML += '<html>'
    $fullHTML += '<head><meta charset="utf-8"><title>Configuration Report</title>'
    $fullHTML += $Script:ReportCSS
    $fullHTML += '</head>'
    $fullHTML += '<body>'
    $fullHTML += "<div class='report-container'>"
    $fullHTML += '<h1>' + $TemplateName + '</h1>'
    $fullHTML += "<div class='logo-container'><img src='" + (Get-IconPath -ResourceName 'Promo') + "' alt='Microsoft365DSC Slogan' width='500' /></div>"
    $fullHTML += '<h2>Template Details</h2>'

    # Group resources by workload
    $resourcesByWorkload = @{}
    foreach ($resource in $parsedContent)
    {
        $workload = Get-M365WorkloadName -ResourceName $resource.ResourceName
        if (-not $resourcesByWorkload.ContainsKey($workload))
        {
            $resourcesByWorkload[$workload] = @()
        }
        $resourcesByWorkload[$workload] += $resource
    }

    $totalCount = $parsedContent.Count
    $currentCount = 0

    # Process each workload group
    foreach ($workload in ($resourcesByWorkload.Keys | Sort-Object))
    {
        $workloadResources = $resourcesByWorkload[$workload]
        $firstResource = $workloadResources[0]

        # Add workload header with icon
        $fullHTML += "<div class='workload-section'>"
        $fullHTML += "<div class='workload-header'>"
        $fullHTML += "<img src='" + (Get-IconPath -ResourceName $firstResource.ResourceName) + "' alt='$workload' style='vertical-align: middle; margin-right: 10px;' />"
        $fullHTML += "<h3 style='display: inline;'>$workload</h3>"
        $fullHTML += '</div>'

        # Process each resource in this workload
        foreach ($resource in $workloadResources)
        {
            $percentage = [math]::Round(($currentCount / $totalCount) * 100, 2)
            Write-Progress -Activity 'Processing generated DSC Object' -Status ("{0:N2}% completed - $($resource.ResourceName)" -f $percentage) -PercentComplete $percentage

            $partHTML = "<table class='resource-table'>"
            $partHTML += "<tr><td class='resource-header' colspan='2'>"
            $partHTML += '<strong>' + $resource.ResourceName + " '" + $resource.ResourceInstanceName + "'</strong>"
            $resource.Remove('ResourceInstanceName') | Out-Null
            $partHTML += '</td></tr>'

            if ($SortProperties)
            {
                $properties = $resource.Keys | Sort-Object
            }
            else
            {
                $properties = $resource.Keys
            }

            foreach ($property in $properties)
            {
                if ($property -ne 'ResourceName')
                {
                    $partHTML += "<tr><td class='property-name'>" + $property + '</td>'
                    $value = "`$null"
                    if ($null -ne $resource.$property)
                    {
                        if ($resource.$property.GetType().Name -eq 'Object[]' -or `
                            $resource.$property.GetType().Name -eq 'Hashtable')
                        {
                            if ($resource.$property -and
                                (($resource.$property -is [hashtable]) -or ($resource.$property -is [array] -and $resource.$property.Count -gt 0 -and ($resource.$property[0] -is [hashtable])))
                            )
                            {
                                $value = Convert-ObjectToHtmlList -InputObject $resource.$property -ParentName $property
                            }
                            else
                            {
                                $temp = $resource.$property -join ','
                                [array]$components = $temp.Split(',')
                                if ($components.Length -gt 0 -and
                                    -not [System.String]::IsNullOrEmpty($temp))
                                {
                                    $Value = '<ul>'
                                    foreach ($comp in $components)
                                    {
                                        $value += "<li>$comp</li>"
                                    }
                                    $value += '</ul>'
                                }
                            }
                        }
                        else
                        {
                            if (-not [System.String]::IsNullOrEmpty($resource.$property))
                            {
                                $value = ($resource.$property).ToString()
                            }
                        }
                    }
                    $partHTML += "<td class='property-value'>" + $value + '</td></tr>'
                }
            }

            $partHTML += '</table><br />'
            $fullHTML += $partHTML

            $currentCount++
        }

        $fullHTML += '</div>' # Close workload-section
    }

    $fullHTML += '</div>' # Close report-container
    $fullHTML += '</body>'
    $fullHTML += '</html>'

    if (-not [System.String]::IsNullOrEmpty($OutputPath))
    {
        Write-Output 'Saving HTML report'
        $fullHtml | Out-File $OutputPath
    }

    Write-Output 'Completed generating HTML report'
}

<#
.DESCRIPTION
    This function creates a new JSON file from the specified exported configuration

.FUNCTIONALITY
    Internal, Hidden
#>
function New-M365DSCConfigurationToJSON
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Array]
        $ParsedContent,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    $jsonContent = $ParsedContent | ConvertTo-Json -Depth 25
    $jsonContent | Out-File -FilePath $OutputPath
}


<#
.DESCRIPTION
    This function gets the workload name from a resource name

.FUNCTIONALITY
    Internal, Hidden
#>
function Get-M365WorkloadName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    foreach ($prefix in $Script:WorkloadMapping.Keys)
    {
        if ($ResourceName.StartsWith($prefix))
        {
            return $Script:WorkloadMapping[$prefix].WorkloadName
        }
    }

    return 'Other'
}

<#
.DESCRIPTION
    This function gets the URL to the logo of the workload of the specified resource

.FUNCTIONALITY
    Internal, Hidden
#>
function Get-IconPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    if ($ResourceName.StartsWith('Promo'))
    {
        return Get-Base64EncodedImage -IconName 'Promo.png'
    }

    foreach ($prefix in $Script:WorkloadMapping.Keys)
    {
        if ($ResourceName.StartsWith($prefix))
        {
            $iconName = $Script:WorkloadMapping[$prefix].IconName
            if ($null -ne $iconName)
            {
                return Get-Base64EncodedImage -IconName $iconName
            }
            return $null
        }
    }

    return $null
}

<#
.DESCRIPTION
    This function returns a string containing mime-type and base64 encoded image to embed into DSC report directly.

.FUNCTIONALITY
    Internal, Hidden
#>
function Get-Base64EncodedImage
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [string]
        $IconName
    )

    $IconPath = Join-Path -Path $PSScriptRoot `
        -ChildPath "..\dependencies\Images\$($IconName)" `
        -Resolve

    if (Test-Path -Path $IconPath)
    {
        $icon = Get-Item -Path $IconPath

        if ($icon.Extension.EndsWith('jpg') -or $icon.Extension.EndsWith('jpeg'))
        {
            $mimeType = 'image/jpeg'
        }

        if ($icon.Extension.EndsWith('png'))
        {
            $mimeType = 'image/png'
        }

        if ($PSVersionTable.PSEdition -eq 'Core')
        {
            $base64EncodedImage = [System.Convert]::ToBase64String((Get-Content -Path $IconPath -AsByteStream -ReadCount 0))
        }
        else
        {
            $base64EncodedImage = [System.Convert]::ToBase64String((Get-Content -Path $iconPath -Encoding Byte -ReadCount 0))
        }

        return $("data:$($mimeType);base64,$($base64EncodedImage)")
    }
    else
    {
        return $null
    }
}

<#
.DESCRIPTION
    This function creates a new Excel document from the specified exported configuration

.FUNCTIONALITY
    Internal, Hidden
#>
function New-M365DSCConfigurationToExcel
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Array]
        $ParsedContent,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    try
    {
        $excel = New-Object -ComObject excel.application
    }
    catch [System.Runtime.InteropServices.COMException]
    {
        throw 'Excel is not installed on this machine. Please install Excel to use this feature.'
    }
    $excel.visible = $True
    $workbook = $excel.Workbooks.Add()
    $report = $workbook.Worksheets.Item(1)
    $report.Name = 'Report'
    $report.Cells.Item(1, 1) = 'Component Name'
    $report.Cells.Item(1, 1).Font.Size = 18
    $report.Cells.Item(1, 1).Font.Bold = $True
    $report.Cells.Item(1, 2) = 'Property'
    $report.Cells.Item(1, 2).Font.Size = 18
    $report.Cells.Item(1, 2).Font.Bold = $True
    $report.Cells.Item(1, 3) = 'Value'
    $report.Cells.Item(1, 3).Font.Size = 18
    $report.Cells.Item(1, 3).Font.Bold = $True
    $report.Range('A1:C1').Borders.Weight = -4138
    $row = 2

    foreach ($resource in $parsedContent)
    {
        $beginRow = $row
        foreach ($property in $resource.Keys)
        {
            if ($property -ne 'ResourceName' -and $property -ne 'Credential')
            {
                $report.Cells.Item($row, 1) = $resource.ResourceName
                $report.Cells.Item($row, 2) = $property
                try
                {
                    if ([System.String]::IsNullOrEmpty($resource.$property))
                    {
                        $report.Cells.Item($row, 3) = "`$null"
                    }
                    else
                    {
                        if ($resource.$property.GetType().Name -eq 'Object[]')
                        {
                            $value = $resource.$property | Out-String
                            $report.Cells.Item($row, 3) = $value
                        }
                        else
                        {
                            $value = ($resource.$property).ToString().Replace('$', '')
                            $value = $value.Replace('@', '')
                            $value = $value.Replace('(', '')
                            $value = $value.Replace(')', '')
                            $report.Cells.Item($row, 3) = $value
                        }
                    }

                    $report.Cells.Item($row, 3).HorizontalAlignment = -4131
                }
                catch
                {
                    New-M365DSCLogEntry -Message 'Error during conversion to Excel:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }

                if ($property -in @('Identity', 'Name', 'IsSingleInstance', 'DisplayName'))
                {
                    $OriginPropertyName = $report.Cells.Item($beginRow, 2).Text
                    $OriginPropertyValue = $report.Cells.Item($beginRow, 3).Text
                    $CurrentPropertyName = $report.Cells.Item($row, 2).Text
                    $CurrentPropertyValue = $report.Cells.Item($row, 3).Text

                    $report.Cells.Item($beginRow, 2) = $CurrentPropertyName
                    $report.Cells.Item($beginRow, 3) = $CurrentPropertyValue
                    $report.Cells.Item($row, 2) = $OriginPropertyName
                    $report.Cells.Item($row, 3) = $OriginPropertyValue

                    $report.Cells($beginRow, 1).Font.ColorIndex = 10
                    $report.Cells($beginRow, 2).Font.ColorIndex = 10
                    $report.Cells($beginRow, 3).Font.ColorIndex = 10
                    $report.Cells($beginRow, 1).Font.Bold = $true
                    $report.Cells($beginRow, 2).Font.Bold = $true
                    $report.Cells($beginRow, 3).Font.Bold = $true
                }
                $row++
            }
        }
        $rangeValue = "A$beginRow" + ':' + "C$row"
        $report.Range($rangeValue).Borders[8].Weight = -4138
    }
    $usedRange = $report.UsedRange
    $usedRange.EntireColumn.AutoFit() | Out-Null
    $workbook.SaveAs($OutputPath)
    $excel.Quit()
}

<#
.DESCRIPTION
    This function creates a new CSV file from the specified exported configuration

.FUNCTIONALITY
    Internal, Hidden
#>
function New-M365DSCConfigurationToCSV
{
    [CmdletBinding()]
    param
    (
        [Parameter()]
        [Array]
        $ParsedContent,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath,

        [Parameter()]
        [System.String]
        $Delimiter = ','
    )

    $modelRow = @{'Component Name' = $null; Property = $null; Value = $null }
    $row = 0
    $csvOutput = @()

    foreach ($resource in $parsedContent)
    {
        $newRow = $modelRow.Clone()
        if ($row -gt 0)
        {
            Write-Verbose -Message 'add separator-line in CSV-file between resources'
            $newRow.'Component Name' = '======================'
            $csvOutput += [pscustomobject]$newRow
            $row++
        }
        $beginRow = $row
        foreach ($property in $resource.Keys)
        {
            $newRow = $modelRow.Clone()
            if ($property -ne 'ResourceName' -and $property -ne 'Credential')
            {
                $newRow.'Component Name' = $resource.ResourceName
                $newRow.Property = $property
                try
                {
                    if ([System.String]::IsNullOrEmpty($resource.$property))
                    {
                        $newRow.Value = "`$null"
                    }
                    else
                    {
                        if ($resource.$property.GetType().Name -eq 'Object[]')
                        {
                            $value = $resource.$property | Out-String
                            $newRow.Value = $value
                        }
                        else
                        {
                            $value = ($resource.$property).ToString() # .Replace('$', '')
                            $value = $value.Replace('@', '')
                            $value = $value.Replace('(', '')
                            $value = $value.Replace(')', '')
                            $newRow.Value = $value
                        }
                    }
                }
                catch
                {
                    New-M365DSCLogEntry -Message 'Error during conversion to CSV:' `
                        -Exception $_ `
                        -Source $($MyInvocation.MyCommand.Source) `
                        -TenantId $TenantId `
                        -Credential $Credential
                }

                if ($property -in @('Identity', 'Name', 'IsSingleInstance', 'DisplayName'))
                {
                    $OriginPropertyName   = $csvOutput[$beginRow].Property
                    $OriginPropertyValue  = $csvOutput[$beginRow].Value
                    $CurrentPropertyName  = $newRow.Property
                    $CurrentPropertyValue = $newRow.Value

                    $csvOutput[$beginRow].Property = $CurrentPropertyName
                    $csvOutput[$beginRow].Value = $CurrentPropertyValue
                    $newRow.Property = $OriginPropertyName
                    $newRow.Value = $OriginPropertyValue
                }
                $csvOutput += [pscustomobject]$newRow
                $row++
            }
        }
    }
    $csvOutput | Export-Csv -Path $OutputPath -Encoding UTF8 -Delimiter $Delimiter -NoTypeInformation
}

<#
.DESCRIPTION
    This function creates a report from the specified exported configuration,
    either in HTML or Excel format

.PARAMETER Type
    The type of report that should be created: Excel or HTML.

.PARAMETER ConfigurationPath
    The path to the exported DSC configuration that the report should be created for.

.PARAMETER OutputPath
    The output path of the report.

.EXAMPLE
    PS> New-M365DSCReportFromConfiguration -Type 'HTML' -ConfigurationPath 'C:\DSC\ConfigName.ps1' -OutputPath 'C:\Dsc\M365Report.html'

.EXAMPLE
    PS> New-M365DSCReportFromConfiguration -Type 'Excel' -ConfigurationPath 'C:\DSC\ConfigName.ps1' -OutputPath 'C:\Dsc\M365Report.xlsx'

.EXAMPLE
    PS> New-M365DSCReportFromConfiguration -Type 'JSON' -ConfigurationPath 'C:\DSC\ConfigName.ps1' -OutputPath 'C:\Dsc\M365Report.json'

.FUNCTIONALITY
    Public
#>
function New-M365DSCReportFromConfiguration
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Excel', 'HTML', 'JSON', 'Markdown', 'CSV')]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ConfigurationPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )
    dynamicparam # parameter 'Delimiter' is only available when Type = 'CSV'
    {
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        if ($Type -eq 'CSV')
        {
            $delimiterAttr = [System.Management.Automation.ParameterAttribute]::New()
            $delimiterAttr.Mandatory = $false
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
            $attributeCollection.Add($delimiterAttr)
            $delimiterParam = [System.Management.Automation.RuntimeDefinedParameter]::New('Delimiter', [System.String], $attributeCollection)
            $delimiterParam.Value = ';' # default value, comma makes a mess when importing a CSV-file in Excel
            $paramDictionary.Add('Delimiter', $delimiterParam)
            $PSBoundParameters.Add('Delimiter', $delimiterParam.Value)
        }
        return $paramDictionary
    }

    begin
    {
        if ($PSBoundParameters.ContainsKey('Delimiter'))
        {
            $Delimiter = $PSBoundParameters.Delimiter
        }
    }
    process # required with DynamicParam
    {
        # Test if Windows Remoting is enabled, which is needed to run this function.
        $result = Test-WSMan -ErrorAction SilentlyContinue
        if ($null -eq $result)
        {
            Write-Error -Message 'Windows Remoting is NOT configured yet. Please configure Windows Remoting (by running `Enable-PSRemoting -SkipNetworkProfileCheck`) before running this function.'
            return
        }

        # Validate that the latest version of the module is installed.
        Test-M365DSCModuleValidity

        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
        $data.Add('Event', 'Report')
        $data.Add('Type', $Type)
        Add-M365DSCTelemetryEvent -Data $data -Type 'NewReport'
        #endregion

        [Array] $parsedContent = Initialize-M365DSCReporting -ConfigurationPath $ConfigurationPath

        if ($null -ne $parsedContent)
        {
            switch ($Type)
            {
                'Excel'
                {
                    New-M365DSCConfigurationToExcel -ParsedContent $parsedContent -OutputPath $OutputPath
                }
                'HTML'
                {
                    $template = Get-Item $ConfigurationPath
                    $templateName = $Template.Name.Split('.')[0]
                    New-M365DSCConfigurationToHTML -ParsedContent $parsedContent -OutputPath $OutputPath -TemplateName $templateName
                }
                'JSON'
                {
                    New-M365DSCConfigurationToJSON -ParsedContent $parsedContent -OutputPath $OutputPath
                }
                'Markdown'
                {
                    $template = Get-Item $ConfigurationPath
                    $templateName = $Template.Name.Split('.')[0]
                    New-M365DSCConfigurationToMarkdown -ParsedContent $parsedContent -OutputPath $OutputPath -TemplateName $templateName
                }
                'CSV'
                {
                    New-M365DSCConfigurationToCSV -ParsedContent $parsedContent -OutputPath $OutputPath -Delimiter $Delimiter
                }
            }
        }
        else
        {
            Write-Warning -Message 'Parsed content was null. No report was generated.'
        }
    }
}

<#
.DESCRIPTION
    This function gets the key parameter for the specified CIMInstance

.FUNCTIONALITY
    Internal
#>
function Get-M365DSCCIMInstanceKey
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $CIMInstance
    )

    $primaryKey = ''
    if ($CIMInstance.ContainsKey('IsSingleInstance'))
    {
        $primaryKey = ''
    }
    elseif ($CIMInstance.ContainsKey('DisplayName'))
    {
        $primaryKey = 'DisplayName'
    }
    elseif ($CIMInstance.ContainsKey('Identity'))
    {
        $primaryKey = 'Identity'
    }
    elseif ($CIMInstance.ContainsKey('Id'))
    {
        $primaryKey = 'Id'
    }
    elseif ($CIMInstance.ContainsKey('Name'))
    {
        $primaryKey = 'Name'
    }
    elseif ($CIMInstance.ContainsKey('Title'))
    {
        $primaryKey = 'Title'
    }
    elseif ($CIMInstance.ContainsKey('CdnType'))
    {
        $primaryKey = 'CdnType'
    }
    elseif ($CIMInstance.ContainsKey('Usage'))
    {
        $primaryKey = 'Usage'
    }
    elseif ($CIMInstance.ContainsKey('odataType'))
    {
        $primaryKey = 'odataType'
    }
    elseif ($CIMInstance.ContainsKey('dataType'))
    {
        $primaryKey = 'dataType'
    }
    elseif ($CIMInstance.ContainsKey('Dmn'))
    {
        $primaryKey = 'Dmn'
    }
    elseif ($CIMInstance.ContainsKey('EmergencyDialString'))
    {
        $primaryKey = 'EmergencyDialString'
    }
    else
    {
        $primaryKey = $CIMInstance.Keys[0]
    }

    return $primaryKey
}

<#
.DESCRIPTION
    This function gets the key parameter for the specified resource

.FUNCTIONALITY
    Internal, Hidden
#>
function Get-M365DSCResourceKey
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Resource,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $DSCResourceInfo
    )
    $resourceInfo = $DSCResourceInfo[$Resource.ResourceName]
    if ($null -eq $Script:MandatoryParametersCache)
    {
        $Script:MandatoryParametersCache = @{}
    }

    if ($Script:MandatoryParametersCache.ContainsKey($Resource.ResourceName))
    {
        return $Script:MandatoryParametersCache[$Resource.ResourceName]
    }

    [Array]$mandatoryParameters = $resourceInfo.Properties | Where-Object IsMandatory -EQ $true
    if ($Resource.ContainsKey('IsSingleInstance') -and $mandatoryParameters.Name.Contains('IsSingleInstance'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('IsSingleInstance')
        return @('IsSingleInstance')
    }
    elseif ($Resource.ContainsKey('DisplayName') -and $mandatoryParameters.Name.Contains('DisplayName') -and $Resource.ResourceName -in @('AADGroup', 'IntuneDeviceEnrollmentPlatformRestriction', 'TeamsChannel', 'TeamsTeam'))
    {
        if ($Resource.ResourceName -eq 'AADGroup' -and -not [System.String]::IsNullOrEmpty($Resource.MailNickname))
        {
            $Script:MandatoryParametersCache[$Resource.ResourceName] = @('DisplayName', 'MailNickname')
            return ('DisplayName', 'MailNickname')
        }
        if ($Resource.ResourceName -eq 'IntuneDeviceEnrollmentPlatformRestriction' -and $Resource.Keys.Where({ $_ -like '*Restriction' }))
        {
            $Script:MandatoryParametersCache[$Resource.ResourceName] = @('ResourceInstanceName')
            return @('ResourceInstanceName')
        }
        if ($Resource.ResourceName -eq 'TeamsChannel' -and -not [System.String]::IsNullOrEmpty($Resource.TeamName))
        {
            # Teams Channel displaynames are not tenant-unique (e.g. "General" is almost in every team), but should be unique per team
            $Script:MandatoryParametersCache[$Resource.ResourceName] = @('TeamName', 'DisplayName')
            return @('TeamName', 'DisplayName')
        }
        if ($Resource.ResourceName -eq 'TeamsTeam' -and -not [System.String]::IsNullOrEmpty($Resource.MailNickName))
        {
            # Teams names are not unique
            $Script:MandatoryParametersCache[$Resource.ResourceName] = @('MailNickName', 'DisplayName')
            return @('MailNickName', 'DisplayName')
        }
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('DisplayName')
        return @('DisplayName')
    }
    elseif ($Resource.ContainsKey('Identity') -and $mandatoryParameters.Name.Contains('Identity'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Identity')
        return @('Identity')
    }
    elseif ($Resource.ContainsKey('Name') -and $mandatoryParameters.Name.Contains('Name'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Name')
        return @('Name')
    }
    elseif ($Resource.ContainsKey('Url') -and $mandatoryParameters.Name.Contains('Url'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Url')
        return @('Url')
    }
    elseif ($Resource.ContainsKey('Organization') -and $mandatoryParameters.Name.Contains('Organization'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Organization')
        return @('Organization')
    }
    elseif ($Resource.ContainsKey('CDNType') -and $mandatoryParameters.Name.Contains('CDNType'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('CDNType')
        return @('CDNType')
    }
    elseif ($Resource.ContainsKey('Action') -and $Resource.ResourceName -eq 'SCComplianceSearchAction' -and $mandatoryParameters.Name.Contains('Action'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('SearchName', 'Action')
        return @('SearchName', 'Action')
    }
    elseif ($Resource.ContainsKey('Workload') -and $Resource.ResourceName -eq 'SCAuditConfigurationPolicy' -and $mandatoryParameters.Name.Contains('Workload'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Workload')
        return @('Workload')
    }
    elseif ($Resource.ContainsKey('Title') -and $Resource.ResourceName -eq 'SPOSiteDesign' -and $mandatoryParameters.Name.Contains('Title'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Title')
        return @('Title')
    }
    elseif ($Resource.ContainsKey('SiteDesignTitle') -and $mandatoryParameters.Name.Contains('SiteDesignTitle'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('SiteDesignTitle')
        return @('SiteDesignTitle')
    }
    elseif ($Resource.ContainsKey('Key') -and $Resource.ResourceName -eq 'SPOStorageEntity' -and $mandatoryParameters.Name.Contains('Key'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Key')
        return @('Key')
    }
    elseif ($Resource.ContainsKey('Usage') -and $mandatoryParameters.Name.Contains('Usage'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('Usage')
        return @('Usage')
    }
    elseif ($Resource.ContainsKey('OrgWideAccount') -and $mandatoryParameters.Name.Contains('OrgWideAccount'))
    {
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @('OrgWideAccount')
        return @('OrgWideAccount')
    }
    elseif ($mandatoryParameters.Count -gt 0)
    {
        # return all mandatory parameters
        if ($Resource.ResourceName -eq 'EXOTenantAllowBlockListItems')
        {
            $mandatoryParameters = $mandatoryParameters | Where-Object Name -NE 'Action' # Action is not a key property but still mandatory
        }
        $Script:MandatoryParametersCache[$Resource.ResourceName] = @($mandatoryParameters.Name)
        return @($mandatoryParameters.Name)
    }
    elseif ($mandatoryParameters.Count -eq 0)
    {
        Write-Verbose -Message "No mandatory parameters found for $($Resource.ResourceName)"
    }
}

<#
.DESCRIPTION
    This function creates a delta HTML report between two provided exported
    DSC configurations

.PARAMETER Source
    The source DSC configuration to compare from.

.PARAMETER Destination
    The destination DSC configuration to compare with.

.PARAMETER OutputPath
    The output path of the delta report.

.PARAMETER DriftOnly
    Specifies that only difference should be in the report.

.PARAMETER IsBlueprintAssessment
    Specifies that the report is a comparison with a Blueprint.

.PARAMETER HeaderFilePath
    Specifies that file that contains a custom header for the report.

.PARAMETER Delta
    An array with difference, already compiled from another source.

.PARAMETER ExcludedProperties
    Array that contains the list of parameters to exclude.

.PARAMETER ExcludedResources
    Array that contains the list of resources to exclude.

.EXAMPLE
    PS> New-M365DSCDeltaReport -Source 'C:\DSC\Source.ps1' -Destination 'C:\DSC\Destination.ps1' -OutputPath 'C:\Dsc\DeltaReport.html'

.EXAMPLE
    PS> New-M365DSCDeltaReport -Source 'C:\DSC\Source.ps1' -Destination 'C:\DSC\Destination.ps1' -OutputPath 'C:\Dsc\DeltaReport.html' -DriftOnly $true

.FUNCTIONALITY
    Public
#>
function New-M365DSCDeltaReport
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Source,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Destination,

        [Parameter()]
        [System.String]
        $OutputPath,

        [Parameter()]
        [System.Boolean]
        $DriftOnly = $false,

        [Parameter()]
        [System.Boolean]
        $IsBlueprintAssessment = $false,

        [Parameter()]
        [System.String]
        $HeaderFilePath,

        [Parameter()]
        [Array]
        $Delta,

        [Parameter()]
        [System.String]
        [ValidateSet('HTML', 'JSON')]
        $Type = 'HTML',

        [Parameter()]
        [Array]
        $ExcludedProperties,

        [Parameter()]
        [Array]
        $ExcludedResources
    )

    # Validate that the latest version of the module is installed.
    Test-M365DSCModuleValidity

    if ((Test-Path -Path $Source) -eq $false)
    {
        Write-Error "Cannot find file specified in parameter Source: $Source. Please make sure the file exists!"
        return
    }

    if ((Test-Path -Path $Destination) -eq $false)
    {
        Write-Error "Cannot find file specified in parameter Destination: $Destination. Please make sure the file exists!"
        return
    }

    if ($OutputPath -and (Test-Path -Path $OutputPath) -eq $true)
    {
        Write-Warning "File specified in parameter OutputPath already exists and will be overwritten: $OutputPath"
        Write-Warning "Make sure you specify a file that does not exist if you don't want the file to be overwritten!"
    }

    if ($PSBoundParameters.ContainsKey('HeaderFilePath') -and -not [System.String]::IsNullOrEmpty($HeaderFilePath) -and `
        (Test-Path -Path $HeaderFilePath) -eq $false)
    {
        Write-Error "Cannot find file specified in parameter HeaderFilePath: $HeaderFilePath. Please make sure the file exists!"
        return
    }

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    if ($null -eq (Get-Module -Name 'M365DSCCompare'))
    {
        Import-Module -Name "$PSScriptRoot\M365DSCCompare.psm1" -Force
    }

    #region Telemetry
    $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
    $data.Add('Event', 'DeltaReport')
    Add-M365DSCTelemetryEvent -Data $data -Type 'CompareConfigurations'
    #endregion

    # Excluding authentication properties by default.
    $authParameters = @('Credential', 'ManagedIdentity', 'ApplicationId', 'TenantId', 'CertificatePath', 'CertificatePassword', 'CertificateThumbprint', 'ApplicationSecret')
    $ExcludedProperties += 'ResourceInstanceName'
    $ExcludedProperties = $ExcludedProperties + $authParameters | Select-Object -Unique

    if ($null -eq $Script:DscResourceInfo)
    {
        $currentModule = Get-Module -Name 'Microsoft365DSC'
        $Script:DscResourceInfo = Get-DscResourceV2 -Module 'Microsoft365DSC' | Where-Object Version -EQ $currentModule.Version
    }

    $dscResourceInfoMap = @{}
    foreach ($resource in $Script:DscResourceInfo)
    {
        $dscResourceInfoMap.Add($resource.Name, $resource)
    }

    Write-Verbose -Message 'Obtaining Delta between the source and destination configurations'
    if (-not $Delta)
    {
        $desiredSplat = @{
            ConfigurationPath = $Destination
            IncludeComments   = $false
            DscResourceInfo   = $Script:DscResourceInfo
        }

        if ($IsBlueprintAssessment)
        {
            $desiredSplat.IncludeComments = $true
        }

        # Parse the blueprint file, pass to other comparison functions as object (including comments aka metadata)
        [Array]$desiredConfiguration = Initialize-M365DSCReporting @desiredSplat
        [Array]$sourceReporting = Initialize-M365DSCReporting -ConfigurationPath $Source
        $Delta = @()
        foreach ($resource in $sourceReporting)
        {
            [array]$key = Get-M365DSCResourceKey -Resource $resource -DSCResourceInfo $dscResourceInfoMap
            #Write-Progress -Activity "Scanning Source $Source...[$i/$($SourceObject.Count)]" -PercentComplete ($i / ($SourceObject.Count) * 100)
            [array]$destinationResource = [Microsoft365DSC.Utilities.Utilities]::FilterHashtablesByResourceAndKey($desiredConfiguration, $resource.ResourceName, $key[0], $resource.($key[0]))

            $keyName = $key[0..1] -join '\'
            $sourceKeyValue = $resource.($key[0])
            # Filter on the second key
            if ($key.Count -gt 1)
            {
                [array]$destinationResource = $destinationResource.Where({ $_.($key[1]) -eq $resource.($key[1]) })
                $sourceKeyValue = $resource.($key[0]), $resource.($key[1]) -join '\'
            }
            # Filter on the third key
            if ($key.Count -gt 2)
            {
                [array]$destinationResource = $destinationResource.Where({ $_.($key[2]) -eq $resource.($key[2]) })
                $sourceKeyValue = $resource.($key[0]), $resource.($key[1]), $resource.($key[2]) -join '\'
            }
            if ($null -eq $destinationResource -or $destinationResource.Count -eq 0)
            {
                $Delta += @{
                    ResourceName         = $resource.ResourceName
                    ResourceInstanceName = $resource.ResourceInstanceName
                    Key                  = $keyName
                    KeyValue             = $sourceKeyValue
                    Properties           = @(@{
                        ParameterName      = '_IsInConfiguration_'
                        ValueInSource      = 'Present'
                        ValueInDestination = 'Absent'
                    })
                }
                continue
            }

            # Get resource-specific comparison parameters from metadata
            $resourceCompareParams = @{
                ResourceName       = $resource.ResourceName
                DesiredValues      = $destinationResource[0]
                CurrentValues      = $resource
                ExcludedProperties = $ExcludedProperties
            }

            # Check if this resource has custom comparison logic
            $metadata = Get-M365DSCResourceComparisonMetadata -ResourceName $resource.ResourceName
            if ($metadata.HasCustomComparison)
            {
                Write-Verbose -Message "Resource $($resource.ResourceName) has custom comparison logic. Retrieving parameters..."
                try
                {
                    $customCompareParams = Get-M365DSCResourceComparisonParameters -ResourceName $resource.ResourceName

                    # Merge resource-specific ExcludedProperties with global ones
                    if ($customCompareParams.ContainsKey('ExcludedProperties') -and $null -ne $customCompareParams.ExcludedProperties)
                    {
                        $resourceCompareParams.ExcludedProperties = $ExcludedProperties + $customCompareParams.ExcludedProperties | Select-Object -Unique
                        Write-Verbose -Message "  Merged ExcludedProperties: $($resourceCompareParams.ExcludedProperties -join ', ')"
                    }

                    # Add IncludedProperties if specified
                    if ($customCompareParams.ContainsKey('IncludedProperties') -and $null -ne $customCompareParams.IncludedProperties)
                    {
                        $resourceCompareParams.IncludedProperties = $customCompareParams.IncludedProperties
                        Write-Verbose -Message "  IncludedProperties: $($customCompareParams.IncludedProperties -join ', ')"
                    }

                    # Add PostProcessing scriptblock if specified
                    if ($customCompareParams.ContainsKey('PostProcessing') -and $null -ne $customCompareParams.PostProcessing)
                    {
                        $resourceCompareParams.PostProcessing = $customCompareParams.PostProcessing
                        Write-Verbose -Message '  PostProcessing scriptblock applied'
                    }

                    # Add PostProcessingArgs if specified
                    if ($customCompareParams.ContainsKey('PostProcessingArgs') -and $null -ne $customCompareParams.PostProcessingArgs)
                    {
                        $resourceCompareParams.PostProcessingArgs = $customCompareParams.PostProcessingArgs
                        Write-Verbose -Message '  PostProcessingArgs applied'
                    }
                }
                catch
                {
                    Write-Warning -Message "Failed to retrieve custom comparison parameters for $($resource.ResourceName): $_. Using default comparison."
                }
            }

            $compareResult = Compare-M365DSCResourceState @resourceCompareParams

            if (-not $compareResult -and $null -ne $Global:AllDrifts.DriftInfo -and $Global:AllDrifts.DriftInfo.Count -gt 0)
            {
                foreach ($driftInfo in $Global:AllDrifts.DriftInfo)
                {
                    $Delta += @{
                        ResourceName         = $resource.ResourceName
                        ResourceInstanceName = $resource.ResourceInstanceName
                        Key                  = $keyName
                        KeyValue             = $sourceKeyValue
                        Properties           = @(@{
                            ParameterName      = $driftInfo.PropertyName
                            ValueInSource      = $driftInfo.CurrentValue
                            ValueInDestination = $driftInfo.DesiredValue
                        })
                    }

                    if ($destinationResource[0].ContainsKey("_metadata_$($driftInfo.PropertyName)"))
                    {
                        $Metadata = $destinationResource[0]."_metadata_$($driftInfo.PropertyName)"
                        $Level = $Metadata.Split('|')[0].Replace('### ', '')
                        $Information = $Metadata.Split('|')[1]
                        $Delta[-1].Properties[0].Add('_Metadata_Level', $Level)
                        $Delta[-1].Properties[0].Add('_Metadata_Info', $Information)
                    }
                }
                $Global:AllDrifts.DriftInfo = @()
            }
        }

        foreach ($resource in $desiredConfiguration)
        {
            [array]$key = Get-M365DSCResourceKey -Resource $resource -DSCResourceInfo $dscResourceInfoMap
            $keyName = $key[0..1] -join '\'
            $destinationKeyValue = $resource.($key[0])
            [array]$sourceResource = [Microsoft365DSC.Utilities.Utilities]::FilterHashtablesByResourceAndKey($sourceReporting, $resource.ResourceName, $key[0], $resource.($key[0]))

            # Filter on the second key
            if ($key.Count -gt 1)
            {
                [array]$sourceResource = $sourceResource.Where({ $_.($key[1]) -eq $resource.($key[1]) })
                $destinationKeyValue = $resource.($key[0]), $resource.($key[1]) -join '\'
            }
            # Filter on the third key
            if ($key.Count -gt 2)
            {
                [array]$sourceResource = $sourceResource.Where({ $_.($key[2]) -eq $resource.($key[2]) })
                $destinationKeyValue = $resource.($key[0]), $resource.($key[1]), $resource.($key[2]) -join '\'
            }

            if ($null -eq $sourceResource -or $sourceResource.Count -eq 0)
            {
                $Delta += @{
                    ResourceName         = $resource.ResourceName
                    ResourceInstanceName = $resource.ResourceInstanceName
                    Key                  = $keyName
                    KeyValue             = $destinationKeyValue
                    Properties           = @(@{
                        ParameterName      = '_IsInConfiguration_'
                        ValueInSource      = 'Absent'
                        ValueInDestination = 'Present'
                    })
                }
            }
        }
    }

    if ($Type -eq 'HTML')
    {
        $reportSB = [System.Text.StringBuilder]::new()
        $ReportTitle = 'Microsoft365DSC - Delta Report'
        $headerTitle = 'Delta Report'
        if ($IsBlueprintAssessment)
        {
            $ReportTitle = 'Microsoft365DSC - Blueprint Assessment Report'
            $headerTitle = 'Blueprint Assessment Report'
        }
        [void]$reportSB.AppendLine("<html><head><meta charset='utf-8'><title>$ReportTitle</title>")
        [void]$reportSB.AppendLine($Script:ReportCSS)
        [void]$reportSB.AppendLine("</head><body><div class='report-container'>")

        #region Custom Header
        if (-not [System.String]::IsNullOrEmpty($HeaderFilePath))
        {
            try
            {
                $headerContent = Get-Content $HeaderFilePath
                [void]$reportSB.AppendLine($headerContent)
            }
            catch
            {
                New-M365DSCLogEntry -Message 'Error while reading DSC configuration:' `
                    -Exception $_ `
                    -Source $($MyInvocation.MyCommand.Source) `
                    -TenantId $TenantId `
                    -Credential $Credential
            }
        }
        #endregion

        [void]$reportSB.AppendLine("<h1>$headerTitle</h1>")
        [void]$reportSB.AppendLine("<div class='logo-container'>")
        [void]$reportSB.AppendLine("<img src='" + (Get-IconPath -ResourceName 'Promo') + "' alt='Microsoft365DSC Slogan' width='500'  />")
        [void]$ReportSB.AppendLine('</div>')
        if (-not $IsBlueprintAssessment)
        {
            [void]$reportSB.AppendLine("<div class='comparison-text'>")
            [void]$reportSB.AppendLine('<p><strong>Comparison between the following configurations:</strong></p>')
            [void]$reportSB.AppendLine('<ul>')
            [void]$reportSB.AppendLine("<li><strong>Source: </strong>$Source</li>")
            [void]$reportSB.AppendLine("<li><strong>Destination: </strong>$Destination</li>")
            [void]$reportSB.AppendLine('</ul>')
            [void]$reportSB.AppendLine("<p>Report generated on: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>")
            [void]$reportSB.AppendLine('</div>')
        }

        [array]$resourcesMissingInSource = $Delta | Where-Object -FilterScript { $_.Properties.ParameterName -eq '_IsInConfiguration_' -and `
                $_.Properties.ValueInSource -eq 'Absent' }
        [array]$resourcesMissingInDestination = $Delta | Where-Object -FilterScript { $_.Properties.ParameterName -eq '_IsInConfiguration_' -and `
                $_.Properties.ValueInDestination -eq 'Absent' }
        [array]$resourcesInDrift = $Delta | Where-Object -FilterScript { $_.Properties.ParameterName -ne '_IsInConfiguration_' }

        if ($resourcesMissingInSource.Count -eq 0 -and $resourcesMissingInDestination.Count -eq 0 -and `
                $resourcesInDrift.Count -eq 0)
        {
            [void]$reportSB.AppendLine('<p class="no-discrepancies"><strong>No discrepancies have been found!</strong></p>')
        }
        elseif (-not $DriftOnly)
        {
            [void]$reportSB.AppendLine('<div class="toc">')
            [void]$reportSB.AppendLine('<h2>Table of Contents</h2>')
            [void]$reportSB.AppendLine('<ul>')
            if ($resourcesMissingInSource.Count -gt 0)
            {
                [void]$reportSB.AppendLine("<li><a href='#Source'>Resources Missing in the Source</a>")
                [void]$reportSB.AppendLine(" <strong>(</strong>$($resourcesMissingInSource.Count)<strong>)</strong></li>")
            }
            if ($resourcesMissingInDestination.Count -gt 0)
            {
                [void]$reportSB.AppendLine("<li><a href='#Destination'>Resources Missing in the Destination</a>")
                [void]$reportSB.AppendLine(" <strong>(</strong>$($resourcesMissingInDestination.Count)<strong>)</strong></li>")
            }
            if ($resourcesInDrift.Count -gt 0)
            {
                $groupedResourcesCount = $resourcesInDrift | Group-Object -Property KeyValue -NoElement | Measure-Object | Select-Object -ExpandProperty Count
                [void]$reportSB.AppendLine("<li><a href='#Drift'>Resources Configured Differently</a>")
                [void]$reportSB.AppendLine(" <strong>(</strong>$($groupedResourcesCount)<strong>)</strong></li>")
            }
            [void]$reportSB.AppendLine('</ul></div>')
        }

        if ($resourcesMissingInSource.Count -gt 0 -and -not $DriftOnly)
        {
            [void]$reportSB.AppendLine('<br /><hr /><br />')
            [void]$reportSB.AppendLine("<a id='Source'></a><h2>Resources missing in the source</h2>")

            $workloadSection = New-M365DSCWorkloadSection -Resources $resourcesMissingInSource -ResourceRenderer {
                param($resource)
                $sb = [System.Text.StringBuilder]::new()
                [void]$sb.AppendLine("<table class='resource-table'>")
                [void]$sb.AppendLine('<tr>')
                [void]$sb.AppendLine("<td class='resource-header'>")
                [void]$sb.AppendLine("<h3>$($resource.ResourceName) - $($resource.Key) = $($resource.KeyValue)</h3>")
                [void]$sb.AppendLine('</td>')
                [void]$sb.AppendLine('</tr>')
                [void]$sb.AppendLine('</table>')
                return $sb.ToString()
            }
            [void]$reportSB.Append($workloadSection)
        }

        if ($resourcesMissingInDestination.Count -gt 0 -and -not $DriftOnly)
        {
            [void]$reportSB.AppendLine('<br /><hr /><br />')
            [void]$reportSB.AppendLine("<a id='Destination'></a><h2>Resources missing in the destination</h2>")

            $workloadSection = New-M365DSCWorkloadSection -Resources $resourcesMissingInDestination -ResourceRenderer {
                param($resource)
                $sb = [System.Text.StringBuilder]::new()
                [void]$sb.AppendLine("<table class='resource-table'>")
                [void]$sb.AppendLine('<tr>')
                [void]$sb.AppendLine("<td class='resource-header'>")
                [void]$sb.AppendLine("<h3>$($resource.ResourceName) - $($resource.Key) = $($resource.KeyValue)</h3>")
                [void]$sb.AppendLine('</td>')
                [void]$sb.AppendLine('</tr>')
                [void]$sb.AppendLine('</table>')
                return $sb.ToString()
            }
            [void]$reportSB.Append($workloadSection)
        }

        if ($resourcesInDrift.Count -gt 0)
        {
            # Combine resources instances together to make sure multiple drifts within the same resource don't appear as separate entries
            $combinedResourcesInDrift = [System.Collections.Generic.List[System.Object]]::new()
            foreach ($resource in $resourcesInDrift)
            {
                $existingInstance = $combinedResourcesInDrift | `
                    Where-Object -FilterScript {
                        $_.ResourceName -eq $resource.ResourceName -and `
                        $_.ResourceInstanceName -eq $resource.ResourceInstanceName
                    }
                if ($null -ne $existingInstance)
                {
                    # Loop through all entries in the combinedResourcesInDrift and remove the entry for the current resource.
                    $foundAt = -1
                    for ($i = 0; $i -lt $combinedResourcesInDrift.Count; $i++)
                    {
                        if ($combinedResourcesInDrift[$i].ResourceName -eq $resource.ResourceName -and `
                                $combinedResourcesInDrift[$i].ResourceInstanceName -eq $resource.ResourceInstanceName)
                        {
                            $foundAt = $i
                            break
                        }
                    }
                    $combinedResourcesInDrift = [System.Collections.Generic.List[System.Object]]$combinedResourcesInDrift
                    $combinedResourcesInDrift.RemoveAt($foundAt)

                    $existingInstance.Properties += $resource.Properties
                    $combinedResourcesInDrift += $existingInstance
                }
                else
                {
                    $combinedResourcesInDrift += $resource
                }
            }
            $resourcesInDrift = $combinedResourcesInDrift

            [void]$reportSB.AppendLine('<br /><hr /><br />')
            [void]$reportSB.AppendLine("<a id='Drift'></a><h2>Resources with differences</h2>")

            $SourceLabel = 'Source Value'
            $DestinationLabel = 'Destination Value'
            if ($IsBlueprintAssessment)
            {
                $SourceLabel = "Tenant's Current Value"
                $DestinationLabel = "Blueprint's Value"
            }

            $workloadSection = New-M365DSCWorkloadSection -Resources $resourcesInDrift -ResourceRenderer {
                param($resource)
                $sb = [System.Text.StringBuilder]::new()
                [void]$sb.AppendLine("<table class='drift-table'>")
                [void]$sb.AppendLine('<tr>')
                [void]$sb.AppendLine("<td class='drift-header' colspan='3'>")
                [void]$sb.AppendLine("<h3>$($resource.ResourceName) - $($resource.ResourceInstanceName)</h3>")
                [void]$sb.AppendLine('</td></tr>')
                [void]$sb.AppendLine('<tr>')
                [void]$sb.AppendLine("<td class='drift-subheader'><strong>Property</strong></td>")
                [void]$sb.AppendLine("<td class='drift-subheader'><strong>$SourceLabel</strong></td>")
                [void]$sb.AppendLine("<td class='drift-subheader'><strong>$DestinationLabel</strong></td>")
                [void]$sb.AppendLine('</tr>')

                foreach ($drift in $resource.Properties)
                {
                    if ($drift.ParameterName -notlike '_metadata_*')
                    {
                        $cellStyle = ''
                        $emoticon = ''
                        if ($drift._Metadata_Level -eq 'L1')
                        {
                            $cellStyle = 'level-L1'
                            $emoticon = '&#x1F7E5;'
                        }
                        elseif ($drift._Metadata_Level -eq 'L2')
                        {
                            $cellStyle = 'level-L2'
                            $emoticon = '&#x1F7E8;'
                        }
                        elseif ($drift._Metadata_Level -eq 'L3')
                        {
                            $cellStyle = 'level-L3'
                            $emoticon = '&#x1F7E6;'
                        }

                        [void]$sb.AppendLine('<tr>')
                        [void]$sb.AppendLine("<td class='property-name'>")
                        [void]$sb.AppendLine("$($drift.ParameterName)</td>")
                        [void]$sb.AppendLine("<td class='value-cell $cellStyle'>")
                        [void]$sb.AppendLine("$($drift.ValueInSource)</td>")
                        [void]$sb.AppendLine("<td class='value-cell'>")
                        [void]$sb.AppendLine("$($drift.ValueInDestination)</td>")
                        [void]$sb.AppendLine('</tr>')

                        if ($null -ne $drift._Metadata_Level)
                        {
                            [void]$sb.AppendLine("<tr><td colspan='3'><span class='emoticon'>$emoticon</span> $($drift._Metadata_Info)</td></tr>")
                        }
                    }
                }
                [void]$sb.AppendLine('</table><hr/>')
                return $sb.ToString()
            }
            [void]$reportSB.Append($workloadSection)
        }
        [void]$reportSB.AppendLine('</div></body></html>')
        if (-not [System.String]::IsNullOrEmpty($OutputPath))
        {
            $reportSB.ToString() | Out-File $OutputPath
        }
        else
        {
            return $reportSB.ToString()
        }
    }
    elseif ($Type -eq 'JSON')
    {
        if (-not [System.String]::IsNullOrEmpty($OutputPath))
        {
            ConvertTo-Json $Delta -Depth 25 | Out-File $OutputPath
        }
        else
        {
            return (ConvertTo-Json $Delta -Depth 25)
        }
    }
}

<#
.DESCRIPTION
    This function prepares the configuration for further parsing of the data

.FUNCTIONALITY
    Internal, Hidden
#>
function Initialize-M365DSCReporting
{
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ConfigurationPath,

        [Parameter()]
        [Switch]
        $IncludeComments,

        [Parameter()]
        [System.Object[]]
        $DscResourceInfo
    )

    if ((Test-Path -Path $ConfigurationPath) -eq $false)
    {
        Write-Error "Cannot find file specified in parameter Source: $ConfigurationPath. Please make sure the file exists!"
        return
    }

    Write-Verbose -Message "Loading file '$ConfigurationPath'"

    $fileContent = [System.IO.File]::ReadAllText($ConfigurationPath)
    try
    {
        $startPosition = $fileContent.IndexOf(' -ModuleVersion')
        if ($startPosition -gt 0)
        {
            $endPosition = $fileContent.IndexOf("`n", $startPosition)
            $fileContent = $fileContent.Remove($startPosition, $endPosition - $startPosition)
        }
    }
    catch
    {
        Write-Warning -Message "Error trying to remove Module Version: $($_.Exception | Out-String)"
    }

    $params = @{
        Content = $fileContent
    }

    if ($IncludeComments)
    {
        $params.Add('IncludeComments', $true)
    }

    if ($PSBoundParameters.ContainsKey('DscResourceInfo'))
    {
        $params.Add('DscResourceInfo', $DscResourceInfo)
    }
    $parsedContent = ConvertTo-DSCObject @params

    if ($null -eq $parsedContent)
    {
        Write-Warning -Message "No configuration found in $ConfigurationPath. Either the configuration was empty or the file was not a valid DSC configuration."
    }

    return $parsedContent
}

<#
.DESCRIPTION
    This function recursively converts a PowerShell object into an HTML list,
    flattening nested properties.

.FUNCTIONALITY
    Internal, Hidden
#>
function Convert-ObjectToHtmlList
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $InputObject,

        [Parameter()]
        [System.String]
        $ParentName = '',

        [Parameter()]
        [switch]
        $NoIndent
    )

    $output = ''
    if ($InputObject -is [array])
    {
        if (-not $NoIndent)
        {
            $output += '<ul>'
        }
        for ($i = 0; $i -lt $InputObject.Count; $i++)
        {
            $item = $InputObject[$i]
            $itemName = "$ParentName[$i]"
            if ($item -is [hashtable])
            {
                $output += Convert-ObjectToHtmlList -InputObject $item -ParentName $itemName -NoIndent
                $output += '<hr/>'
            }
            else
            {
                $output += "<li><strong>$($itemName):</strong> $($item | Out-String)</li>"
            }
        }
        $output = $output.TrimEnd('<hr/>')
        if (-not $NoIndent)
        {
            $output += '</ul>'
        }
    }
    elseif ($InputObject -is [hashtable])
    {
        if (-not $NoIndent)
        {
            $output += '<ul>'
        }
        foreach ($key in ($InputObject.Keys | Sort-Object))
        {
            if ($key -ne 'CIMInstance')
            {
                $value = $InputObject.$key
                $childName = if ([System.String]::IsNullOrEmpty($ParentName))
                {
                    $key
                }
                else
                {
                    "$ParentName.$key"
                }
                if ($value -is [hashtable] -or $value -is [array])
                {
                    $output += Convert-ObjectToHtmlList -InputObject $value -ParentName $childName -NoIndent
                }
                else
                {
                    $output += "<li><strong>$($childName):</strong> $($value | Out-String)</li>"
                }
            }
        }
        if (-not $NoIndent)
        {
            $output += '</ul>'
        }
    }
    else
    {
        $output = "$(if ($NoIndent) { '' } else { '<ul>' })<li>$($InputObject | Out-String)</li>$(if ($NoIndent) { '' } else { '</ul>' })"
    }
    return $output
}

Export-ModuleMember -Function @(
    'New-M365DSCDeltaReport',
    'New-M365DSCReportFromConfiguration',
    'Get-M365DSCCIMInstanceKey'
)
