{ lib, config, pkgs, ... }:

with lib;

let cfg = config.within.htop;
in {
  options.within.htop.enable = mkEnableOption "htop";
  config = mkIf cfg.enable {
    programs.htop.enable = true;
  };
}
