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

      To reinstall an existing host, run `reinstall <HOST>` where
      <HOST> is the hostname to install.

      -------------------------------------
    '';
  };

  documentation.enable = false;
  isoImage.compressImage = true;
  image.baseName = lib.mkForce "cd-installer";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    substituters = [
      "https://ggemre.cachix.org"
    ];
    trusted-public-keys = [
      "ggemre.cachix.org-1:ULcTF3sXFvs42La9WBB+hUOLuI3eFExxQBpRMgOzTdo="
    ];
  };
}
