{ config, pkgs, ... }:

{
  imports = [ ./maisem.nix ];

  users.motd = builtins.readFile ./motd;
  environment.systemPackages = with pkgs; [ nodejs-14_x ];
  services.tailscale.port = 15428;

  networking.hostName = "kos-mos";
  networking.hostId = "472479d4";
}
