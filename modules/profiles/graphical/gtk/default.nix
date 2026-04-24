{config, ...}: let
  preferDark = config.theme.variant == "dark";
  gtkTheme =
    if preferDark
    then "Adwaita-Dark"
    else "Adwaita";
in {
  environment.etc = {
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name = ${gtkTheme}
      gtk-application-prefer-dark-theme = ${builtins.toString preferDark}
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-theme-name = ${gtkTheme}
      gtk-application-prefer-dark-theme = ${builtins.toString preferDark}
    '';
    "xdg/gtk-2.0/gtkrc".text = ''
      gtk-theme-name = "${gtkTheme}"
    '';
  };
}
