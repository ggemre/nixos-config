# gen-config-tree.nix
{
  lib,
  self,
  ...
}: attrs: let
  toRON = self.lib.generators.ron;

  go = path: value:
    if builtins.isAttrs value
    then let
      lastElem =
        if path == []
        then null
        else lib.last path;
    in
      if
        lastElem
        != null
        && builtins.match "v[0-9]+" lastElem != null
      then
        # Inside version dir: each attr is a file
        lib.mapAttrsToList (
          name: v: let
            relPath = ".config/cosmic/" + (lib.concatStringsSep "/" (path ++ [ name ]));
          in { ${relPath} = { text = toRON v; }; }
        )
        value
      else
        # Keep recursing
        lib.flatten (lib.mapAttrsToList (name: v: go (path ++ [ name ]) v) value)
    else
      # Fallback: raw leaf (shouldn’t usually happen)
      let
        relPath = ".config/cosmic/" + (lib.concatStringsSep "/" path);
      in [ { ${relPath} = { text = toRON value; }; } ];
in
  lib.mkMerge (go [] attrs)
