{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.plex = {
    dataDir = "/data/plex";
    user = "cadey";
    enable = false;
  };
}
