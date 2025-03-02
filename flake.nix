{
  description = "Home Manager configuration of joongwon";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    vim-healthcheck = {
      url = "github:rhysd/vim-healthcheck";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, flake-utils, vim-healthcheck }:
    let
      hostnames = [ "freleefty-macbook" "freleefty-nixos" ];
      usernames = [ "joongwon" ];
      eachHome = f: builtins.listToAttrs (
        builtins.concatMap (username: builtins.map (hostname: {
          name = "${username}@${hostname}";
          value = f { inherit username; inherit hostname; };
        }) hostnames) usernames
      );
    in
    flake-utils.lib.eachDefaultSystem (system: {
      packages.homeConfigurations = eachHome ({ username, hostname }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./modules/${hostname}.nix
            nixvim.homeManagerModules.nixvim
            ({ config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  (self: super: {
                    vimPlugins = super.vimPlugins // {
                      vim-healthcheck = pkgs.vimUtils.buildVimPlugin {
                        name = "vim-healthcheck";
                        src = vim-healthcheck;
                      };
                    };
                  })
                ];
              })
          ];
        }
      );
    });
}
