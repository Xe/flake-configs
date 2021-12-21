{ config, pkgs, ... }:

{
  users.motd = builtins.readFile ./motd;

  networking.hostName = "logos";
  networking.hostId = "aeace675";
}
