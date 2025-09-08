{
  # Modules for my NixOS Configurations:
  common = import ./common; # Settings that ALL NixOS hosts import (sans configuration)
  config = import ./config; # Configuration settings for programs and services
  programs = import ./programs; # Options for programs to be configured
  services = import ./services; # Options for services to be configured
  profiles = import ./profiles; # Settings for specific kinds of systems

  # Internally-used modules that are shared amongst programs:
  homeless = import ./shared/homeless; # Simple and idempotent home management (unlike HomeManager)
  theme = import ./shared/theme; # Set consistent themes for use elsewhere
}
