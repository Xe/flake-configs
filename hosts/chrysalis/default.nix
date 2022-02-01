{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./prometheus.nix
    ./solanum.nix
    ./znc.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "chrysalis"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp11s0.useDHCP = true;
  networking.interfaces.enp12s0.useDHCP = true;

  environment.systemPackages = with pkgs; [ wget vim ];

  services.openssh.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  services.nginx.enable = true;

  within.microcode = {
    enable = true;
    vendor = "intel";
  };

  services.tailscale.enable = true;
  services.redis.servers.main = {
    enable = true;
    port = 6379;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };
}

