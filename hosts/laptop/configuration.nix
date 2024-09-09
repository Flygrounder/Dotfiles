{ ... }: {
  boot.initrd.luks.devices."luks-6f48c27b-c755-4d74-90b4-552685ae256a".device =
    "/dev/disk/by-uuid/6f48c27b-c755-4d74-90b4-552685ae256a";
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "laptop";
  hardware.bluetooth.enable = true;
  services.tlp.enable = true;
  custom = {
    desktop.enable = true;
    neovim.enable = true;
    cli.enable = true;
    hyprland.enable = true;
  };
}
