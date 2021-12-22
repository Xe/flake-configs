{ config, pkgs, lib, ... }:

with lib;

let cfg = config.within.users.enableSystem;
in {
  options.within.users = {
    enableSystem = mkEnableOption "enable system-wide users (vic, mai)";
  };

  config = mkIf cfg {
    users.users.mai = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [ "within" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOyr7PjUfbALe3+zgygnL0fQz4GhQ7qT9b0Lw+1Gzwk"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrz5T/RdragJF6StZm92JZKPMJinYdw5fYnV4osiY8Q"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF0I+UJPT7noL/bDvPj25SC24kpThqHUtge3tSQ9sIUx"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL46usOZyZD+CYa5wNBSpPxNWwF3EMeeAytPq6iVPO2X"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN76Ol48QNvRjjjIaAa3WPqVWB/ryFMmOUJpszEz13TO"
      ];
    };

    home-manager.users.mai = (import ./mai);

    users.users.vic = {
      isNormalUser = true;
      extraGroups = [ "wheel" "libvirtd" "adbusers" "dialout" "within" ];
      shell = pkgs.powershell;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZBjzU/7vrR8isVC2xzRamcREWw+oLeB2cS+zfZwqEwXHTI99LonR2ow5xlnngmBcJMQo8aIChwwX4iHVuUIx5ObvfbtauqWjImr8ItNqJgMnbPXwzNVJmuuhC7ThxoSYWlmyRQNChE1BAcVeSqU9Vjvc4No9GYAOMOazeAhz5jnesauemFU1WTgIcdnUyuBA2vHNYj/I0K5FHUSjpePccCwpCz+5ieELMcpGv+Wtlq8v8OiasxmLP7MORX6AClvqPtczd5M40rLlX96AoEXuviUbEvy2GzaKsutzyI7OdnfCMw2PWhxL0kjNWsU4VAYVH1EdOfoJeeEO8FuSUIQnd"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIChFSS2KUKbGYFrkbO2VwxuWqFkCSdzbxh68Edk+Pkss victo@Nami"
      ];
    };

    home-manager.users.vic = (import ./vic);
  };
}
