{ config, lib, ... }: {
  options = { custom.nvidia.enable = lib.mkEnableOption "Enable Nvidia"; };
  config = lib.mkIf config.custom.nvidia.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
