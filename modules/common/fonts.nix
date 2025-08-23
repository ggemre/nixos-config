# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/fonts/packages.nix
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/fonts/fontconfig.nix
{pkgs, ...}: let
  defaultFonts = [
    pkgs.dejavu_fonts
    pkgs.freefont_ttf
    pkgs.gyre-fonts # TrueType substitutes for standard PostScript fonts
    pkgs.liberation_ttf
    pkgs.unifont
    pkgs.noto-fonts-color-emoji
  ];
in {
  fonts.packages = defaultFonts;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["DejaVu Serif"];
      sansSerif = ["DejaVu Sans"];
      monospace = ["DejaVu Sans Mono"];
      emoji = ["Noto Color Emoji"];
    };
    allowBitmaps = true;
  };
}
