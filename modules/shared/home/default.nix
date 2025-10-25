# Thanks to @sioodmy for the "Homix" flake, from which I pulled much reference and inspiration
# https://github.com/sioodmy/homix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    home = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule ({
        name,
        config,
        options,
        ...
      }: {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
            readOnly = true;
            description = "Path to the file relative to the $HOME directory.";
          };
          source = lib.mkOption {
            type = lib.types.path;
            description = "Path of the source file or directory.";
          };
          text = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.lines;
            description = "Text of the file.";
          };
        };
        config = {
          path = lib.mkDefault name;
          source = lib.mkIf (config.text != null) (
            let
              name' = "home-" + builtins.replaceStrings [ "/" ] [ "-" ] name;
            in
              lib.mkDerivedConfig options.text (pkgs.writeText name')
          );
        };
      }));
    };
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.manageHome = lib.mkEnableOption "Enable home management for selected user";
      });
    };
  };

  config = let
    users = builtins.attrNames (
      lib.filterAttrs (
        _name: user:
          lib.isAttrs user && user ? manageHome && user.manageHome
      )
      config.users.users
    );

    home-link = let
      files = builtins.map (f: ''
        FILE=$HOME/${f.path}
        mkdir -p "$(dirname "$FILE")"
        if [ ! -e "$FILE" ] || [ ! -L "$FILE" ] || [ "$(readlink "$FILE")" != "${f.source}" ]; then
            ln -sf "${f.source}" "$FILE"
        fi
      '') (lib.attrValues config.home);
    in
      pkgs.writeShellScript "home-link" ''
        #!/bin/sh
        ${builtins.concatStringsSep "\n" files}
      '';

    mkService = user: {
      name = "home-${user}";
      value = {
        wantedBy = [ "multi-user.target" ];
        description = "Setup home environment for ${user}.";
        serviceConfig = {
          Type = "oneshot";
          User = "${user}";
          ExecStart = "${home-link}";
        };
        environment = {
          HOME = config.users.users.${user}.home or "/home/${user}";
        };
      };
    };

    services = builtins.listToAttrs (builtins.map mkService users);
  in {
    systemd.services = services;
  };
}
