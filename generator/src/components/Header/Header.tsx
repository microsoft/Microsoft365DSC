import * as React from 'react';
import { Stack, Link, ILinkStyleProps, ILinkStyles, ITheme, IStackProps, PrimaryButton } from '@fluentui/react';
import { mergeStyles } from '@fluentui/merge-styles';

export interface IHeaderProps {
  onGenerate: (event: React.MouseEvent<HTMLButtonElement>) => void;
}

const microsoftLogo = mergeStyles({
  height: '20px',
  display: 'block',
  paddingRight: '5px',
});

const pipeFabricStyles = (p: ILinkStyleProps): ILinkStyles => ({
  root: {
    textDecoration: 'none',
    color: p.theme.semanticColors.bodyText,
    fontWeight: '600',
    fontSize: p.theme.fonts.medium.fontSize,
    paddingLeft: '5px',
  },
});

const headerStackStyles = (p: IStackProps, theme: ITheme) => ({
  root: {
    backgroundColor: theme.semanticColors.bodyBackground,
    minHeight: 47,
    padding: '0 32px',
    boxShadow: theme.effects.elevation16,
  },
});

const headerStyles = mergeStyles({
  position: 'fixed',
  top: 0,
  left: 0,
  width: '100%',
  zIndex: 1,
});

const HeaderComponent: React.FunctionComponent<IHeaderProps> = (props: IHeaderProps) => {
  return (
    <Stack horizontal verticalAlign="center" grow={0} styles={headerStackStyles} className={headerStyles}>
      <Stack horizontal grow={1} verticalAlign="center">
        <a
          href={process.env.REACT_APP_ROOT_SITE_URL}
          title={process.env.REACT_APP_ROOT_SITE_NAME}
          aria-label={process.env.REACT_APP_ROOT_SITE_NAME}
          className={microsoftLogo}
          target="_blank"
          rel="noreferrer"
        >
          <img src="/img/Microsoft365DSC.png" alt={process.env.REACT_APP_SITE_NAME} className={microsoftLogo} />
        </a>
        |
        <Link
          href={'#Home'}
          title={process.env.REACT_APP_SITE_NAME}
          aria-label={process.env.REACT_APP_SITE_NAME}
          styles={pipeFabricStyles}
        >
          {process.env.REACT_APP_SITE_DESCRIPTION}
        </Link>
      </Stack>
      <PrimaryButton text="Generate" onClick={props.onGenerate} />
    </Stack>
  );
};

export const Header = React.memo(HeaderComponent);
