{ config, pkgs, ... }:

{
  imports = [ ./minecraft.nix ../../location/YOW ];

  users.motd = builtins.readFile ./motd;

  networking.hostName = "logos";
  networking.hostId = "aeace675";

  services.nginx.enable = true;
}
