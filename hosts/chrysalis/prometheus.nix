{ config, ... }:

{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        domain = "chrysalis.shark-harmonic.ts.net";
        http_port = 2342;
        http_addr = "0.0.0.0";
        root_url = "https://chrysalis.shark-harmonic.ts.net";
      };
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

      # xedn
      {
        job_name = "xedn";
        metrics_path = "/debug/varz";
        static_configs = [
          {
            targets = [ "xedn-fra:80" ];
            labels.region = "fra";
          }
          {
            targets = [ "xedn-sea:80" ];
            labels.region = "sea";
          }
          {
            targets = [ "xedn-yyz:80" ];
            labels.region = "yyz";
          }
        ];
      }

      # computers
      {
        job_name = "chrysalis";
        static_configs = [{ targets = [ "chrysalis:9100" ]; }];
      }
      {
        job_name = "joker";
        static_configs = [{ targets = [ "joker:9100" ]; }];
      }
      {
        job_name = "firgu";
        static_configs = [{ targets = [ "firgu:9100" ]; }];
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
      {
        job_name = "akko";
        static_configs = [{ targets = [ "akko:9100" ]; }];
      }
    ];

    exporters = {
      node = { enable = true; };
      wireguard.enable = true;
    };
  };
}
