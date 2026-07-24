#! /usr/bin/env bash
set -euo pipefail
nix run nixpkgs#lixPackageSets.latest.nix-update -- mango --flake
