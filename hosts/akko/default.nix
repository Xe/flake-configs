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
}
