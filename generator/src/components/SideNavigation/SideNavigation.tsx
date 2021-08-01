import { INavLink, INavLinkGroup, INavStyles, Nav } from '@fluentui/react';
import * as React from 'react';
import { useHistory } from 'react-router-dom';
import { useRecoilState } from 'recoil';
import { selectedWorkloadState } from '../../state/selectedWorkloadState';

export interface ISideNavigationProps {
  items: INavLinkGroup[];
}

const SideNavigationComponent: React.FunctionComponent<ISideNavigationProps> = (props) => {
  const { items } = props;
  const history = useHistory();
  const [selectedWorkload, setSelectedWorkload] = useRecoilState(selectedWorkloadState);

  const navStyles: Partial<INavStyles> = {
    groupContent: {
      animationDuration: '0',
    },
    root: {
      overflowY: 'auto',
      width: '220px',
    },
  };

  return (
    <Nav
      ariaLabel="Navigation"
      styles={navStyles}
      groups={items}
      selectedKey={selectedWorkload}
      onLinkClick={(ev?: React.MouseEvent<HTMLElement>, item?: INavLink) => {
        history.push(item!.url);
        setSelectedWorkload(item?.key);
      }}
    />
  );
};

export const SideNavigation = React.memo(SideNavigationComponent);
