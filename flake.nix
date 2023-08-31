{
  description = "My deploy-rs config for logos";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    xesite = {
      url = "github:Xe/site";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "utils";
    };
  };

  outputs = { self, nixpkgs, deploy-rs, home-manager, agenix, printerfacts, mara
    , rhea, waifud, emacs-overlay, wsl, x, xesite, vscode-server, ... }@inputs:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";

      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            vscode-server.nixosModule

            ({ config, ... }: {
              system.configurationRevision = self.sourceInfo.rev;
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${self.sourceInfo.rev} - \\l >>>";

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              nixpkgs.overlays = [
                emacs-overlay.overlay
                (import ./overlays/tree-sitter-typescript.nix)
                (import ./overlays/weechat.nix)
              ];

              services.vscode-server.enable = true;

              environment.systemPackages = with pkgs;
                [ x.packages.${system}.uploud ];
            })
            ./common

            printerfacts.nixosModules.${system}.printerfacts
            mara.nixosModules.${system}.bot
            rhea.nixosModule.${system}
            x.nixosModules.default
            #xesite.nixosModules.default

          ] ++ extraModules;
        };
      
      mkAlrest = extraModules:
        mkSystem (extraModules ++ [
          ./hardware/alrest
          ./hardware/location/YOW
          waifud.nixosModules.x86_64-linux.waifud-runner
        ]);
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          deploy-rs.packages.x86_64-linux.deploy-rs
          agenix.packages.x86_64-linux.agenix
        ];
      };

      nixosModules = {
        microcode = import ./common/microcode.nix;
        home-manager = import ./common/home-manager;
        workVM = import ./modules/workVM.nix inputs;
      };

      nixosConfigurations = {
        # avalon
        chrysalis = mkSystem [ ./hosts/chrysalis ./hardware/location/YOW ];

        itsuki = mkSystem [ ./hosts/itsuki ./hardware/location/YOW ];

        kos-mos = mkAlrest [ ./hosts/kos-mos ];

        logos = mkAlrest [ ./hosts/logos ];

        ontos = mkAlrest [ ./hosts/ontos ];

        pneuma = mkAlrest [ ./hosts/pneuma ];

        joker = mkSystem [ ./hosts/joker ./hardware/location/YYZ ];

        # cloud
        akko = mkSystem [ ./hosts/akko ./hardware/location/YYZ ];

        firgu = mkSystem [ ./hosts/firgu ./hardware/location/YYZ ];
      };

      deploy.nodes.akko = {
        hostname = "akko.within.website";
        sshUser = "root";

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.akko;
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

      deploy.nodes.chrysalis = {
        hostname = "192.168.2.46";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.chrysalis;
        };
      };

      deploy.nodes.itsuki = {
        hostname = "192.168.2.34";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.itsuki;
        };
      };

      deploy.nodes.joker = {
        hostname = "192.168.2.232";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.joker;
        };
      };

      deploy.nodes.logos = {
        hostname = "192.168.2.43";
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
        hostname = "192.168.2.25";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.ontos;
        };
      };

      deploy.nodes.pneuma = {
        hostname = "192.168.2.31";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.pneuma;
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
