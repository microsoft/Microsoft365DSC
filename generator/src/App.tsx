import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import './App.css';
import { GeneratorPage } from './pages/GeneratorPage/GeneratorPage';

export const App: React.FunctionComponent = (theme) => {
  return (
    <BrowserRouter>
      <GeneratorPage></GeneratorPage>
    </BrowserRouter>
  );
};
