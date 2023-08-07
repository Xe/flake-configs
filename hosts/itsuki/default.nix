# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../../common

    ./hardware-configuration.nix
    ./plex.nix
    ./smb.nix
    ./zrepl.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [ "nomodeset" ];

  services.prometheus.exporters.node.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };
  systemd.services."docker" = {
    path = [ pkgs.zfs ];
  };

  virtualisation.libvirtd.enable = true;
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /data 0.0.0.0/0(insecure,rw,sync,all_squash,anonuid=1000,anongid=996)
  '';
  security.sudo.wheelNeedsPassword = false;

  networking.hostName = "itsuki"; # Define your hostname.
  networking.hostId = "4d64f279";
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  services.openssh.enable = true;
  networking.firewall.enable = false;
  system.stateVersion = "21.05"; # Did you read the comment?

  environment.systemPackages = with pkgs; [ docker-compose ];

  services.tailscale.enable = true;

  xeserv.services = {
    sanguisuga.enable = true;
    vest-pit-near.enable = true;
  };

  age.secrets.sanguisuga = {
    file = ../../secret/sanguisuga.ts.age;
    path = "/var/lib/sanguisuga/config.ts";
    owner = "sanguisuga";
    group = "within";
    mode = "660";
  };

  age.secrets.vest-pit-near = {
    file = ../../secret/vest-pit-near.age;
    path = "/var/lib/private/vest-pit-near/.env";
    owner = "root";
    group = "docker";
    mode = "770";
  };

  within.users.enableSystem = true;

  home-manager.users.cadey = { ... }: {
    within.emacs.enable = true;
  };
}
