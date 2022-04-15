{ config, pkgs, ... }:

{
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15429;

  networking.hostName = "ontos";
  networking.hostId = "07602ecc";
}
