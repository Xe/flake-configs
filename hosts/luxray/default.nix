{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../hardware/macos-rosetta
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "luxray"; # Define your hostname.
  services.openssh.enable = true;
  networking.firewall.enable = false;
  system.copySystemConfiguration = true;
  system.stateVersion = "22.05";
}


