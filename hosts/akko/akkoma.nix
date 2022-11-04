{ pkgs, lib, ... }:
let vhost = "akko.within.website";
in {
  services.akkoma = {
    enable = true;
    config = let inherit ((pkgs.formats.elixirConf { }).lib) mkRaw mkMap;
    in {
      ":pleroma"."Pleroma.Web.Endpoint".url.host = vhost;
      ":pleroma".":media_proxy".enabled = true;
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

        limit_to_local_content = mkRaw ":unauthenticated";
        healthcheck = true;
        cleanup_attachments = true;
        allow_relay = true;
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
        base_url = "https://s3.us-west-000.backblazeb2.com";
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

  security.acme = {
    defaults.email = "me@xeiaso.net";

    certs."akko.within.website" = {
      group = "nginx";
      dnsProvider = "route53";
      credentialsFile = "/run/keys/aws-within.website";
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
