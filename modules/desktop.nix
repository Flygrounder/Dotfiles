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
      roboto
      jetbrains.idea-community
      telegram-desktop
      libreoffice-still
      firefox
      font-awesome
    ];
    my.programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };
    my.wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mainMod" = "SUPER";
        general = {
          layout = "master";
          gaps_in = 5;
          gaps_out = 10;
          "col.active_border" = "$overlay2";
          "col.inactive_border" = "$overlay0";
        };
        windowrulev2 =
          [ "workspace 1, class:(kitty)" "workspace 2, class:(firefox)" ];
        input = {
          kb_layout = "us,ru";
          kb_options = "grp:alt_shift_toggle";
        };
        master = { mfact = 0.5; };
        exec-once = [ "waybar" ];
        bind = let
          genWsKeysRec = wsNumber:
            if wsNumber < 0 then
              [ ]
            else
              let
                wsKey = toString (wsNumber - wsNumber / 10 * 10);
                ws = toString wsNumber;
              in [
                "$mainMod, ${wsKey}, workspace, ${ws}"
                "$mainMod SHIFT, ${wsKey}, movetoworkspace, ${ws}"
              ] ++ genWsKeysRec ((wsNumber - 1));
          wsKeys = genWsKeysRec 10;
        in [
          "$mainMod, RETURN, exec, kitty"
          "$mainMod SHIFT, Q, exit, "
          "$mainMod, D, exec, rofi -show combi -combi-modes 'drun,run' -modes combi"
          "$mainMod, Q, killactive, "
          "$mainMod, J, cyclenext, "
          "$mainMod, k, cyclenext, prev"
          "$mainMod SHIFT, J, swapnext, "
          "$mainMod SHIFT, k, swapnext, prev"
        ] ++ wsKeys;
      };
    };
    services = { xserver.enable = true; };
    my.catppuccin.enable = true;
    my.catppuccin.flavor = "mocha";
    nixpkgs.config.allowUnfree = true;
    programs.hyprland.enable = true;
    programs.regreet.enable = true;
    services.greetd.enable = true;
    my.programs.kitty.enable = true;
    my.programs.waybar = {
      enable = true;
      catppuccin.mode = "createLink";
      style = ../configs/waybar/style.css;
      settings = {
        mainBar = {
          margin-top = 5;
          layer = "top";
          modules-left = [ "custom/logo" "hyprland/workspaces" ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "tray"
            "hyprland/language"
            "pulseaudio"
            "backlight"
            "battery"
            "clock"
          ];
          "hyprland/workspaces" = {
            format = "{icon}";
            persistent-workspaces = { "*" = 6; };
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "";
              "4" = "";
              "5" = "";
              "6" = "";
            };
          };
          clock = { format = " {:%H:%M}"; };
          "custom/logo" = {
            format = "";
            class = "logo";
          };
          battery = {
            format-discharging = "{icon} {capacity}% {time}";
            format-charging = " {capacity}% {time}";
            format-full = "{icon} {capacity}% {time}";
            format-time = "{H}:{m}";
            format-icons = [ "" "" "" "" "" ];
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "  {volume}%";
            format-icons = { default = [ "" "" "" ]; };
          };
          backlight = {
            format = "{icon} {percent}%";
            format-icons = [ "" "" "" "" "" ];
          };
          "hyprland/language" = {
            format = " {}";
            format-en = "RU";
            format-ru = "US";
          };
        };
      };
    };
    my.home.file = {
      wallpapers = {
        recursive = true;
        source = ../wallpapers;
        target = ".wallpapers";
      };
    };
    my.services.hyprpaper = {
      enable = true;
      settings =
        let wallpaperPath = "/home/flygrounder/.wallpapers/nix-black.png";
        in {
          preload = wallpaperPath;
          wallpaper = ", ${wallpaperPath}";
        };
    };
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
