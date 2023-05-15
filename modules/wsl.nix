inputs:
{ config, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  networking.hostName = "xatci";
  networking.nameservers = [ "100.100.100.100" ];
  networking.search = [ "shark-harmonic.ts.net" ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "cadey";
    startMenuLaunchers = true;
  };

  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users.users.cadey = {
    extraGroups = [
      "wheel"
      "docker"
      "audio"
      "plugdev"
      "libvirtd"
      "adbusers"
      "dialout"
      "within"
    ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [ mosh flyctl ];
  virtualisation.docker.enable = true;

  home-manager.users.cadey = { lib, ... }:
    let
      name = "Xe Iaso";
      email = "me@xeiaso.net";
      commitTemplate = pkgs.writeTextFile {
        name = "cadey-commit-template";
        text = ''
          Signed-off-by: ${name} <${email}>
        '';
      };
    in {
      imports = [ ./common/home-manager ];

      within = {
        emacs.enable = true;
        fish.enable = true;
        neofetch.enable = true;
        vim.enable = true;
        tmux.enable = true;
      };

      services.emacs.enable = lib.mkForce false;
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;

      programs.git = {
        package = pkgs.gitAndTools.gitFull;
        enable = true;
        userName = name;
        userEmail = email;
        ignores = [ "*~" "*.swp" "*.#" ];
        delta.enable = true;
        extraConfig = {
          commit.template = "${commitTemplate}";
          core.editor = "vim";
          color.ui = "auto";
          credential.helper = "store --file ~/.git-credentials";
          format.signoff = true;
          init.defaultBranch = "main";
          protocol.keybase.allow = "always";
          pull.rebase = "true";
          push.default = "current";
        };
      };
    };
}
