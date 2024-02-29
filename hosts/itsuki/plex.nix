{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.plex = {
    enable = true;
  };
}
