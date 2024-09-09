{ pkgs, lib, config, ... }: {
  options = { custom.qtile.enable = lib.mkEnableOption "Enable qtile module"; };
  config = lib.mkIf config.custom.qtile.enable {
    services.xserver.windowManager.qtile.enable = true;
  };
}
