$Script:ReportCSS = @"
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
"@

<#
.Description
This function generates HTML workload sections by grouping resources

.Functionality
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
.Description
This function creates a new Markdown document from the specified exported configuration

.Functionality
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
      $fullMD = "# " + $TemplateName + $crlf

      $totalCount = $parsedContent.Count
      $currentCount = 0
      foreach ($resource in $parsedContent)
      {
          # Create a new table for each resource
          $percentage = [math]::Round(($currentCount / $totalCount) * 100, 2)
          Write-Progress -Activity 'Processing generated DSC Object' -Status ("{0:N2}% completed - $($resource.ResourceName)" -f $percentage) -PercentComplete $percentage

          $fullMD += "## " + $resource.ResourceInstanceName + $crlf
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
                  $partMD += "|**" + $property + "**|"
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
                                  $value +=  '<br>'
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
                              $value = ($resource.$property).ToString() + "|"
                          }
                      }
                  }
                  $partMD += $value + $crlf
              }
          }

          $fullMD += $partMD + $crlf
          $partMD = ""

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
.Description
This function creates a new HTML document from the specified exported configuration

.Functionality
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
    $fullHTML += "<div class='logo-container'><img src='" + (Get-IconPath -ResourceName "Promo") + "' alt='Microsoft365DSC Slogan' width='500' /></div>"
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
            $resource.Remove("ResourceInstanceName") | Out-Null
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
.Description
This function creates a new JSON file from the specified exported configuration

.Functionality
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
.Description
This function gets the workload name from a resource name

.Functionality
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

    if ($ResourceName.StartsWith('AAD'))
    {
        return 'Azure Active Directory'
    }
    elseif ($ResourceName.StartsWith('ADO'))
    {
        return 'Azure DevOps'
    }
    elseif ($ResourceName.StartsWith('Azure'))
    {
        return 'Azure'
    }
    elseif ($ResourceName.StartsWith('Defender'))
    {
        return 'Microsoft Defender'
    }
    elseif ($ResourceName.StartsWith('EXO'))
    {
        return 'Exchange Online'
    }
    elseif ($ResourceName.StartsWith('Intune'))
    {
        return 'Intune'
    }
    elseif ($ResourceName.StartsWith('O365'))
    {
        return 'Office 365'
    }
    elseif ($ResourceName.StartsWith('OD'))
    {
        return 'OneDrive'
    }
    elseif ($ResourceName.StartsWith('Planner'))
    {
        return 'Planner'
    }
    elseif ($ResourceName.StartsWith('PP'))
    {
        return 'Power Platform'
    }
    elseif ($ResourceName.StartsWith('SC'))
    {
        return 'Security & Compliance'
    }
    elseif ($ResourceName.StartsWith('Sentinel'))
    {
        return 'Sentinel'
    }
    elseif ($ResourceName.StartsWith('SH'))
    {
        return 'Services Hub'
    }
    elseif ($ResourceName.StartsWith('SPO'))
    {
        return 'SharePoint Online'
    }
    elseif ($ResourceName.StartsWith('Teams'))
    {
        return 'Microsoft Teams'
    }
    else
    {
        return 'Other'
    }
}

<#
.Description
This function gets the URL to the logo of the workload of the specified resource

.Functionality
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
        return Get-Base64EncodedImage -IconName "Promo.png"
    }
    elseif ($ResourceName.StartsWith('AAD'))
    {
        return Get-Base64EncodedImage -IconName "AzureAD.jpg"
    }
    elseif ($ResourceName.StartsWith('ADO'))
    {
        return Get-Base64EncodedImage -IconName "AzureDevOps.png"
    }
    elseif ($ResourceName.StartsWith('Azure'))
    {
        return Get-Base64EncodedImage -IconName "Azure.png"
    }
    elseif ($ResourceName.StartsWith('Defender'))
    {
        return Get-Base64EncodedImage -IconName "SecurityAndCompliance.png"
    }
    elseif ($ResourceName.StartsWith('EXO'))
    {
        return Get-Base64EncodedImage -IconName "Exchange.jpg"
    }
    elseif ($ResourceName.StartsWith('Intune'))
    {
        return Get-Base64EncodedImage -IconName "Intune.jpg"
    }
    elseif ($ResourceName.StartsWith('O365'))
    {
        return Get-Base64EncodedImage -IconName "Office365.jpg"
    }
    elseif ($ResourceName.StartsWith('OD'))
    {
        return Get-Base64EncodedImage -IconName "OneDrive.jpg"
    }
    elseif ($ResourceName.StartsWith('Planner'))
    {
        return Get-Base64EncodedImage -IconName "Planner.png"
    }
    elseif ($ResourceName.StartsWith('PP'))
    {
        return Get-Base64EncodedImage -IconName "PowerApps.jpg"
    }
    elseif ($ResourceName.StartsWith('SC'))
    {
        return Get-Base64EncodedImage -IconName "SecurityAndCompliance.png"
    }
    elseif ($ResourceName.StartsWith('Sentinel'))
    {
        # TODO: Add Sentinel icon
        # return Get-Base64EncodedImage -IconName "SecurityAndCompliance.png"
    }
    elseif ($ResourceName.StartsWith('SH'))
    {
        # TODO: Add Services Hub icon
        #return Get-Base64EncodedImage -IconName "SecurityAndCompliance.png"
    }
    elseif ($ResourceName.StartsWith('SPO'))
    {
        return Get-Base64EncodedImage -IconName "SharePoint.jpg"
    }
    elseif ($ResourceName.StartsWith('Teams'))
    {
        return Get-Base64EncodedImage -IconName "Teams.jpg"
    }
    return $null
}

