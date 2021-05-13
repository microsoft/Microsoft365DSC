import { ExtractionModes } from './ExtractionModes';
import { Resource } from './Resource';

export interface Workload {
  title: string;
  description: string;
  key: string;
  //resources: Resource[];
  extractionModes: ExtractionModes;
}
