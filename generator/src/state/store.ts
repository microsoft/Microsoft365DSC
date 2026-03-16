import { create } from 'zustand';
import { AuthenticationType } from '../models/AuthenticationType';
import { ExtractionType } from '../models/ExtractionType';
import { Resource } from '../models/Resource';
import { Workload } from '../models/Workload';

interface AppState {
  authenticationType: AuthenticationType;
  setAuthenticationType: (type: AuthenticationType) => void;

  extractionType: ExtractionType;
  setExtractionType: (type: ExtractionType) => void;

  generatorPanelOpen: boolean;
  setGeneratorPanelOpen: (open: boolean) => void;

  loading: boolean;
  setLoading: (loading: boolean) => void;

  selectedResources: Resource[];
  setSelectedResources: (resources: Resource[] | ((prev: Resource[]) => Resource[])) => void;

  selectedWorkload: string | undefined;
  setSelectedWorkload: (workload: string | undefined) => void;

  workloads: Workload[];
  setWorkloads: (workloads: Workload[]) => void;
}

export const useAppStore = create<AppState>((set) => ({
  authenticationType: AuthenticationType.Credentials,
  setAuthenticationType: (type) => set({ authenticationType: type }),

  extractionType: ExtractionType.Default,
  setExtractionType: (type) => set({ extractionType: type }),

  generatorPanelOpen: false,
  setGeneratorPanelOpen: (open) => set({ generatorPanelOpen: open }),

  loading: false,
  setLoading: (loading) => set({ loading }),

  selectedResources: [],
  setSelectedResources: (resources) =>
    set((state) => ({
      selectedResources:
        typeof resources === 'function' ? resources(state.selectedResources) : resources,
    })),

  selectedWorkload: 'Home',
  setSelectedWorkload: (workload) => set({ selectedWorkload: workload }),

  workloads: [],
  setWorkloads: (workloads) => set({ workloads }),
}));
