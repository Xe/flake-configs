{ config, pkgs, ... }:

{
  imports = [ ./minecraft.nix ];

  users.motd = builtins.readFile ./motd;
  services.prometheus.exporters.node.enable = true;

  networking.hostName = "logos";
  networking.hostId = "aeace675";

  services.nginx.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  virtualisation.docker.enableNvidia = true;
  hardware.opengl.driSupport32Bit = true;

  # make steam work
  hardware.steam-hardware.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.flatpak.enable = true;

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
