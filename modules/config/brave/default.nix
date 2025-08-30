{
  config,
  self,
  ...
}: {
  imports = [
    self.nixosModules.programs.brave
  ];

  programs.brave = {
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
