_: {
  programs.yazi = {
    enable = true;

    # plugins = {
    #   inherit (pkgs.yaziPlugins) mount;
    # };

    # settings.keymap = {
    #   mgr.prepend_keymap = [
    #     {
    #       on = "M";
    #       run = "plugin mount";
    #     }
    #   ];
    # };
  };
}
