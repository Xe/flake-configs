{ config, pkgs, lib, ... }:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "wasm32-wasi" ];
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15430;
  environment.systemPackages = with pkgs; [ wasmtime weechat ];

  programs.nix-ld.enable = true;
  environment.variables = {
      NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
      ];
      NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  };
  
  services.tor = {
    enable = true;
    client.enable = true;
    settings.SOCKSPort = [ 9051 ];
  };

  networking.hostName = "pneuma";
  networking.hostId = "34fbd94b";

  time.timeZone = "America/Toronto";
}
