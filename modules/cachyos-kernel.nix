{ pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ]; # use the exact kernel versions as defined in this repo. Guarantees you have binary cache.
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # Binary cache
  nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
  nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
}
