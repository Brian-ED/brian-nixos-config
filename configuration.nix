# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, brian-i3-config, inputs, ... }:
{
  nix = {
    channel.enable = false;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs; # For disabling channels
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;

      nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs; # For disabling channels
      flake-registry = ""; # ensures flakes are truly self-contained
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.systemd.network.wait-online.enable = false; # Apparently improves boot time. Why should the boot process wait for internet?
    supportedFilesystems = [ "ntfs" "ext4" ];
  };

  networking = {
    hostName = "brians-laptop"; # Define your hostname.

    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall = {
      enable = true;

      # Open ports in the firewall.
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_DK.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "da_DK.UTF-8";
      LC_IDENTIFICATION = "da_DK.UTF-8";
      LC_MEASUREMENT    = "da_DK.UTF-8";
      LC_MONETARY       = "da_DK.UTF-8";
      LC_NAME           = "da_DK.UTF-8";
      LC_NUMERIC        = "da_DK.UTF-8";
      LC_PAPER          = "da_DK.UTF-8";
      LC_TELEPHONE      = "da_DK.UTF-8";
      LC_TIME           = "da_DK.UTF-8";
    };
  };
  services = {

    # Enable the OpenSSH daemon.
    openssh.enable = false;


    # Firefox settings (Haven't looked into it yet)
    # firefox-syncserver = {
    #   secrets = "./file.json";
    #   enable = true;
    #   singleNode.enable = true;
    # };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    displayManager.defaultSession = "none+i3";
    xserver = {
      excludePackages = [ pkgs.xterm ];

      videoDrivers = [ "displaylink" "modesetting" "fbdev" ];

      enable = true; # Enable the X11 windowing system.

      # For i3
      desktopManager = {
        wallpaper.combineScreens = true; # background img = ~/.background-image
        wallpaper.mode = "center"; # One of "center", "fill", "max", "scale", "tile"
      };


      windowManager.i3.enable = true;
      windowManager.i3.configFile = if false then "${brian-i3-config}/config" else "/home/brian/brian-i3-config/config";
      windowManager.i3.extraPackages = [];

      # Configure keymap in X11
      xkb = {
        options = "grp:lswitch";
        layout = "fo,bqn";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false; # Used for audio work, which I don't do.

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = [];
    sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Optionally, set the environment variable
    pathsToLink = [ "/libexec" ]; # For i3
    etc = {
      "xdg/gtk-2.0/gtkrc".text = "gtk-error-bell=0";
      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-error-bell=false
      '';
      "xdg/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-error-bell=false
      '';
    };
  };

  programs = {
    i3lock.enable = true;
    dconf.enable = true; # For i3

    # Some programs need SUID wrappers, can be configured further or are started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.users.brian = { # Define a user account. Don't forget to set a password with ‘passwd’.
    isNormalUser = true;
    description = "Brian Ellingsgaard";
    extraGroups = [ "networkmanager" "wheel" "video"]; # Video added so that i3 can change brightness
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; # I use this for Obsidian

  security = {
    rtkit.enable = true; # Enable sound with pipewire.
    pam.loginLimits = [ { domain = "@users"; item = "rtprio"; type = "-"; value = 1; } ]; # Set system schedular's priority for @users. Apparently improved swayWM perf, found it in their docs.
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
    ];
  };

  fileSystems = let
    options = ["noatime" "nodiratime" "discard"];
  in {
    "/mnt/0AD47A53D47A414D" = {
      device = "/dev/disk/by-uuid/0AD47A53D47A414D";
      fsType = "ntfs";
      inherit options;
    };
    "/mnt/linux-mint" = {
      device = "/dev/disk/by-uuid/3cd525e2-0864-4559-a882-5af643a62d00";
      fsType = "ext4";
      inherit options;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
