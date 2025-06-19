{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-conf-editor.url = "github:snowfallorg/nixos-conf-editor";
    nixos-conf-editor.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
#    sops-nix.url = "github:Mic92/sops-nix";
    nix-watch.url = "github:Cloud-Scythe-Labs/nix-watch";
    nix-watch.inputs.nixpkgs.follows = "nixpkgs";

    brian-i3-config.url = "github:Brian-ED/brian-i3-config";
    brian-i3-config.flake = false;

    nil = {
      url="github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nil.follows = "nil";
    };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.brian = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
      extraSpecialArgs = {inherit inputs;};
    };

    nixosConfigurations = {
      brians-laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hardware/lenovo-C940-14IIL.nix # Include the results of the hardware scan
          ./configuration.nix
        ];
      };
      lifebook = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hardware/lifebook-AH512.nix
          ./configuration.nix
        ];
      };
    };
  };
}
