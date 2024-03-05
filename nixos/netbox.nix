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
    settings = {
      PREFER_IPV4 = true;
    };
  };

  services.nginx = {
    enable = true;
    user = "netbox";
    recommendedTlsSettings = false;
    recommendedGzipSettings = true;
    recommendedOptimisationSettings = true;
    recommendedProxySettings = true;
    clientMaxBodySize = "25m";

    virtualHosts = {
      "192.168.1.13" = {
        listen = [
          { addr = "192.168.1.13"; port = 8001; }
        ];
        locations = {
          "/" = {
            proxyPass = "http://localhost:8001";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_cookie_path / "/; HTTPOnly";
            '';
          };
          "/static/" = {
            root = "${config.services.netbox.dataDir}";
          };
        };
      };
    };
  };
}
