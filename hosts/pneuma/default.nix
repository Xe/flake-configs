{ config, pkgs, ... }:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15430;

  networking.hostName = "pneuma";
  networking.hostId = "34fbd94b";

  time.timeZone = "America/Toronto";
}
