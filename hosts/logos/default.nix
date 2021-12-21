{ config, pkgs, ... }:

{
  imports = [ ../../common ./minecraft.nix ];

  users.motd = builtins.readFile ./motd;

  networking.hostName = "logos";
  networking.hostId = "aeace675";
}
