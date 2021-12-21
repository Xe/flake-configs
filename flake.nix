{
  description = "My deploy-rs config for logos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    deploy-rs.url = "github:serokell/deploy-rs";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, deploy-rs, home-manager, utils, ... }:
    let pkgs = nixpkgs.legacyPackages."x86_64-linux";
    in {
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [ deploy-rs.packages.x86_64-linux.deploy-rs ];
      };

      nixosConfigurations.logos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./hosts/logos
          ./hardware/alrest
        ];
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

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
