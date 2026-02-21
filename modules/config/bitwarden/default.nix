{
  config,
  pkgs,
  self,
  ...
}: let
  bitwardenCorrectTheme =
    if config.theme.variant == "dark"
    then
      (pkgs.bitwarden-desktop.overrideAttrs (old: {
        postFixup =
          (old.postFixup or "")
          + ''
            wrapProgram $out/bin/bitwarden \
              --add-flags "--force-dark-mode"
          '';
      }))
    else pkgs.bitwarden-desktop;
in {
  imports = [ self.nixosModules.programs.bitwarden ];

  programs.bitwarden.enable = true;
  programs.bitwarden.package = bitwardenCorrectTheme;
}
