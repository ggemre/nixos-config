{
  # Modules for my NixOS Configurations:
  common = import ./common; # Settings that ALL NixOS hosts import (sans configuration)
  system = import ./system; # Possible NixOS configuration options
  programs = import ./programs; # Possible programs to install (with sane defaults)

  # Internally-used modules that are shared amongst programs:
  homeless = import ./shared/homeless; # Simple and idempotent home management (unlike HomeManager)
  theme = import ./shared/theme; # Set consistent themes for use elsewhere
}
