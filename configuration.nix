# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’)
{pkgs, lib, inputs, ... }:
{
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024; # 16 GB
  }];
  nix = {
    channel.enable = false;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs; # For disabling channels
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      trusted-users = [ "brian" ];
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
    hostName = "brians-laptop"; # Define your hostname

    # wireless.enable = true;  # Enables wireless support via wpa_supplicant
    networkmanager.enable = true; # Enable networking

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall = {
      enable = true;

      # Open ports in the firewall
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [];
    };
  };

  # Set your time zone
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  virtualisation.docker.enable = true;

  powerManagement.powertop.enable = true; # powertop auto tuning on startup # Disabled usb after some time of incativity, so not usable on desktop

  services = {
    # Powermanagment
    tlp.enable = true; # TLP power management daemon
    upower.enable = true; # DBus service that provides power management support to applications.
    fail2ban.enable = true; # Security for ssh, ratelimiting and such
    libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager)

    # Enable the OpenSSH daemon
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };

    # Firefox settings (Haven't looked into it yet)
    # firefox-syncserver = {
    #   secrets = "./file.json";
    #   enable = true;
    #   singleNode.enable = true;
    # };

    displayManager.defaultSession = "none+i3";
    xserver = {
      excludePackages = [ pkgs.xterm ];

      videoDrivers = [ "displaylink" "modesetting" "fbdev" ];

      enable = true; # Enable the X11 windowing system

      # For i3
      desktopManager = {
        wallpaper.combineScreens = true; # background img = ~/.background-image
        wallpaper.mode = "center"; # One of "center", "fill", "max", "scale", "tile"
      };

      windowManager.i3 = {
        enable = true;
        configFile = "${inputs.brian-i3-config}/config";
        extraPackages = [];
      };
    };

    # Enable CUPS to print documents
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false; # Used for audio work, which I don't do

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    # Trying to handle multiple monitors, WIP
    #autorandr = {
    #  enable = true;
    #  profiles = {
    #    mobile = {
    #      fingerprint = {
    #        eDP-1 = "00ffffffffffff0030e41f0600000000001c0104a51f117802e085a3544e9b260e5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a542b80a070381f403020350035ae1000001a000000fe004c4720446973706c61790a2020000000fe004c503134305746392d5350453200be";
    #      };
    #      config = {
    #        eDP-1.enable = true;
    #        eDP-1.primary = true;
    #      };
    #    };
    #    docked = {
    #      fingerprint = {
    #        eDP-1 = "00ffffffffffff0030e41f0600000000001c0104a51f117802e085a3544e9b260e5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a542b80a070381f403020350035ae1000001a000000fe004c4720446973706c61790a2020000000fe004c503134305746392d5350453200be";
    #        HDMI-1 = "00ffffffffffff004c2d3e0f000e0001011c0103806f3e780a23ada4544d99260f474abdef80714f81c0810081809500a9c0b300010104740030f2705a80b0588a00501d7400001e023a801871382d40582c4500501d7400001e000000fd00184b0f511e000a202020202020000000fc0053414d53554e470a202020202001f702034cf0535f101f041305142021225d5e626364071603122909070715075057070183010000e2004fe30503016e030c001000b83c20008001020304e3060d01e50e60616566e5018b849001011d80d0721c1620102c2580501d7400009e662156aa51001e30468f3300501d7400001e000000000000000000000000000000a3";
    #      };
    #      config = {
    #        eDP-1.enable = true;
    #        HDMI-1.enable = true;
    #        HDMI-1.position = "1920x0";
    #      };
    #    };
    #  };
    #};
  };
  environment = {
    # Apparently dyalogscript's /bin/dyalogscript is better than "/usr/bin/env dyalogscript".
    # This enables it
    bindyalogscript = "${pkgs.dyalog.override { acceptLicense = true; }}/bin/dyalogscript";

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [ # These are duplicates from home, TODO: Simplify the shared pkgs list
      xviewer           # Image viewer
      copyq             # clipboard saving
      xcolor            # color-pick shortcut for i3
      alacritty         # My chosen terminal. Loads quickly, and doesn't have a inbuilt-windowmanager to complicate it
      xdotool           # Useful for automating tasks
      rofi              # Used by i3 for fancy UI
      xorg.xkbcomp      # Temporary for messing with my keyboard settings
      xorg.xev          # I use this for testing button presses on i3
      xorg.xbacklight   # Modify device brightness, xrandr can only modify software brightness
      sops              # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
      gnome-clocks      # Needed a timer
      keepassxc         # Password manager. TODO: Needs to be configured
      baobab            # Drive space tree-like view
      restic            # Backup the borgBackup folder at drive/backup-brian-Lenovo-Yoga-C940-14IIL-LinuxMintCinamon
      obsidian          # Unfree package. Can only use for non-profit
      nodejs            # Javascript interpreter
      haruna            # Video player
      light             # My i3 config uses this
      elixir            # I want to try out elixer to develop concurrent applications
      gh                # github commands
      libllvm           # Playing around with llvm IR
      pet               # Snippet manager, not exactly sure what that means
      qutebrowser       # browser with loads of shortcuts
      lxappearance      # GTK theme switcher, useful for i3
      audacious         # For playing music
      zig zls           # Zig stuff
      firefox
      nemo
      xclip
      unzip
      xed-editor
      gnome-system-monitor
      pavucontrol        # Audio interface
      brightnessctl      # For i3 brightness without sudo
      llvmPackages.clangWithLibcAndBasicRtAndLibcxx llvmPackages.clang-manpages # Will remove later, temporary till I fix permission issues with using zig for building with make
      arc-theme          # Dark theme related: Arc-Dark GTK theme
      gnome-themes-extra # Dark theme related: Includes Adwaita-dark
      simplescreenrecorder # My favorite recording software
      (import ./pkgs/cbqn.nix pkgs) bqn386 # BQN interpreter and font
    ] ++ [ # The rest is extra packages not found in home
      pkgs.git
      inputs.home-manager.packages.${pkgs.system}.home-manager
    ];
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

    # Some programs need SUID wrappers, can be configured further or are started in user sessions
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.users.brian = { # Define a user account. Don't forget to set a password with ‘passwd’
    isNormalUser = true;
    initialPassword = "ChangeThisASAP123";
    description = "Brian Ellingsgaard";
    extraGroups = [ "networkmanager" "wheel" "video" "www-data"]; # Video added so that i3 can change brightness. # www-data is for Pelican
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; # I use this for Obsidian

  security = {
    rtkit.enable = true; # Enable sound with pipewire
    pam.loginLimits = [ { domain = "@users"; item = "rtprio"; type = "-"; value = 1; } ]; # Set system schedular's priority for @users. Apparently improved swayWM perf, found it in their docs
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
    ];
  };

  # Cleanup coredumps
  systemd = {
    coredump.extraConfig = "MaxUse=250m";
    slices.anti-hungry.sliceConfig = {
      CPUAccounting = true;
      CPUQuota = "50%";
      MemoryAccounting = true; # Allow to control with systemd-cgtop
      MemoryHigh = "50%";
      MemoryMax = "75%";
      MemorySwapMax = "50%";
      MemoryZSwapMax = "50%";
    };
    services = {};
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html)
  system.stateVersion = "24.05"; # Did you read the comment?

}
