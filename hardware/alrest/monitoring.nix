{ config, pkgs, ... }:

{
  services.prometheus.exporters.node.enable = true;
}