<#
.Description
This function returns a string containing mime-type and base64 encoded image to embed into DSC report directly.

.Functionality
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

    if(Test-Path -Path $IconPath)
    {
        $icon = Get-Item -Path $IconPath

        if($icon.Extension.EndsWith("jpg") -or $icon.Extension.EndsWith("jpeg"))
        {
            $mimeType = "image/jpeg"
        }

        if($icon.Extension.EndsWith("png"))
        {
            $mimeType = "image/png"
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
.Description
This function creates a new Excel document from the specified exported configuration

.Functionality
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
.Description
This function creates a new CSV file from the specified exported configuration

.Functionality
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

    $modelRow = @{'Component Name'=$null; Property=$null; Value = $null}
    $row = 0
    $csvOutput = @()

    foreach ($resource in $parsedContent)
    {
        $newRow = $modelRow.Clone()
        if ($row -gt 0)
        {
            Write-Verbose -Message "add separator-line in CSV-file between resources"
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
                $newRow.Property        = $property
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
                    $OriginPropertyName  = $csvOutput[$beginRow].Property
                    $OriginPropertyValue  = $csvOutput[$beginRow].Value
                    $CurrentPropertyName  = $newRow.Property
                    $CurrentPropertyValue = $newRow.Value

                    $csvOutput[$beginRow].Property = $CurrentPropertyName
                    $csvOutput[$beginRow].Value    = $CurrentPropertyValue
                    $newRow.Property = $OriginPropertyName
                    $newRow.Value    = $OriginPropertyValue
                }
                $csvOutput += [pscustomobject]$newRow
                $row++
            }
        }
    }
    $csvOutput | Export-Csv -Path $OutputPath -Encoding UTF8 -Delimiter $Delimiter -NoTypeInformation
}

<#
.Description
This function creates a report from the specified exported configuration,
either in HTML or Excel format

.Parameter Type
The type of report that should be created: Excel or HTML.

.Parameter ConfigurationPath
The path to the exported DSC configuration that the report should be created for.

.Parameter OutputPath
The output path of the report.

.Example
New-M365DSCReportFromConfiguration -Type 'HTML' -ConfigurationPath 'C:\DSC\ConfigName.ps1' -OutputPath 'C:\Dsc\M365Report.html'

.Example
New-M365DSCReportFromConfiguration -Type 'Excel' -ConfigurationPath 'C:\DSC\ConfigName.ps1' -OutputPath 'C:\Dsc\M365Report.xlsx'

.Example
New-M365DSCReportFromConfiguration -Type 'JSON' -ConfigurationPath 'C:\DSC\ConfigName.ps1' -OutputPath 'C:\Dsc\M365Report.json'

.Functionality
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
    DynamicParam # parameter 'Delimiter' is only available when Type = 'CSV'
    {
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        if ($Type -eq 'CSV')
        {
            $delimiterAttr = [System.Management.Automation.ParameterAttribute]::New()
            $delimiterAttr.Mandatory = $false
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::New()
            $attributeCollection.Add($delimiterAttr)
            $delimiterParam = [System.Management.Automation.RuntimeDefinedParameter]::New("Delimiter", [System.String], $attributeCollection)
            $delimiterParam.Value = ';' # default value, comma makes a mess when importing a CSV-file in Excel
            $paramDictionary.Add("Delimiter", $delimiterParam)
            $PSBoundParameters.Add("Delimiter", $delimiterParam.Value)
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
                    New-M365DSCConfigurationToMarkdown -ParsedContent $parsedContent -OutputPath $OutputPath -TemplateName  $templateName
                }
                'CSV'
                {
                    New-M365DSCConfigurationToCSV -ParsedContent $parsedContent -OutputPath $OutputPath -Delimiter $Delimiter
                }
            }
        }
        else
        {
            Write-Warning -Message "Parsed content was null. No report was generated."
        }
    }
}

<#
.Description
This function compares two provided DSC configuration to determine the delta.

.Parameter Source
Local path of the source configuration.

.Parameter Destination
Local path of the destination configuraton.

.Parameter SourceObject
Array that contains the list of configuration components for the source.

.Parameter DestinationObject
Array that contains the list of configuration components for the destination.

.Parameter ExcludedProperties
Array that contains the list of parameters to exclude.

.Parameter ExcludedResources
Array that contains the list of resources to exclude.

.Parameter IsBlueprintAssessment
Specifies whether or not we are currently comparing a configuration to a Blueprint.

.Example
Compare-M365DSCConfigurations -Source 'C:\DSC\source.ps1' -Destination 'C:\DSC\destination.ps1'

