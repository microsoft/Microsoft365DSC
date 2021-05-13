import { IStackProps, mergeStyles, Stack } from '@fluentui/react';
import * as React from 'react';
import { Workload } from '../../models/Workload';
import { Resource } from '../../models/Resource';
import { Header } from '../../components/Header';
import { SideNavigation } from '../../components/SideNavigation/SideNavigation';
import { GenerationOptions } from '../../components/GeneratorOptions/GeneratorOptions';
import { WorkloadOptions } from '../../components/WorkloadOptions/WorkloadOptions';
import { GeneratorPanel } from '../../components/GeneratorPanel/GeneratorPanel';
import { ExtractionType } from '../../models/ExtractionType';
import { AuthenticationType } from '../../models/AuthenticationType';

export const GeneratorPage: React.FunctionComponent = () => {
  const [extractionType, setExtractionType] = React.useState<ExtractionType>(ExtractionType.Default);
  const [authenticationType, setAuthenticationType] = React.useState<AuthenticationType>(
    AuthenticationType.Credentials
  );
  const [generatorPanelOpen, setGeneratorPanelOpen] = React.useState<boolean>(false);
  const [resources, setResources] = React.useState<Resource[]>([]);
  const [workloads, setWorkloads] = React.useState<Workload[]>([]);

  const _onExtractionTypeChange = (extractionType: ExtractionType): void => {
    setExtractionType(extractionType);
  };

  const _onAuthenticationTypeChange = (authenticationType: AuthenticationType): void => {
    setAuthenticationType(authenticationType);
  };

  const _onGenerateToggle = React.useCallback(() => {
    setGeneratorPanelOpen(!generatorPanelOpen);
  }, [generatorPanelOpen, setGeneratorPanelOpen]);

  const _onSelectedResourcesChange = (changedResource: Resource, checked?: boolean) => {
    changedResource.checked = checked;
    const resourceIndex = resources.findIndex((resource) => resource.name === changedResource.name);
    resources[resourceIndex] = changedResource;
    setResources([...resources]);
  };

  const _isResourceChecked = React.useCallback(
    (resource: Resource) => {
      const workload = workloads.find((workload) => workload.key === resource.workload);

      if (workload !== undefined) {
        switch (extractionType) {
          case ExtractionType.Lite:
            if (
              (workload.extractionModes &&
                workload.extractionModes.default &&
                workload.extractionModes.default.includes(resource.name)) ||
              (workload.extractionModes &&
                workload.extractionModes.full &&
                workload.extractionModes.full.includes(resource.name))
            ) {
              return false;
            }

            return true;

          case ExtractionType.Default:
            if (
              workload.extractionModes &&
              workload.extractionModes.full &&
              workload.extractionModes.full.includes(resource.name)
            ) {
              return false;
            }

            return true;
        }

        return true;
      }
    },
    [extractionType, workloads]
  );

  const _updateExtractionSelections = React.useCallback(
    (resources: Resource[]): Resource[] => {
      resources.forEach((resource: Resource) => {
        resource.checked = _isResourceChecked(resource);
      });

      return resources;
    },
    [_isResourceChecked]
  );

  React.useEffect(() => {
    async function fetchData() {
      const workloadResponse = await fetch(`/data/workloads.json`);
      const workloadsData = (await workloadResponse.json()) as Workload[];
      setWorkloads(workloadsData);

      const resourceResponse = await fetch(`/data/resources.json`);
      const resourcesData = (await resourceResponse.json()) as Resource[];
      setResources(_updateExtractionSelections([...resourcesData]));
    }

    fetchData();
  }, [setWorkloads, setResources, _updateExtractionSelections]);

  React.useEffect(() => {
    //if (extractionType !== previousExtractionType) {
    setResources((resources) => _updateExtractionSelections([...resources]));
    //}
  }, [extractionType, _updateExtractionSelections]);

  const Content = (props: IStackProps) => (
    <Stack horizontal gap={10} className={mergeStyles({ overflow: 'hidden' })} {...props} />
  );

  const Sidebar = (props: IStackProps) => (
    <Stack
      disableShrink
      gap={20}
      grow={20}
      className={mergeStyles({
        position: 'fixed',
        top: 50,
        left: 0,
        backgroundColor: '#ffffff',
      })}
      verticalFill={true}
      {...props}
    />
  );

  const Main = (props: IStackProps) => (
    <Stack
      grow={80}
      className={mergeStyles({ padding: '40px', paddingLeft: '15rem', paddingTop: '50px', backgroundColor: '#faf9f8' })}
      disableShrink
      {...props}
    />
  );

  const Page = (props: IStackProps) => (
    <Stack
      gap={10}
      className={mergeStyles({
        selectors: {
          ':global(body)': {
            padding: 0,
            margin: 0,
          },
        },
      })}
      {...props}
    />
  );

  return (
    <Page>
      <Header onGenerate={_onGenerateToggle}></Header>
      {workloads && workloads.length > 0 && (
        <Content>
          <Sidebar>
            <SideNavigation workloads={workloads}></SideNavigation>
          </Sidebar>
          <Main>
            <header>
              <h1 id="Home">Generator</h1>
            </header>
            <Stack horizontal gap={30} className={mergeStyles({ paddingTop: '30px' })}>
              <GenerationOptions
                extractionType={extractionType}
                authenticationType={authenticationType}
                onExtractionTypeChange={_onExtractionTypeChange}
                onAuthenticationTypeChange={_onAuthenticationTypeChange}
              ></GenerationOptions>
            </Stack>
            <Stack gap={30} className={mergeStyles({ paddingTop: '30px' })}>
              <WorkloadOptions
                workloads={workloads}
                resources={resources}
                extractionType={extractionType}
                onSelectedResourcesChange={_onSelectedResourcesChange}
              ></WorkloadOptions>
            </Stack>
            {generatorPanelOpen && (
              <GeneratorPanel
                resources={resources}
                authenticationType={authenticationType}
                onDismiss={_onGenerateToggle}
              ></GeneratorPanel>
            )}
          </Main>
        </Content>
      )}
    </Page>
  );
};
