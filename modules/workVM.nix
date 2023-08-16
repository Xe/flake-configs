inputs:
({ pkgs, config, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.2"
  ];
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "unlimited";
  }];

  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
  '';

  services.resolved = {
    enable = true;
    dnssec = "false";
  };

  users.groups.xe = { };
  users.users.xe = {
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
    isNormalUser = true;
    group = "xe";
  };

  boot.binfmt.emulatedSystems = [ "wasm32-wasi" ];

  environment.systemPackages = with pkgs; [ mosh flyctl ];
  virtualisation.docker.enable = true;

  services.tailscale.enable = true;

  home-manager.users.xe = { lib, ... }:
    let
      name = "Xe Iaso";
      email = "xe@tailscale.com";
      commitTemplate = pkgs.writeTextFile {
        name = "xe-commit-template";
        text = ''
          Signed-off-by: ${name} <${email}>
        '';
      };
    in {
      imports = [ ../common/home-manager ];

      within = {
        emacs.enable = true;
        fish.enable = true;
        neofetch.enable = true;
        vim.enable = true;
        tmux.enable = true;
      };

      services.lorri.enable = true;
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
})
