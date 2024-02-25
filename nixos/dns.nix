{
  networking = {
    firewall = {
      enable = true;
      # [blocky dns, blocky metrics, unbound dns, unbound metrics]
      allowedUDPPorts = [ 53 4000 5300 9167 ];
      allowedTCPPorts = [ 53 4000 5300 9167 ];
    };

    # settings to fix conflicts with blocky
    useHostResolvConf = false;
    resolvconf.useLocalResolver = true;
  };

  services = {
    resolved.enable = false;

    unbound = {
      enable = true;

      # Configure Unbound to listen on localhost port 5300 to avoid conflicts with Blocky
      settings = {
        server = {
          interface = [ "127.0.0.1@5300" ];
          access-control = [ "127.0.0.0/8 allow" ];
          do-not-query-localhost = false;
          qname-minimisation = "yes";

          # LOGS
          statistics-interval = 0;
          extended-statistics = "yes";
          statistics-cumulative = "no";
        };
      };
    };

    prometheus.exporters.unbound.enable = true;

    # https://nixos.wiki/wiki/Blocky
    # https://0xerr0r.github.io/blocky/configuration/
    blocky = {
      enable = true;
      settings = {
        upstreams.groups.default = [
          "127.0.0.1:5300" # Forward queries to Unbound
        ];

        # For initially solving DoH/DoT Requests when no system Resolver is available.
        bootstrapDns = {
          upstream = "127.0.0.1:5300";
          ips = [ "127.0.0.1" ];
        };

        ports = {
          dns = 53;
          http = 4000;
        };

        blocking = {
          blackLists = {
            ads = [
              "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
          };

          clientGroupsBlock = {
            default = [ "ads" ];
          };
        };

        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };

        # LOGS
        prometheus = {
          enable = true;
          path = "/metrics";
        };
      };
    };
  };
}
