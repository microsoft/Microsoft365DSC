Import-Module C:\GitHub\DSCParser\Modules\DSCParser.psm1 -Force

function New-M365DSCConfigurationToHTML
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $ConfigurationPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    $TemplateFile = Get-Item $ConfigurationPath
    $parsedContent = ConvertTo-DSCObject -Path $ConfigurationPath
    $TemplateName = $TemplateFile.Name.Split('.')[0]
    $fullHTML = "<h1>" + $TemplateName + "</h1>"
    $fullHTML += "<div style='width:100%;text-align:center;'>"
    $fullHTML += "<h2>Template Details</h2>"
    foreach ($resource in $parsedContent)
    {
        $partHTML = "<div width='100%' style='text-align:center;'><table width='80%' style='margin-left:auto;
    margin-right:auto;'>"
        $partHTML += "<tr><th rowspan='" + ($resource.Keys.Count) + "' width='20%'>"
        $partHTML += "<img src='" + (Get-IconPath -ResourceName $resource.ResourceName) + "' />"
        $partHTML += "</th>"

        $partHTML += "<th colspan='2' style='background-color:silver;text-align:center;' width='80%'>"
        $partHTML += "<strong>" + $resource.ResourceName + "</strong>"
        $partHTML += "</th></tr>"

        foreach ($property in $resource.Keys)
        {
            if ($property -ne "ResourceName" -and $property -ne "GlobalAdminAccount")
            {
                $partHTML += "<tr><td width='40%' style='padding:5px;text-align:right;border:1px solid black;'><strong>" + $property + "</strong></td>"
                $value = "Null"
                if ($null -ne $resource.$property)
                {
                    $value = ($resource.$property).ToString().Replace("$","")
                }
                $partHTML += "<td width='40%' style='padding:5px;border:1px solid black;'>" + $value + "</td></tr>"
            }
        }

        $partHTML += "</table></div><br />"
        $fullHtml += $partHTML
    }

    $fullHtml | Out-File $OutputPath
}


function Get-IconPath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $ResourceName
    )

    if ($ResourceName.StartsWith("AAD"))
    {
        return "http://microsoft365dsc.com/Images/AzureAD.jpg"
    }
    elseif ($ResourceName.StartsWith("EXO"))
    {
        return "http://microsoft365dsc.com/Images/Exchange.jpg"
    }
    elseif ($ResourceName.StartsWith("O365"))
    {
        return "http://microsoft365dsc.com/Images/Office365.jpg"
    }
    elseif ($ResourceName.StartsWith("OD"))
    {
        return "http://microsoft365dsc.com/Images/OneDrive.jpg"
    }
    elseif ($ResourceName.StartsWith("PP"))
    {
        return "http://microsoft365dsc.com/Images/PowerApps.jpg"
    }
    elseif ($ResourceName.StartsWith("SC"))
    {
        return "http://microsoft365dsc.com/Images/SecurityAndCompliance.png"
    }
    elseif ($ResourceName.StartsWith("SPO"))
    {
        return "http://microsoft365dsc.com/Images/SharePoint.jpg"
    }
    elseif ($ResourceName.StartsWith("Teams"))
    {
        return "http://microsoft365dsc.com/Images/Teams.jpg"
    }
    return $null
}

function New-M365DSCConfigurationToExcel
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $ConfigurationPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    $excel = New-Object -ComObject excel.application
    $excel.visible = $True
    $workbook = $excel.Workbooks.Add()
    $report= $workbook.Worksheets.Item(1)
    $report.Name = 'Report'
    $report.Cells.Item(1,1) = "Component Name"
    $report.Cells.Item(1,1).Font.Size = 18
    $report.Cells.Item(1,1).Font.Bold=$True
    $report.Cells.Item(1,2) = "Property"
    $report.Cells.Item(1,2).Font.Size = 18
    $report.Cells.Item(1,2).Font.Bold=$True
    $report.Cells.Item(1,3) = "Value"
    $report.Cells.Item(1,3).Font.Size = 18
    $report.Cells.Item(1,3).Font.Bold=$True
    $report.Range("A1:C1").Borders.Weight = -4138
    $row = 2

    $parsedContent = ConvertTo-DSCObject -Path $ConfigurationPath
    $csvContent = "Component Name,Property,Value`n"
    foreach ($resource in $parsedContent)
    {
        $beginRow = $row
        foreach ($property in $resource.Keys)
        {
            if ($property -ne "ResourceName" -and $property -ne "GlobalAdminAccount")
            {
                $report.Cells.Item($row,1) = $resource.ResourceName
                $report.Cells.Item($row,2) = $property
                try
                {
                    if ([System.String]::IsNullOrEmpty($resource.$property))
                    {
                        $report.Cells.Item($row,3) = "null"
                    }
                    else
                    {
                        $value = ($resource.$property).ToString().Replace("$","")
                        $value = $value.Replace("@","")
                        $value = $value.Replace("(","")
                        $value = $value.Replace(")","")
                        $report.Cells.Item($row,3) = $value
                    }

                    $report.Cells.Item($row,3).HorizontalAlignment = -4131
                }
                catch{}

                if ($property -in @("Identity", "Name", "IsSingleInstance"))
                {
                    $OriginPropertyName = $report.Cells.Item($beginRow, 2).Text
                    $OriginPropertyValue = $report.Cells.Item($beginRow, 3).Text
                    $CurrentPropertyName = $report.Cells.Item($row, 2).Text
                    $CurrentPropertyValue = $report.Cells.Item($row, 3).Text

                    $report.Cells.Item($beginRow, 2) = $CurrentPropertyName
                    $report.Cells.Item($beginRow, 3) = $CurrentPropertyValue
                    $report.Cells.Item($row, 2) = $OriginPropertyName
                    $report.Cells.Item($row, 3) = $OriginPropertyValue

                    $report.Cells($beginRow,1).Font.ColorIndex = 10
                    $report.Cells($beginRow,2).Font.ColorIndex = 10
                    $report.Cells($beginRow,3).Font.ColorIndex = 10
                    $report.Cells($beginRow,1).Font.Bold = $true
                    $report.Cells($beginRow,2).Font.Bold = $true
                    $report.Cells($beginRow,3).Font.Bold = $true
                }
                $row++
            }
        }
        $rangeValue = "A$beginRow" + ":" + "C$row"
        $report.Range($rangeValue).Borders[8].Weight = -4138
    }
    $usedRange = $report.UsedRange
    $usedRange.EntireColumn.AutoFit() | Out-Null
    $workbook.SaveAs($OutputPath)
    #$excel.Quit()
}

function New-M365DSCReportFromConfiguration
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Excel', 'HTML')]
        [System.String]
        $Type,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ConfigurationPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    switch ($Type)
    {
        "Excel" {
            New-M365DSCConfigurationToExcel -ConfigurationPath $ConfigurationPath -OutputPath $OutputPath
        }
        "HTML" {
            New-M365DSCConfigurationToHTML -ConfigurationPath $ConfigurationPath -OutputPath $OutputPath
        }
    }
}
