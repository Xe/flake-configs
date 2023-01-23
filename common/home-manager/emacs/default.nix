{ pkgs, lib, config, ... }:

with lib;

let cfg = config.within.emacs;
in {
  options.within.emacs.enable =
    mkEnableOption "emacs without spacemacs support";
  imports = [ ./emacs-init.nix ./emacs-init-defaults.nix ];

  config = mkIf cfg.enable {
    home.file."bin/e" = {
      text = ''
        #!/bin/sh
        emacsclient -a "" -nc $@
      '';
      executable = true;
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacsUnstable-nox;

      init = {
        enable = true;

        recommendedGcSettings = true;

        prelude = ''
          (require 'bind-key)

          (setq inhibit-startup-screen t)

          (menu-bar-mode -1)

          (electric-pair-mode)

          (recentf-mode 1)
          (setq recentf-max-menu-items 25)
          (setq recentf-max-saved-items 25)
          (global-set-key "\C-x\ \C-r" 'recentf-open-files)

          (when window-system
            (dolist (mode
              '(tool-bar-mode
                tooltip-mode
                scroll-bar-mode
                menu-bar-mode
                blink-cursor-mode))
              (funcall mode 0)))

          (add-hook 'text-mode-hook 'auto-fill-mode)

          (setq delete-old-versions -1 )		; delete excess backup versions silently
          (setq version-control t )		; use version control
          (setq vc-make-backup-files t )		; make backups file even when in version controlled dir
          (setq backup-directory-alist `(("." . "~/.emacs.d/backups")) ) ; which directory to put backups file
          (setq vc-follow-symlinks t )				       ; don't ask for confirmation when opening symlinked file
          (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ) ;transform backups file name
          (setq inhibit-startup-screen t )	; inhibit useless and old-school startup screen
          (setq ring-bell-function 'ignore )	; silent bell when you make a mistake
          (setq coding-system-for-read 'utf-8 )	; use utf-8 by default
          (setq coding-system-for-write 'utf-8 )
          (setq sentence-end-double-space nil)	; sentence SHOULD end with only a point.
          (setq default-fill-column 80)		; toggle wrapping text at the 80th character

          (defun chomp (str)
            "Chomp leading and tailing whitespace from STR."
            (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
                                str)
              (setq str (replace-match "" t t str)))
            str)

          (defun eshell/e (arg)
            "opens a given file in emacs from eshell"
            (find-file arg))

          (defun eshell/eh (arg)
            "opens a file in emacs from shell horizontally"
            (split-window-vertically)
            (other-window 1)
            (find-file arg))

          (defun eshell/ev (arg)
            "opens a file in emacs from shell vertically"
            (split-window-horizontally)
            (other-window 1)
            (find-file arg))

          ;;;; Mouse scrolling in terminal emacs
          (unless (display-graphic-p)
            ;; activate mouse-based scrolling
            (xterm-mouse-mode 1)
            (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
            (global-set-key (kbd "<mouse-5>") 'scroll-up-line))
        '';

        usePackageVerbose = true;

        usePackage = {
          # core packages
          better-defaults.enable = true;

          company = {
            enable = true;
            diminish = [ "company-mode" ];
            config = ''
              (company-mode)
            '';
          };

          counsel = {
            enable = true;

            bindStar = {
              "M-x" = "counsel-M-x";
              "C-x C-f" = "counsel-find-file";
              "C-x C-r" = "counsel-recentf";
              "C-c f" = "counsel-git";
              "C-c s" = "counsel-git-grep";
              "C-c /" = "counsel-rg";
              "C-c l" = "counsel-locate";
              "M-y" = "counsel-yank-pop";
            };

            general = ''
              (general-nmap
                :prefix "SPC"
                "SPC" '(counsel-M-x :which-key "M-x")
                "ff"  '(counsel-find-file :which-key "find file")
                "s"   '(:ignore t :which-key "search")
                "sc"  '(counsel-unicode-char :which-key "find character"))
            '';
          };

          direnv = {
            enable = true;
            config = ''
              (direnv-mode)
            '';
          };

          evil = {
            enable = true;
            init = ''
              (setq evil-want-C-i-jump nil)
            '';
            config = ''
              (evil-mode 1)
            '';
          };

          evil-surround = {
            enable = true;
            config = ''
              (global-evil-surround-mode 1)
            '';
          };

          evil-collection = {
            enable = true;
            after = [ "evil" ];
          };

          evil-magit = {
            enable = true;
            after = [ "magit" ];
          };

          flycheck = {
            enable = true;
            diminish = [ "flycheck-mode" ];
            config = ''
              (global-flycheck-mode)
            '';
          };

          lsp-mode = {
            enable = true;
            command = [ "lsp" ];
            hook = [
              "(go-mode . lsp)"
              "(rust-mode . lsp)"
              "(lsp-mode . lsp-enable-which-key-integration)"
            ];
            config = ''
              (setq lsp-rust-server 'rust-analyzer)
            '';
          };

          lsp-ui = {
            enable = true;
            after = [ "lsp" ];
            command = [ "lsp-ui-mode" ];
          };

          lsp-ivy = {
            enable = true;
            after = [ "lsp" "ivy" ];
            command = [ "lsp-ivy-workspace-symbol" ];
          };

          general = {
            enable = true;
            after = [ "evil" "which-key" ];
            config = ''
              (general-evil-setup)

              (general-mmap
                ":" 'evil-ex
                ";" 'evil-repeat-find-char)

              (general-create-definer my-leader-def
                :prefix "SPC")

              (general-create-definer my-local-leader-def
                :prefix "SPC m")

              (general-nmap
                :prefix "SPC"
                "b"  '(:ignore t :which-key "buffer")
                "bd" '(kill-this-buffer :which-key "kill buffer")

                "f"  '(:ignore t :which-key "file")
                "ff" '(find-file :which-key "find")
                "fs" '(save-buffer :which-key "save")

                "m"  '(:ignore t :which-key "mode")

                "t"  '(:ignore t :which-key "toggle")
                "tf" '(toggle-frame-fullscreen :which-key "fullscreen")
                "wv" '(split-window-horizontally :which-key "split vertical")
                "ws" '(split-window-vertically :which-key "split horizontal")
                "wk" '(evil-window-up :which-key "up")
                "wj" '(evil-window-down :which-key "down")
                "wh" '(evil-window-left :which-key "left")
                "wl" '(evil-window-right :which-key "right")
                "wd" '(delete-window :which-key "delete")

                "q"  '(:ignore t :which-key "quit")
                "qq" '(save-buffers-kill-emacs :which-key "quit"))
            '';
          };

          fountain-mode = {
            enable = true;
            mode = [
              ''("\\.fountain\\'" . fountain-mode)''
            ];
          };

          ivy = {
            enable = true;
            demand = true;
            diminish = [ "ivy-mode" ];
            config = ''
              (ivy-mode 1)
              (setq ivy-use-virtual-buffers t
                    ivy-hight 25
                    ivy-count-format "(%d/%d) "
                    ivy-initial-inputs-alist nil)
            '';
            general = ''
              (general-nmap
                :prefix "SPC"
                "bb" '(ivy-switch-buffer :which-key "switch buffer")
                "fr" '(ivy-recentf :which-key "recent file"))
            '';
          };

          magit = {
            enable = true;

            general = ''
              (general-nmap
                :prefix "SPC"
                "g" '(:ignore t :which-key "Git")
                "gs" 'magit-status)
            '';
          };

          markdown-mode = {
            enable = true;
            command = [ "markdown-mode" "gfm-mode" ];
            mode = [
              ''("README\\.md\\'" . gfm-mode)''
              ''("\\.md\\'" . markdown-mode)''
              ''("\\.mdx\\'" . markdown-mode)''
              ''("\\.markdown\\'" . markdown-mode)''
            ];
          };

          projectile = {
            enable = true;
            after = [ "ivy" ];
            diminish = [ "projectile-mode" ];
            config = ''
              (projectile-mode 1)
              (progn
                (setq projectile-enable-caching t)
                (setq projectile-require-project-root nil)
                (setq projectile-completion-system 'ivy)
                (add-to-list 'projectile-globally-ignored-files ".DS_Store"))
            '';
            general = ''
              (general-nmap
                :prefix "SPC"
                "p"  '(:ignore t :which-key "Project")
                "pf" '(projectile-find-file :which-key "Find in project")
                "pl" '(projectile-switch-project :which-key "Switch project"))
            '';
          };

          rainbow-delimiters = {
            enable = true;
            config = ''
              (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
            '';
          };

          swiper = {
            enable = true;

            bindStar = { "C-s" = "swiper"; };

            general = ''
              (general-nmap
                :prefix "SPC"
                "ss" '(swiper :which-key "swiper"))
            '';
          };

          which-key = {
            enable = true;
            diminish = [ "which-key-mode" ];
            config = ''
              (which-key-mode)
              (which-key-setup-side-window-right-bottom)
              (setq which-key-sort-order 'which-key-key-order-alpha
                    which-key-side-window-max-width 0.33
                    which-key-idle-delay 0.05)
            '';
          };

          gruvbox-theme = {
            enable = true;
            config = ''
              (setq custom-safe-themes t)
              (add-hook 'after-init-hook (lambda () (load-theme 'gruvbox-dark-soft t)))
            '';
          };

          nov = {
            enable = true;
            mode = [ ''"\\.epub\\'"'' ];
          };

          web-mode = {
            enable = true;
            mode = [ ''"\\.html\\'"'' ''"\\.tmpl\\'"'' ];
            config = ''
              (define-derived-mode typescript-tsx-mode web-mode "TypeScript-tsx")
              (add-to-list 'auto-mode-alist '("\\.tsx\\'" . typescript-tsx-mode))
            '';
          };

          # org-mode
          org = {
            enable = true;
            config = ''
              (setq org-agenda-files '("~/org/daily/" "~/org/"))

              (setq org-capture-templates '(("c" "Contacts" entry (file "~/org/contacts.org")
                                                 "* %(org-contacts-template-name)\n:PROPERTIES:\n:EMAIL: %(org-contacts-template-email)\n:END:")))
            '';
          };

          org-journal = {
            enable = true;
            config = ''
              (setq org-journal-dir "~/org/daily/")
              (setq org-journal-date-prefix "#+startup: logdrawer\n#+options: d:t\n#+TITLE: ")
              (setq org-journal-file-format "%Y%m%d.org")
              (setq org-journal-time-prefix "* ")
              (setq org-journal-time-format "TODO ")
              (setq org-journal-enable-agenda-integration t)
            '';
          };

          org-roam = {
            enable = true;
            config = ''
              (setq org-roam-directory "~/org/roam")
            '';
          };

          ob.enable = true;
          org-download.enable = true;
          org-mime.enable = true;
          org-pomodoro.enable = true;
          org-projectile.enable = true;
          org-contacts.enable = true;
          ox-epub.enable = true;
          org-roam-ui.enable = true;
          org-roam-protocol.enable = true;

          systemd.enable = true;

          gemini-mode.enable = true;
          highlight-indent-guides.enable = true;
          "0x0".enable = true;
          request.enable = true;

          # programming languages
          cython-mode.enable = true;
          dockerfile-mode.enable = true;
          nix.enable = true;
          protobuf-mode.enable = true;
          terraform-mode.enable = true;

          ## typescript
          js2-mode.enable = true;
          #rjsx-mode.enable = true;
          tide.enable = true;
          typescript-mode = {
            enable = true;
            config = ''
              (setq typescript-indent-level 2)
            '';
          };

          deno-fmt = {
            enable = true;
            config = ''
              (add-hook 'typescript-mode-hook 'deno-fmt-mode)
              (add-hook 'js2-mode-hook 'deno-fmt-mode)
            '';
          };

          go-mode = {
            enable = true;
            config = ''
              (setq gofmt-command "goimports")
            '';
          };

          nix-mode = {
            enable = true;
            mode = [ ''"\\.nix\\'"'' ];
            bindLocal = { nix-mode-map = { "C-i" = "nix-indent-line"; }; };
          };

          nix-prettify-mode = {
            enable = true;
            config = ''
              (nix-prettify-global-mode)
            '';
          };

          nix-drv-mode = {
            enable = true;
            mode = [ ''"\\.drv\\'"'' ];
          };

          dhall-mode = {
            enable = true;
            mode = [ ''"\\.dhall\\'"'' ];
          };

          moonscript = {
            enable = true;
            mode = [ ''"\\.moon\\'"'' ];
          };

          rust-mode = {
            enable = true;
            mode = [ ''"\\.rs\\'"'' ];
          };

          toml-mode = {
            enable = true;
            mode = [ ''"\\.toml\\'"'' ];
          };

          zig-mode = {
            enable = true;
            mode = [ ''"\\.zig\\'"'' ];
          };

          ## custom shit
          xe-tools = {
            enable = true;
            package = (epkgs: epkgs.trivialBuild {
              pname = "xe-tools";
              src = ./xe-tools.el;
            });
            general = ''
              (general-nmap
                :prefix "SPC"
                "x-l-d" '(xe/look-of-disapproval))
            '';
          };
        };
      };
    };
  };
}
