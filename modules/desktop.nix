{ pkgs, lib, config, ... }: {
  options = {
    custom.desktop.enable = lib.mkEnableOption "Enable desktop module";
  };
  config = lib.mkIf config.custom.desktop.enable {
    users.users.flygrounder = {
      isNormalUser = true;
      description = "Артём";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
    security.sudo.wheelNeedsPassword = false;
    security.polkit.enable = true;
    my.home.packages = with pkgs; [
      telegram-desktop
      libreoffice-still
      firefox
      popsicle
    ];
    services = {
      xserver.enable = true;
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;
      xserver.xkb = {
        layout = "us,ru";
        options = "grp:alt_shift_toggle";
      };
    };
    nixpkgs.config.allowUnfree = true;
    networking.firewall.enable = false;
    system.stateVersion = "24.05";
    hardware.opengl = { enable = true; };
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    virtualisation.docker.enable = true;
    time.timeZone = "Europe/Moscow";
    i18n.defaultLocale = "ru_RU.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
    networking.networkmanager.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
