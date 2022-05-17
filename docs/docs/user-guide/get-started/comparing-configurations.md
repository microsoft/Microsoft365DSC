The Microsoft365DSC solution has a built-in engine to compare configurations and generate a delta report in HTML that shows the discrepancies between the two. You can either use it to compare the configuration between 2 files or you can use it to compare a configuration against another tenant and see how it defers from that tenant’s current configuration.

## Comparing 2 Configuration Files

Using the <a href="../../cmdlets/New-M365DSCDeltaReport/">New-M365DSCDeltaReport</a> cmdlet, you can specify the two configuration files you wish to compare using the **-Source** and **-Destination** parameters. You then need to specify where you wish to store the resulting HTML report using the **-OutputPath** parameter.

Consider the following example, where we have taken two configuration snapshots of a tenant over a period of 6 months apart. The goal is to determine what configuration settings have changed over that period of time. Using the **New-M365DSCDeltaReport** cmdlet, we can easily compare the two and generate a delta report as shown in the image below.

<figure markdown>
  ![Generating a Delta Report of two configurations](../../Images/GeneratingDeltaReport.png)
  <figcaption>Generating a Delta Report of two configurations</figcaption>
</figure>

We can also decide to customize the generated report by injecting custom HTML into its header. To do so, simply specify the location of the HTML file to inject in the header of the report using the **-HeaderFilePath** parameter. The example shown in the following picture shows how to add your customer header to a delta report.

<figure markdown>
  ![Generating a Delta Report of two configurations with a custom header](../../Images/GeneratingDeltaReportWithCustomHeader.png)
  <figcaption>Generating a Delta Report of two configurations with a custom header</figcaption>
</figure>

## Comparing a Configuration Against Another Tenant

Using Microsoft365DSC, you can compare any configuration file against the current configuration of any other given Microsoft 365 tenant. This can be very useful in comparing the configuration between two tenants in scenarios like mergers and acquisitions. For example, let’s assume you are trying to compare the configuration of Tenant A with the one from Tenant B. You can start by taking a snapshot of both tenants, and then use this feature to compare it against the configuration of Tenant B using the **New-M365DSCDeltaReport** cmdlet.
