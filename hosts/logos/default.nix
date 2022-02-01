{ config, pkgs, ... }:

{
  imports = [ ./minecraft.nix ];

  users.motd = builtins.readFile ./motd;

  networking.hostName = "logos";
  networking.hostId = "aeace675";

  services.nginx.enable = true;
}
