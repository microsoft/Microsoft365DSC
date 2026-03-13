import { Dropdown, IDropdownOption, IDropdownStyles, StackItem } from '@fluentui/react';
import * as React from 'react';
import { useAppStore } from '../../state/store';
import { AuthenticationType } from '../../models/AuthenticationType';
import { ExtractionType } from '../../models/ExtractionType';

export interface IGenerationOptionsProps {}

export const GenerationOptions: React.FunctionComponent<IGenerationOptionsProps> = (props) => {
  const extractionType = useAppStore((s) => s.extractionType);
  const setExtractionType = useAppStore((s) => s.setExtractionType);
  const authenticationType = useAppStore((s) => s.authenticationType);
  const setAuthenticationType = useAppStore((s) => s.setAuthenticationType);

  const dropdownStyles: Partial<IDropdownStyles> = { dropdown: { width: 300 } };
  const extractionModesOptions: IDropdownOption[] = [
    { key: ExtractionType.None, text: 'None' },
    { key: ExtractionType.Default, text: 'Default' },
    { key: ExtractionType.Full, text: 'Full' },
  ];

  const authenticationOptions: IDropdownOption[] = [
    { key: AuthenticationType.Application, text: 'Application' },
    { key: AuthenticationType.Credentials, text: 'Credentials' },
    { key: AuthenticationType.Certificate, text: 'Certificate' },
  ];

  const _onExtractionTypeChange = (_event: React.SyntheticEvent<HTMLDivElement>, item: IDropdownOption | undefined): void => {
    const type: ExtractionType = item!.key.toString() as ExtractionType;
    setExtractionType(type);
  };

  const _onAuthenticationTypeChange = (
    _event: React.SyntheticEvent<HTMLDivElement>,
    item: IDropdownOption | undefined
  ): void => {
    const type: AuthenticationType = item!.key.toString() as AuthenticationType;
    setAuthenticationType(type);
  };

  return (
    <>
      <StackItem>
        <Dropdown
          label="Selection mode"
          selectedKey={extractionType}
          onChange={_onExtractionTypeChange}
          placeholder="Select an option"
          options={extractionModesOptions}
          styles={dropdownStyles}
        />
      </StackItem>

      <StackItem>
        <Dropdown
          label="Authentication"
          selectedKey={authenticationType}
          onChange={_onAuthenticationTypeChange}
          placeholder="Select an option"
          options={authenticationOptions}
          styles={dropdownStyles}
        />
      </StackItem>
    </>
  );
};
