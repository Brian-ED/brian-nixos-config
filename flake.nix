{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = i: let
    system = "x86_64-linux";
    pkgs = i.nixpkgs.legacyPackages.${system};
  in {

    homeConfigurations.brian = i.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
      extraSpecialArgs = i;
    };

    nixosConfigurations.brians-laptop = i.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = i;
      modules = [
        ./configuration.nix
        i.home-manager.nixosModules.default
      ];
    };
  };
}
