{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "work";
  custom = {
    hyprland.enable = true;
    desktop.enable = true;
    cli.enable = true;
    neovim.enable = true;
  };
}
