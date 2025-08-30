{
  # Modules for my NixOS Configurations:
  common = import ./common; # Settings that ALL NixOS hosts import (sans configuration)
  config = import ./config;
  programs = import ./programs; # Possible programs to install (with sane defaults)
  services = import ./services; # Possible services to enable
  profiles = import ./profiles; # Possible NixOS configuration options

  # Internally-used modules that are shared amongst programs:
  homeless = import ./shared/homeless; # Simple and idempotent home management (unlike HomeManager)
  theme = import ./shared/theme; # Set consistent themes for use elsewhere
}
