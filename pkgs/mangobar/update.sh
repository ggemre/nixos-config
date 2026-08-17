#!/usr/bin/env nix-shell
#! nix-shell -i bash -p lixPackageSets.latest.nix-update
nix-update mangobar --flake --version=branch=main
