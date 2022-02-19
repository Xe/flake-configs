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

  system.stateVersion = "20.09"; # Did you read the comment?

  within.services.snoo2nebby.enable = true;
  age.secrets.snoo2nebby = {
    file = ./secret/snoo2nebby.age;
    path = "/var/lib/snoo2nebby/whurl.txt";
    user = "snoo2nebby";
    group = "snoo2nebby";
  };
  within.users.enableSystem = true;

  boot.kernel.sysctl = {
    "net.ipv4.forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
}
