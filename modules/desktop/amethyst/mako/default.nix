{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    self.nixosModules.services.mako
  ];

  services.mako = {
    enable = true;

    settings = {
      actions = true;
      anchor = "top-right";
      layer = "overlay";
      background-color = config.theme.colorsWithHashtag.base00;
      border-color = config.theme.colorsWithHashtag.base0D;
      border-radius = 10;
      on-notify = "exec ${lib.getExe' pkgs.libcanberra-gtk3 "canberra-gtk-play"} -i message-new-instant";
    };
  };
}
