{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
#    sops-nix.url = "github:Mic92/sops-nix";
    nix-watch.url = "github:Cloud-Scythe-Labs/nix-watch";
    nix-watch.inputs.nixpkgs.follows = "nixpkgs";

    brian-i3-config.url = "github:Brian-ED/brian-i3-config";
    brian-i3-config.flake = false;

    # Optional, if you intend to follow nvf's obsidian-nvim input
    # you must also add it as a flake input.
#    obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
#    obsidian-nvim.flake = false;

    # Required, nvf works best and only directly supports flakes
#    nvf = {
#      url = "github:notashelf/nvf";
#      # You can override the input nixpkgs to follow your system's
#      # instance of nixpkgs. This is safe to do as nvf does not depend
#      # on a binary cache.
#      inputs.nixpkgs.follows = "nixpkgs";
#      # Optionally, you can also override individual plugins
#      # for example:
#      inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
#    };

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
      inherit system;
      specialArgs = {inputs = i;};
      modules = [
        ./hardware-configuration.nix # Include the results of the hardware scan
        ./configuration.nix
      ];
    };
  };
}
