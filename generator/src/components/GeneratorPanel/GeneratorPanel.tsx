import { Panel, PanelType } from '@fluentui/react';
import Editor from '@monaco-editor/react';
import * as React from 'react';
import { useRecoilState, useRecoilValue } from 'recoil';
import { authenticationTypeState } from '../../state/authenticationTypeState';
import { selectedResourcesState } from '../../state/resourcesState';

export interface IGeneratorPanelProps {
  onDismiss: (ev?: React.SyntheticEvent<HTMLElement, Event> | undefined) => void;
}

export const GeneratorPanel: React.FunctionComponent<IGeneratorPanelProps> = (props) => {
  const [isOpen, setIsOpen] = React.useState<boolean>(true);
  const authenticationType = useRecoilValue(authenticationTypeState);

  const [selectedResources] = useRecoilState(selectedResourcesState);

  const _dismissPanel = (ev?: React.SyntheticEvent<HTMLElement, Event> | undefined) => {
    setIsOpen(false);
    props.onDismiss(ev);
  };

  const _getExportScript = () => {
    let resourcesToExport: string[] = selectedResources.filter((r) => r.checked === true).map((r) => r.name);

    return `# Exporting all components using ${authenticationType} authentication \nExport-M365DSCConfiguration -Quiet -ComponentsToExtract @("${resourcesToExport.join(
      '", "'
    )}")`;
  };

  return (
    <Panel
      isOpen={isOpen}
      onDismiss={_dismissPanel}
      type={PanelType.large}
      closeButtonAriaLabel="Close"
      headerText="Export"
    >
      <p>Use the following script to export the selected resources.</p>
      <Editor
        height="80vh"
        defaultLanguage="powershell"
        defaultValue={_getExportScript()}
        options={{ wordWrap: 'wordWrapColumn', wordWrapColumn: 120, readOnly: true, minimap: { enabled: false } }}
      />
    </Panel>
  );
};
