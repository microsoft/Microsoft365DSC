import { mergeStyles } from '@fluentui/merge-styles';
import { IStyle, Stack } from '@fluentui/react';
import * as React from 'react';
import { ContentCard } from '../../components/ContentCard/ContentCard';

export const HomePage: React.FunctionComponent = () => {
  const sectionStyles: IStyle = {
    paddingBottom: '30px',
  };
  return (
    <>
      <header>
        <h1>What is Microsoft365DSC?</h1>
      </header>
      Microsoft365DSC is an Open-Source initiative hosted on GitHub, lead by Microsoft engineers and maintained by the
      community. It allows you to write a definition for how your Microsoft 365 tenant should be configured, automate
      the deployment of that configuration, and ensures the monitoring of the defined configuration, notifying and
      acting on detected configuration drifts. It also allows you to extract a full-fidelity configuration out of any
      existing Microsoft 365 tenant. The tool covers all major Microsoft 365 workloads such as Exchange Online, Teams,
      Power Platforms, SharePoint and Security and Compliance.
      <Stack tokens={{ childrenGap: 30 }} className={mergeStyles({ paddingTop: '30px' })}>
        <ContentCard title="Automate" iconName="AutomateFlow">
          <div className={mergeStyles(sectionStyles)}>
            365 tenant to be configured. The Microsoft365DSC module allows Microsoft 365 administrators to define how
            the configuration of the various workloads (SharePoint, Exchange, Security & Compliance, Teams, etc.), and
            apply the configuration in an automated way. For example, administrator that which to deploy a new Search
            Managed Property to their SharePoint Online workload, can do so with similar lines of code (all code
            examples can be found on the Resources List wiki page):
          </div>
          <div className={mergeStyles(sectionStyles)}>
            Using PowerShell Desired State Configuration (DSC) syntax, write a complete definition of how you want your
            Microsoft Just like any other normal PowerShell DSC configuration, your Microsoft365DSC file will need to be
            compiled into a .MOF file for the Local Configuration Manager to be able to apply it. Once your
            configuration file has been compiled, you can execute the configuration process by calling into the
            Start-DSCConfiguration PowerShell cmdlet. All configuration resources defined by Microsoft365DSC will make
            remote calls back to the Microsoft 365 tenant using various underlying frameworks and components (Microsoft
            Teams PowerShell Module, SharePoint PnP, Azure Active Directory, etc.). It is therefore important that the
            machine that executes the configuration has internet connectivity back to the Microsoft 365 tenant you are
            trying to configure. For additional information on how to get started with PowerShell Desired State
            Configuration, you can refer to the Introduction to PowerShell Desired State Configuraton training video.
          </div>
        </ContentCard>

        <ContentCard title={'Export'}>
          Microsoft365DSC is the very first PowerShell project that natively supports ReverseDSC. This means that by
          simply installing the module, you are able to leverage ReverseDSC to extract the entire configuration of any
          existing tenants. The module exposes a cmdlet called Export-M365DSCConfiguration which launches a Graphical
          User Interface (GUI) that allows you to pick and choose what configuration components you wish to extract in a
          granular fashion.
        </ContentCard>

        <ContentCard title={'Synchronize'}>
          Microsoft365DSC makes it very easy for users to keep multiple tenants' configuration synchronized. With the
          tool you can export the configuration from any existing tenant and re-apply it onto multiple other tenants,
          keeping their configuration synchronized.
        </ContentCard>

        <ContentCard title={'Assess'}>
          <div className={mergeStyles(sectionStyles)}>
            Assess any Microsoft 365 tenant against a known good configuration and generate a discrepency report.
            Microsoft365DSC makes it feasible for organizations to validate the configuration of their existing
            Microsoft 365 tenant against industry's best practices with a single line command. You can assess any tenant
            against any baseline configuration that you and your team developed or use official Blueprints.
          </div>

          <div className={mergeStyles(sectionStyles)}>
            Microsoft365DSC also allows you to compare two configuration files and obtain the delta between the two.
            Whether you wish to compare the configuration between 2 tenants or two point-in-time exports of the same
            tenant, we've got you covered!
          </div>
        </ContentCard>

        <ContentCard title={'Assess'}>
          <div className={mergeStyles(sectionStyles)}>
            Automatic monitoring of configuration drifts in your tenant and notification about detected drifts with
            in-depth details for troubleshooting. Microsoft365DSC will perform regular checks to detect configuration
            drifts (every 15 minutes by default) and can take one of the following 3 actions when drifts are detected:
            <ul>
              <li>Fix the drift automatically by re-applying the desired configuration;</li>
              <li>Log detailed information about the drifts detected in Event Viewer;</li>
              <li>
                Notify administrators via emails when drifts are detected, providing them with a detailed report as to
                what the drifts are (requires the use of Azure DevOPS pipelines);
              </li>
            </ul>
          </div>
        </ContentCard>

        <ContentCard title={'Report'}>
          <div className={mergeStyles(sectionStyles)}>
            Take any Microsoft365DSC configuration and generate a user friendly report from it in an Excel or HTML
            format. With a single command you can convert any Microsoft365DSC configuration
          </div>
        </ContentCard>
      </Stack>
    </>
  );
};
