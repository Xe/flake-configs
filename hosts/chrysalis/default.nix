{ lib, config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./prometheus.nix ./solanum.nix ./znc.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "chrysalis"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp11s0.useDHCP = true;
  networking.interfaces.enp12s0.useDHCP = true;

  environment.systemPackages = with pkgs; [ wget vim ];

  services.openssh.enable = true;

  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  services.nginx.enable = false;

  within.microcode = {
    enable = true;
    vendor = "intel";
  };

  services.tailscale.enable = true;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    authentication = ''
      host marabot all 100.64.0.0/10 md5
    '';
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  within.services.mara-bot.enable = true;
  age.secrets.mara-bot = {
    file = ./secret/mara.age;
    path = "/var/lib/mara-bot/config.yaml";
    owner = "mara-bot";
    group = "mara-bot";
  };
}

