{ config, ... }:

{
  services.grafana = {
    enable = true;
    domain = "chrysalis.shark-harmonic.ts.net";
    port = 2342;
    addr = "0.0.0.0";
  };

  services.nginx.virtualHosts."chrysalis.shark-harmonic.ts.net" = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
    };
  };

  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "15s";
    scrapeConfigs = [
      # services
      {
        job_name = "mi";
        static_configs = [{ targets = [ "lufta:38184" ]; }];
      }
      {
        job_name = "site";
        metrics_path = "/xesite";
        static_configs = [{ targets = [ "lufta:43705" ]; }];
      }
      {
        job_name = "ircmon";
        metrics_path = "/ircmon";
        static_configs = [{ targets = [ "lufta:43705" ]; }];
      }
      {
        job_name = "corerad";
        static_configs = [{ targets = [ "keanu:38177" ]; }];
      }
      {
        job_name = "coredns";
        static_configs = [{ targets = [ "chrysalis:47824" ]; }];
      }
      {
        job_name = "nginx";
        static_configs = [{
          targets = [ "lufta:9113" "lufta:9117" ];
          labels.host = "lufta";
        }];
      }
      {
        job_name = "rhea";
        static_configs = [{ targets = [ "lufta:23818" ]; }];
      }

      # computers
      {
        job_name = "chrysalis";
        static_configs = [{ targets = [ "chrysalis:9100" ]; }];
      }
      {
        job_name = "shachi";
        static_configs = [{ targets = [ "shachi:9100" ]; }];
      }
      {
        job_name = "lufta";
        static_configs = [{ targets = [ "lufta:9100" ]; }];
      }
      {
        job_name = "itsuki";
        static_configs = [{ targets = [ "itsuki:9100" ]; }];
      }
      {
        job_name = "kos-mos";
        static_configs = [{ targets = [ "kos-mos:9100" ]; }];
      }
      {
        job_name = "logos";
        static_configs = [{ targets = [ "logos:9100" ]; }];
      }
      {
        job_name = "ontos";
        static_configs = [{ targets = [ "ontos:9100" ]; }];
      }
      {
        job_name = "pneuma";
        static_configs = [{ targets = [ "pneuma:9100" ]; }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard.enable = true;
    };
  };
}
