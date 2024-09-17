{ ... }: {
  boot.initrd.luks.devices."luks-6f48c27b-c755-4d74-90b4-552685ae256a".device =
    "/dev/disk/by-uuid/6f48c27b-c755-4d74-90b4-552685ae256a";
  imports = [ ./hardware-configuration.nix ];
  networking.hostName = "laptop";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  my.services.blueman-applet.enable = true;
  services.tlp.enable = true;
  programs.light.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  custom = {
    desktop.enable = true;
    neovim.enable = true;
    cli.enable = true;
    hyprland.enable = true;
  };
}
