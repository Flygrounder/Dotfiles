{ pkgs, lib, config, ... }: {
  options = { custom.neovim.enable = lib.mkEnableOption "Enable Neovim"; };
  config = lib.mkIf config.custom.neovim.enable {
    my = {
      home.packages = with pkgs; [
        fira-code-nerdfont
        nixfmt-classic
        wl-clipboard
        ripgrep
        luajitPackages.lua-utils-nvim
      ];
      programs.nixvim = {
        enable = true;
        globals.mapleader = " ";
        clipboard.register = "unnamedplus";
        colorschemes.catppuccin.enable = true;
        extraPlugins = [
          (pkgs.vimUtils.buildVimPlugin {
            inherit (pkgs.luaPackages.lua-utils-nvim) pname version src;
          })

          (pkgs.vimUtils.buildVimPlugin {
            inherit (pkgs.luaPackages.pathlib-nvim) pname version src;
          })

          (pkgs.vimUtils.buildVimPlugin {
            inherit (pkgs.luaPackages.nvim-nio) pname version src;
          })
        ];
        opts = {
          number = true;
          ignorecase = true;
          smartcase = true;
          swapfile = true;
        };
        keymaps = [
          {
            action = "<cmd>Telescope projects<cr>";
            key = "<leader>sp";
          }
          {
            action = "<cmd>Oil<cr>";
            key = "<leader>o";
          }
          {
            action = "<cmd>Oil<cr>";
            key = "<leader>o";
          }
          {
            action = "<cmd>lua require('harpoon.mark').add_file()<cr>";
            key = "<leader>k";
          }
          {
            action = "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>";
            key = "<leader>j";
          }
          {
            action = "<cmd>lua require('harpoon.ui').nav_file(1)<cr>";
            key = "<M-q>";
          }
          {
            action = "<cmd>lua require('harpoon.ui').nav_file(2)<cr>";
            key = "<M-w>";
          }
          {
            action = "<cmd>lua require('harpoon.ui').nav_file(3)<cr>";
            key = "<M-e>";
          }
          {
            action = "<cmd>lua require('harpoon.ui').nav_file(4)<cr>";
            key = "<M-r>";
          }
          {
            action = "<cmd>Telescope find_files<cr>";
            key = "<leader>sf";
          }
          {
            action = "<cmd>Telescope live_grep<cr>";
            key = "<leader>sg";
          }
          {
            action = "<cmd>Telescope help_tags<cr>";
            key = "<leader>sh";
          }
          {
            action = "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>";
            key = "<leader>ss";
          }
          {
            action = "<cmd>TroubleToggle<cr>";
            key = "<leader>q";
          }
          {
            action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
            key = "]d";
          }
          {
            action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
            key = "[d";
          }
          {
            action = "<cmd>Neorg index<cr>";
            key = "<leader>ww";
          }
          {
            action = "<cmd>Neorg return<cr>";
            key = "<leader>we";
          }
        ];
        plugins = {
          comment.enable = true;
          neorg = {
            enable = true;
            modules = {
              "core.defaults" = { __empty = null; };
              "core.dirman" = {
                config = {
                  workspaces = { notes = "~/notes"; };
                  default_workspace = "notes";
                };
              };
            };
          };
          autoclose.enable = true;
          ts-autotag.enable = true;
          treesitter.enable = true;
          trouble.enable = true;
          oil.enable = true;
          lsp-format.enable = true;
          harpoon.enable = true;
          direnv.enable = true;
          cmp-nvim-lsp-signature-help.enable = true;
          cmp = {
            enable = true;
            settings = {
              snippet.expand = ''
                function(args)
                require('luasnip').lsp_expand(args.body)
                end
              '';

              sources = [
                { name = "nvim_lsp"; }
                { name = "luasnip"; }
                { name = "nvim_lsp_signature_help"; }
              ];

              mapping = {
                "<C-n>" = "cmp.mapping.select_next_item()";
                "<C-p>" = "cmp.mapping.select_prev_item()";
                "<cr>" = "cmp.mapping.confirm({ select = true })";
              };
            };
          };
          cmp-nvim-lsp.enable = true;
          lualine.enable = true;
          luasnip.enable = true;
          lsp = {
            enable = true;
            servers = {
              rust-analyzer = {
                enable = true;
                installCargo = false;
                installRustc = false;
              };
              nil-ls = {
                enable = true;
                settings.formatting.command = [ "nixfmt" ];
              };
              tsserver.enable = true;
              yamlls.enable = true;
            };
            keymaps = {
              silent = true;
              lspBuf = {
                K = "hover";
                "<leader>r" = "rename";
                "<leader>i" = "format";
              };
              extra = [
                {
                  action = "<cmd>Telescope lsp_definitions<cr>";
                  key = "gd";
                }
                {
                  action = "<cmd>Telescope lsp_type_definitions<cr>";
                  key = "gt";
                }
                {
                  action = "<cmd>Telescope lsp_references<cr>";
                  key = "gD";
                }
              ];
            };
          };
          project-nvim = {
            enable = true;
            enableTelescope = true;
            detectionMethods = [ "pattern" ];
            patterns = [ ".git" ".project" ];
          };
          surround.enable = true;
          telescope.enable = true;
          gitsigns.enable = true;
        };
      };
    };
  };
}