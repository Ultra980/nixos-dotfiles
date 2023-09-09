{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.forgejo;
in {
  options.services.forgejo = {
    enable = mkEnableOption (mdDoc "Enable forgejo");
    hostAddress = mkOption {
      type = types.str;
      default = "192.168.0.221";
    };
    localAddress = mkOption {
      type = types.str;
      default = "192.168.0.222";
    };
    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/forgejo";
    };
    package = mkOption {
      type = types.package;
      default = pkgs.forgejo;
    };
        
  };
  config = mkIf cfg.enable {
    containers = {
      forgejo = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = cfg.hostAddress;
        localAddress = cfg.localAddress;
        config = ( cfg: { config, pkgs, ... }: {
          services.gitea = cfg; /*{
            enable = true;
            package = pkgs.forgejo;
            stateDir = /var/lib/forgejo;
          
          }; */
          networking.useHostResolvConf = mkForce false;
        } cfg );
      };
    };
  };
}

