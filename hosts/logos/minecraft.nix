{ ... }: {
  services.minecraft-server = {
    enable = false;
    eula =
      true; # set to true if you agree to Mojang's EULA: https://account.mojang.com/documents/minecraft_eula
    declarative = true;

    # see here for more info: https://minecraft.gamepedia.com/Server.properties#server.properties
    serverProperties = {
      server-port = 25565;
      gamemode = "survival";
      motd = "logos";
      max-players = 20;
      enable-rcon = true;
      "rcon.password" = "hunter2";
      level-seed = "10292992";
    };
  };
}
