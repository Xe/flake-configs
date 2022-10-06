{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.within.services.jenkinsAgent;
  masterCfg = config.services.jenkins;
in {
  options = {
    within.services.jenkinsAgent = {
      # todo:
      # * assure the profile of the jenkins user has a JRE and any specified packages. This would
      # enable ssh agents.
      # * Optionally configure the node as a jenkins ad-hoc agent. This would imply configuration
      # properties for the master node.
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If true the system will be configured to work as a jenkins agent.
          If the system is also configured to work as a jenkins master then this has no effect.
          In progress: Currently only assures the jenkins user is configured.
        '';
      };

      user = mkOption {
        default = "jenkins-agent";
        type = types.str;
        description = ''
          User the jenkins agent should execute under.
        '';
      };

      group = mkOption {
        default = "jenkins-agent";
        type = types.str;
        description = ''
          If the default agent user "jenkins" is configured then this is
          the primary group of that user.
        '';
      };

      home = mkOption {
        default = "/var/lib/jenkins-agent";
        type = types.path;
        description = ''
          The path to use as JENKINS_HOME. If the default user "jenkins" is configured then
          this is the home of the "jenkins" user.
        '';
      };

      javaPackage = mkOption {
        default = pkgs.jdk;
        defaultText = literalExpression "pkgs.jdk";
        description = ''
          Java package to install.
        '';
        type = types.package;
      };
    };
  };

  config = mkIf (cfg.enable && !masterCfg.enable) {
    users.groups = optionalAttrs (cfg.group == "jenkins-agent") {
      jenkins-agent.gid = config.ids.gids.jenkins;
    };

    users.users.jenkins = {
      description = "jenkins user";
      createHome = true;
      home = cfg.home;
      group = cfg.group;
      useDefaultShell = true;
    };

    programs.java = {
      enable = true;
      package = cfg.javaPackage;
    };
  };
}
