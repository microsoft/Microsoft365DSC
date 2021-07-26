import {
  Checkbox,
  IStackItemStyles,
  IStackStyles,
  IStackTokens,
  Stack,
  StackItem
} from '@fluentui/react';
import * as React from 'react';
import { useRecoilState, useRecoilValue } from 'recoil';
import { Resource } from '../../models/Resource';
import { Workload } from '../../models/Workload';
import { selectedResourcesState } from '../../state/resourcesState';
import { workloadsState } from '../../state/workloadState';
import { ContentCard } from '../ContentCard/ContentCard';

export interface IWorkloadOptionsProps {
  onSelectedResourcesChange: (changedResource: Resource, checked?: boolean) => void;
}

export const WorkloadOptions: React.FunctionComponent<IWorkloadOptionsProps> = (props) => {
  const workloads = useRecoilValue(workloadsState);
  const [resources, setResources] = useRecoilState(selectedResourcesState);

  const wrapStackTokens: IStackTokens = { childrenGap: 30 };

  const stackStyles: IStackStyles = {
    root: {
      width: '100%',
    },
  };

  const stackItemStyles: IStackItemStyles = {
    root: {
      width: 275,
    },
  };

  const _onCheckboxMouseEnter = function (resource: Resource) {
    resource.hovered = true;
    props.onSelectedResourcesChange(resource, false);
  };

  const onSelectAll = (workload: Workload, isIndeterminate?: boolean, checked?: boolean) => {
      setResources((selectedResources) => {
        return selectedResources.map((resource) => {
          const updatedResource = resource.workload === workload.id ? { ...resource, checked: isIndeterminate || checked } : resource;
          return updatedResource;
        });
      });

  };

  return (
    <>
      {workloads?.map((workload: Workload) => (
        <ContentCard workload={workload} key={workload.id} onSelectAll={onSelectAll}>
          <Stack horizontal wrap styles={stackStyles} tokens={wrapStackTokens}>
            {resources
              ?.filter((resource) => resource.workload === workload.id)
              .map((resource: Resource) => (
                <StackItem styles={stackItemStyles}>
                  <Checkbox
                    id={resource.name}
                    label={resource.name}
                    checked={resource.checked}
                    onChange={(ev, checked) => props.onSelectedResourcesChange(resource, checked)}
                    value={resource.name}
                    key={resource.name}
                    onMouseOver={() => _onCheckboxMouseEnter(resource)}
                  />
                </StackItem>
              ))}
          </Stack>
        </ContentCard>
      ))}
    </>
  );
};
