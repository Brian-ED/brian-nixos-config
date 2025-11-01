{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url        = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05"   ;
    k.url              = "github:runtimeverification/k"       ;
    darwin.url         = "github:LnL7/nix-darwin"             ;

    brian-i3-config = { url = "github:Brian-ED/brian-i3-config"; flake = false; };
    singeli         = { url = "github:mlochbaum/Singeli"       ; flake = false; };

    nixos-conf-editor = { url = "github:snowfallorg/nixos-conf-editor"; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager      = { url = "github:nix-community/home-manager"   ; inputs.nixpkgs.follows = "nixpkgs"; };
    nixGL             = { url = "github:nix-community/nixGL"          ; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-watch         = { url = "github:Cloud-Scythe-Labs/nix-watch"  ; inputs.nixpkgs.follows = "nixpkgs"; };
    nil               = { url = "github:oxalica/nil"                  ; inputs.nixpkgs.follows = "nixpkgs"; };
    nvf               = { url = "github:notashelf/nvf"                ; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    win = "/mnt/windows";
    min = "/mnt/linux-mint";
    winUser = "${win}/Users/brian";
    minUser = "${min}/home/brian";
    pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.nixGL.overlay ];
    };
    pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
  in {
    homeConfigurations.brian = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ./pkgs/restic-temp.nix ];
      extraSpecialArgs = {inherit inputs pkgs-stable winUser minUser; };
    };

    nixosConfigurations = {
      brians-laptop = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs win min;};
        modules = [
          ./hardware/lenovo-C940-14IIL.nix # Include the results of the hardware scan
          ./configuration.nix
          ./unsafe-config.nix
        ] ++ (if false then [ ./optional/vm.nix ] else []) ;
      };
      lifebook = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hardware/lifebook-AH512.nix
          ./configuration.nix
        ];
      };
      remote-server = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hardware/qemu.nix
          ./qemu-config.nix
        ];
      };
    };

    darwinConfigurations.macOSIntel = inputs.darwin.lib.darwinSystem {
      system = "x86_64-darwin"; # I can generalize this when/if i get a non-intel mac
      specialArgs = {inherit inputs;};
      modules = [
        ./hardware/intel-mac.nix # Include the results of the hardware scan
        ./configuration-darwin.nix
        ./unsafe-config.nix
      ];
    };
  };
}
