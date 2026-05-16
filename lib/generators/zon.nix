_: attrs: let
  toZon' = let
    indent = n: builtins.concatStringsSep "" (builtins.genList (_: "  ") n);

    escape = s:
      builtins.replaceStrings
      [ "\\" "\"" "\n" "\r" "\t" ]
      [ "\\\\" "\\\"" "\\n" "\\r" "\\t" ]
      s;

    startsWith = string: prefix:
      builtins.substring 0 (builtins.stringLength prefix) string == prefix;

    gen = level: value:
    # null
      if value == null
      then "null"
      # bool
      else if builtins.isBool value
      then
        (
          if value
          then "true"
          else "false"
        )
      # int/float
      else if builtins.isInt value || builtins.isFloat value
      then builtins.toString value
      # zig reference
      else if builtins.isString value && (startsWith value ".")
      then builtins.toString value
      # string
      else if builtins.isString value
      then "\"${escape value}\""
      # list
      else if builtins.isList value
      then
        if value == []
        then ".{}"
        else
          ".{\n"
          + builtins.concatStringsSep ",\n" (
            map (v: "${indent (level + 1)}${gen (level + 1) v}") value
          )
          + "\n${indent level}}"
      # attrs
      else if builtins.isAttrs value
      then let
        names = builtins.attrNames value;

        renderField = name: let
          key =
            if builtins.match "^[A-Za-z_][A-Za-z0-9_]*$" name != null
            then ".${name}"
            else "@\"${escape name}\"";
        in "${indent (level + 1)}${key} = ${gen (level + 1) value.${name}}";
      in
        if names == []
        then ".{}"
        else
          ".{\n"
          + builtins.concatStringsSep ",\n" (map renderField names)
          + "\n${indent level}}"
      else throw "toZon: unsupported type";
  in
    gen 0;
in
  toZon' attrs + "\n"
