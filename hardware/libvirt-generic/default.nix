{ config, pkgs, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ../../common ];

  services.openssh.enable = true;

  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";

  nixpkgs.config.allowUnfree = true;

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
  };

  services.qemuGuest.enable = true;
}
