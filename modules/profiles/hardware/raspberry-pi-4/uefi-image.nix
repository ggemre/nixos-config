# Thanks to @matthewcroughan for figuring out most of this stuff first.
# https://codeberg.org/matthewcroughan/matthew-hardware/src/commit/afbe474d16932167a109c343020f06de48fe6b50/common/generic-uefi-image.nix
{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: let
  configTxt = ''
    [pi4]
    kernel=u-boot.bin
    disable_overscan=1

    [all]
    arm_64bit=1
    enable_uart=1
    avoid_warnings=1
  '';

  efiArch = pkgs.stdenv.hostPlatform.efiArch;
in {
  imports = [
    "${modulesPath}/image/repart.nix"
  ];

  hardware.deviceTree.name = "broadcom/bcm2711-rpi-4-b.dtb";

  boot.loader.systemd-boot.enable = true;
  systemd.repart = {
    enable = true;
    partitions."30-root".Type = "root";
  };

  image.repart = {
    partitions = {
      "20-esp" = {
        contents = {
          "/u-boot.bin".source = "${pkgs.ubootRaspberryPi4_64bit}/u-boot.bin";
          "/config.txt".source = pkgs.writeText "config.txt" configTxt;
          "/".source = "${pkgs.raspberrypifw}/share/raspberrypi/boot";
          "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source = "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";
          "/EFI/Linux/${config.system.boot.loader.ukiFile}".source = "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
        };
        repartConfig = {
          Type = "esp";
          Format = "vfat";
          Label = "ESP";
          SizeMinBytes = "2G";
          GrowFileSystem = true;
        };
        "30-root" = {
          storePaths = [ config.system.build.toplevel ];
          contents."/boot".source = pkgs.runCommand "boot" {} "mkdir $out";
          contents."/nix/var/nix/db".source = let
            closure = pkgs.buildPackages.closureInfo { rootPaths = config.system.build.toplevel; };
            db = pkgs.runCommand "nix-var-nix-db" { nativeBuildInputs = [ pkgs.nix ]; } ''
              export NIX_STATE_DIR=$TMP/var/nix
              nix-store --load-db < ${closure}/registration
              mv $NIX_STATE_DIR/db $out
            '';
          in
            db;
          repartConfig = {
            Type = "root";
            Format = "ext4";
            Label = "nixos";
            Minimize = "guess";
            GrowFileSystem = true;
          };
        };
      };
    };
  };
}
