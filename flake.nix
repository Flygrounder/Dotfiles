{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, nixvim, arion, catppuccin, ... }:
    let
      system = "x86_64-linux";
      extraModules = [
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        ({ lib, ... }: {
          imports = [
            (lib.mkAliasOptionModule [ "my" ] [
              "home-manager"
              "users"
              "flygrounder"
            ])
          ];
          home-manager = {
            sharedModules = [
              nixvim.homeManagerModules.nixvim
              catppuccin.homeManagerModules.catppuccin
            ];
            useGlobalPkgs = true;
            useUserPackages = true;
            users.flygrounder = {
              programs.home-manager.enable = true;
              home = {
                username = "flygrounder";
                homeDirectory = "/home/flygrounder";
                stateVersion = "24.05";
              };
            };
          };
        })
        arion.nixosModules.arion
        ./modules
      ];
    in {
      nixosConfigurations = let
        mkSystem = host:
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = extraModules ++ [ ./hosts/${host}/configuration.nix ];
          };
      in {
        desktop = mkSystem "desktop";
        laptop = mkSystem "laptop";
        work = mkSystem "work";
      };
      colmena = {
        meta = {
          nixpkgs = import nixpkgs { inherit system; };
          specialArgs = { inherit extraModules; };
        };
        server = import ./hosts/server/configuration.nix;
      };
      devShells.${system}.default =
        let pkgs = import nixpkgs { inherit system; };
        in with pkgs; mkShell { buildInputs = [ colmena ]; };
    };
}
