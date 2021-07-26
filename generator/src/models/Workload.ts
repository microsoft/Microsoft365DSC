import { ExtractionModes } from './ExtractionModes';
import { Resource } from './Resource';

export interface Workload {
  title: string;
  iconName: string;
  id: string;
  extractionModes: ExtractionModes;
}
