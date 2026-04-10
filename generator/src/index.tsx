import { createRoot } from 'react-dom/client';
import { App } from './App';
import { mergeStyles } from '@fluentui/react';
import { initializeIcons } from '@uifabric/icons';
import { FluentProvider, webLightTheme } from '@fluentui/react-components';

initializeIcons(undefined, { disableWarnings: true });

// Inject some global styles
mergeStyles({
  ':global(body,html,#root)': {
    margin: 0,
    padding: 0,
    height: '100vh',
  },
});

const root = createRoot(document.getElementById('root')!);
root.render(
  <FluentProvider theme={webLightTheme}>
    <App />
  </FluentProvider>
);
