{ config, lib, ... }: {
  options = {
    within.microcode = {
      enable = lib.mkEnableOption "Enables CPU Microcode updates";
      vendor = lib.mkOption { type = lib.types.enum [ "intel" "amd" ]; };
    };
  };

  config = lib.mkIf config.within.microcode.enable {
    hardware.cpu.intel.updateMicrocode = (config.within.microcode.vendor == "intel");
    hardware.cpu.amd.updateMicrocode = (config.within.microcode.vendor == "amd");
  };
}
