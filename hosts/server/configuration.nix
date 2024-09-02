{ pkgs, extraModules, ... }:

{
  deployment = {
    targetHost = "89.110.91.29";
    targetUser = "flygrounder";
  };

  imports = extraModules ++ [ ./hardware-configuration.nix ];

  networking.hostName = "server";

  nix.settings.trusted-users = [ "flygrounder" ];

  custom = {
    cli.enable = true;
    neovim.enable = true;
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  users.users.flygrounder = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDO6tAAy/5hCN/F4/lcADbpJa9qd4nwW896Q3BV5pjBsNX2QM0+okkuUo7zRAjBktwmp1F9xIBSC067UEHoBfvWqeDgWHWrk58Se954kHyc9OLEXIdsqnLGfW72lGrLv/I1NKE2V81d7WC+Y/w4tcn9i9a4Bl+hlz4aA4lEscB7gXLDVchIvAEaivyd4J/Kx+qa6niIyNIDwoYwCuepbdMx0zFdJar0PGouUoriJKo8Hl1mEIrVesdH8O3VIi2hSJh+3Nyt5UV18LThzELt+7MYQNRcses8I4ps8jShn0St+fUFvSbCP+q1tWLP0MQh8IT0bu3oni4lIxj6R9GfEzLhFLr06JDewDAvWFEE3+eNQHYAD7lsGTt4t2eZ8Wmmmyw1QW6E1P3fMr7EqYEJfwJruAlWiHiZFTOEl5aceN9zXWHwGSSfD4DN0g1BnAQEa+/yLLgnA9dWaMgvGoyw79JcC8vQ5vacZ2lsKKeW9p37GtSmK+f5LlsL1o9wgLqr6Fc= flygrounder@archlinux"
    ];
  };
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "24.05";

  networking.interfaces.ens3.ipv4.addresses = [{
    address = "89.110.91.29";
    prefixLength = 24;
  }];

  networking.defaultGateway = {
    address = "89.110.91.1";
    interface = "ens3";
  };

  networking.nameservers = [ "8.8.8.8" ];
}

