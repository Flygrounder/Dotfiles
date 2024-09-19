{ pkgs, lib, config, ... }: {
  options = { custom.neovim.enable = lib.mkEnableOption "Enable Neovim"; };
  config = lib.mkIf config.custom.neovim.enable {
    my = {
      home.packages = with pkgs; [
        biome
        fira-code-nerdfont
        nixfmt-classic
        wl-clipboard
        xclip
        ripgrep
        luajitPackages.lua-utils-nvim
        sqlfluff
      ];
      programs.nixvim = {
        enable = true;
        autoCmd = [{
          command = "set conceallevel=2";
          event = [ "BufEnter" "BufWinEnter" ];
          pattern = [ "*.norg" ];
        }];
        globals.mapleader = " ";
        globals.maplocalleader = ",";
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
          swapfile = false;
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
            action = "<cmd>Trouble diagnostics focus<cr>";
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
          vimtex = {
            enable = true;
            texlivePackage = pkgs.texlive.combined.scheme-full;
            settings = { view_method = "zathura"; };
          };
          comment.enable = true;
          conform-nvim = {
            enable = true;
            settings = {
              default_format_opts = { lsp_format = "fallback"; };
              format_on_save = { lsp_format = "fallback"; };
              formatters_by_ft = let jsConfig = { __unkeyed-1 = "biome"; };
              in {
                javascript = jsConfig;
                typescript = jsConfig;
                typescriptreact = jsConfig;
              };
              formatters = { biome = { command = "biome"; }; };
            };
          };
          neorg = {
            enable = true;
            modules = {
              "core.defaults" = { __empty = null; };
              "core.dirman" = {
                config = {
                  workspaces = { org = "~/org"; };
                  default_workspace = "org";
                };
              };
              "core.concealer" = { __empty = null; };
            };
          };
          autoclose.enable = true;
          ts-autotag.enable = true;
          treesitter = {
            enable = true;
            settings = {
              highlight = {
                enable = true;
                disable = [ "latex" ];
                additional_vim_regex_highlighting = false;
              };
            };
          };
          trouble = {
            enable = true;
            settings = {
              warn_no_results = false;
              open_no_results = true;
            };
          };
          oil.enable = true;
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
                "<C-Space>" = "cmp.mapping.complete()";
              };
            };
          };
          cmp-nvim-lsp.enable = true;
          lualine.enable = true;
          luasnip.enable = true;
          lsp = {
            enable = true;
            servers = {
              cssls.enable = true;
              pyright.enable = true;
              gopls.enable = true;
              rust-analyzer = {
                enable = true;
                installCargo = false;
                installRustc = false;
              };
              nil-ls = {
                enable = true;
                settings.formatting.command = [ "nixfmt" ];
              };
              clangd.enable = true;
              tsserver.enable = true;
              yamlls.enable = true;
            };
            keymaps = {
              silent = true;
              lspBuf = {
                K = "hover";
                "<leader>r" = "rename";
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
                {
                  action = "<cmd>lua require('conform').format({})<cr>";
                  key = "<leader>i";
                }
              ];
            };
          };
          project-nvim = {
            enable = true;
            enableTelescope = true;
            settings = {
              detection_methods = [ "pattern" ];
              patterns = [ ".git" ".project" ];
            };
          };
          surround.enable = true;
          telescope.enable = true;
          gitsigns.enable = true;
        };
      };
    };
  };
}
