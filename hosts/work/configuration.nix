{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "work";
  custom = {
    desktop.enable = true;
    cli.enable = true;
    neovim.enable = true;
  };
}
