{ config, lib, pkgs, ... }:

with lib;

let cfg = config.within.powershell;
in {
  options.within.powershell.enable = mkEnableOption "enables powershell config";
  config = mkIf cfg.enable {
    home.packages = [ pkgs.powershell ];
    home.file.".config/powershell/Microsoft.PowerShell_profile.ps1".source =
      ./profile.ps1;
  };
}
