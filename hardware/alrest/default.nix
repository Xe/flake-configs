{ config, pkgs, ... }:

{
  imports =
    [ ./monitoring.nix ./hardware-configuration.nix ./zfs.nix ./zrepl.nix ];

  within.users.enableSystem = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-partuuid";
  boot.kernelParams = [ "zfs.zfs_arc_max=1073741824" ];

  networking.interfaces.enp2s0.useDHCP = true;

  system.autoUpgrade = {
    flake = "github:Xe/flake-configs";
    randomizedDelaySec = "15m";
    dates = "daily";

    operation = "boot";
    allowReboot = true;
    rebootWindow = {
      lower = "00:00";
      upper = "02:00";
    };
  };

  nixpkgs.config.allowUnfree = true;

  networking.firewall.enable = false;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [ wget vim zfs rsync ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  within.microcode = {
    enable = true;
    vendor = "intel";
  };

  security.sudo.wheelNeedsPassword = false;

  services.tailscale.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "overlay2";

  systemd.services.network-setup = {
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.coreutils}/bin/true";
    serviceConfig.RemainAfterExit = true;
  };

  systemd.services.tailscaled.path = with pkgs; [ mosh getent shadow ];

  home-manager.users.cadey = { ... }: {
    within.emacs.enable = true;
  };
}
