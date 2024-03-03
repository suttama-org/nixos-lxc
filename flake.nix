{
  description = "Dhamma Suttama's NixOS proxmox LXCs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }: {

    nixosConfigurations = {
      "dns" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/proxmox-lxc.nix"
          ./nixos
          ./nixos/dns.nix
        ];
      };

      "netbox" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/proxmox-lxc.nix"
          ./nixos
          ./nixos/netbox.nix
        ];
      };
    };
  };
}
