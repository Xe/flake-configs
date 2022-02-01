{config, pkgs, lib, ...}:

{
  services.znc = {
    enable = true;
    openFirewall = true;
    useLegacyConfig = false;

    config = {
      LoadModule = [ "webadmin" ];
      User.Mara = {
        Admin = true;
        Nick = "Mara";
        RealName = "Mara the Sh0rk";
        QuitMsg = "sh0rknap";
        LoadModule = [ "chansaver" "controlpanel" ];
        Pass.password = { # hunter2
          Method = "sha256";
          Hash =
            "7ab28a482206bfe8f72b3e8d75fb513de0a7cb6382f2cb4817128de24b801a6f";
          Salt = "oHoLmhoNEA61woJWaqS-";
        };
      };
    };
  };
}
