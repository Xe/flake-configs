{ config, pkgs, ... }:

{
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    openMulticastPort = true;
    settings = {
      IfName = "yggdrasil0";
      Peers = [
        "tcp://kusoneko.moe:9002"
        "tcp://yyz.yuetau.net:6642"
      ];
    };
  };
}
