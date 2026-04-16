HOSTNAME := `uname -n`

default:
  just --list

[linux]
[doc('Activate {{host}} without adding to boot list')]
[group('build')]
test host=HOSTNAME:
  sudo nixos-rebuild test --flake .#{{host}}

[linux]
[doc('Rebuild, activate, and boot list {{host}}')]
[group('build')]
switch host=HOSTNAME:
  sudo nixos-rebuild switch --flake .#{{host}}

[linux]
[doc('Build {{host}} to `./result`')]
[group('build')]
build host=HOSTNAME:
  nixos-rebuild build --flake .#{{host}}

[linux]
[doc('Add new generation of {{host}} to boot list without activation')]
[group('build')]
boot host=HOSTNAME:
  sudo nixos-rebuild boot --flake .#{{host}}

[doc('Update all inputs (i.e. recreate the lock file from scratch)')]
[group('flake')]
update:
  nix flake update

[doc('Format the nix files in this repo')]
[group('flake')]
fmt:
  nix fmt .

[doc('Remove the symlinked build output at `./result`')]
[group('flake')]
clean:
  rm -rf result

[doc('Show all versions of the current profile')]
[group('system')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

[doc('Remove week old generations and unused derivations')]
[group('system')]
gc:
  nix-collect-garbage --delete-older-than 7d
  sudo nix-collect-garbage --delete-older-than 7d

[doc('Remove everything not used by the current generation')]
[group('system')]
prune:
  nix-collect-garbage --delete-old
  sudo nix-collect-garbage --delete-old
  sudo /run/current-system/bin/switch-to-configuration boot

[doc('Manually optimize the nix store')]
[group('system')]
optimise:
  nix-store --optimise

