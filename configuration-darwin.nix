# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’)
{pkgs, lib, inputs, nixPath, ... }:
{
  nix = {
    channel.enable = false;
    inherit nixPath;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      trusted-users = [ "brian" ];
      nix-path = nixPath;
      flake-registry = ""; # ensures flakes are truly self-contained
    };
  };

  networking = {
    hostName = "brians-laptop"; # Define your hostname

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Set your time zone
  time.timeZone = "Europe/Copenhagen";

  services = {
    # Enable the OpenSSH daemon
    openssh = {
      enable = true;
    };

    # Firefox settings (Haven't looked into it yet)
    # firefox-syncserver = {
    #   secrets = "./file.json";
    #   enable = true;
    #   singleNode.enable = true;
    # };
  };
  environment = {
    # Apparently dyalogscript's /bin/dyalogscript is better than "/usr/bin/env dyalogscript".
    # This enables it
    #bindyalogscript = "${pkgs.dyalog.override { acceptLicense = true; }}/bin/dyalogscript";

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [ # These are duplicates from home, TODO: Simplify the shared pkgs list
      #× xviewer           # Image viewer
      #× copyq             # clipboard saving
      xcolor            # color-pick shortcut for i3
      alacritty         # My chosen terminal. Loads quickly, and doesn't have a inbuilt-windowmanager to complicate it
      #× xdotool           # Useful for automating tasks
      #× rofi              # Used by i3 for fancy UI
      #xorg.xkbcomp      # Temporary for messing with my keyboard settings
      #xorg.xev          # I use this for testing button presses on i3
      #xorg.xbacklight   # Modify device brightness, xrandr can only modify software brightness
      #sops              # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
      #gnome-clocks      # Needed a timer
      #keepassxc         # Password manager. TODO: Needs to be configured
      #baobab            # Drive space tree-like view
      #restic            # Backup the borgBackup folder at drive/backup-brian-Lenovo-Yoga-C940-14IIL-LinuxMintCinamon
      #obsidian          # Unfree package. Can only use for non-profit
      #nodejs            # Javascript interpreter
      #pgadmin4          # Postgresql for database connection
      #haruna            # Video player
      #light             # My i3 config uses this
      #elixir            # I want to try out elixer to develop concurrent applications
      #gh                # github commands
      #libllvm           # Playing around with llvm IR
      #pet               # Snippet manager, not exactly sure what that means
      #qutebrowser       # browser with loads of shortcuts
      #lxappearance      # GTK theme switcher, useful for i3
      #audacious         # For playing music
      #zig zls           # Zig stuff
      firefox
      #nemo
      #xclip
      #unzip
      #xed-editor
      #gnome-system-monitor
      #pavucontrol        # Audio interface
      #brightnessctl      # For i3 brightness without sudo
      llvmPackages.clangWithLibcAndBasicRtAndLibcxx llvmPackages.clang-manpages # Will remove later, temporary till I fix permission issues with using zig for building with make
      #arc-theme          # Dark theme related: Arc-Dark GTK theme
      #gnome-themes-extra # Dark theme related: Includes Adwaita-dark
      #simplescreenrecorder # My favorite recording software
      #(import ./pkgs/cbqn.nix pkgs) bqn386 # BQN interpreter and font
    ] ++ [ # The rest is extra packages not found in home
      pkgs.git
      inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
    ];
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

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.users.brian = { # Define a user account. Don't forget to set a password with ‘passwd’
    description = "Brian Ellingsgaard";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true; # I use this for Obsidian

  system.primaryUser = "brian";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html)
  system.stateVersion = 6; # Did you read the comment?

}