.Functionality
Public
#>
# TODO: Remove in a future release
function Compare-M365DSCConfigurations
{
    [CmdletBinding()]
    [OutputType([System.Array])]
    param
    (
        [Parameter()]
        [System.String]
        $Source,

        [Parameter()]
        [System.String]
        $Destination,

        [Parameter()]
        [System.Boolean]
        $CaptureTelemetry = $true,

        [Parameter()]
        [Array]
        $SourceObject,

        [Parameter()]
        [Array]
        $DestinationObject,

        [Parameter()]
        [Array]
        $ExcludedProperties,

        [Parameter()]
        [Array]
        $ExcludedResources,

        [Parameter()]
        [System.Boolean]
        $IsBlueprintAssessment = $false
    )

    if ($CaptureTelemetry)
    {
        #Ensure the proper dependencies are installed in the current environment.
        Confirm-M365DSCDependencies

        #region Telemetry
        $data = [System.Collections.Generic.Dictionary[[String], [String]]]::new()
        $data.Add('Event', 'Compare')
        Add-M365DSCTelemetryEvent -Data $data -Type 'CompareConfigurations'
        #endregion
    }

    [Array] $Delta = @()

    if (-not $SourceObject)
    {
        [Array] $SourceObject = Initialize-M365DSCReporting -ConfigurationPath $Source
    }
    if (-not $DestinationObject)
    {
        [Array] $DestinationObject = Initialize-M365DSCReporting -ConfigurationPath $Destination
    }

    if ($ExcludedResources.Count -gt 0)
    {
        [Array]$SourceObject = $SourceObject | Where-Object -FilterScript { $_.ResourceName -notin $ExcludedResources }
        [Array]$DestinationObject = $DestinationObject | Where-Object -FilterScript { $_.ResourceName -notin $ExcludedResources }
    }

    $isPowerShellCore = $PSVersionTable.PSEdition -eq 'Core'
    if ($isPowerShellCore)
    {
        $dscResourceInfo = Get-PwshDSCResource -Module 'Microsoft365DSC'
    }
    else
    {
        $dscResourceInfo = Get-DSCResource -Module 'Microsoft365DSC'
    }
    # Loop through all items in the source array
    $i = 1
    foreach ($sourceResource in $SourceObject)
    {
        try
        {
            [array]$key = Get-M365DSCResourceKey -Resource $sourceResource -DSCResourceInfo $dscResourceInfo
            Write-Progress -Activity "Scanning Source $Source...[$i/$($SourceObject.Count)]" -PercentComplete ($i / ($SourceObject.Count) * 100)
            [array]$destinationResource = $DestinationObject | Where-Object -FilterScript { $_.ResourceName -eq $sourceResource.ResourceName -and $_.($key[0]) -eq $sourceResource.($key[0]) }

            $keyname = $key[0..1] -join '\'
            $SourceKeyValue = $sourceResource.($key[0])
            # Filter on the second key
            if ($key.Count -gt 1)
            {
                [array]$destinationResource = $destinationResource | Where-Object -FilterScript { $_.ResourceName -eq $sourceResource.ResourceName -and $_.($key[1]) -eq $sourceResource.($key[1]) }
                $SourceKeyValue = $sourceResource.($key[0]), $sourceResource.($key[1]) -join '\'
            }
            if ($null -eq $destinationResource)
            {
                $drift = @{
                    ResourceName         = $sourceResource.ResourceName
                    ResourceInstanceName = $sourceResource.ResourceInstanceName
                    Key                  = $keyName
                    KeyValue             = $SourceKeyValue
                    Properties           = @(@{
                            ParameterName      = '_IsInConfiguration_'
                            ValueInSource      = 'Present'
                            ValueInDestination = 'Absent'
                        })
                }
                $Delta += , $drift
                $drift = $null
            }
            else
            {
                $filteredProperties = @(
                    'ResourceName',
                    'ResourceId',
                    'Credential',
                    'CertificatePath',
                    'CertificatePassword',
                    'TenantId',
                    'ApplicationId',
                    'CertificateThumbprint',
                    'ApplicationSecret',
                    'ManagedIdentity'
                )

                $filteredProperties = ($filteredProperties + $ExcludedProperties) | Select-Object -Unique

                [System.Collections.Hashtable]$destinationResource = $destinationResource[0]
                # The resource instance exists in both the source and the destination. Compare each property;
                foreach ($propertyName in $sourceResource.Keys)
                {
                    if ($propertyName -notin $filteredProperties)
                    {
                        $destinationPropertyName = $propertyName

                        # Case where the property contains CIMInstances
                        if ($null -ne $sourceResource.$propertyName.Keys -and $sourceResource.$propertyName.Keys.Contains('CIMInstance'))
                        {
                            foreach ($instance in $sourceResource.$propertyName)
                            {
                                [string]$key = Get-M365DSCCimInstanceKey -CIMInstance $instance

                                $destinationResourceInstances = $destinationResource.$destinationPropertyName | Where-Object -FilterScript {$_."$key" -eq $instance."$key"}

                                if ($null -ne $destinationResourceInstances)
                                {
                                    # There is a chance we found multiple instances of a CIMInstance based on its key property.
                                    # If that's the case, loop through each instance found and if at least one of them is
                                    # a perfect match, then don't consider this a drift.
                                    $foundOneMatch = $false
                                    $foundMatchResource = $null
                                    $drift = $null
                                    foreach ($destinationResourceInstance in $destinationResourceInstances)
                                    {
                                        $foundResourceMatch = $true
                                        [array]$driftProperties = @()
                                        foreach ($property in $instance.Keys)
                                        {
                                            if ($null -eq $destinationResourceInstance."$property" -or `
                                                (-not [System.String]::IsNullOrEmpty($instance."$property") -and
                                                $null -ne (Compare-Object -ReferenceObject ($instance."$property")`
                                                -DifferenceObject ($destinationResourceInstance."$property"))))
                                            {
                                                $driftProperties += @{
                                                    ParameterName      = $property
                                                    CIMInstanceKey     = $key
                                                    CIMInstanceValue   = $instance."$Key"
                                                    ValueInSource      = $instance."$property"
                                                    ValueInDestination = $destinationResourceInstance."$property"
                                                }
                                                $foundResourceMatch = $false
                                            }
                                        }
                                        if ($foundResourceMatch)
                                        {
                                            $foundOneMatch = $true
                                            $foundMatchResource = $destinationResourceInstance
                                        }
                                        else
                                        {
                                            $drift = @{
                                                ResourceName         = $sourceResource.ResourceName
                                                ResourceInstanceName = $destinationResource.ResourceInstanceName
                                                Key                  = $propertyName
                                                KeyValue             = $instance."$key"
                                                Properties           = $driftProperties
                                            }
                                        }
                                    }
                                    if ($foundOneMatch)
                                    {
                                        # If a match was found, clear the drift.
                                        $drift = $null
                                        $destinationResource.$destinationPropertyName = $destinationResource.$destinationPropertyName | Where-Object { $_ -ne $foundMatchResource }
                                    }
                                    else
                                    {
                                        $Delta += , $drift
                                        $drift = $null
                                    }
                                }
                                else
                                {
                                    # We have detected a drift where the CIM Instance exists in the Source but NOT in the Destination
                                    $drift = @{
                                        ResourceName         = $sourceResource.ResourceName
                                        ResourceInstanceName = $destinationResource.ResourceInstanceName
                                        Key                  = $propertyName
                                        KeyValue             = $instance."$key"
                                        Properties           = @(@{
                                            ParameterName      = $propertyName
                                            CIMInstanceKey     = $key
                                            CIMInstanceValue   = $instance."$Key"
                                            ValueInSource      = $instance
                                            ValueInDestination = $null
                                        })
                                    }
                                    if ($null -ne $drift)
                                    {
                                        $Delta += , $drift
                                        $drift = $null
                                    }
                                }
                            }
                        }
                        # Needs to be a separate nested if statement otherwise the ReferenceObject can be null and it will error out;
                        elseif ($destinationResource.ContainsKey($destinationPropertyName) -eq $false -or (-not [System.String]::IsNullOrEmpty($propertyName) -and
                                ($null -ne $sourceResource.$propertyName -and
                                    $null -ne (Compare-Object -ReferenceObject ($sourceResource.$propertyName)`
                                        -DifferenceObject ($destinationResource.$destinationPropertyName)))) -and
                            -not ([System.String]::IsNullOrEmpty($destinationResource.$destinationPropertyName) -and [System.String]::IsNullOrEmpty($sourceResource.$propertyName)))
                        {
                            if ($null -eq $drift -and (-not $IsBlueprintAssessment -or $destinationResource.ContainsKey($destinationPropertyName)))
                            {
                                $drift = @{
                                    ResourceName         = $sourceResource.ResourceName
                                    ResourceInstanceName = $destinationResource.ResourceInstanceName
                                    Key                  = $keyname
                                    KeyValue             = $SourceKeyValue
                                    Properties           = @(@{
                                        ParameterName      = $propertyName
                                        ValueInSource      = $sourceResource.$propertyName
                                        ValueInDestination = $destinationResource.$destinationPropertyName
                                    })
                                }

                                if ($destinationResource.Contains("_metadata_$($destinationPropertyName)"))
                                {
                                    $Metadata = $destinationResource."_metadata_$($destinationPropertyName)"
                                    $Level = $Metadata.Split('|')[0].Replace('### ', '')
                                    $Information = $Metadata.Split('|')[1]
                                    $drift.Properties[0].Add('_Metadata_Level', $Level)
                                    $drift.Properties[0].Add('_Metadata_Info', $Information)
                                }
                                if ($null -ne $drift)
                                {
                                    $Delta += , $drift
                                    $drift = $null
                                }
                            }
                            elseif (-not $IsBluePrintAssessment -or $destinationResource.ContainsKey($destinationPropertyName))
                            {
                                $newDrift = @{
                                    ParameterName      = $propertyName
                                    ValueInSource      = $sourceResource.$propertyName
                                    ValueInDestination = $destinationResource.$destinationPropertyName
                                }
                                if ($destinationResource.Contains("_metadata_$($destinationPropertyName)"))
                                {
                                    $Metadata = $destinationResource."_metadata_$($destinationPropertyName)"
                                    $Level = $Metadata.Split('|')[0].Replace('### ', '')
                                    $Information = $Metadata.Split('|')[1]
                                    $newDrift.Add('_Metadata_Level', $Level)
                                    $newDrift.Add('_Metadata_Info', $Information)
                                }
                                $drift.Properties += $newDrift
                            }
                        }
                    }
                }

                # Do the scan the other way around because there's a chance that the property, if null, wasn't part of the source object.
                # By scanning against the destination we will catch properties that are not null on the source but not null in destination;
                foreach ($propertyName in $destinationResource.Keys)
                {
                    if ($propertyName -notin $filteredProperties)
                    {
                        $sourcePropertyName = $propertyName

                        # Case where the property contains CIMInstances
                        if ($null -ne $destinationResource.$propertyName.Keys -and $destinationResource.$propertyName.Keys.Contains('CIMInstance'))
                        {
                            foreach ($instance in $destinationResource.$propertyName)
                            {
                                [string]$key = Get-M365DSCCimInstanceKey -CIMInstance $instance

                                $sourceResourceInstances = $sourceResource.$sourcePropertyName | Where-Object -FilterScript {$_."$key" -eq $instance."$key"}

                                if ($null -ne $sourceResourceInstances)
                                {
                                    # There is a chance we found 2 instances of a CIMInstance based on its key property.
                                    # If that's the case, loop through each instance found and if at least one of them is
                                    # a perfect match, then don't consider this a drift.
                                    $foundOneMatch = $false
                                    $drift = $null
                                    foreach ($sourceResourceInstance in $sourceResourceInstances)
                                    {
                                        $innerDrift = $null
                                        foreach ($property in $instance.Keys)
                                        {
                                            if ($null -eq $sourceResourceInstance."$property" -or `
                                                ($null -ne $instance."$property" -and `
                                                    $null -ne (Compare-Object -ReferenceObject ($instance."$property")`
                                                -DifferenceObject ($sourceResourceInstance."$property"))))
                                            {
                                                # Make sure we haven't already added this drift in the delta return object to prevent duplicates.
                                                $existing = $delta | Where-Object -FilterScript {
                                                    $_.ResourceName -eq $destinationResource.ResourceName -and
                                                    $_.ResourceInstanceName -eq $destinationResource.ResourceInstanceName
                                                }

                                                $sameEntry = $null
                                                if ($null -ne $existing)
                                                {
                                                    $sameEntry = $existing.Properties | Where-Object -FilterScript {$_.ParameterName -eq $property -and `
                                                                                                                    $_.CIMInstanceKey -eq $key -and `
                                                                                                                    $_.CIMInstanceValue -eq ($instance."$key") -and `
                                                                                                                    $_.ValueInSource -eq $sourceResourceInstance."$property" -and `
                                                                                                                    $_.ValueInDestination -eq $instance."$property"}
                                                }

                                                if ($null -eq $sameEntry)
                                                {
                                                    $innerDrift = @{
                                                        ResourceName         = $destinationResource.ResourceName
                                                        ResourceInstanceName = $destinationResource.ResourceInstanceName
                                                        Key                  = $propertyName
                                                        KeyValue             = $instance."$key"
                                                        Properties           = @(@{
                                                            ParameterName      = $property
                                                            CIMInstanceKey     = $key
                                                            CIMInstanceValue   = $instance."$Key"
                                                            ValueInSource      = $sourceResourceInstance."$property"
                                                            ValueInDestination = $instance."$property"
                                                        })
                                                    }
                                                }
                                            }
                                        }
                                        if ($null -eq $innerDrift)
                                        {
                                            $foundOneMatch = $true
                                        }
                                        else
                                        {
                                            $drift = $innerDrift
                                        }
                                    }
                                    if ($foundOneMatch)
                                    {
                                        # If a match was found, clear the drift.
                                        $drift = $null
                                    }
                                }
                                else
                                {
                                    # We have detected a drift where the CIM Instance exists in the Destination but NOT in the Source
                                    $drift = @{
                                        ResourceName         = $destinationResource.ResourceName
                                        ResourceInstanceName = $destinationResource.ResourceInstanceName
                                        Key                  = $propertyName
                                        KeyValue             = $instance."$key"
                                        Properties           = @(@{
                                            ParameterName      = $propertyName
                                            CIMInstanceKey     = $key
                                            CIMInstanceValue   = $instance."$Key"
                                            ValueInSource      = $null
                                            ValueInDestination = $instance
                                        })
                                    }
                                    if ($null -ne $drift)
                                    {
                                        $Delta += , $drift
                                        $drift = $null
                                    }
                                }
                            }
                        }
                        elseif (-not [System.String]::IsNullOrEmpty($propertyName) -and
                            -not $sourceResource.Contains($sourcePropertyName))
                        {
                            if ($null -eq $drift -and (-not $IsBlueprintAssessment -or -not $sourcePRopertyName.StartsWith('_metadata_')))
                            {
                                $drift = @{
                                    ResourceName = $sourceResource.ResourceName
                                    Key          = $keyName
                                    KeyValue     = $SourceKeyValue
                                    Properties   = @(@{
                                        ParameterName      = $sourcePropertyName
                                        ValueInSource      = $null
                                        ValueInDestination = $destinationResource.$propertyName
                                    })
                                }
                            }
                            elseif (-not $IsBlueprintAssessment -or -not $sourcePRopertyName.StartsWith('_metadata_'))
                            {
                                $drift.Properties += @{
                                    ParameterName      = $sourcePropertyName
                                    ValueInSource      = $null
                                    ValueInDestination = $destinationResource.$propertyName
                                }
                            }
                        }
                    }
                }

                if ($null -ne $drift)
                {
                    $Delta += , $drift
                    $drift = $null
                }
            }
        }
        catch
        {
            Write-Error -Message $_ -ErrorAction Continue
        }
        $i++
    }
    Write-Progress -Activity 'Scanning Source...' -Completed

    # Loop through all items in the destination array
    $i = 1
    try
    {
        foreach ($destinationResource in $DestinationObject)
        {
            try
            {
                [System.Collections.HashTable]$currentDestinationResource = ([array]$destinationResource)[0]
                $key = Get-M365DSCResourceKey -Resource $currentDestinationResource -DSCResourceInfo $dscResourceInfo
                Write-Progress -Activity "Scanning Destination $Destination...[$i/$($DestinationObject.Count)]" -PercentComplete ($i / ($DestinationObject.Count) * 100)
                $sourceResource = $SourceObject | Where-Object -FilterScript { $_.ResourceName -eq $currentDestinationResource.ResourceName -and `
                                                                               $_.($key[0]) -eq $currentDestinationResource.($key[0]) -and `
                                                                               $_.ResourceInstanceName -eq $currentDestinationResource.ResourceInstanceName}
                $currentDestinationKeyValue = $currentDestinationResource.($key[0])

                # Filter on the second key
                if ($key.Count -gt 1)
                {
                    [array]$sourceResource = $sourceResource | Where-Object -FilterScript { $_.ResourceName -eq $currentDestinationResource.ResourceName -and $_.($key[1]) -eq $currentDestinationResource.($key[1]) }
                    $currentDestinationKeyValue = $currentDestinationResource.($key[0]), $currentDestinationResource.($key[1]) -join '\'
                }
                if ($null -eq $sourceResource)
                {
                    $drift = @{
                        ResourceName         = $currentDestinationResource.ResourceName
                        ResourceInstanceName = $currentDestinationResource.ResourceInstanceName
                        Key                  = $key
                        KeyValue             = $currentDestinationResource."$key"
                        Properties           = @(@{
                            ParameterName      = '_IsInConfiguration_'
                            ValueInSource      = 'Absent'
                            ValueInDestination = 'Present'
                        })
                    }
                    $Delta += , $drift
                    $drift = $null
                }
            }
            catch
            {
                Write-Verbose -Message "Error: $_"
            }
            $i++
        }
    }
    catch
    {
        Write-Error -Message $_ -ErrorAction Continue
    }
    Write-Progress -Activity 'Scanning Destination...' -Completed

    return $Delta
}

