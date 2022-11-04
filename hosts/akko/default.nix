{ ... }: {
  imports = [
    ./akkoma.nix
    ./hardware-configuration.nix
  ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "akko";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6NPbPIcCTzeEsjyx0goWyj6fr2qzcfKCCdOUqg0N/v cadey@kos-mos" 
  ];

  security.acme.email = "me@xeiaso.net";
  security.acme.acceptTerms = true;

  services.nginx = {
    enable = true;

    clientMaxBodySize = "128m";
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };
}
