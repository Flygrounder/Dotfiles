{ pkgs, lib, config, ... }: {
  options = { custom.cli.enable = lib.mkEnableOption "Enable CLI module"; };
  config = lib.mkIf config.custom.cli.enable {
    my = {
      home.packages = with pkgs; [ git fastfetch bottom ];
      programs = {
        starship.enable = true;
        fish = {
          enable = true;
          functions = { fish_greeting = ""; };
          shellAliases = { lg = "lazygit"; };
        };
        zoxide.enable = true;
        lazygit.enable = true;
        eza.enable = true;
        bat.enable = true;
      };
    };
  };
}
