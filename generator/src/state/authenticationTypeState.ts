import { atom } from 'recoil';
import { AuthenticationType } from '../models/AuthenticationType';

export const authenticationTypeState = atom<AuthenticationType>({
  key: 'authenticationTypeState',
  default: AuthenticationType.Credentials,
});
