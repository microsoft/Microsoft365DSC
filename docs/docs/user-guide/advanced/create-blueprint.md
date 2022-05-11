A Microsoft365DSC Blueprint is a configuration file that has been reviewed and approved by an organization and which has the .M365 extension instead of a .ps1 one. It can be hosted locally or on the web and is used to assess the current configuration of any Microsoft 365 tenant against it to generate a discrepancy report. Other than having a different file extension than a normal DSC configuration, a Microsoft365DSC Blueprint can also include metadata that will be included as contextual information within the discrepancy report for configuration settings that have been identified as being different on a given tenant.

The following is an example of a blueprint snippet which contains metadata:

```PowerShell
TeamsCallingPolicy M365DSCPolicy
{
    AllowCallForwardingToPhone = $True; ### L2|We <strong>recommend</strong> allowing call forwarding to phone lines because...
    AllowCallForwardingToUser  = $True; ### L3|Information about <a href="https://docs.microsoft.com/en-us/MicrosoftTeams/teams-calling-policy">call forwarding</a>
    AllowPrivateCalling        = $false; ### L1|<img src='warning.png' />We don't recommend allowing people to allow private calls due to....
    AllowVoicemail             = "UserOverride";
    BusyOnBusyEnabledType      = "Disabled";
    Identity                   = "Microsoft365DSC Policy";
    PreventTollBypass          = $True;
    Ensure                     = "Present";
    Credential                 = $Credential
}
```

## Creating A Blueprint

As you can see from the example above, the format for a metadata entry is the following:

```PowerShell
    <Property Name> = <Property Value>; ### <Severity Level>|<Contextual Information>
```

Please note that, as the example above shows, you can use rich HTML in the Contextual Information to add visual elements to your reports.

Metadata in the blueprint needs to be included after the end of a line, following the configuration setting it related to. It is represented by the ### syntax. What follows the 3 pounds sign is an indicator of the level of severity related to the configuration setting assuming a drift was detected for it. The engine currently offers 3 levels of severity:

L1 - Critical, will appear in red in the discrepancy report. This indicates that this drift needs to be addressed as soon as possible.
L2 - Warning, will appear in yellow in the discrepancy report. This indicates that a drift was detected for the given property and that we strongly recommend addressing it.
L3 - Information, will appear in white in the discrepancy report. This indicates that a drift was detected and that it is up to the organization to decide if they want to address it or not.
It is important to understand that if a drifted property doesn't have associated metadata in the blueprint, it will still appear in the discrepancy report. It simply won't have any contextual information associated with it.

## Assessing A Blueprint

In order to assess an existing tenant against a given Microsoft365DSC Blueprint, you will need to use the following cmdlet:

```PowerShell
Assert-M365DSCBlueprint -BluePrintUrl [Url or local path to the .m365] -OutputReportPath [Full path to where to save the HTML report] -Credentials [Optional credentials for the tenant to assess]
```

<iframe width="560" height="315" src="https://www.youtube.com/embed/UE-nRdZ4iJk" title="Microsoft365DSC Blueprints" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
