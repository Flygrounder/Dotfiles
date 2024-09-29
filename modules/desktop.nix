{ pkgs, lib, config, ... }: {
  options = {
    custom.desktop.enable = lib.mkEnableOption "Enable desktop module";
  };
  config = lib.mkIf config.custom.desktop.enable {
    users.users.flygrounder = {
      isNormalUser = true;
      description = "Артём";
      extraGroups = [ "networkmanager" "wheel" "docker" "video" ];
    };
    security.sudo.wheelNeedsPassword = false;
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    my.home.packages = with pkgs; [
      brave
      corefonts
      firefox
      jetbrains.idea-community
      libreoffice-still
      nextcloud-client
      pavucontrol
      telegram-desktop
      vistafonts
      vlc
    ];
    services = { xserver.enable = true; };
    nixpkgs.config.allowUnfree = true;
    my.xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
      };
    };
    my.programs.zathura.enable = true;
    my.programs.kitty = {
      enable = true;
      settings = {
        tab_fade = 0;
        confirm_os_window_close = 0;
        window_padding_width = 10;
        tab_bar_margin_height = "5 0";
        tab_bar_margin_width = 0;
        tab_title_template =
          "{fmt.bg._080808}{fmt.fg._303030}{fmt.fg.default}{fmt.bg._303030}{fmt.fg._c6c6c6} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg._303030}{fmt.fg.default}";
        active_tab_title_template =
          "{fmt.bg._080808}{fmt.fg._80a0ff}{fmt.fg.default}{fmt.bg._80a0ff}{fmt.fg._080808} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg._80a0ff}{fmt.fg.default}";
        font_family = "FiraCode Nerd Font";
      };
    };
    networking.firewall.enable = false;
    system.stateVersion = "24.05";
    hardware.graphics.enable = true;
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
