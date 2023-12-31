{ config, pkgs, ... }:

{
  imports = [ ./maisem.nix ];

  users.motd = builtins.readFile ./motd;
  environment.systemPackages = with pkgs; [ nodejs_20 ];
  services.tailscale.port = 15428;

  nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" "/rpool/keys" ];

  networking.hostName = "kos-mos";
  networking.hostId = "472479d4";

  system.autoUpgrade.enable = true;
}
