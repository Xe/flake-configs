{ config, pkgs, ... }:

{
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    openMulticastPort = true;
    config = {
      IfName = "yggdrasil0";
      Peers = [
        "tcp://kusoneko.moe:9002"
        "tcp://yyz.yuetau.net:6642"
      ];
    };
  };
}
