{ config, pkgs, lib, ... }:

with lib;

let
  e = pkgs.writeTextFile {
    name = "cadey-emacs.desktop";
    destination = "/share/applications/cadey-emacs.desktop";
    text = ''
      [Desktop Entry]
      Exec=emacsclient -nc
      Icon=emacs
      Name[en_US]=Emacs Client
      Name=Emacs Client
      StartupNotify=true
      Terminal=false
      Type=Application
    '';
  };

  cfg = config.within.spacemacs;
in {
  options.within.spacemacs.enable = mkEnableOption "emacs with spacemacs";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ anonymousPro e sqlite-interactive graphviz ];

    programs.emacs.enable = true;

    home.file.".spacemacs".source = ./spacemacs;

    home.file."bin/e" = {
      text = ''
        #!/bin/sh
        emacsclient -a "" -nc $@
      '';
      executable = true;
    };

    home.activation.spacemacs = ''
      mkdir -p ~/.ssh

      if ! grep github.com ~/.ssh/known_hosts > /dev/null
      then
          echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts
      fi

      if [ ! -d "$HOME/.emacs.d" ]; then
        GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_SYSTEM=/dev/null git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
        systemctl --user restart emacs
      fi
    '';
  };
}
