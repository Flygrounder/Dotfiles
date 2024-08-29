{ pkgs, ... }: {
  imports = [ ../../modules ./hardware-configuration.nix ];
  networking.hostName = "desktop";
  users.users.dmitry = {
    isNormalUser = true;
    description = "Дмитрий";
    extraGroups = [ "networkmanager" ];
  };
  home-manager.users.dmitry.home = {
    username = "dmitry";
    homeDirectory = "/home/dmitry";
    stateVersion = "24.05";
    packages = with pkgs; [ firefox libreoffice-still ];
  };
  custom = {
    base.enable = true;
    hp-printer.enable = true;
    neovim.enable = true;
    nvidia.enable = true;
    cli.enable = true;
  };
}
