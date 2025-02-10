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
        # i.home-manager.nixosModule.default
      ];
    };
  };
}
