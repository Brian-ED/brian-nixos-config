{ config, pkgs, inputs, ... }:
{
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ]; # use the exact kernel versions as defined in this repo. Guarantees you have binary cache.

  # Old code that isn't in the https://github.com/xddxdd/nix-cachyos-kernel docs.
  # I don't remember where I got it from:
    #boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
    #boot.zfs.forceImportRoot = false;
    #boot.zfs.package = pkgs.cachyosKernels.linuxPackages-cachyos-latest.zfs_cachyos;
    #boot.supportedFilesystems = [ "zfs" ];

    #networking.hostId = "7b5827db"; # Used by ZFS, which cachyOS kernel uses
}
