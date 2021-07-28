import { atom } from 'recoil';
import { Workload } from '../models/Workload';

export const workloadsState = atom<Workload[]>({
  key: 'workloadsState',
  default: [],
});
