import { INavLink, INavLinkGroup, INavStyles, Nav } from '@fluentui/react';
import * as React from 'react';
import { useHistory } from 'react-router-dom';
import { Workload } from '../../models/Workload';

export interface ISideNavigationProps {
  workloads: Workload[];
}

const SideNavigationComponent: React.FunctionComponent<ISideNavigationProps> = (props) => {
  const [workloads] = React.useState<Workload[]>(props.workloads);
  const [navigationItems, setNavigationItems] = React.useState<INavLinkGroup[]>([]);
  const history = useHistory();

  const navStyles: Partial<INavStyles> = {
    groupContent: {
      animationDuration: '0',
    },
    root: {
      overflowY: 'auto',
      width: '220px',
    },
  };

  React.useEffect(() => {
    let navigation: INavLinkGroup[] = [
      {
        links: [
          {
            name: 'Home',
            url: '#Home',
          },
        ],
      },
    ];
    workloads.forEach((workload: Workload) => {
      navigation[0].links.push({
        name: workload.title,
        url: `#${workload.title}`,
      });
    });

    setNavigationItems(navigation);
  }, [workloads]);

  return (
    <Nav
      ariaLabel="Navigation"
      styles={navStyles}
      groups={navigationItems}
      onLinkClick={(ev?: React.MouseEvent<HTMLElement>, item?: INavLink) => {
        history.push(item!.url);
      }}
    />
  );
};

export const SideNavigation = React.memo(SideNavigationComponent);
