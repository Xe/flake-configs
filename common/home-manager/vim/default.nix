{ lib, config, pkgs, ... }:

with lib;

let cfg = config.within.vim;
in {
  options.within.vim.enable = mkEnableOption "Enables Within's vim config";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.vim ];
    home.file.".vimrc".source = ./vimrc;
  };
}
