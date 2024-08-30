{ pkgs, lib, config, ... }: {
  imports = with lib;
    [ (mkAliasOptionModule [ "my" ] [ "home-manager" "users" "flygrounder" ]) ];
  options = { custom.base.enable = lib.mkEnableOption "Enable base module"; };
  config = lib.mkIf config.custom.base.enable {
    users.users.flygrounder = {
      isNormalUser = true;
      description = "Артём";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      shell = pkgs.fish;
    };
    security.sudo.wheelNeedsPassword = false;
    security.polkit.enable = true;
    my = {
      home = {
        username = "flygrounder";
        homeDirectory = "/home/flygrounder";
        stateVersion = "24.05";
        packages = with pkgs; [
          telegram-desktop
          libreoffice-still
          firefox
          popsicle
        ];
      };
      programs.home-manager.enable = true;
    };
    programs = {
      fish.enable = true;
      direnv.enable = true;
    };
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
