# Barely adapted version of function `toHyprconf` from
# https://github.com/nix-community/home-manager/blob/master/modules/lib/generators.nix
{lib}: attrs: let
  indentLevel = 0;
  importantPrefixes = [ "$" "bezier" "name" ];

  initialIndent = lib.concatStrings (lib.replicate indentLevel "  ");

  toHyprConf' = indent: attrs: let
    sections = lib.filterAttrs (_: v: lib.isAttrs v || (lib.isList v && lib.all lib.isAttrs v)) attrs;

    mkSection = n: attrs:
      if lib.isList attrs
      then (lib.concatMapStringsSep "\n" (a: mkSection n a) attrs)
      else ''
        ${indent}${n} {
        ${toHyprConf' "  ${indent}" attrs}${indent}}
      '';

    mkFields = lib.generators.toKeyValue {
      listsAsDuplicateKeys = true;
      inherit indent;
    };

    allFields = lib.filterAttrs (_: v: !(lib.isAttrs v || (lib.isList v && lib.all lib.isAttrs v))) attrs;

    isImportantField = n: _:
      lib.foldl (acc: prev:
        if lib.hasPrefix prev n
        then true
        else acc)
      false
      importantPrefixes;

    importantFields = lib.filterAttrs isImportantField allFields;

    fields = builtins.removeAttrs allFields (lib.mapAttrsToList (n: _: n) importantFields);
  in
    mkFields importantFields
    + lib.concatStringsSep "\n" (lib.mapAttrsToList mkSection sections)
    + mkFields fields;
in
  toHyprConf' initialIndent attrs
