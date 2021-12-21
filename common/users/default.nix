{ config, pkgs, lib, ... }:

with lib;

{
  imports = [ ./cadey.nix ./other.nix ];
}
