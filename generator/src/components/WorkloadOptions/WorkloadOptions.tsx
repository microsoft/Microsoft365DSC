import { Checkbox, IStackItemStyles, IStackStyles, IStackTokens, Stack, StackItem } from '@fluentui/react';
import * as React from 'react';
import { useAppStore } from '../../state/store';
import { useShallow } from 'zustand/react/shallow';
import { Resource } from '../../models/Resource';
import { Workload } from '../../models/Workload';
import { ContentCard } from '../ContentCard/ContentCard';

export interface IWorkloadOptionsProps {
  onSelectedResourcesChange: (changedResource: Resource, checked?: boolean) => void;
}

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

interface IWorkloadSectionProps {
  workload: Workload;
  onSelectedResourcesChange: (changedResource: Resource, checked?: boolean) => void;
}

const WorkloadSection: React.FunctionComponent<IWorkloadSectionProps> = React.memo(({ workload, onSelectedResourcesChange }) => {
  const resources = useAppStore(
    useShallow((s) => s.selectedResources.filter((r) => r.workload === workload.id))
  );
  const setResources = useAppStore((s) => s.setSelectedResources);

  const onSelectAll = React.useCallback((w: Workload, isIndeterminate?: boolean, checked?: boolean) => {
    setResources((selectedResources) => {
      return selectedResources.map((resource) => {
        const updatedResource =
          resource.workload === w.id ? { ...resource, checked: isIndeterminate || checked } : resource;
        return updatedResource;
      });
    });
  }, [setResources]);

  const _onCheckboxMouseEnter = React.useCallback(function (resource: Resource) {
    resource.hovered = true;
    onSelectedResourcesChange(resource, false);
  }, [onSelectedResourcesChange]);

  return (
    <ContentCard workload={workload} onSelectAll={onSelectAll}>
      <Stack horizontal wrap styles={stackStyles} tokens={wrapStackTokens}>
        {resources.map((resource: Resource) => (
          <StackItem styles={stackItemStyles} key={resource.name}>
            <Checkbox
              id={resource.name}
              label={resource.name}
              checked={resource.checked}
              onChange={(ev, checked) => onSelectedResourcesChange(resource, checked)}
              inputProps={{ value: resource.name, onMouseOver: () => _onCheckboxMouseEnter(resource) }}
              key={resource.name}
            />
          </StackItem>
        ))}
      </Stack>
    </ContentCard>
  );
});

export const WorkloadOptions: React.FunctionComponent<IWorkloadOptionsProps> = (props) => {
  const workloads = useAppStore((s) => s.workloads);

  return (
    <>
      {workloads?.map((workload: Workload) => (
        <WorkloadSection
          key={workload.id}
          workload={workload}
          onSelectedResourcesChange={props.onSelectedResourcesChange}
        />
      ))}
    </>
  );
};
