{ config, pkgs, ... }:

{
  imports = [ ../../common ];

  users.motd = builtins.readFile ./motd;

  networking.hostName = "logos";
  networking.hostId = "aeace675";
}
