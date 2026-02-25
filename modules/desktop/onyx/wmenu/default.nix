{selfModules, ...}: {
  imports = [
    selfModules.programs.wmenu
  ];
  programs.wmenu = {
    enable = true;
  };
}
