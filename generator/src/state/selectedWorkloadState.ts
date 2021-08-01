import { atom } from 'recoil';

export const selectedWorkloadState = atom<string | undefined>({
  key: 'selectedWorkloadState',
  default: "Home",
});
