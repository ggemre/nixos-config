# nixos-config

For personal use

Public so I can easily clone it and so you can have a reference

## Info

My primary goal was creating something extremely simple while avoiding unecessary abstraction and indirection.

Written with paranoia toward patterns that I find risky/fragile:

* No import from derivation (slow & hard to debug)
* No `with` or `rec` (footgun keywords)
* No stylix or home-manager (fragile bloat)
* No channels (outdated)
* No overlays (unnecessary for my use case)
* No flake-utils (extra unnecessary)
* No imperative design (impure)

## Credit

Any code that I found from someone else includes a clear header giving credit to them.

Any patching or customizing done to software was done clearly within the bounds of that software's license.

