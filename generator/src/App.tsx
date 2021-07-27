import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { RecoilRoot } from 'recoil';
import './App.css';
import { GeneratorPage } from './pages/GeneratorPage/GeneratorPage';

export const App: React.FunctionComponent = (theme) => {
  return (
    <RecoilRoot>
      <BrowserRouter>
        <GeneratorPage></GeneratorPage>
      </BrowserRouter>
    </RecoilRoot>
  );
};