<#
.Description
This function gets the key parameter for the specified CIMInstance

.Functionality
Public
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
    elseif ($CIMInstance.ContainsKey("odataType"))
    {
        $primaryKey = 'odataType'
    }
    elseif ($CIMInstance.ContainsKey("dataType"))
    {
        $primaryKey = 'dataType'
    }
    elseif ($CIMInstance.ContainsKey("Dmn"))
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
.Description
This function gets the key parameter for the specified resource

.Functionality
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
        [Array]
        $DSCResourceInfo
    )
    $resourceInfo = $DSCResourceInfo | Where-Object -FilterScript {$_.Name -eq $Resource.ResourceName}
    [Array]$mandatoryParameters = $resourceInfo.Properties | Where-Object -FilterScript { $_.IsMandatory }
    if ($Resource.Contains('IsSingleInstance') -and $mandatoryParameters.Name.Contains('IsSingleInstance'))
    {
        return @('IsSingleInstance')
    }
    elseif ($Resource.Contains('DisplayName') -and $mandatoryParameters.Name.Contains('DisplayName'))
    {
        if ($Resource.ResourceName -eq 'AADMSGroup' -and -not [System.String]::IsNullOrEmpty($Resource.Id))
        {
            return @('Id')
        }
        if ($Resource.ResourceName -eq 'AADGroup' -and -not [System.String]::IsNullOrEmpty($Resource.MailNickname))
        {
            return ('DisplayName', 'MailNickname')
        }
        if ($Resource.ResourceName -eq 'IntuneDeviceEnrollmentPlatformRestriction' -and $Resource.Keys.Where({ $_ -like "*Restriction"}))
        {
            return @('ResourceInstanceName')
        }
        if ($Resource.ResourceName -eq 'TeamsChannel' -and -not [System.String]::IsNullOrEmpty($Resource.TeamName))
        {
            # Teams Channel displaynames are not tenant-unique (e.g. "General" is almost in every team), but should be unique per team
            return @('TeamName', 'DisplayName')
        }
        if ($Resource.ResourceName -eq 'TeamsTeam' -and -not [System.String]::IsNullOrEmpty($Resource.MailNickName))
        {
            # Teams names are not unique
            return @('MailNickName', 'DisplayName')
        }
        return @('DisplayName')
    }
    elseif ($Resource.Contains('Identity') -and $mandatoryParameters.Name.Contains('Identity'))
    {
        return @('Identity')
    }
    elseif ($Resource.Contains('Name') -and $mandatoryParameters.Name.Contains('Name'))
    {
        return @('Name')
    }
    elseif ($Resource.Contains('Url') -and $mandatoryParameters.Name.Contains('Url'))
    {
        return @('Url')
    }
    elseif ($Resource.Contains('Organization') -and $mandatoryParameters.Name.Contains('Organization'))
    {
        return @('Organization')
    }
    elseif ($Resource.Contains('CDNType') -and $mandatoryParameters.Name.Contains('CDNType'))
    {
        return @('CDNType')
    }
    elseif ($Resource.Contains('Action') -and $Resource.ResourceName -eq 'SCComplianceSearchAction' -and $mandatoryParameters.Name.Contains('Action'))
    {
        return @('SearchName', 'Action')
    }
    elseif ($Resource.Contains('Workload') -and $Resource.ResourceName -eq 'SCAuditConfigurationPolicy' -and $mandatoryParameters.Name.Contains('Workload'))
    {
        return @('Workload')
    }
    elseif ($Resource.Contains('Title') -and $Resource.ResourceName -eq 'SPOSiteDesign' -and $mandatoryParameters.Name.Contains('Title'))
    {
        return @('Title')
    }
    elseif ($Resource.Contains('SiteDesignTitle') -and $mandatoryParameters.Name.Contains('SiteDesignTitle'))
    {
        return @('SiteDesignTitle')
    }
    elseif ($Resource.Contains('Key') -and $Resource.ResourceName -eq 'SPOStorageEntity' -and $mandatoryParameters.Name.Contains('Key'))
    {
        return @('Key')
    }
    elseif ($Resource.Contains('Usage') -and $mandatoryParameters.Name.Contains('Usage'))
    {
        return @('Usage')
    }
    elseif ($Resource.Contains('OrgWideAccount') -and $mandatoryParameters.Name.Contains('OrgWideAccount'))
    {
        return @('OrgWideAccount')
    }
    elseif ($mandatoryParameters.Count -gt 0)
    {
        # return all mandatory parameters
        return @($mandatoryParameters.Name)
    }
    elseif ($mandatoryParameters.Count -eq 0)
    {
        Write-Verbose -Message "No mandatory parameters found for $($Resource.ResourceName)"
    }
}

