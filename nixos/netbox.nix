# https://nixos.wiki/wiki/NetBox
# see the above link for a complete setup with reverse proxy

{ config, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8001 ];
  };

  services.netbox = {
    enable = true;
    secretKeyFile = "/var/lib/netbox/secret-key-file";
  };

  services.nginx = {
    enable = true;
    user = "netbox";
    recommendedTlsSettings = false;
    clientMaxBodySize = "25m";
    virtualHosts = {
      "192.168.1.13" = {
        listen = [
          { addr = "192.168.1.13"; port = 8001; }
        ];
        locations = {
          "/" = {
            proxyPass = "http://localhost:8001";
          };
          "/static/" = {
            root = "${config.services.netbox.dataDir}";
          };
        };
      };
    };
  };
}
