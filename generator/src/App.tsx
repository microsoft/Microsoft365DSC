import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import { RecoilRoot } from 'recoil';
import './App.css';
import { GeneratorPage } from './pages/GeneratorPage/GeneratorPage';
import TelemetryProvider from './components/TelemetryProvider/TelemetryProvider';

export const App: React.FunctionComponent = (theme) => {
  return (
    <RecoilRoot>
      <BrowserRouter>
        <TelemetryProvider instrumentationKey={process.env.REACT_APP_INSTRUMENTATION_KEY}>
          <GeneratorPage></GeneratorPage>
        </TelemetryProvider>
      </BrowserRouter>
    </RecoilRoot>
  );
};
