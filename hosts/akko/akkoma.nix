{ pkgs, lib, ... }:
let vhost = "akko.within.website";
in {
  services.akkoma = {
    enable = true;
    config = let inherit ((pkgs.formats.elixirConf { }).lib) mkRaw mkMap;
    in {
      ":pleroma"."Pleroma.Web.Endpoint".url.host = vhost;
      ":pleroma".":media_proxy" = {
        enabled = false;
        base_url = "https://cache.akko.within.website";
        proxy_opts.redirect_on_failure = true;
      };
      ":prometheus"."Pleroma.Web.Endpoint.MetricsExporter" = {
        enabled = true;
        auth = false;
        format = mkRaw ":text";
        path = "/api/pleroma/app_metrics";
      };
      ":pleroma".":instance" = {
        name = "Within's Bot Zone";
        description =
          "Within's akkoma server for testing and bot deployment, antifash edition";
        email = "akko@xeserv.us";
        notify_email = "akko@xeserv.us";

        registrations_open = false;
        invites_enabled = true;

        limit = 69420;
        remote_limit = 100000;
        max_pinned_statuses = 10;
        max_account_fields = 100;

        upload_limit = 67108864;

        limit_to_local_content = mkRaw ":unauthenticated";
        healthcheck = true;
        cleanup_attachments = true;
        allow_relay = true;
        safe_dm_mentions = true;
        external_user_synchronization = true;
      };
      ":pleroma".":mrf".policies =
        map mkRaw [ "Pleroma.Web.ActivityPub.MRF.SimplePolicy" ];

      # To allow configuration from admin-fe
      ":pleroma".":configurable_from_database" = false;

      ":pleroma"."Pleroma.Captcha" = {
        enabled = false;
      };

      # S3 setup
      ":pleroma"."Pleroma.Upload" = {
        uploader = mkRaw "Pleroma.Uploaders.S3";
        base_url = "https://cdn.xeiaso.net/file/";
        strip_exif = false;
      };
      ":pleroma"."Pleroma.Uploaders.S3".bucket = "xeserv-akko";
      ":ex_aws".":s3" = {
        access_key_id._secret = "/var/lib/secrets/akkoma/b2_key_id";
        secret_access_key._secret = "/var/lib/secrets/akkoma/b2_app_key";
        host = "s3.us-west-001.backblazeb2.com";
      };

      # Automated moderation settings
      # Borrowed from https://github.com/chaossocial/about/blob/master/blocked_instances.md
      ":pleroma".":mrf_simple" = let blocklist = import ./blocklist.nix;
      in {
        media_nsfw = mkMap blocklist.media_nsfw;
        reject = mkMap blocklist.reject;
        followers_only = mkMap blocklist.followers_only;
      };
    };

    nginx = {
      useACMEHost = "akko.within.website";
      forceSSL = true;
    };
  };

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_15;
  services.postgresql.settings = {
    listen_addresses = lib.mkForce "100.106.53.73,fd7a:115c:a1e0:ab12:4843:cd96:626a:3549,localhost";
  };

  services.postgresqlBackup.enable = true;

  services.nginx.commonHttpConfig = ''
  proxy_cache_path /var/cache/nginx/akkoma-media-cache
    levels= keys_zone=akkoma_media_cache:16m max_size=2g
    inactive=1y use_temp_path=off;
  '';

  services.nginx.virtualHosts."cache.akko.within.website" = {
    locations."/" = {
      proxyPass = "http://unix:/run/akkoma/socket";

      extraConfig = ''
        proxy_cache akkoma_media_cache;

        proxy_cache_key $host$uri$is_args$args;

        # Decouple client and upstream requests
        proxy_buffering on;
        proxy_cache_lock on;
        proxy_ignore_client_abort on;

        # Default cache times for various responses
        proxy_cache_valid 200 1y;
        proxy_cache_valid 206 301 304 1h;

        # Allow serving of stale items
        proxy_cache_use_stale error timeout invalid_header updating;
      '';
    };
  };

  # services.nginx.virtualHosts."media.akko.within.website" = {
  #   locations."~ /file/xeserv-akko/" = {
  #     proxyPass = "https://b2";

  #     extraConfig = ''
  #       proxy_cache akkoma_media_cache;

  #       # Cache objects in slices of 1 MiB
  #       proxy_cache_key $host$uri$is_args$args;

  #       # Decouple client and upstream requests
  #       proxy_buffering on;
  #       proxy_cache_lock on;
  #       proxy_ignore_client_abort on;

  #       # Default cache times for various responses
  #       proxy_cache_valid 200 1y;
  #       proxy_cache_valid 206 301 304 1h;

  #       # Allow serving of stale items
  #       proxy_cache_use_stale error timeout invalid_header updating;

  #       proxy_set_header Host f001.backblazeb2.com;
  #     '';
  #   };
  # };

  security.acme = {
    defaults.email = "me@xeiaso.net";

    certs."akko.within.website" = {
      group = "nginx";
      dnsProvider = "route53";
      credentialsFile = "/run/keys/aws-within.website";
      extraDomainNames = [ "*.akko.within.website" ];
      extraLegoFlags = [ "--dns.resolvers=8.8.8.8:53" ];
    };
  };

  age.secrets = {
    "aws-within.website" = {
      file = ../../secret/aws-within.website.age;
      path = "/run/keys/aws-within.website";
      owner = "acme";
      group = "nginx";
    };
    akko-keyid = {
      file = ../../secret/akko-keyid.age;
      path = "/var/lib/secrets/akkoma/b2_key_id";
      owner = "akkoma";
      group = "akkoma";
    };
    akko-applicationkey = {
      file = ../../secret/akko-applicationkey.age;
      path = "/var/lib/secrets/akkoma/b2_app_key";
      owner = "akkoma";
      group = "akkoma";
    };
  };
}
