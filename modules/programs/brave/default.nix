{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.brave
  ];

  programs.chromium = {
    enable = true;

    extraOpts = {
      BrowserSignin = 0;
      SyncDisabled = true;
      PasswordManagerEnabled = false;
      SpellcheckEnabled = false;
      BrowserThemeColor = config.theme.colorsWithHashtag.base00;
      OsColorMode = config.theme.variant;
    };

    extensions = [
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsor block
    ];
  };
}
