{ pkgs, ... }: {
  imports = [ ../../modules ./hardware-configuration.nix ];
  networking.hostName = "desktop";
  users.users.dmitry = {
    isNormalUser = true;
    description = "Дмитрий";
    extraGroups = [ "networkmanager" ];
  };
  services.desktopManager.plasma6.enable = true;
  home-manager.users.dmitry.home = {
    username = "dmitry";
    homeDirectory = "/home/dmitry";
    stateVersion = "24.05";
    packages = with pkgs; [ firefox libreoffice-still ];
  };
  custom = {
    base.enable = true;
    cli.enable = true;
    gaming.enable = true;
    hp-printer.enable = true;
    neovim.enable = true;
    nvidia.enable = true;
  };
}
