{ pkgs, lib, config, ... }: {
  options = { custom.cli.enable = lib.mkEnableOption "Enable CLI module"; };
  config = lib.mkIf config.custom.cli.enable {
    my = {
      home.packages = with pkgs; [ fastfetch bottom unzip ];
      programs = {
        yazi = {
          enable = true;
          initLua = ''
            require("bookmarks"):setup({
            	persist = "all",
            })
          '';
          keymap = {
            manager.prepend_keymap = [
              {
                on = [ "m" ];
                run = "plugin bookmarks --args=save";
                desc = "Save current position as a bookmark";
              }
              {
                on = [ "'" ];
                run = "plugin bookmarks --args=jump";
                desc = "Jump to a bookmark";
              }
              {
                on = [ "b" "d" ];
                run = "plugin bookmarks --args=delete";
                desc = "Delete a bookmark";
              }
              {
                on = [ "b" "D" ];
                run = "plugin bookmarks --args=delete_all";
                desc = "Delete all bookmarks";
              }
            ];
          };
          plugins = {
            bookmarks = pkgs.fetchFromGitHub {
              owner = "dedukun";
              repo = "bookmarks.yazi";
              rev = "600f87c02176175f55b0571f79c5ff0b1606362f";
              sha256 = "sha256-pNRRxS4IQO8y8/WSK9s8mNZHEdl1u1cuPfdULxikl7k=";
            };
          };
        };
        git = {
          enable = true;
          extraConfig = { credential.helper = "store"; };
          userEmail = "flygrounder@yandex.ru";
          userName = "Artyom Belousov";
        };
        starship = {
          enable = true;
          settings = {
            format =
              "$directory$hostname$git_branch$git_commit$git_state$git_metrics$git_status$cmd_duration$line_break$character";
          };
        };
        fish = {
          enable = true;
          functions = { fish_greeting = ""; };
          shellAliases = {
            lg = "lazygit";
            hf =
              "git add -N flake.nix flake.lock && git update-index --assume-unchanged flake.nix flake.lock";
          };
        };
        zoxide.enable = true;
        lazygit.enable = true;
        eza.enable = true;
        bat.enable = true;
      };
    };
    users.users.flygrounder.shell = pkgs.fish;
    programs = {
      fish.enable = true;
      direnv.enable = true;
    };
    my.home.sessionVariables = { EDITOR = "nvim"; };
  };
}
