{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "desktop";
  services.greetd.enable = true;
  programs.regreet.enable = true;
  hardware.ledger.enable = true;
  my.home.packages = with pkgs; [ ledger-live-desktop monero-gui ];
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
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  custom = {
    hyprland.enable = true;
    desktop.enable = true;
    cli.enable = true;
    gaming.enable = true;
    hp-printer.enable = true;
    neovim.enable = true;
  };
}
