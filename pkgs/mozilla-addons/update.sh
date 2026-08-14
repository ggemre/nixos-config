#!/usr/bin/env nix-shell
#! nix-shell -i bash -p python3
exec python3 "$(dirname "$0")/update.py"
