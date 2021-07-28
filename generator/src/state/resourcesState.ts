import { atom } from 'recoil';
import { Resource } from '../models/Resource';

export const availableResourcesState = atom<Resource[]>({
  key: 'availableResourcesState',
  default: [],
});

export const selectedResourcesState = atom<Resource[]>({
  key: 'selectedResourcesState',
  default: [],
});
