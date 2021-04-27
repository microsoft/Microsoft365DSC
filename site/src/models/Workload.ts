import { ExtractionModes } from './ExtractionModes';
import { Resource } from './Resource';

export interface Workload {
  title: string;
  description: string;
  resources: Resource[];
  extractionModes: ExtractionModes;
}
