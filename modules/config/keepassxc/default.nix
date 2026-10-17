_: {
  programs.keepassxc = {
    enable = true;

    settings = {
      Browser = {
        Enabled = false;
      };

      GUI = {
        AdvancedSettings = true;
        # ApplicationTheme = "dark";
        CompactMode = true;
        HideMenubar = true;
        MovableToolbar = false;
        ShowTrayIcon = false;
        ToolButtonStyle = 0;
        TrayIconAppearance = "colorful";
        HidePasswords = true;
      };

      SSHAgent = {
        Enabled = true;
      };

      PasswordGenerator = {
        AdvancedMode = false;
        Braces = true;
        Dashes = true;
        EnsureEvery = false;
        ExcludeAlike = false;
        Length = 32;
        Logograms = false;
        Math = false;
        Punctuation = true;
        Quotes = true;
        Type = 0;
        WordCount = 8;
      };

      Security = {
        IconDownloadFallback = true;
      };
    };
  };
}
