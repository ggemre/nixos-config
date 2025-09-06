{self, ...}: {
  imports = [
    self.nixosModules.programs.zen
    ./policies.nix
  ];

  programs.zen = {
    enable = true;
    searchJsonArchive = ./search.json.mozlz4;
  };
}
