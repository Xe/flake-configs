{ ... }:

{
  imports = [
    # explicit xe.*
    ./emacs
    ./fish
    ./htop.nix
    ./k8s.nix
    ./keybase.nix
    ./luakit
    ./neofetch.nix
    ./powershell
    #./sway
    ./tmux.nix
    ./urxvt.nix
    ./vim
    #./zathura
    ./weechat

    # implicit
    ./pastebins
    ./vscode-remote
  ];

  nixpkgs.config = {
    allowBroken = true;
    allowUnfree = true;

    manual.manpages.enable = true;
  };

  systemd.user.startServices = true;

  # hack to fix vscode
  services.vscode-server.enable = true;

  home.stateVersion = "21.11";
}
