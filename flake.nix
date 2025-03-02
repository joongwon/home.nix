{
  description = "Home Manager configuration of joongwon";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    vim-healthcheck = {
      url = "github:rhysd/vim-healthcheck";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, vim-healthcheck }@inputs:
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
          extraSpecialArgs.flake-inputs = inputs;
        }
      );
    });
}
