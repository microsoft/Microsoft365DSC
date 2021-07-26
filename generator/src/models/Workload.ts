import { ExtractionModes } from './ExtractionModes';
import { Resource } from './Resource';

export interface Workload {
  title: string;
  iconName: string;
  key: string;
  extractionModes: ExtractionModes;
}
