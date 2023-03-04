{ config, pkgs, lib, ... }:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "wasm32-wasi" ];
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15430;
  environment.systemPackages = with pkgs; [ wasmtime weechat ];

  services.tor = {
    enable = true;
    client.enable = true;
    settings.SOCKSPort = [ 9051 ];
  };

  networking.hostName = "pneuma";
  networking.hostId = "34fbd94b";

  time.timeZone = "America/Toronto";
}
