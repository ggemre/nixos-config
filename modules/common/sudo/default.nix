_: {
  security = {
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      extraConfig = ''
        Defaults timestamp_timeout=30
        Defaults !lecture
      '';
    };
  };
}
