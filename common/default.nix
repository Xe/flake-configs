{ config, lib, pkgs, ... }: {
  imports = [ ./users ./microcode.nix ./no-rsa-ssh-hostkey.nix ];

  boot.tmp.cleanOnBoot = true;
  boot.kernelModules = [ "wireguard" ];

  environment.systemPackages = with pkgs; [
    age
    minisign
    tmate
    jq
    nfs-utils
    git
    mosh
    wasmer
    wasmtime
    nodejs-16_x
  ];

  security.polkit.enable = true;
  programs.nix-ld.enable = true;

  programs.zsh.enable = true;

  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.loginShellInit = ''
    ## XXX(Xe): unfuck nix-ld
    eval (cat /etc/set-environment | grep NIX_LD)
  '';

  boot.binfmt.emulatedSystems = [ "wasm32-wasi" "aarch64-linux" ];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
      sandbox = true;
      substituters = [
        "https://xe.cachix.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://cache.floxdev.com?trusted=1"
        "https://cache.garnix.io"
      ];
      trusted-users = [ "root" "cadey" ];
      trusted-public-keys = [
        "xe.cachix.org-1:kT/2G09KzMvQf64WrPBDcNWTKsA79h7+y2Fn2N7Xk2Y="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "flox-store-public-0:8c/B+kjIaQ+BloCmNkRUKwaVPFWkriSAd0JJvuDu4F0="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };

  services.prometheus.exporters.node.enable = true;
  services.prometheus.exporters.node.enabledCollectors = [ "systemd" ];

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

  system.stateVersion = lib.mkDefault "21.05";
}
