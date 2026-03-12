{lib}: attrs: let
  boolToInt = b:
    if b
    then 1
    else 0;
in
  lib.generators.toKeyValue { listsAsDuplicateKeys = true; }
  (lib.mapAttrs (
      _: v:
        if lib.isBool v
        then boolToInt v
        else v
    )
    attrs)
