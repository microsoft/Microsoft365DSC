import { INavLink, INavLinkGroup, INavStyles, Nav } from '@fluentui/react';
import * as React from 'react';
import { useHistory } from 'react-router-dom';

export const SideNavigation: React.FunctionComponent = () => {
  const history = useHistory();

  const navLinkGroups: INavLinkGroup[] = [
    {
      links: [
        {
          name: 'Home',
          url: '/',
        },
        {
          name: 'Automate',
          url: '/#Automate',
        },
        {
          name: 'Export',
          url: '/#Export',
        },
        {
          name: 'Synchronize',
          url: '/#Synchronize',
        },
        {
          name: 'Assess',
          url: '/#Assess',
        },
        {
          name: 'Monitor',
          url: '/#Monitor',
        },
        {
          name: 'Report',
          url: '/#Report',
        },
        {
          name: 'Generator',
          url: '/generator',
        },
      ],
    },
  ];
  const navStyles: Partial<INavStyles> = {
    root: {
      boxSizing: 'border-box',
      border: '1px solid #eee',
      overflowY: 'auto',
    },
  };

  return (
    <Nav
      ariaLabel="Nav basic example"
      styles={navStyles}
      groups={navLinkGroups}
      onLinkClick={(ev?: React.MouseEvent<HTMLElement>, item?: INavLink) => {
        ev!.preventDefault();
        history.push(item!.url);
      }}
      selectedKey={history.location.pathname}
    />
  );
};
