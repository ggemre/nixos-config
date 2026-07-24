# Reinstall script for supported hosts only.
# Usage: reinstall <HOSTNAME>
# This script is tailored to systems in github:ggemre/nixos-config and
# may not work correctly on other hardware. Use at your own risk.

# Dependency checks
if ! command -v disko >/dev/null 2>&1; then
	echo -e "\033[0;31mERROR:\033[0m disko must be installed and available to run this script"
	exit 1
elif ! command -v curl >/dev/null 2>&1; then
	echo -e "\033[0;31mERROR:\033[0m curl must be installed and available to run this script"
	exit 1
fi

# Internet check
curl -sS -I -o /dev/null -m 10 "https://nixos.org" 2>/dev/null || {
  echo -e "\033[0;31mERROR:\033[0m an internet connection is required to run this script"
  exit 1
}

# Begin installation
HOST=$1

if [ -z "$HOST" ]; then
	echo -e "\033[0;31mERROR:\033[0m argument HOST not provided"
	echo "Run this command with reinstall <HOST>"
	exit 1
fi

DISK_URL="https://raw.githubusercontent.com/ggemre/nixos-config/refs/heads/main/hosts/$HOST/disk.nix"

echo "Installing NixOS for machine named $HOST..."

if ! curl -sf "$DISK_URL" -o disk.nix; then
	echo -e "\033[0;31mERROR:\033[0m disk configuration for $HOST not found"
	exit 1
fi

sudo disko --mode destroy,format,mount --yes-wipe-all-disks disk.nix
sudo nixos-install --no-channel-copy --no-root-passwd --flake github:ggemre/nixos-config#$HOST
echo "Installation complete. You may now reboot."

