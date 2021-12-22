{ config, pkgs, ... }:

{
  imports = [ ../../home-manager ];

  within = {
    emacs.enable = true;
    fish.enable = true;
    tmux.enable = true;
    tmux.shortcut = "a";
    vim.enable = true;
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    packageOverrides = import ../../../pkgs;

    manual.manpages.enable = true;
  };

  services.lorri.enable = true;
}
