# https://nixos.wiki/wiki/NetBox
# see the above link for a complete setup with reverse proxy

{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8001 ];
  };

  services.netbox = {
    enable = true;
    secretKeyFile = "/var/lib/netbox/secret-key-file";
  };
}
