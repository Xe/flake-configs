{ config, pkgs, ... }:

{
  imports = [ ./maisem.nix ];

  users.motd = builtins.readFile ./motd;
  environment.systemPackages = with pkgs; [ nodejs-14_x ];
  services.tailscale.port = 15428;

  networking.hostName = "kos-mos";
  networking.hostId = "472479d4";

  xeserv.services.robocadey.enable = true;
  age.secrets.robocadey = {
    file = ../../secret/robocadey.age;
    path = "/var/lib/private/xeserv.robocadey/.env";
    owner = "robocadey";
    group = "robocadey";
    mode = "0666";
  };
}
