{ lib, config, pkgs, ... }:

with lib;

let cfg = config.within.vim;
in {
  options.within.vim.enable = mkEnableOption "Enables Within's vim config";

  config = mkIf cfg.enable {
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline gruvbox vim-go direnv-vim vim-lsp ];
    };

    home.file.".vimrc".source = ./vimrc;
  };
}
