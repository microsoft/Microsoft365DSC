import { atom } from 'recoil';

export const generatorPanelState = atom<boolean>({
  key: 'generatorPanelState',
  default: false,
});
