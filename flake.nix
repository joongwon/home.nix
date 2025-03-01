{
  description = "Home Manager configuration of joongwon";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils }@inputs:
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
          ];
          extraSpecialArgs.flake-inputs = inputs;
        }
      );
    });
}
