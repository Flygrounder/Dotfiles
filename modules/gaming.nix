{ lib, config, ... }: {
  options = {
    custom.gaming.enable = lib.mkEnableOption "Enable gaming module";
  };
  config = lib.mkIf config.custom.gaming.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
