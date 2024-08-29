# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = with lib; [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (mkAliasOptionModule [ "my" ] [ "home-manager" "users" "flygrounder" ])
  ];

  security.sudo.wheelNeedsPassword = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:alt_shift_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.flygrounder = {
    isNormalUser = true;
    description = "Artyom";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.direnv.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #  wget
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  # Enable OpenGL
  hardware.opengl = { enable = true; };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  my.home = {
    username = "flygrounder";
    homeDirectory = "/home/flygrounder";
    stateVersion = "24.05";
    packages = with pkgs; [
      appflowy
      telegram-desktop
      git
      fira-code-nerdfont
      wl-clipboard
      nixfmt-classic
      ripgrep
      zoom-us
      fastfetch
      bottom
    ];
  };
  my.programs = {
    nixvim = {
      enable = true;
      globals.mapleader = " ";
      clipboard.register = "unnamedplus";
      colorschemes.catppuccin.enable = true;
      opts = { number = true; };
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
      ];
      plugins = {
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
        telescope.enable = true;
      };
    };
    home-manager.enable = true;
    starship.enable = true;
    fish = {
      enable = true;
      functions = { fish_greeting = ""; };
      shellAliases = { lg = "lazygit"; };
    };
    zoxide.enable = true;
    lazygit.enable = true;
    eza.enable = true;
    bat.enable = true;
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  virtualisation.docker.enable = true;
}
