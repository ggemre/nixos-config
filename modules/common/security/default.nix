_: {
  security = {
    sudo = {
      enable = true;
      configFile = ''
        Defaults timestamp_timeout=30
        Defaults !lecture
        Defaults pwfeedback
      '';
    };

    rtkit.enable = true;
  };

  users.users.root.hashedPassword = "!"; # Disable root
}
