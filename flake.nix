{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = i: {

    packages.x86_64-linux.hello = i.nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = i.self.packages.x86_64-linux.hello;

    nixosConfigurations.brians-laptop = i.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = i;
      modules = [
        ./configuration.nix
        i.home-manager.nixosModules.default
      ];
    };
  };

# Home manager default:
#  outputs = { nixpkgs, home-manager, ... }:
#    let
#      system = "x86_64-linux";
#      pkgs = nixpkgs.legacyPackages.${system};
#    in {
#      homeConfigurations."brian" = home-manager.lib.homeManagerConfiguration {
#        inherit pkgs;
#
#        # Specify your home configuration modules here, for example,
#        # the path to your home.nix.
#        modules = [ ./home.nix ];
#
#        # Optionally use extraSpecialArgs
#        # to pass through arguments to home.nix
#      };
#    };


}
