import { Checkbox, IStackItemStyles, IStackStyles, IStackTokens, mergeStyles, Stack, StackItem } from '@fluentui/react';
import * as React from 'react';
import { ExtractionType } from '../../models/ExtractionType';
import { Resource } from '../../models/Resource';
import { Workload } from '../../models/Workload';
import { ContentCard } from '../ContentCard/ContentCard';

export interface IWorkloadOptionsProps {
  workloads: Workload[];
  resources: Resource[];
  onSelectedResourcesChange: (changedResource: Resource, checked?: boolean) => void;
  extractionType: ExtractionType;
}

export const WorkloadOptions: React.FunctionComponent<IWorkloadOptionsProps> = (props) => {
  const { workloads, resources } = props;

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

  return (
    <>
      {workloads &&
        workloads.length > 0 &&
        workloads.map((workload: Workload) => (
          <ContentCard title={workload.title}>
            {workload.description && (
              <div className={mergeStyles({ paddingBottom: '30px' })}>{workload.description}</div>
            )}
            <Stack horizontal wrap styles={stackStyles} tokens={wrapStackTokens}>
              {resources
                .filter((resource) => resource.workload === workload.key)
                .map((resource: Resource) => (
                  <StackItem styles={stackItemStyles}>
                    <Checkbox
                      label={resource.name}
                      checked={resource.checked}
                      onChange={(ev, checked) => props.onSelectedResourcesChange(resource, checked)}
                      value={resource.name}
                      key={resource.name}
                    />
                  </StackItem>
                ))}
            </Stack>
          </ContentCard>
        ))}
    </>
  );
};
