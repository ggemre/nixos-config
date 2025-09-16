{self, ...}: {
  imports = [
    self.nixosModules.services.cosmic
    ./colors.nix
  ];

  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic = {
    enable = true;
    settings = {
      "com.system76.CosmicSettings.Wallpaper".v1 = {
        "custom-images" = [
          "$HOME/media/pictures/wallpapers/*.png"
        ];
      };
    };
  };
}
