{ pkgs, lib, config, ... }: {
  options = {
    custom.hyprland.enable = lib.mkEnableOption "Enable hyprland module";
  };
  config = lib.mkIf config.custom.hyprland.enable {
    my.home.packages = with pkgs; [ roboto font-awesome ];
    my.services.network-manager-applet.enable = true;
    services.xserver.displayManager.lightdm.enable = false;
    networking.networkmanager.enable = true;
    my.programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      catppuccin.flavor = "macchiato";
    };
    services.getty.autologinUser = "flygrounder";
    my.gtk.enable = true;
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
        decoration = { rounding = 15; };
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
                wsKey = toString (if wsNumber == 10 then 0 else wsNumber);
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
          "$mainMod SHIFT, K, swapnext, prev"
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
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
