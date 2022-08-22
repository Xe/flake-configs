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
}
