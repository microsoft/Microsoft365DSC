import { Dropdown, IDropdownOption, IDropdownStyles, StackItem } from '@fluentui/react';
import * as React from 'react';
import { AuthenticationType } from '../../models/AuthenticationType';
import { ExtractionType } from '../../models/ExtractionType';

export interface IGenerationOptionsProps {
  extractionType: ExtractionType;
  authenticationType: AuthenticationType;
  onExtractionTypeChange: (extractionType: ExtractionType) => void;
  onAuthenticationTypeChange: (authentication: AuthenticationType) => void;
}

export const GenerationOptions: React.FunctionComponent<IGenerationOptionsProps> = (props) => {
  const [extractionType, setExtractionType] = React.useState<ExtractionType>(props.extractionType);
  const [authenticationType, setAuthenticationType] = React.useState<AuthenticationType>(props.authenticationType);

  const dropdownStyles: Partial<IDropdownStyles> = { dropdown: { width: 300 } };
  const extractionModesOptions: IDropdownOption[] = [
    { key: ExtractionType.Lite, text: 'Lite' },
    { key: ExtractionType.Default, text: 'Default' },
    { key: ExtractionType.Full, text: 'Full' },
  ];

  const authenticationOptions: IDropdownOption[] = [
    { key: AuthenticationType.Application, text: 'Application' },
    { key: AuthenticationType.Credentials, text: 'Credentials' },
    { key: AuthenticationType.Certificate, text: 'Certificate' },
  ];

  const _onExtractionTypeChange = (event: React.FormEvent<HTMLDivElement>, item: IDropdownOption | undefined): void => {
    const type: ExtractionType = item!.key.toString() as ExtractionType;
    setExtractionType(type);
    props.onExtractionTypeChange(type);
  };

  const _onAuthenticationTypeChange = (
    event: React.FormEvent<HTMLDivElement>,
    item: IDropdownOption | undefined
  ): void => {
    const type: AuthenticationType = item!.key.toString() as AuthenticationType;
    setAuthenticationType(type);
    props.onAuthenticationTypeChange(type);
  };

  return (
    <>
      <StackItem>
        <Dropdown
          label="Extraction mode"
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
