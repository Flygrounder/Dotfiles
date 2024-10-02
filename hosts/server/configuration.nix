{ pkgs, extraModules, ... }:

{
  deployment = {
    targetHost = "89.110.91.29";
    targetUser = "flygrounder";
    keys."drone.secret" = { keyFile = "/etc/nixos/keys/drone.secret"; };
  };

  imports = extraModules ++ [ ./hardware-configuration.nix ];

  networking.hostName = "server";

  nix.settings.trusted-users = [ "flygrounder" ];

  custom = { cli.enable = true; };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  users.users.flygrounder = {
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDO6tAAy/5hCN/F4/lcADbpJa9qd4nwW896Q3BV5pjBsNX2QM0+okkuUo7zRAjBktwmp1F9xIBSC067UEHoBfvWqeDgWHWrk58Se954kHyc9OLEXIdsqnLGfW72lGrLv/I1NKE2V81d7WC+Y/w4tcn9i9a4Bl+hlz4aA4lEscB7gXLDVchIvAEaivyd4J/Kx+qa6niIyNIDwoYwCuepbdMx0zFdJar0PGouUoriJKo8Hl1mEIrVesdH8O3VIi2hSJh+3Nyt5UV18LThzELt+7MYQNRcses8I4ps8jShn0St+fUFvSbCP+q1tWLP0MQh8IT0bu3oni4lIxj6R9GfEzLhFLr06JDewDAvWFEE3+eNQHYAD7lsGTt4t2eZ8Wmmmyw1QW6E1P3fMr7EqYEJfwJruAlWiHiZFTOEl5aceN9zXWHwGSSfD4DN0g1BnAQEa+/yLLgnA9dWaMgvGoyw79JcC8vQ5vacZ2lsKKeW9p37GtSmK+f5LlsL1o9wgLqr6Fc= flygrounder@archlinux"
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  virtualisation.arion = {
    backend = "podman-socket";
    projects.drone-ci = {
      serviceName = "drone-ci";
      settings = {
        docker-compose.volumes = { drone_data = { }; };
        services = {
          drone-server = {
            service = {
              image = "drone/drone:2";
              restart = "unless-stopped";
              env_file = [ "/run/keys/drone.secret" ];
              ports = [ "127.0.0.1:8777:80" ];
              volumes = [ "drone_data:/data" ];
            };
          };
          drone-runner = {
            service = {
              image = "drone/drone-runner-docker:1";
              env_file = [ "/run/keys/drone.secret" ];
              volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
            };
          };
        };
      };
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "chipollino.flygrounder.ru" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8000
        '';
      };
      "ci.flygrounder.ru" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:8777
        '';
      };
      "mtg-price-bot.flygrounder.ru" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3000
        '';
      };
      "dota2-esports-bot.flygrounder.ru" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:3234
        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [ docker-client ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "24.05";

  networking.interfaces.ens3.ipv4.addresses = [{
    address = "89.110.91.29";
    prefixLength = 24;
  }];

  networking.firewall.enable = false;

  networking.defaultGateway = {
    address = "89.110.91.1";
    interface = "ens3";
  };

  networking.nameservers = [ "8.8.8.8" ];
}

