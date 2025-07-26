# Barely adapted version of function `toHyprconf` from
# https://github.com/nix-community/home-manager/blob/master/modules/lib/generators.nix
{lib}: {
    toHyprConf = attrs: let
      indentLevel = 0;
      importantPrefixes = ["$" "bezier" "name"];
      inherit
        (lib)
        all
        concatMapStringsSep
        concatStrings
        concatStringsSep
        filterAttrs
        foldl
        generators
        hasPrefix
        isAttrs
        isList
        mapAttrsToList
        replicate
        ;

      initialIndent = concatStrings (replicate indentLevel "  ");

      toHyprConf' = indent: attrs: let
        sections = filterAttrs (n: v: isAttrs v || (isList v && all isAttrs v)) attrs;

        mkSection = n: attrs:
          if lib.isList attrs
          then (concatMapStringsSep "\n" (a: mkSection n a) attrs)
          else ''
            ${indent}${n} {
            ${toHyprConf' "  ${indent}" attrs}${indent}}
          '';

        mkFields = generators.toKeyValue {
          listsAsDuplicateKeys = true;
          inherit indent;
        };

        allFields = filterAttrs (n: v: !(isAttrs v || (isList v && all isAttrs v))) attrs;

        isImportantField = n: _:
          foldl (acc: prev:
            if hasPrefix prev n
            then true
            else acc)
          false
          importantPrefixes;

        importantFields = filterAttrs isImportantField allFields;

        fields = builtins.removeAttrs allFields (mapAttrsToList (n: _: n) importantFields);
      in
        mkFields importantFields
        + concatStringsSep "\n" (mapAttrsToList mkSection sections)
        + mkFields fields;
    in
      toHyprConf' initialIndent attrs;
}
