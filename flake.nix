{
  description = "My deploy-rs config for logos";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";

    # my apps
    xe-printerfacts.url = "git+https://tulpa.dev/cadey/printerfacts.git?ref=main";
  };

  outputs = { self, nixpkgs, deploy-rs, home-manager, agenix, xe-printerfacts, ... }:
    let
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      mkSystem = extraModules:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            xe-printerfacts.nixosModules."${system}".printerfacts
            ({ config, ... }: {
              system.configurationRevision = self.sourceInfo.rev;
              services.getty.greetingLine =
                "<<< Welcome to NixOS ${config.system.nixos.label} @ ${self.sourceInfo.rev} - \\l >>>";

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            })
          ] ++ extraModules;
        };
    in {
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [
          deploy-rs.packages.x86_64-linux.deploy-rs
          agenix.packages.x86_64-linux.agenix
        ];
      };

      nixosConfigurations = {
        logos = mkSystem [ ./hosts/logos ./hardware/alrest ];

        # vms
        ## logos
        hugo = mkSystem [ ./hosts/vm/hugo ./hardware/libvirt-generic ];
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

      deploy.nodes.hugo = {
        hostname = "10.77.129.6";
        sshUser = "root";
        fastConnection = true;

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.hugo;
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
