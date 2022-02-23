{ config, pkgs, ... }:

{
  imports = [ ./minecraft.nix ];

  users.motd = builtins.readFile ./motd;
  services.prometheus.exporters.node.enable = true;

  networking.hostName = "logos";
  networking.hostId = "aeace675";

  services.nginx.enable = true;
}
