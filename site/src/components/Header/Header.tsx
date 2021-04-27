import * as React from 'react';
import { Stack, Link, ILinkStyleProps, ILinkStyles, ITheme, IStackProps } from '@fluentui/react';
import { IThemeRules, ThemeGenerator } from '@fluentui/react/lib/ThemeGenerator';
import { mergeStyles } from '@fluentui/merge-styles';

export interface IHeaderProps {
  themeRules?: IThemeRules;
}

export interface IHeaderState {
  showPanel: boolean;
  jsonTheme: string;
  powershellTheme: string;
  themeAsCode: any;
}

const microsoftLogo = mergeStyles({
  width: '120px',
  display: 'block',
});

const pipeFabricStyles = (p: ILinkStyleProps): ILinkStyles => ({
  root: {
    textDecoration: 'none',
    color: p.theme.semanticColors.bodyText,
    fontWeight: '600',
    fontSize: p.theme.fonts.medium.fontSize,
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

export class Header extends React.Component<IHeaderProps, IHeaderState> {
  constructor(props: any) {
    super(props);
    this.state = {
      showPanel: false,
      jsonTheme: '',
      powershellTheme: '',
      themeAsCode: <div />,
    };
  }

  public render(): JSX.Element {
    return (
      <Stack horizontal verticalAlign="center" grow={0} styles={headerStackStyles}>
        <Stack horizontal grow={1} verticalAlign="center">
          <a
            href="https://www.microsoft365dsc.com"
            title="Microsoft365DSC Home Page"
            aria-label="Microsoft365DSC Home Page"
            className={microsoftLogo}
          >
            <img
              src="https://themingdesigner.blob.core.windows.net/$web/MicrosoftLogo.png"
              alt="Microsoft365DSC"
              className={microsoftLogo}
            />
          </a>
          <Link
            href="https://www.microsoft365dsc.com"
            title="Microsoft Theme Designer page"
            aria-label="Microsoft Fabric Theme Designer page"
            styles={pipeFabricStyles}
          >
            | Configuration-as-Code for the Cloud
          </Link>
        </Stack>
      </Stack>
    );
  }

  private _exportToJson = () => {
    const themeRules = this.props.themeRules!;

    // strip out the unnecessary shade slots from the final output theme
    const abridgedTheme: IThemeRules = {};
    for (const ruleName in themeRules) {
      if (themeRules.hasOwnProperty(ruleName)) {
        if (
          ruleName.indexOf('ColorShade') === -1 &&
          ruleName !== 'primaryColor' &&
          ruleName !== 'backgroundColor' &&
          ruleName !== 'foregroundColor' &&
          ruleName.indexOf('body') === -1
        ) {
          abridgedTheme[ruleName] = themeRules[ruleName];
        }
      }
    }

    this.setState({
      jsonTheme: JSON.stringify(ThemeGenerator.getThemeAsJson(abridgedTheme), undefined, 2),
      powershellTheme: ThemeGenerator.getThemeForPowerShell(abridgedTheme),
      themeAsCode: ThemeGenerator.getThemeAsCodeWithCreateTheme(abridgedTheme),
    });
  };

  private _showPanel = () => {
    this.setState({ showPanel: true });
    this._exportToJson();
  };

  private _hidePanel = () => {
    this.setState({ showPanel: false });
  };
}
