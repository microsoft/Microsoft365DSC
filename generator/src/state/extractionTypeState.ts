import { atom } from 'recoil';
import { ExtractionType } from '../models/ExtractionType';

export const extractionTypeState = atom<ExtractionType>({
  key: 'extractionTypeState',
  default: ExtractionType.Default,
});
