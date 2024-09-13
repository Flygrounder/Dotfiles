{ pkgs, lib, config, ... }: {
  options = {
    custom.hyprland.enable = lib.mkEnableOption "Enable hyprland module";
  };
  config = lib.mkIf config.custom.hyprland.enable {
    my.home.packages = with pkgs; [ roboto font-awesome slurp grim yazi ags ];
    my.services.network-manager-applet.enable = true;
    services.xserver.displayManager.lightdm.enable = false;
    networking.networkmanager.enable = true;
    my.xdg.configFile = {
      ags = {
        source = ../configs/ags;
        target = "ags";
      };
    };
    my.programs.hyprlock = {
      enable = true;
      settings = {

        general = {
          disable_loading_bar = true;
          hide_cursor = true;
          no_fade_in = false;
        };

        background =
          [{ path = "/home/flygrounder/.wallpapers/nix-black.png"; }];

        input-field = [{
          size = "400, 50";
          position = "0, -200";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text =
            "'<span foreground=\"##cad3f5\">Password...</span>'";
          shadow_passes = 2;
        }];

      };
    };
    security.pam.services.hyprlock = { };
    my.programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      catppuccin.flavor = "macchiato";
    };
    services.getty.autologinUser = "flygrounder";
    my.gtk = {
      enable = true;
      theme = {
        name = "catppuccin-mocha-blue-standard";
        package = pkgs.catppuccin-gtk.override { variant = "mocha"; };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders;
      };
    };
    my.catppuccin.pointerCursor.enable = true;
    my.services.dunst.enable = true;
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
        xwayland = { force_zero_scaling = true; };
        animation = [ "windows, 1, 10, default, slide" ];
        decoration = { rounding = 15; };
        input = {
          kb_layout = "us,ru";
          kb_options = "grp:alt_shift_toggle";
          touchpad = { natural_scroll = true; };
        };
        gestures = { workspace_swipe = true; };
        master = { mfact = 0.5; };
        exec-once = [ "waybar" "ags" ];
        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86MonBrightnessUp, exec, light -A 10"
          ", XF86MonBrightnessDown, exec, light -U 10"
        ];
        bind = let
          genWsKeysRec = wsNumber:
            if wsNumber < 0 then
              [ ]
            else
              let
                wsKey = toString (if wsNumber == 10 then 0 else wsNumber);
                ws = toString wsNumber;
              in [
                "$mainMod, ${wsKey}, workspace, ${ws}"
                "$mainMod SHIFT, ${wsKey}, movetoworkspace, ${ws}"
              ] ++ genWsKeysRec ((wsNumber - 1));
          wsKeys = genWsKeysRec 10;
        in [
          "$mainMod, RETURN, exec, kitty"
          "$mainMod, L, exec, hyprlock"
          "$mainMod SHIFT, Q, exit, "
          "$mainMod, D, exec, rofi -show combi -combi-modes 'drun,run' -modes combi"
          "$mainMod, Q, killactive, "
          "$mainMod, J, cyclenext, "
          "$mainMod, k, cyclenext, prev"
          "$mainMod SHIFT, m, fullscreen, 0"
          "$mainMod, m, fullscreen, 1"
          "$mainMod SHIFT, J, swapnext, "
          "$mainMod SHIFT, K, swapnext, prev"
          ", Print, exec, mkdir -p Изображения/Скриншоты && slurp | grim -g - - | wl-copy && wl-paste > ~/Изображения/Скриншоты/Screenshot-$(date +%F_%T).png | dunstify 'Сделан области сохранён' -t 1000"
          "SHIFT, Print, exec, mkdir -p Изображения/Скриншоты && grim - | wl-copy && wl-paste > ~/Изображения/Скриншоты/Screenshot-$(date +%F_%T).png | dunstify 'Снимок всего экрана сохранён' -t 1000"

        ] ++ wsKeys;
      };
    };
    my.catppuccin.enable = true;
    my.catppuccin.flavor = "mocha";
    programs.hyprland.enable = true;
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
          "hyprland/window" = { max-length = 30; };
          modules-right = [
            "tray"
            "hyprland/language"
            "pulseaudio"
            "backlight"
            "battery"
            "clock"
          ];
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
            format-en = "US";
            format-ru = "RU";
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
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
