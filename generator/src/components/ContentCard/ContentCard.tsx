import { DefaultEffects, Icon, IStyle, mergeStyles } from '@fluentui/react';
import * as React from 'react';
import { useState } from 'react';
import { useHistory } from 'react-router-dom';
import { getTheme } from '@fluentui/react';
import { useSetRecoilState } from 'recoil';
import { selectedWorkloadState } from '../../state/selectedWorkloadState';

export interface IContentCardProps {
  title?: string;
  iconName?: string;
}
export const ContentCard: React.FunctionComponent<IContentCardProps> = (props) => {
  const history = useHistory();
  const [isHovered, setIsHovered] = useState(false);
  const theme = getTheme();
  const setSelectedWorkload = useSetRecoilState(selectedWorkloadState);

  const contentCardStyles: IStyle = {
    backgroundColor: theme.palette.white,
    padding: '40px',
    boxShadow: DefaultEffects.elevation4,
  };

  const titleStyles: IStyle = {
    marginTop: '-70px',
    paddingBottom: '16px',
    paddingTop: '60px',
    display: 'flex',
    alignItems: 'center'
  };

  const iconStyles = mergeStyles({
    fontSize: 25,
    height: 25,
    width: 25,
    margin: '0 8px 0 0',
  });

  const linkIconStyles = mergeStyles({
    fontSize: 16,
    height: 16,
    width: 16,
    color: theme.palette.themePrimary,
    margin: '0 0 0 8px',
    cursor: 'pointer'
  });

  return (
    <div className={`${mergeStyles(contentCardStyles)} section-title`}>
      <div>
        {props.title && (
          <h2
            className={mergeStyles(titleStyles)}
            id={props.title}
            onMouseEnter={() => setIsHovered(true)}
            onMouseLeave={() => setIsHovered(false)}>
              {props.iconName && <Icon iconName={props.iconName} className={iconStyles} />}
              {props.title}
              {isHovered && (
                <Icon
                iconName={"Link"}
                className={linkIconStyles}
                onClick={(ev?: React.MouseEvent<HTMLElement>) => {
                  let hash = `#${props.title}`;
                  window.location.hash = hash;
                  history.push(hash);
                  setSelectedWorkload(props.title);
                }} />
              )}
          </h2>
        )}

        {props.children}
      </div>
    </div>
  );
};
