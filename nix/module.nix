{ config, lib, pkgs, ... }:
{
  config = {
    services.cage = {
      enable = true;
      program = "${lib.getExe pkgs.ungoogled-chromium} --kiosk http://localhost:1024";
    };

    systemd.services.serface = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      before = [ "cage-tty1.service" ];
      description = "Serface server";
      serviceConfig = {
        ExecStart = lib.getExe pkgs.serface;
        User = config.services.cage.user;
        UtmpIdentifier = "%n";
        UtmpMode = "user";
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

    users.users.${config.services.cage.user} = {
      initialPassword = config.services.cage.user;
      isNormalUser = true;
    };

    nix.enable = false;

    system.stateVersion = lib.version;
  };
}
