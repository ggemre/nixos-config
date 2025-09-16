# Heavily modified adaptation of function `toKdl` from
# https://github.com/nix-community/home-manager/blob/master/modules/lib/generators.nix
{lib}: let
  # ListOf String -> String
  indentStrings = let
    # Although the input of this function is a list of strings,
    # the strings themselves *will* contain newlines, so you need
    # to normalize the list by joining and resplitting them.
    unlines = lib.splitString "\n";
    lines = lib.concatStringsSep "\n";
    indentAll = lines: lib.concatStringsSep "\n" (map (x: "	" + x) lines);
  in
    stringsWithNewlines: indentAll (unlines (lines stringsWithNewlines));

  # String -> String
  sanitizeString = builtins.replaceStrings [ "\n" ''"'' ] [ "\\n" ''\"'' ];

  # OneOf [Int Float String Bool Null] -> String
  literalValueToString = value: let
    vType = builtins.typeOf value;
  in
    if vType == "null"
    then "null"
    else if vType == "bool"
    then
      if value
      then "true"
      else "false"
    else if vType == "int" || vType == "float"
    then toString value
    else if vType == "string"
    then ''"${sanitizeString value}"''
    else throw "Cannot convert type ${vType} to KDL literal";

  # Attrset Conversion
  # String -> AttrsOf Anything -> String
  convertAttrsToKDL = name: attrs: let
    optArgs = map literalValueToString (attrs._args or []);
    optProps = lib.mapAttrsToList (name: value: "${name}=${literalValueToString value}") (
      attrs._props or {}
    );

    orderedChildren = lib.pipe (attrs._children or []) [
      (map (child: lib.mapAttrsToList convertAttributeToKDL child))
      lib.flatten
    ];
    unorderedChildren = lib.pipe attrs [
      (lib.filterAttrs (
        name: _:
          !(builtins.elem name [
            "_args"
            "_props"
            "_children"
          ])
      ))
      (lib.mapAttrsToList convertAttributeToKDL)
    ];
    children = orderedChildren ++ unorderedChildren;
    optChildren = lib.optional (children != []) ''
      {
      ${indentStrings children}
      }'';
  in
    lib.concatStringsSep " " ([ name ] ++ optArgs ++ optProps ++ optChildren);

  # List Conversion
  # String -> ListOf (OneOf [Int Float String Bool Null])  -> String
  convertListOfFlatAttrsToKDL = name: list: let
    flatElements = map literalValueToString list;
  in "${name} ${lib.concatStringsSep " " flatElements}";

  # String -> ListOf Anything -> String
  convertListOfNonFlatAttrsToKDL = name: list: ''
    ${name} {
    ${indentStrings (map (x: convertAttributeToKDL "-" x) list)}
    }'';

  # String -> ListOf Anything  -> String
  convertListToKDL = name: list: let
    elementsAreFlat =
      !lib.any (
        el:
          builtins.elem (builtins.typeOf el) [
            "list"
            "set"
          ]
      )
      list;
  in
    if elementsAreFlat
    then convertListOfFlatAttrsToKDL name list
    else convertListOfNonFlatAttrsToKDL name list;

  # Combined Conversion
  # String -> Anything  -> String
  convertAttributeToKDL = name: value: let
    vType = builtins.typeOf value;
  in
    if name == "window-rules" && vType == "list"
    then lib.concatStringsSep "\n" (map (convertAttrsToKDL "window-rule") value)
    else if vType == "bool"
    then
      if value
      then name
      else ""
    else if builtins.elem vType [ "int" "float" "string" "null" ]
    then "${name} ${literalValueToString value}"
    else if vType == "set"
    then convertAttrsToKDL name value
    else if vType == "list"
    then convertListToKDL name value
    else
      throw ''
        Cannot convert type `(${builtins.typeOf value})` to KDL:
          ${name} = ${toString value}
      '';
in
  attrs: ''
    ${lib.concatStringsSep "\n" (lib.filter (x: x != "") (lib.mapAttrsToList convertAttributeToKDL attrs))}
  ''