<#
.Description
This function creates a delta HTML report between two provided exported
DSC configurations

.Parameter Source
The source DSC configuration to compare from.

.Parameter Destination
The destination DSC configuration to compare with.

.Parameter OutputPath
The output path of the delta report.

.Parameter DriftOnly
Specifies that only difference should be in the report.

.Parameter IsBlueprintAssessment
Specifies that the report is a comparison with a Blueprint.

.Parameter HeaderFilePath
Specifies that file that contains a custom header for the report.

.Parameter Delta
An array with difference, already compiled from another source.

.Parameter ExcludedProperties
Array that contains the list of parameters to exclude.

.Parameter ExcludedResources
Array that contains the list of resources to exclude.

.Example
New-M365DSCDeltaReport -Source 'C:\DSC\Source.ps1' -Destination 'C:\DSC\Destination.ps1' -OutputPath 'C:\Dsc\DeltaReport.html'

.Example
New-M365DSCDeltaReport -Source 'C:\DSC\Source.ps1' -Destination 'C:\DSC\Destination.ps1' -OutputPath 'C:\Dsc\DeltaReport.html' -DriftOnly $true

.Functionality
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
    $authParameters = @("Credential", "ManagedIdentity", "ApplicationId", "TenantId", "CertificatePath", "CertificatePassword", "CertificateThumbprint", "ApplicationSecret")
    $ExcludedProperties += "ResourceInstanceName"
    $ExcludedProperties = $ExcludedProperties + $authParameters | Select-Object -Unique

    $isPowerShellCore = $PSVersionTable.PSEdition -eq 'Core'
    if ($isPowerShellCore)
    {
        $dscResourceInfo = Get-PwshDSCResource -Module 'Microsoft365DSC'
    }
    else
    {
        $dscResourceInfo = Get-DSCResource -Module 'Microsoft365DSC'
    }

    Write-Verbose -Message 'Obtaining Delta between the source and destination configurations'
    if (-not $Delta)
    {
        if ($IsBlueprintAssessment)
        {
            $desiredSplat = @{
                ConfigurationPath   = $Destination
                IncludeComments     = $true
            }
        }
        else
        {
            $desiredSplat = @{
                ConfigurationPath   = $Destination
                IncludeComments     = $false
            }
        }
        # Parse the blueprint file, pass to Compare-M365DSCConfigurations as object (including comments aka metadata)
        [Array] $desiredConfiguration = Initialize-M365DSCReporting @desiredSplat
        $sourceReporting = Initialize-M365DSCReporting -ConfigurationPath $Source
        $Delta = @()
        foreach ($resource in $sourceReporting)
        {
            [array]$key = Get-M365DSCResourceKey -Resource $resource -DSCResourceInfo $dscResourceInfo
            #Write-Progress -Activity "Scanning Source $Source...[$i/$($SourceObject.Count)]" -PercentComplete ($i / ($SourceObject.Count) * 100)
            [array]$destinationResource = $desiredConfiguration | Where-Object -FilterScript { $_.ResourceName -eq $resource.ResourceName -and $_.($key[0]) -eq $resource.($key[0]) }

            $keyName = $key[0..1] -join '\'
            $sourceKeyValue = $resource.($key[0])
            # Filter on the second key
            if ($key.Count -gt 1)
            {
                [array]$destinationResource = $destinationResource | Where-Object -FilterScript { $_.($key[1]) -eq $resource.($key[1]) }
                $sourceKeyValue = $resource.($key[0]), $resource.($key[1]) -join '\'
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
            $compareResult = Compare-M365DSCResourceState -ResourceName $resource.ResourceName -DesiredValues $destinationResource[0] -CurrentValues $resource -ExcludedProperties $ExcludedProperties
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
                }
                $Global:AllDrifts.DriftInfo = @()
            }
        }

        foreach ($resource in $desiredConfiguration)
        {
            [array]$key = Get-M365DSCResourceKey -Resource $resource -DSCResourceInfo $dscResourceInfo
            $keyName = $key[0..1] -join '\'
            $destinationKeyValue = $resource.($key[0])
            $sourceResource = $sourceReporting | Where-Object { $_.ResourceName -eq $resource.ResourceName -and $_.($key[0]) -eq $resource.($key[0]) }

            # Filter on the second key
            if ($key.Count -gt 1)
            {
                [array]$sourceResource = $sourceResource | Where-Object -FilterScript { $_.($key[1]) -eq $resource.($key[1]) }
                $destinationKeyValue = $resource.($key[0]), $resource.($key[1]) -join '\'
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

        [void]$reportSB.AppendLine("<h1>$headerTitle</h1>")
        [void]$reportSB.AppendLine("<div class='logo-container'>")
        [void]$reportSB.AppendLine("<img src='" + (Get-IconPath -ResourceName "Promo") + "' alt='Microsoft365DSC Slogan' width='500'  />")
        [void]$ReportSB.AppendLine('</div>')
        if (-not $IsBlueprintAssessment)
        {
            [void]$reportSB.AppendLine("<div class='comparison-text'>")
            [void]$reportSB.AppendLine("<p><strong>Comparison between the following configurations:</strong></p>")
            [void]$reportSB.AppendLine("<ul>")
            [void]$reportSB.AppendLine("<li><strong>Source: </strong>$Source</li>")
            [void]$reportSB.AppendLine("<li><strong>Destination: </strong>$Destination</li>")
            [void]$reportSB.AppendLine("</ul></div>")
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
            $combinedResourcesInDrift = [System.Collections.ArrayList]::new()
            foreach ($resource in $resourcesInDrift)
            {
                $existingInstance = $combinedResourcesInDrift | `
                    Where-Object -FilterScript {$_.ResourceName -eq $resource.ResourceName -and `
                                                $_.ResourceInstanceName -eq $resource.ResourceInstanceName}
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
                    $combinedResourcesInDrift = [System.Collections.ArrayList]$combinedResourcesInDrift
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
.Description
This function prepares the configuration for further parsing of the data

.Functionality
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
        $IncludeComments
    )

    if ((Test-Path -Path $ConfigurationPath) -eq $false)
    {
        Write-Error "Cannot find file specified in parameter Source: $ConfigurationPath. Please make sure the file exists!"
        return
    }

    Write-Verbose -Message "Loading file '$ConfigurationPath'"

    $fileContent = Get-Content $ConfigurationPath -Raw
    try
    {
        $startPosition = $fileContent.IndexOf(' -ModuleVersion')
        if ($startPosition -gt 0)
        {
            $endPosition = $fileContent.IndexOf("`r", $startPosition)
            $fileContent = $fileContent.Remove($startPosition, $endPosition - $startPosition)
        }
    }
    catch
    {
        Write-Verbose 'Error trying to remove Module Version'
    }

    if ($IncludeComments)
    {
        $parsedContent = ConvertTo-DSCObject -Content $fileContent -IncludeComments:$True
    }
    else
    {
        $parsedContent = ConvertTo-DSCObject -Content $fileContent
    }

    if ($null -eq $parsedContent)
    {
        Write-Warning -Message "No configuration found in $ConfigurationPath. Either the configuration was empty or the file was not a valid DSC configuration."
    }

    return $parsedContent
}

<#
.Description
    This function recursively converts a PowerShell object into an HTML list,
    flattening nested properties.

.Functionality
    Internal, Hidden
#>
function Convert-ObjectToHtmlList {
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

    $output = ""
    if ($InputObject -is [array])
    {
        if (-not $NoIndent)
        {
            $output += "<ul>"
        }
        for ($i = 0; $i -lt $InputObject.Count; $i++)
        {
            $item = $InputObject[$i]
            $itemName = "$ParentName[$i]"
            if ($item -is [hashtable])
            {
                $output += Convert-ObjectToHtmlList -InputObject $item -ParentName $itemName -NoIndent
                $output += "<hr/>"
            }
            else
            {
                $output += "<li><strong>$($itemName):</strong> $($item | Out-String)</li>"
            }
        }
        $output = $output.TrimEnd("<hr/>")
        if (-not $NoIndent)
        {
            $output += "</ul>"
        }
    }
    elseif ($InputObject -is [hashtable])
    {
        if (-not $NoIndent)
        {
            $output += "<ul>"
        }
        foreach ($key in ($InputObject.Keys | Sort-Object))
        {
            if ($key -ne 'CIMInstance')
            {
                $value = $InputObject.$key
                $childName = if ([System.String]::IsNullOrEmpty($ParentName)) { $key } else { "$ParentName.$key" }
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
            $output += "</ul>"
        }
    }
    else
    {
        $output = "$(if ($NoIndent) { '' } else { '<ul>' })<li>$($InputObject | Out-String)</li>$(if ($NoIndent) { '' } else { '</ul>' })"
    }
    return $output
}

Export-ModuleMember -Function @(
    'Compare-M365DSCConfigurations',
    'New-M365DSCDeltaReport',
    'New-M365DSCReportFromConfiguration',
    'Get-M365DSCCIMInstanceKey'
)
