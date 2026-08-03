{lib, ...}: {
  users.users.root = {
    initialPassword = "hunter2";
    initialHashedPassword = lib.mkForce null;
  };

  services.getty = {
    autologinUser = lib.mkForce "root";
    helpLine = lib.mkForce ''
      -------------------------------------

      The account "root" has the password "hunter2".

      -------------------------------------
    '';
  };

  documentation.enable = false;
  sdImage.compressImage = true;
  image.baseName = "sd-installer";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
