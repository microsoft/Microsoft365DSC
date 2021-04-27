import {
  Checkbox,
  Dropdown,
  IDropdownOption,
  IDropdownStyles,
  IStackItemStyles,
  IStackStyles,
  IStackTokens,
  mergeStyles,
  Panel,
  PanelType,
  PrimaryButton,
  Stack,
  StackItem,
} from '@fluentui/react';
import * as React from 'react';
import { ContentCard } from '../../components/ContentCard/ContentCard';
import { Workload } from '../../models/Workload';
import { Resource } from '../../models/Resource';
import Editor from '@monaco-editor/react';

const dropdownStyles: Partial<IDropdownStyles> = { dropdown: { width: 300 } };

export const GeneratorPage: React.FunctionComponent = () => {
  const [extractionMode, setExtractionMode] = React.useState<string | undefined>('default');
  const [authentication, setAuthentication] = React.useState<string | undefined>('credentials');
  const [exportPanelOpen, setExportPanelOpen] = React.useState<boolean>(false);
  const [workloads, setWorkloads] = React.useState<Workload[]>([]);

  const extractionModesOptions: IDropdownOption[] = [
    { key: 'lite', text: 'Lite' },
    { key: 'default', text: 'Default' },
    { key: 'full', text: 'Full' },
  ];

  const authenticationOptions: IDropdownOption[] = [
    { key: 'app', text: 'Application' },
    { key: 'credentials', text: 'Credentials' },
    { key: 'certificate', text: 'Certificate' },
  ];

  const _isResourceChecked = React.useCallback(
    (workload: Workload, resource: Resource) => {
      switch (extractionMode) {
        case 'lite':
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

        case 'default':
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
    },
    [extractionMode]
  );

  const _onExtractionModeChange = (event: React.FormEvent<HTMLDivElement>, item: IDropdownOption | undefined): void => {
    setExtractionMode(item?.key.toString());
  };

  const _updateExtractionSelections = React.useCallback(
    (workloads: Workload[]): Workload[] => {
      workloads.forEach((workload: Workload) => {
        workload.resources.forEach((resource: Resource) => {
          resource.checked = _isResourceChecked(workload, resource);
        });
      });

      return workloads;
    },
    [_isResourceChecked]
  );

  const _onAuthenticationChange = (event: React.FormEvent<HTMLDivElement>, item: IDropdownOption | undefined): void => {
    setAuthentication(item?.key.toString());
  };

  const _onResourceChange = (resource: Resource, checked?: boolean) => {
    resource.checked = checked;
    _updateResource(resource);
    console.log(resource);
  };

  React.useEffect(() => {
    async function getServices() {
      const response = await fetch(`/data/workloads.json`);
      const worloadsData = (await response.json()) as Workload[];
      setWorkloads(_updateExtractionSelections([...worloadsData]));
    }

    getServices();
  }, [setWorkloads, _updateExtractionSelections]);

  React.useEffect(() => {
    setWorkloads(_updateExtractionSelections([...workloads]));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [extractionMode, _updateExtractionSelections]);

  const _exportClicked = () => {
    setExportPanelOpen(true);
  };

  const stackStyles: IStackStyles = {
    root: {
      width: '100%',
    },
  };

  const _updateResource = (resource: Resource) => {
    workloads.forEach((workload: Workload, workloadIndex: number) => {
      workload.resources.forEach((r: Resource, resourceIndex: number) => {
        if (resource.name === r.name) {
          r.checked = resource.checked;
        }
      });
    });

    setWorkloads([...workloads]);
  };

  const _dismissPanel = () => {
    setExportPanelOpen(false);
  };

  const wrapStackTokens: IStackTokens = { childrenGap: 30 };

  const _getExportScript = () => {
    let resourcesToExport: string[] = _getResources(true).map((r) => {
      return r.name;
    });

    return `# Exporting all components\nExport-M365DSCConfiguration -Quiet -ComponentsToExtract @("${resourcesToExport.join(
      '", "'
    )}")`;
  };

  const _getResources = (checked?: boolean | undefined) => {
    let resources: Resource[] = [];
    workloads.forEach((workload: Workload) => {
      workload.resources.forEach((r: Resource) => {
        if (checked === undefined || r.checked === checked) {
          resources.push(r);
        }
      });
    });

    return resources;
  };

  const stackItemStyles: IStackItemStyles = {
    root: {
      width: 275,
    },
  };

  return (
    <>
      <header>
        <h1>Generator</h1>
      </header>

      <Stack horizontal gap={30} className={mergeStyles({ paddingTop: '30px' })}>
        <StackItem>
          <Dropdown
            label="Extraction mode"
            selectedKey={extractionMode}
            onChange={_onExtractionModeChange}
            placeholder="Select an option"
            options={extractionModesOptions}
            styles={dropdownStyles}
          />
        </StackItem>

        <StackItem>
          <Dropdown
            label="Authentication"
            selectedKey={authentication}
            onChange={_onAuthenticationChange}
            placeholder="Select an option"
            options={authenticationOptions}
            styles={dropdownStyles}
          />
        </StackItem>

        <StackItem align={'end'}>
          <PrimaryButton text="Export" onClick={_exportClicked} />
        </StackItem>
      </Stack>

      <Stack gap={30} className={mergeStyles({ paddingTop: '30px' })}>
        {workloads &&
          workloads.length > 0 &&
          workloads.map((workload: Workload) => (
            <ContentCard title={workload.title}>
              {workload.description && (
                <div className={mergeStyles({ paddingBottom: '30px' })}>{workload.description}</div>
              )}
              <Stack horizontal wrap styles={stackStyles} tokens={wrapStackTokens}>
                {workload.resources &&
                  workload.resources.length > 0 &&
                  workload.resources.map((resource: Resource) => (
                    <StackItem styles={stackItemStyles}>
                      <Checkbox
                        label={resource.name}
                        checked={resource.checked}
                        onChange={(ev, checked) => _onResourceChange(resource, checked)}
                        value={resource.name}
                        key={resource.name}
                      />
                    </StackItem>
                  ))}
              </Stack>
            </ContentCard>
          ))}
      </Stack>
      <Panel
        isOpen={exportPanelOpen}
        onDismiss={_dismissPanel}
        type={PanelType.large}
        closeButtonAriaLabel="Close"
        headerText="Export"
      >
        <p>Use the following script to export the selected resources.</p>
        <Editor
          height="100vh"
          defaultLanguage="powershell"
          value={_getExportScript()}
          options={{ wordWrap: 'wordWrapColumn', wordWrapColumn: '120' }}
        />
      </Panel>
    </>
  );
};
