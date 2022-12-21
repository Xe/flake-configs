{ config, pkgs, ... }:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "wasm32-wasi" ];
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15430;
  environment.systemPackages = with pkgs; [ wasmtime ];

  networking.hostName = "pneuma";
  networking.hostId = "34fbd94b";

  time.timeZone = "America/Toronto";
}
