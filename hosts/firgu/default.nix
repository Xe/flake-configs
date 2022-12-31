{ config, lib, pkgs, ... }:

let metadata = pkgs.callPackage ../../ops/metadata/peers.nix { };
in {
  imports = [
    ./hardware-configuration.nix
    ./matrix.nix
    ./shellbox.nix
  ];

  services.openssh.enable = true;

  networking.useDHCP = false;
  networking.interfaces.ens3.useDHCP = true;
  networking.hostName = "firgu";
  networking.firewall.enable = false;

  i18n.defaultLocale = "en_US.UTF-8";
  services.tailscale.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  environment.systemPackages = with pkgs; [
    wget
    vim
    python3
    lua5_3
    git
  ];

  within.users.enableSystem = true;

  xeserv.services.hlang = {
    enable = true;
    useACME = true;
    domain = "h.within.lgbt";
  };

  boot.kernel.sysctl = {
    "net.ipv4.forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
