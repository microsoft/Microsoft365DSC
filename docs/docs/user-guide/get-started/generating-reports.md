Microsoft365DSC makes it very easy to generate user friendly reports from any configuration, whether you wrote it yourself or generated it using the configuration snapshot feature. The solution allows you to generate HTML, Excel and JSON reports from existing files.

> **NOTE:** To generate and Excel reports, you need to have Office installed on the machine that you are trying to generate the report from.

## Generate Report

To generate reports, simply use the <a href="../../cmdlets/New-M365DSCReportFromConfiguration/">New-M365DSCReportFromConfiguration</a> cmdlet and specify what type of report you want using the **Type** parameter (specify HTML, Excel or JSON). The cmdlet also requires you to specify the full path to the .ps1 configuration file you want to generate the report from using the **-ConfigurationPath** parameter and specify where you wish to store the generated report using the **-OutputPath** parameter.

## Excel Report

Trying to generate an Excel report from a configuration will automatically launch the Excel client as part of the process. Users will see data being loaded progressively into it and once the generation processes has finished, columns will automatically be resized to fit the content. The report will also automatically put the key mandatory parameter (e.g. primary key) of each resource in bold and do some styling of the output.

<figure markdown>
  ![Generating an Excel report](../../Images/GenerateExcelReport.png)
  <figcaption>Generating an Excel report</figcaption>
</figure>

## HTML Report

Generating an HTML report will generate a different result. It will create the report file at the location specified by the **OutputPath** parameter, but it won’t actually launch the report in a browser. The **New-M365DSCReportFromConfiguration** cmdlet, when used for HTML reports, will also return the raw HTML content of the report as seen in the image below.

<figure markdown>
  ![Generating an HTML report](../../Images/CommandToGenerateHTMLReport.png)
  <figcaption>Generating an HTML report</figcaption>
</figure>

<figure markdown>
  ![Example of HTML report](../../Images/ExampleOfHTMLReport.png)
  <figcaption>Example of HTML report</figcaption>
</figure>
