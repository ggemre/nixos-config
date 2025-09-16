{lib}:
# hex: string like "0f1acc" or "#0f1acc"
# alpha: float between 0 and 1
hex: alpha: let
  # strip leading '#' if present
  hexStr =
    if lib.hasPrefix "#" hex
    then lib.substring 1 6 hex
    else hex;

  r = lib.trivial.fromHexString (lib.substring 0 2 hexStr);
  g = lib.trivial.fromHexString (lib.substring 2 2 hexStr);
  b = lib.trivial.fromHexString (lib.substring 4 2 hexStr);
  normalize = x: x / 255.0;
in {
  inherit alpha;
  red = normalize r;
  green = normalize g;
  blue = normalize b;
}
