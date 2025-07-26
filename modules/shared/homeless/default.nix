# Thanks to @sioodmy for the "Homix" flake, from which I pulled much reference and inspiration
# https://github.com/sioodmy/homix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    homeless = lib.mkOption {
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
            description = ''
              Path to the file relative to the $HOME directory.
            '';
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
              name' = "homeless-" + lib.replaceStrings ["/"] ["-"] name;
            in
              lib.mkDerivedConfig options.text (pkgs.writeText name')
          );
        };
      }));
    };
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options.homeless = lib.mkEnableOption "Enable homeless for selected user";
      });
    };
  };

  config = let
    users = builtins.attrNames (
      lib.filterAttrs (
        _name: user:
          lib.isAttrs user && user ? homeless && user.homeless
      )
      config.users.users
    );

    homeless-link = let
      files = builtins.map (f: ''
        FILE=$HOME/${f.path}
        mkdir -p "$(dirname "$FILE")"
        if [ ! -e "$FILE" ] || [ ! -L "$FILE" ] || [ "$(readlink "$FILE")" != "${f.source}" ]; then
            ln -sf "${f.source}" "$FILE"
        fi
      '') (lib.attrValues config.homeless);
    in
      pkgs.writeShellScript "homeless-link" ''
        #!/bin/sh
        ${builtins.concatStringsSep "\n" files}
      '';

    mkService = user: {
      name = "homeless-${user}";
      value = {
        wantedBy = ["multi-user.target"];
        description = "Setup home environment for ${user}.";
        serviceConfig = {
          Type = "oneshot";
          User = "${user}";
          ExecStart = "${homeless-link}";
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
