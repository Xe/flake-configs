{ config, lib, pkgs, ... }: {
  imports = [ ./users ./microcode.nix ];

  boot.cleanTmpDir = true;
  boot.kernelModules = [ "wireguard" ];

  environment.systemPackages = with pkgs; [
    age
    minisign
    tmate
    jq
    nfs-utils
    git
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      sandbox = true;
      substituters =
        [ "https://xe.cachix.org" "https://nix-community.cachix.org" ];
      trusted-users = [ "root" "cadey" ];
      trusted-public-keys = [
        "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
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

  systemd.services.nginx.serviceConfig.SupplementaryGroups = "within";

  users.groups.within = { };
  systemd.services."within.homedir-setup" = {
    description = "Creates homedirs for /srv/within services";
    wantedBy = [ "multi-user.target" ];

    serviceConfig.Type = "oneshot";

    script = with pkgs; ''
      ${coreutils}/bin/mkdir -p /srv/within
      ${coreutils}/bin/chown root:within /srv/within
      ${coreutils}/bin/chmod 775 /srv/within
      ${coreutils}/bin/mkdir -p /srv/within/run
      ${coreutils}/bin/chown root:within /srv/within/run
      ${coreutils}/bin/chmod 770 /srv/within/run
    '';
  };
}
