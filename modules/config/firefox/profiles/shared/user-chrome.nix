{config}: let
  c = config.theme.colorsWithHashtag;
in ''
    :root {
    --uc-bg: ${c.base00};
    --uc-bg-alt: ${c.base01};
    --uc-fg: ${c.base05};
    --uc-muted: ${c.base04};
    --uc-accent: ${c.base0D};

    --lwt-frame: var(--uc-bg) !important;
    --lwt-accent-color: var(--uc-bg) !important;
    --lwt-text-color: var(--uc-fg) !important;

    --toolbar-background-color: var(--uc-bg) !important;
    --toolbar-color: var(--uc-fg) !important;

    --toolbar-field-background-color: var(--uc-bg) !important;
    --toolbar-field-background-color-focus: var(--uc-bg-alt) !important;
    --toolbar-field-color: var(--uc-fg) !important;
    --toolbar-field-focus-color: var(--uc-fg) !important;

    --lwt-selected-tab-background-color: var(--uc-bg-alt) !important;
    --toolbarbutton-hover-background: var(--uc-bg-alt) !important;
    --toolbarbutton-active-background: var(--uc-bg-alt) !important;

    --toolbox-background-color: var(--uc-bg) !important;
    --toolbox-background-color-inactive: var(--uc-muted) !important;

    --toolbarseparator-color: var(--uc-accent) !important;

    --urlbar-box-bgcolor: var(--uc-bg-alt) !important;
    --urlbar-box-hover-bgcolor: var(--uc-bg-alt) !important;
    --urlbar-box-focus-bgcolor: var(--uc-bg-alt) !important;
    --urlbar-box-text-color: var(--uc-muted) !important;
    --urlbar-box-hover-text-color: var(--uc-fg) !important;
    --urlbar-box-focus-text-color: var(--uc-fg) !important;
  }

  .identity-color-blue {
    --identity-tab-color: ${c.base0D};
    --identity-icon-color: ${c.base0D};
  }

  .identity-color-turquoise {
    --identity-tab-color: ${c.base0C};
    --identity-icon-color: ${c.base0C};
  }

  .identity-color-green {
    --identity-tab-color: ${c.base0B};
    --identity-icon-color: ${c.base0B};
  }

  .identity-color-yellow {
    --identity-tab-color: ${c.base0A};
    --identity-icon-color: ${c.base0A};
  }

  .identity-color-orange {
    --identity-tab-color: ${c.base09};
    --identity-icon-color: ${c.base09};
  }

  .identity-color-red {
    --identity-tab-color: ${c.base08};
    --identity-icon-color: ${c.base08};
  }

  .identity-color-pink {
    --identity-tab-color: ${c.base0F};
    --identity-icon-color: ${c.base0F};
  }

  .identity-color-purple {
    --identity-tab-color: ${c.base0E};
    --identity-icon-color: ${c.base0E};
  }

  .titlebar-buttonbox-container,
  .titlebar-spacer,
  #firefox-view-button,
  #alltabs-button {
    display: none !important;
  }

  #tabbrowser-tabs::before {
    border-inline-start: 0 !important;
  }
''
