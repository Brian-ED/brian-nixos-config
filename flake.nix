{
  description = "A very basic flake";

  inputs = rec {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url   = "github:NixOS/nixpkgs/nixos-25.11"   ;

    nixpkgs = nixpkgs-stable;

    k.url                  = "github:runtimeverification/k"            ;
    darwin.url             = "github:LnL7/nix-darwin"                  ;
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    brian-i3-config = { url = "github:Brian-ED/brian-i3-config"; flake = false; };
    singeli         = { url = "github:mlochbaum/Singeli"       ; flake = false; };

    nixos-conf-editor = { url = "github:snowfallorg/nixos-conf-editor"           ; inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager      = { url = "github:nix-community/home-manager/release-25.11"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixGL             = { url = "github:nix-community/nixGL"                     ; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-watch         = { url = "github:Cloud-Scythe-Labs/nix-watch"             ; inputs.nixpkgs.follows = "nixpkgs"; };
    nil               = { url = "github:oxalica/nil"                             ; inputs.nixpkgs.follows = "nixpkgs"; };
    nvf               = { url = "github:notashelf/nvf"                           ; inputs.nixpkgs.follows = "nixpkgs"; };
    fenix             = { url = "github:nix-community/fenix"                     ; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs: let
    system = "x86_64-linux";
    win = "/mnt/windows";
    min = "/mnt/linux-mint";
    winUser = "${win}/Users/brian";
    minUser = "${min}/home/brian";
    env = {
      inherit system;
      config.dyalog.acceptLicense = true;
      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          "dyalog" "obsidian"
          "vscode-extension-mark-wiemer-vscode-autohotkey-plus-plus" # Most of this one is MIT, it's just one asset that's not explicitly
        ];
      overlays = [
        inputs.nixGL.overlay
      ];
    };
    pkgs-unstable = import inputs.nixpkgs-unstable env;
    pkgs-stable   = import inputs.nixpkgs-stable   env;
    pkgs          = import inputs.nixpkgs          env;
    nixpkgs = inputs.nixpkgs;
    nixPath = pkgs.lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs; # For disabling channels
  in {
    homeConfigurations.brian = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ./pkgs/restic-temp.nix ];
      extraSpecialArgs = {inherit inputs pkgs-stable pkgs-unstable winUser minUser nixPath; };
    };

    nixosConfigurations = {
      brians-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs pkgs-unstable win min nixPath;};
        modules = [
          ./hardware/lenovo-C940-14IIL.nix # Include the results of the hardware scan
          ./configuration.nix
          ./unsafe-config.nix
          ./modules/cachyos-kernel.nix
        ] ++ (if false then [ ./optional/vm.nix ] else []) ;
      };
      lifebook = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs nixPath;};
        modules = [
          ./hardware/lifebook-AH512.nix
          ./configuration.nix
          ./unsafe-config.nix
        ];
      };
      remote-server = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs nixPath;};
        modules = [
          ./hardware/qemu.nix
          ./qemu-config.nix
        ];
      };
    };

    darwinConfigurations.macOSIntel = inputs.darwin.lib.darwinSystem {
      system = "x86_64-darwin"; # I can generalize this when/if i get a non-intel mac
      specialArgs = {inherit inputs nixPath;};
      modules = [
        ./hardware/intel-mac.nix # Include the results of the hardware scan
        ./configuration-darwin.nix
        ./unsafe-config.nix
      ];
    };
  };
}
