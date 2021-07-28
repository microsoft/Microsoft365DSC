import { INavLinkGroup, IStackProps, mergeStyles, Stack } from '@fluentui/react';
import * as React from 'react';
import { Workload } from '../../models/Workload';
import { Resource } from '../../models/Resource';
import { Header } from '../../components/Header';
import { SideNavigation } from '../../components/SideNavigation/SideNavigation';
import { GeneratorPanel } from '../../components/GeneratorPanel/GeneratorPanel';
import { ExtractionType } from '../../models/ExtractionType';
import { Generator } from '../../components/Generator/Generator';
import { selectedResourcesState } from '../../state/resourcesState';
import { useRecoilState, useRecoilValue } from 'recoil';
import { extractionTypeState } from '../../state/extractionTypeState';
import { workloadsState } from '../../state/workloadState';
import { generatorPanelState } from '../../state/generatorPanelState';

export const GeneratorPage: React.FunctionComponent = () => {
  const extractionType = useRecoilValue(extractionTypeState);
  const [generatorPanelOpen, setGeneratorPanelOpen] = useRecoilState(generatorPanelState);
  const [navigationItems, setNavigationItems] = React.useState<INavLinkGroup[]>([]);
  const [selectedResources, setSelectedResources] = useRecoilState(selectedResourcesState);
  const [workloads, setWorkloads] = useRecoilState(workloadsState);

  const _isResourceChecked = React.useCallback(
    (resource: Resource) => {
      const workload = workloads.find((workload) => workload.id === resource.workload);

      if (workload !== undefined) {
        switch (extractionType) {
          case ExtractionType.Lite:
            if (
              workload.extractionModes?.default?.includes(resource.name) ||
              workload.extractionModes?.full?.includes(resource.name)
            ) {
              return false;
            }

            return true;

          case ExtractionType.Default:
            if (workload.extractionModes?.full?.includes(resource.name)) {
              return false;
            }

            return true;

          case ExtractionType.None:
            return false;
        }

        return true;
      } else {
        return false;
      }
    },
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [extractionType, workloads]
  );

  const _buildNavigationItems = React.useCallback(() => {
    let navigation: INavLinkGroup[] = [
      {
        links: [
          {
            name: 'Home',
            url: '#Home',
            icon: 'Home',
            key: 'Home'
          },
        ],
      },
    ];
    workloads.forEach((workload: Workload) => {
      navigation[0].links.push({
        name: workload.title,
        key: workload.id,
        url: `#${workload.title}`,
        icon: workload.iconName
      });
    });

    return navigation;
  }, [workloads]);

  const _buildResourcesForExtractionType = React.useCallback(
    (resources: Resource[]): Resource[] => {
      return resources.map((resource) => {
        const isResourceChecked = _isResourceChecked(resource);
        const updatedResource =
          resource.checked !== isResourceChecked ? { ...resource, checked: isResourceChecked } : resource;
        return updatedResource;
      });
    },
    [_isResourceChecked]
  );

  const _onGenerateToggle = React.useCallback(() => {
    setGeneratorPanelOpen(!generatorPanelOpen);
  }, [generatorPanelOpen, setGeneratorPanelOpen]);

  React.useEffect(() => {
    async function fetchData() {
      const workloadResponse = await fetch(`/data/workloads.json`);
      if (workloads?.length === 0) {
        const workloadsData = (await workloadResponse.json()) as Workload[];
        setWorkloads(workloadsData);
      }
    }

    fetchData();
  }, [workloads, setWorkloads]);

  React.useEffect(() => {
    async function fetchData() {
      setNavigationItems(_buildNavigationItems());

      const resourceResponse = await fetch(`/data/resources.json`);
      let resourcesData = (await resourceResponse.json()) as Resource[];

      resourcesData = resourcesData.map((resource) => {
        resource.checked = false;
        resource.hovered = false;
        return resource;
      });

      resourcesData = _buildResourcesForExtractionType(resourcesData);

      setSelectedResources(resourcesData);
    }

    fetchData();
  }, [workloads, _buildResourcesForExtractionType, setSelectedResources, setNavigationItems, _buildNavigationItems]);

  React.useEffect(() => {
    if (workloads && workloads.length > 0 && selectedResources && selectedResources.length > 0) {
      setSelectedResources(_buildResourcesForExtractionType(selectedResources));
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [extractionType, setSelectedResources, _buildResourcesForExtractionType]);

  const Content = (props: IStackProps) => (
    <Stack horizontal tokens={{ childrenGap: 10 }} className={mergeStyles({ overflow: 'hidden' })} {...props} />
  );

  const Sidebar = (props: IStackProps) => (
    <Stack
      disableShrink
      tokens={{ childrenGap: 20 }}
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
      tokens={{ childrenGap: 10 }}
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
      <Content>
        <Sidebar>
          <SideNavigation items={navigationItems}></SideNavigation>
        </Sidebar>
        <Main>
          <Generator></Generator>

          {generatorPanelOpen && (
            <GeneratorPanel></GeneratorPanel>
          )}
        </Main>
      </Content>
    </Page>
  );
};
