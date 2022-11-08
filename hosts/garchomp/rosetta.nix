{ config, lib, ...}: {
  boot.initrd.availableKernelModules = [ "virtiofs" ];
  fileSystems."/run/rosetta" = {
    device = "rosetta";
    fsType = "virtiofs";
  };
  nix.settings.extra-platforms = [ "x86_64-linux" ];
  nix.settings.extra-sandbox-paths = [ "/run/rosetta" "/run/binfmt" ];
  boot.binfmt.registrations."rosetta" = { # based on https://developer.apple.com/documentation/virtualization/running_intel_binaries_in_linux_vms_with_rosetta#3978495
    interpreter = "/run/rosetta/rosetta";
    fixBinary = true;
    wrapInterpreterInShell = false;
    matchCredentials = true;
    magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
    mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
  };
}
