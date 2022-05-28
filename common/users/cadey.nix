{ config, pkgs, ... }:

{
  users.users.cadey = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "docker" "audio" "plugdev" "libvirtd" "adbusers" "dialout" "within" ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDK1sv1j0XAuHkcUB78D1S0Gv1mvJDjpCcZSTSgR5j3vxFoONctnb1BtnV75zR5YRkAfDNs00qeL+nyWA1s2VR9onaYRTQYO5TRsJhOgSijthn8qT8uK1ws1tWWui/sPzxbLu34nW8IsoQm3iFLD9yQCR7GK9e4WOU5itqLNMyh5jS7LTRKCSC2mi9IvYyTfFMggtuF3u7yFTksR02FOoox2YPzB8bHM3xBqPK46Z+fq+/mWaulnoXWcC3SZgjwpRmcEOAmTEQuk67jlpeumGqRU3lO6UFY3FDvQ8W1VYv2O1ZwPmV87S1pIEulX3WG+r7lO73bPT420PdoQehS/pY7"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsviqiUuN6t4YM2H+ApQtGAFx6TWJbWCqDDhInIh3X40ZAxtTmryRwAXdtHJ+v6HuGFU5XH3chDX1WSRbwVIrlxkX1hJIEZO379YSIHkORSrAmxF/2lsrW2zSjufZ6IS9yI7nsxe2mJf3GEiFjoAh2iGrSKnOACK2Y+o/SiO0BtDkOUIabofuAxf/RNOpn/HSPh/MabOxYuNOMO2bl+quYN7C1idyvVcNp0llfrnGGTCk5g3rDpR+CDQ0P2Ebg1hf4j2i/6XJmHL52Zg4b8hkoS9BzRcb2vOjGYZVR4lOMqR9ZcNMUBwMboJeQtsAib9DYaGjhMWgMQ76brXwE65sX"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPrz5T/RdragJF6StZm92JZKPMJinYdw5fYnV4osiY8Q"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH6BhO4roUnnppgf4GPDonhu0DOaA60dZ+JaFBZUa+IW"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPg9gYKVglnO2HQodSJt4z4mNrUSUiyJQ7b+J798bwD9"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAv/8Iprp3f+THr9txqoWKTO5KxnYVpiKI7e4mdTO2+b"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBp8WiNUFK6mbehvO94LAzIA4enTuWxugABC79tiQSHT"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC1e4qhGYEUCNoCYHUqfvPSkBfVdlIjmwQI7q8eibeWw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMOyr7PjUfbALe3+zgygnL0fQz4GhQ7qT9b0Lw+1Gzwk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL46usOZyZD+CYa5wNBSpPxNWwF3EMeeAytPq6iVPO2X"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN76Ol48QNvRjjjIaAa3WPqVWB/ryFMmOUJpszEz13TO"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICmEyBV301bq2VMa0cm4aE4peh57TcmNq4jHVN3Clufp cadey@la-tahorskami"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBJHpoa7MSKy50Jv0cKjb1B/6jh/VtB71v8OGrt+lw3P cadey@genza"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4mrGB2aTjHkp3r3Q7l8FHgtDPCCDqBUp9DykRWjcMA mara@blink"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6NPbPIcCTzeEsjyx0goWyj6fr2qzcfKCCdOUqg0N/v alrest cluster"
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNUAej4Q8+tZ4Wn0rjz+Jz6/eno7rlsuZBxJCmdDDiE5Teve2TTyFXJTifE4+w5xxbfkskR3pI9meAfq1+PdqmIAAAAEc3NoOg== cadey@shachi"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBJVMtDyxLCleOVugt1x6YlCQF5USS/M5cEFzpzKV8tGrKdkrzO/rKoLK4K7Ehk38sdUEoqA5NeV/rsG4KBe1W5Q= sutra touchid"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKgGePSwpBuHUhrFCRLch9Usqi7L0fKtgTRnh6F/R+ruAAAABHNzaDo= faded ring yubikey"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = config.users.users.cadey.openssh.authorizedKeys.keys;
  home-manager.users.cadey = (import ./cadey);
}
