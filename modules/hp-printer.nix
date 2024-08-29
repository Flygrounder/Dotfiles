{ pkgs, config, lib, ... }: {
  options = {
    custom.hp-printer.enable = lib.mkEnableOption "Enable HP printer";
  };
  config = lib.mkIf config.custom.hp-printer.enable {
    services.printing.enable = true;
    environment.systemPackages = with pkgs; [ vim hplipWithPlugin ];
    services.printing.drivers = [ pkgs.hplipWithPlugin ];
  };
}
