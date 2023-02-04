{ lib, config, pkgs, ... }:

with lib;

let
  dquot = "''";
  cfg = config.within.fish;
in {
  options.within.fish.enable = mkEnableOption "fish config";

  config = mkIf cfg.enable {
    programs.fish.enable = true;

    home.file = {
      ".config/fish/functions/fish_greeting.fish".text = ''
        function fish_greeting;end
      '';

      ".config/fish/functions/vterm_printf.fish".text = ''
        function vterm_printf;
            if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end 
                # tell tmux to pass the escape sequences through
                printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
            else if string match -q -- "screen*" "$TERM"
                # GNU screen (screen, screen-256color, screen-256color-bce)
                printf "\eP\e]%s\007\e\\" "$argv"
            else
                printf "\e]%s\e\\" "$argv"
            end
        end
      '';

      ".config/fish/functions/fish_prompt.fish".source = ./fish_prompt.fish;
      ".config/fish/functions/fish_right_prompt.fish".source =
        ./fish_right_prompt.fish;
      ".config/fish/conf.d/ssh-agent.fish".source = ./ssh-agent.fish;

      # global fish config
      ".config/fish/conf.d/cadey.fish".text = ''
        alias edit "emacsclient -t -c -a ${dquot}"
        alias e "edit"

        set -gx GOPATH $HOME/go
        set -gx PATH $PATH $HOME/go/bin $HOME/bin

        set -gx GO111MODULE on

        set -gx PATH $PATH $HOME/.local/bin

        set -gx PATH $PATH $HOME/.luarocks/bin

        set -gx PATH $PATH $HOME/.cargo/bin

        set -gx WASMER_DIR $HOME/.wasmer
        set -gx WASMER_CACHE_DIR $WASMER_DIR/cache
        set -gx PATH $PATH $WASMER_DIR/bin $WASMER_DIR/globals/wapm_packages/.bin

        set -gx EDITOR vim
      '';

      ".config/fish/conf.d/colors.fish".text = ''
        switch $TERM
          case '*xte*'
            set -gx TERM xterm-256color
          case '*scree*'
            set -gx TERM screen-256color
          case '*rxvt*'
            set -gx TERM rxvt-unicode-256color
        end
      '';

      ".config/fish/conf.d/gpg.fish".text = ''
        # Set GPG TTY
        set -x GPG_TTY (tty)
      '';

      ".config/fish/conf.d/emacs.fish".text = ''
        if [ "$INSIDE_EMACS" = 'vterm' ]
            function clear
                vterm_printf "51;Evterm-clear-scrollback";
                tput clear;
            end

            function e
                vterm_printf "51;Efind-file" $argv;
            end

            function vterm_prompt_end;
                vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
            end
            functions --copy fish_prompt vterm_old_fish_prompt
            function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
                # Remove the trailing newline from the original prompt. This is done
                # using the string builtin from fish, but to make sure any escape codes
                # are correctly interpreted, use %b for printf.
                printf "%b" (string join "\n" (vterm_old_fish_prompt))
                vterm_prompt_end
            end
        end
      '';
    };

    home.packages = [ pkgs.fishPlugins.foreign-env ];

    programs.fish.shellAliases = {
      pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
      pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
    };
  };
}
