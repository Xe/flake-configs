{ config, pkgs, ... }:

{
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    openMulticastPort = true;
    config = {
      IfName = "yggdrasil0";
      Peers = [
        "tls://ca1.servers.devices.cwinfo.net:58226"
        "tls://192.99.145.61:58226"
        "tcp://kusoneko.moe:9002"
      ];
    };
  };
}
