{ config, lib, pkgs, ... }: {
  imports = [ ./users ];

  boot.cleanTmpDir = true;
  boot.kernelModules = [ "wireguard" ];

  environment.systemPackages = with pkgs; [ age minisign tmate jq nfs-utils git ];

  nix = {
    autoOptimiseStore = true;
    useSandbox = true;
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    binaryCaches =
      [ "https://xe.cachix.org" "https://nix-community.cachix.org" ];
    binaryCachePublicKeys = [
      "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    trustedUsers = [ "root" "cadey" ];
  };

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
}
