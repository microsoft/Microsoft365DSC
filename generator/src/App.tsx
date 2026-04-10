import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import './App.css';
import { GeneratorPage } from './pages/GeneratorPage/GeneratorPage';
import TelemetryProvider from './components/TelemetryProvider/TelemetryProvider';

export const App: React.FunctionComponent = (theme) => {
  return (
    <BrowserRouter>
      <TelemetryProvider instrumentationKey={import.meta.env.VITE_INSTRUMENTATION_KEY}>
        <GeneratorPage></GeneratorPage>
      </TelemetryProvider>
    </BrowserRouter>
  );
};
