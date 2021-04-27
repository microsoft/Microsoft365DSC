import { IStackProps, mergeStyles, Stack } from '@fluentui/react';
import React from 'react';
import { BrowserRouter, Route, Switch } from 'react-router-dom';
import './App.css';
import { Header } from './components/Header';
import { SideNavigation } from './components/SideNavigation/SideNavigation';
import { GeneratorPage } from './pages/GeneratorPage/GeneratorPage';
import { HomePage } from './pages/HomePage/HomePage';

export const App: React.FunctionComponent = (theme) => {
  const Content = (props: IStackProps) => (
    <Stack horizontal gap={10} className={mergeStyles({ overflow: 'hidden' })} {...props} />
  );

  const Sidebar = (props: IStackProps) => (
    <Stack
      disableShrink
      gap={20}
      grow={20}
      className={mergeStyles({
        paddingRight: '1rem',
      })}
      verticalFill={true}
      {...props}
    />
  );

  const Main = (props: IStackProps) => (
    <Stack
      grow={80}
      className={mergeStyles({ padding: '40px', backgroundColor: '#faf9f8' })}
      disableShrink
      {...props}
    />
  );

  const Page = (props: IStackProps) => (
    <Stack
      gap={10}
      className={mergeStyles({
        selectors: {
          ':global(body)': {
            padding: 0,
            margin: 0,
          },
        },
      })}
      {...props}
    />
  );

  return (
    <Page>
      <BrowserRouter>
        <Header></Header>
        <Content>
          <Sidebar>
            <SideNavigation></SideNavigation>
          </Sidebar>
          <Main>
            <Switch>
              <Route path="/" exact={true} component={HomePage} />
              <Route path="/generator" component={GeneratorPage} />
            </Switch>
          </Main>
        </Content>
      </BrowserRouter>
    </Page>
  );
};
