{ config, pkgs, lib, ... }:

{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "wasm32-wasi" ];
  virtualisation.docker.enable = true;
  users.motd = builtins.readFile ./motd;
  services.tailscale.port = 15430;
  environment.systemPackages = with pkgs; [ wasmtime weechat ];

  services.tor = {
    enable = true;
    client.enable = true;
    settings.SOCKSPort = [ 9051 ];
  };

  boot.zfs.extraPools = [ "nelo" ];

  networking.hostName = "pneuma";
  networking.hostId = "34fbd94b";

  within.microcode.vendor = lib.mkForce "amd";

  boot.initrd.kernelModules = [ "amdgpu" ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  time.timeZone = "America/Toronto";
}
