{
  description = "My deploy-rs config for logos";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixpkgs-master.url = "nixpkgs/master";

    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };

    # my apps
    printerfacts = {
      url = "git+https://tulpa.dev/cadey/printerfacts.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
    mara = {
      url = "git+https://tulpa.dev/Xe/mara.git?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
    rhea = {
      url = "github:Xe/rhea";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    waifud = {
      url = "github:Xe/waifud";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
    x = {
      url = "github:Xe/x";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
    };
  };

  outputs = { self, nixpkgs, deploy-rs, home-manager, agenix, printerfacts, mara
    , rhea, waifud, emacs-overlay, wsl, x, nixpkgs-master, ... }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      pkgsMaster = nixpkgs-master.legacyPackages."x86_64-linux";

      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager

            ({ config, ... }: {
              system.configurationRevision = self.sourceInfo.rev;
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${self.sourceInfo.rev} - \\l >>>";

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              nixpkgs.overlays = [
                emacs-overlay.overlay
              ];
            })
            ./common

            printerfacts.nixosModules.${system}.printerfacts
            mara.nixosModules.${system}.bot
            rhea.nixosModule.${system}
            x.nixosModules.${system}.robocadey

          ] ++ extraModules;
        };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          deploy-rs.packages.x86_64-linux.deploy-rs
          agenix.packages.x86_64-linux.agenix
          pkgsMaster.vim
        ];
      };

      nixosConfigurations = {
        # wsl
        xatci = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            wsl.nixosModules.wsl

            ({ config, ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              nixpkgs.overlays = [ emacs-overlay.overlay ];

              networking.hostName = "xatci";
              networking.nameservers = [ "100.100.100.100" ];
              networking.search = [ "shark-harmonic.ts.net" ];

              wsl = {
                enable = true;
                automountPath = "/mnt";
                defaultUser = "cadey";
                startMenuLaunchers = true;
              };

              nix.package = pkgs.nixFlakes;
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
                  email = "me@christine.website";
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
            })
          ];
        };

        # avalon
        chrysalis = mkSystem [ ./hosts/chrysalis ./hardware/location/YOW ];

        itsuki = mkSystem [ ./hosts/itsuki ./hardware/location/YOW ];

        kos-mos = mkSystem [
          ./hosts/kos-mos
          ./hardware/alrest
          ./hardware/location/YOW
          waifud.nixosModules.x86_64-linux.waifud-runner
        ];

        logos = mkSystem [
          ./hosts/logos
          ./hardware/alrest
          ./hardware/location/YOW
          waifud.nixosModules.x86_64-linux.waifud-runner
        ];

        ontos = mkSystem [
          ./hosts/ontos
          ./hardware/alrest
          ./hardware/location/YOW
          waifud.nixosModules.x86_64-linux.waifud-runner
        ];

        pneuma = mkSystem [
          ./hosts/pneuma
          ./hardware/alrest
          ./hardware/location/YOW
          waifud.nixosModules.x86_64-linux.waifud-runner
        ];

        # cloud
        firgu = mkSystem [ ./hosts/firgu ./hardware/location/YYZ ];

        # vms
        ## logos
        hugo = mkSystem [ ./hosts/vm/hugo ./hardware/libvirt-generic ];
      };

      deploy.nodes.chrysalis = {
        hostname = "192.168.2.29";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.chrysalis;
        };
      };

      deploy.nodes.firgu = {
        hostname = "149.248.59.1";
        sshUser = "root";

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.firgu;
        };
      };

      deploy.nodes.itsuki = {
        hostname = "192.168.2.174";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.itsuki;
        };
      };

      deploy.nodes.logos = {
        hostname = "192.168.2.35";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.logos;
        };
      };

      deploy.nodes.kos-mos = {
        hostname = "192.168.2.32";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.kos-mos;
        };
      };

      deploy.nodes.ontos = {
        hostname = "192.168.2.34";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.ontos;
        };
      };

      deploy.nodes.pneuma = {
        hostname = "192.168.2.33";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.pneuma;
        };
      };

      # deploy.nodes.hugo = {
      #   hostname = "10.77.129.6";
      #   sshUser = "root";
      #   fastConnection = true;

      #   profiles.system = {
      #     user = "root";
      #     path = deploy-rs.lib.x86_64-linux.activate.nixos
      #       self.nixosConfigurations.hugo;
      #   };
      # };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
