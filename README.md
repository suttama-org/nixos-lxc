# nixos-lxc

NixOS LXC template for proxmox virtual environment

## Usage in NixOS Linux containers

### Information

- `hostname` corresponds to the NixOS hostnames in `flake.nix` eg. `dns` or `samba`.
- make sure to add your SSH public key to `keys.nix` as `PasswordAuthentication` is disabled
  - the key should have an identifier at the end (should be default `ssh-keygen` behaviour)

### New LXC

1. Generate the build using GitHub Actions by pushing a new tag (`v*.*.*-hostname`).
2. Get the build tarball from the [releases page](https://github.com/suttama-org/nixos-lxc/releases), download it and upload it to PVE.
3. Create a new LXC using the uploaded tarball.
4. If it's running as expected, backup the LXC.

### First update to an existing LXC

1. SSH into the LXC, and run `ssh-keygen` to generate a new SSH key.
2. Upload the public key to your personal [GitHub account](https://github.com/settings/keys) to be able to clone the repo.
3. At `$HOME`, run `git clone git@github.com:suttama-org/nixos-lxc.git`
4. `cd` into `nixos-lxc` and run `./bin/nixos-build .#hostname`
5. Reboot the LXC from PVE or using `poweroff --reboot`
6. If it's running as expected, backup the LXC.
7. The first update will increase the size of the container, so run `nix store gc`

### Subsequent updates

1. SSH into the LXC
2. `cd` into `nixos-lxc` and run `git pull` to get the latest changes
3. run `./bin/nixos-build .#hostname`
4. reboot
