import { DefaultEffects, Icon, IStyle, mergeStyles } from '@fluentui/react';
import * as React from 'react';
import './ContentCard.css';

export interface IContentCardProps {
  title?: string;
  iconName?: string;
}
export const ContentCard: React.FunctionComponent<IContentCardProps> = (props) => {
  const contentCardStyles: IStyle = {
    backgroundColor: '#ffffff',
    padding: '40px',
    boxShadow: DefaultEffects.elevation4,
  };

  const titleStyles: IStyle = {
    marginTop: '0',
  };

  const iconStyles = mergeStyles({
    fontSize: 50,
    height: 50,
    width: 50,
    margin: '0 25px',
  });

  return (
    <div className={`${mergeStyles(contentCardStyles)} section-title`}>
      <div>
        {props.title && (
          <h2 className={mergeStyles(titleStyles)} id={props.title}>
            {props.title}
            {props.iconName && <Icon iconName={props.iconName} className={iconStyles} />}
          </h2>
        )}

        {props.children}
      </div>
    </div>
  );
};
