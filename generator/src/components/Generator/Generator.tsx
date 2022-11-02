import { IStackTokens, mergeStyles, Stack } from '@fluentui/react';
import * as React from 'react';
import { useSetRecoilState } from 'recoil';
import { Resource } from '../../models/Resource';
import { selectedResourcesState } from '../../state/resourcesState';
import { GenerationOptions } from '../GeneratorOptions/GeneratorOptions';
import { WorkloadOptions } from '../WorkloadOptions/WorkloadOptions';

export interface IGeneratorProps {}

export const Generator: React.FunctionComponent<IGeneratorProps> = (props) => {
  const setSelectedResources = useSetRecoilState(selectedResourcesState);

  const _onSelectedResourcesChange = (changedResource: Resource, checked?: boolean) => {
    setSelectedResources((selectedResources) => {
      return selectedResources.map((resource) => {
        const updatedResource = resource.name === changedResource.name ? { ...resource, checked: checked } : resource;
        return updatedResource;
      });
    });
  };

  const stackTokens: IStackTokens = { childrenGap: 30 };

  return (
    <>
      <Stack horizontal tokens={stackTokens} className={mergeStyles({ paddingTop: '30px' })}>
        <GenerationOptions></GenerationOptions>
      </Stack>
      <Stack tokens={stackTokens} className={mergeStyles({ paddingTop: '30px', wordBreak: 'break-word' })}>
        <WorkloadOptions onSelectedResourcesChange={_onSelectedResourcesChange}></WorkloadOptions>
      </Stack>
    </>
  );
};
