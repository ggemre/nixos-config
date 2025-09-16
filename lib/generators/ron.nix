{lib}: let
  sanitizeString = builtins.replaceStrings [ "\n" ''"'' ] [ "\\n" ''\"'' ];

  literalValueToRON = value: let
    vType = builtins.typeOf value;
  in
    if vType == "null"
    then "None"
    else if vType == "bool"
    then
      (
        if value
        then "true"
        else "false"
      )
    else if vType == "int" || vType == "float"
    then toString value
    else if vType == "string"
    then ''"${sanitizeString value}"''
    else throw "Cannot convert type ${vType} to RON literal";

  listToRON = list:
    "[\n"
    + lib.concatStringsSep ",\n" (map (x: "    " + toRON' x) list)
    + ",\n]";

  attrsToTupleRON = attrs:
    "(\n"
    + lib.concatStringsSep ",\n"
    (lib.mapAttrsToList (n: v: "    ${n}: ${toRON' v}") attrs)
    + ",\n)";

  toRON' = value: let
    vType = builtins.typeOf value;
  in
    if vType == "set"
    then attrsToTupleRON value
    else if vType == "list"
    then listToRON value
    else literalValueToRON value;
in
  toRON'
