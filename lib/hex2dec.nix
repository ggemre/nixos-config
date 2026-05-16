{lib}: let
  hexToInt = {
    "0" = 0;
    "1" = 1;
    "2" = 2;
    "3" = 3;
    "4" = 4;
    "5" = 5;
    "6" = 6;
    "7" = 7;
    "8" = 8;
    "9" = 9;
    "a" = 10;
    "b" = 11;
    "c" = 12;
    "d" = 13;
    "e" = 14;
    "f" = 15;
    "A" = 10;
    "B" = 11;
    "C" = 12;
    "D" = 13;
    "E" = 14;
    "F" = 15;
  };

  pow = base: exponent:
    if exponent == 0
    then 1
    else if exponent == 1
    then base
    else base * (pow base (exponent - 1));

  hexToDec = hex: let
    chars = lib.stringToCharacters hex;
    len = builtins.length chars;
    digits = lib.imap0 (i: c: (hexToInt.${c} or (builtins.throw "Invalid hex char: ${c}")) * (pow 16 (len - i - 1))) chars;
  in
    lib.foldl (acc: val: acc + val) 0 digits;
in
  hexToDec
