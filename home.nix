# TODO get home manager to manage files ~/.gtkrc-2.0
{ pkgs, lib, inputs, ...}:
let
  nix-watch = inputs.nix-watch.packages.${pkgs.system}.default;
  home-manager = inputs.home-manager.packages.${pkgs.system}.home-manager;
  nixos-conf-editor = inputs.nixos-conf-editor.packages.${pkgs.system}.nixos-conf-editor;
  username = "brian";
  homeDir = "/home/${username}";
  sessionVariables = {
    EDITOR = "codium";
    BROWSER = "qutebrowser";
    TERMINAL = "alacritty";
  };
in
{
  imports = [ inputs.nvf.homeManagerModules.default ];
  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;
        lsp = {
          enable = true;
        };
        languages = {
          rust    .enable = true;
          nix     .enable = true;
          clang   .enable = true; # C/C++
          ts      .enable = true; # JS/TS
          python  .enable = true;
          zig     .enable = true;
          markdown.enable = true;
          html    .enable = true;
        };
      };
    };
  };

  # Sets up repositories for my projects, cloning only if missing, automatically
  # TODO: warn when a repository is removed from the list but still exists with state (autodelete if no state exists).
  home.activation = { # It's complicated, refer to: https://home-manager-options.extranix.com/?query=home.activation&release=release-25.05
    makeRepo = let
      proj = "${homeDir}/proj";
    in lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "git" ] ''
      if [ ! -d ${proj} ]; then
        run mkdir ${proj}
      fi
      if [ ! -d ${proj}/brian-nixos-config ]; then
        run ${pkgs.git}/bin/git clone https://github.com/Brian-ED/brian-nixos-config ${proj}/brian-nixos-config
      fi
      if [ ! -d ${proj}/brian-i3-config ]; then
        run ${pkgs.git}/bin/git clone https://github.com/Brian-ED/brian-i3-config ${proj}/brian-i3-config
      fi
      if [ ! -d ${homeDir}/.config/i3 ]; then
        run ln -s ${proj}/brian-i3-config ${homeDir}/.config/i3
      fi
    '';
  };

  home.keyboard = { # Keyboard configuration. Set to `null` to disable Home Manager keyboard management.
    layout  = "fo,bqn";  # Keyboard layout. If `null`, then the system configuration will be used. This defaults to `null` for state version ≥ 19.09 and `"us"` otherwise.
    model   = "";  # Keyboard model.
    options = [ "grp:lswitch" ];  # X keyboard options; layout switching goes here.
    variant =  ""; # X keyboard variant. If `null`, then the system configuration will be used. This defaults to `null` for state version ≥ 19.09 and `""` otherwise.
  };

  home.pointerCursor = { # Cursor configuration. Top-level options declared under this submodule are backend independent options. Options declared under namespaces such as `x11` are backend specific options. By default, only backend independent cursor configurations are generated. If you need configurations for specific backends, you can toggle them via the enable option. For example, [](#opt-home.pointerCursor.x11.enable) will enable x11 cursor configurations. Note that this will merely generate the cursor configurations. To apply the configurations, the relevant subsytems must also be configured. For example, [](#opt-home.pointerCursor.gtk.enable) will generate the gtk cursor configuration, but [](#opt-gtk.enable) needs to be set for it to be applied
    enable = true; # Whether to enable cursor config generation
    dotIcons.enable = true; # TODO: Try true # Whether to enable `.icons` config generation for {option}`home.pointerCursor`
    gtk.enable = true; # TODO: Whether to enable gtk config generation for {option}`home.pointerCursor`
    name = "Vanilla-DMZ"; # TODO: try "Vanilla-DMZ" # The cursor name within the package
    package = pkgs.vanilla-dmz; # Package providing the cursor theme
    size = 32; # The cursor size
    x11 = {
      enable = true; # Whether to enable x11 config generation for home.pointerCursor
      defaultCursor = "left_ptr"; # TODO: try "X_cursor" # The default cursor file to use within the package
    };
  };

  home.language = { #  Language configuration. All options are null or string
    address     = "da_DK.UTF-8"; # The language to use for addresses.
    base        = "da_DK.UTF-8"; # The language to use unless overridden by a more specific option.
    collate     = "da_DK.UTF-8"; # The language to use for collation (alphabetical ordering).
    ctype       = "da_DK.UTF-8"; # Character classification category.
    measurement = "da_DK.UTF-8"; # The language to use for measurement values.
    messages    = "da_DK.UTF-8"; # The language to use for messages, application UI languages, etc.
    monetary    = "da_DK.UTF-8"; # The language to use for formatting currencies and money amounts.
    name        = "da_DK.UTF-8"; # The language to use for personal names.
    numeric     = "da_DK.UTF-8"; # The language to use for numerical values.
    paper       = "da_DK.UTF-8"; # The language to use for paper sizes.
    telephone   = "da_DK.UTF-8"; # The language to use for telephone numbers.
    time        = "da_DK.UTF-8"; # The language to use for formatting times.
  };

  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "24.11"; # You should not change this value, even if you update Home Manager

  nixpkgs.config.allowUnfree = true;

  services.home-manager.autoExpire = {
    enable = true;
    timestamp = "-30 days";
    frequency = "monthly";
    store = {
      cleanup = true;
      options = "--delete-older-than 30d";
    };
  };

  # Install Nix packages
  home.packages = with pkgs; [
    xcolor            # color-pick shortcut for i3
    alacritty         # My chosen terminal. Loads quickly, and doesn't have a inbuilt-windowmanager to complicate it.
    xdotool           # Useful for automating tasks.
    rofi              # Used by i3 for fancy UI.
    rustdesk          # Remote control. Useful for helping family.
    fd
#   nixos-conf-editor # Editor for this configuration
    home-manager      # Have home manager manage itself.
    xorg.xkbcomp      # Temporary for messing with my keyboard settings
    xorg.xev          # I use this for testing button presses on i3
    xorg.xbacklight   # Modify device brightness, xrandr can only modify software brightness.
    sops              # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
    gnome-clocks      # Needed a timer
    keepassxc         # Password manager. TODO: Needs to be configured
    baobab            # Drive space tree-like view
    restic            # Backup the borgBackup folder at drive/backup-brian-Lenovo-Yoga-C940-14IIL-LinuxMintCinamon # TODO: Set up borg backup
    obsidian          # Unfree package. Can only use for non-profit.
    nodejs            # Javascript interpreter
    pgadmin4          # Postgresql for database connection
    haruna            # Video player
    light             # My i3 config uses this
    elixir            # I want to try out elixer to develop concurrent applications
    gh                # github commands
    libllvm           # Playing around with llvm IR
    pet               # Snippet manager, not exactly sure what that means
    qutebrowser       # browser with loads of shortcuts
    lxappearance      # GTK theme switcher, useful for i3
    audacious         # For playing music
    nil               # Nix langauge server
    rustc cargo       # Rust stuff
    zig zls           # Zig stuff
    firefox
    nemo
    xclip
    unzip
    xed-editor
    gnome-system-monitor
    pavucontrol        # Audio interface
    brightnessctl      # For i3 brightness without sudo
    llvmPackages_19.clangWithLibcAndBasicRtAndLibcxx llvmPackages_19.clang-manpages # Will remove later, temporary till I fix permission issues with using zig for building with make.
    arc-theme          # Dark theme related: Arc-Dark GTK theme
    gnome-themes-extra # Dark theme related: Includes Adwaita-dark
    simplescreenrecorder # My favorite recording software
    (import ./cbqn.nix pkgs) bqn386 # BQN interpreter and font
    ( # Python with scientific libraries
      python3.withPackages (p: with p;[
        numpy matplotlib sympy pandas # Me want very much. Used often.
        jupyter ipython ipykernel # Jupiter and dependencies
        mpmath # Arbitrary precision math
        scipy # Lots of mathy functions like eigenvalues and curve fitting
        scikit-learn # AI
      ])
    )

    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        ms-python.python # Python extension
        ms-python.vscode-pylance
        ziglang.vscode-zig
        esbenp.prettier-vscode
        formulahendry.code-runner
        vscode-extensions."13xforever".language-x86-64-assembly
        bradlc.vscode-tailwindcss
        rust-lang.rust-analyzer
        ms-vscode-remote.remote-ssh-edit
        ms-vscode-remote.remote-ssh
        ms-python.debugpy
        jnoortheen.nix-ide
        ritwickdey.liveserver
        eamodio.gitlens
#       github.copilot
#       github.copilot-chat
        hediet.vscode-drawio
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (map (x:
        let I=builtins.elemAt; in
        { name=I x 0;                   publisher=I x 1; version=I x 2; sha256=I x 3; } ) [
        [ "bqn"                         "mk12"           "latest" "0bnpc1xw5gs362sk213r0n2p37zd08m6jgj61jh3y098wni6say8" ]
        [ "newline"                     "chang196700"    "latest" "0xijg1nqlrlwkl4ls21hzikr30iz8fd98ynpbmhhdxrkm3iccqa1" ]
        [ "tws"                         "jkiviluoto"     "latest" "0aj58iasgnmd2zb7zxz587k9mfmykjwrb8h7hfvpkmh76s9bj4y5" ] # Trailing white space
        [ "toggle-zen-mode"             "fudd"           "latest" "0whmbpnin1r1qnq45fpz7ayp51d4lilvbnv7llqd6jplx5b4n3ds" ]
        [ "todo-tree"                   "Gruntfuggly"    "latest" "0yrc9qbdk7zznd823bqs1g6n2i5xrda0f9a7349kknj9wp1mqgqn" ]
        [ "iceworks-time-master"        "iceworks-team"  "latest" "05k7icssa7llbp4a44kny0556hvimmdh6fm394y5rh86bxqq0iq3" ]
        [ "suteppu"                     "Itsakaseru"     "latest" "1z0zkznwwm0z1vyq2wsw9rf1kg8pfpb3rl7glx0zp3aq8sxvnfsf" ]
        [ "vscode-sort"                 "henriiik"       "latest" "0sam2qfa596dcbabx3alrwsgm56a8wzb65dp45yv172kcaam5yd6" ]
        [ "slint"                       "Slint"          "latest" "1yshm7x6dalg4xw7ykwj736sq0dknnhm8j2wvjxqj5mcp43dxlzh" ]
        [ "remote-explorer"             "ms-vscode"      "latest" "0nzbra88cjf87vqjry3fczjjqs995fzp5m43wqbdidlw83wxpqp6" ]
        [ "ols"                         "DanielGavin"    "latest" "0rl6mjkabgbwc0vnm96ax1jhjh5rrky0i1w40fhs1zqyfd83mrsx" ]
        [ "vscode-lowercase"            "ruiquelhas"     "latest" "03kwbnc25rfzsr7lzgkycwxnifv4nx04rfcvmfcqqhacx74g14gs" ]
        [ "vsliveshare"                 "MS-vsliveshare" "latest" "0rhwjar2c6bih1c5w4w8gdgpc6f18669gzycag5w9s35bv6bvsr8" ] # Live Share
        [ "inline-html-indent"          "vulkd"          "latest" "0mh7kpis821088g5qmzay76zrgvgbikl9v2jdjs3mdfkbh2rfl6s" ]
        [ "vuerd-vscode"                "dineug"         "latest" "1n74fwpp0qpqjv42ni05j2h8c7dcf5brramm8s2b7a0q8m5fjk6z" ] # ERD editor
#       [ "chatgpt-copilot"             "feiskyer"       "latest" "0766vq07gjxgh4xpflzmrcx55i6b9w4hk5zg8yirvgfjscv5gvxv" ]
        [ "vscode-apl-language-client"  "OptimaSystems"  "latest" "050nn7f6gfzskq1yavqdw77rgl1lxs3p8dqkzrmmliqh5kqh2gr8" ]
        [ "vscode-apl-language"         "OptimaSystems"  "latest" "003n637vskbi4wypm8qwdy4fa9skp19w6kli1bgc162gzcbswhia" ]
        [ "vscode-autohotkey-plus-plus" "mark-wiemer"    "latest" "1i7gqxsgyf18165m2j6wb0ps1h6iniy89jhvhy89hnzm2i95a0ck" ]
        [ "i3"                          "dcasella"       "latest" "0z7qj6bwch1cxr6pab2i3yqk5id8k14mjlvl6i9f0cmdsxqkmci5" ]
      ]);
    })
  ];

  # manages dotfiles
  home.file = {
    "${homeDir}/.config/alacritty/alacritty.toml" = {
      enable = true;
      # onChange   # Shell commands to run when file has changed between generations. The script will be run *after* the new files have been linked into place. Note, this code is always run when `recursive` is enabled.   strings concatenated with "\n"
      # recursive  # If the file source is a directory, then this option determines whether the directory should be recursively linked to the target location. This option has no effect if the source is a file. If `false` (the default) then the target will be a symbolic link to the source directory. If `true` then the target will be a directory structure matching the source's but whose leafs are symbolic links to the files of the source directory.   boolean
      # source     # Path of the source file or directory. If .text is non-null then this option will automatically point to a file containing that text.   path
      text = lib.concatStringsSep "\n" [
        ''font.normal = { family = "BQN386 Unicode", style = "Regular" }'' # Requires bqn386 package
        ''window.decorations = "None"'' # No difference on i3. Disabled since probably less for alacrety to do.
        ''scrolling.history = 100000'' # 100,000 is the absolute max according to docs.
        ''colors.cursor = { text = "CellBackground", cursor = "#7d7d7d" }''
        "[general]"
        ''live_config_reload = true''
        ''ipc_socket = false'' # Disable using "alacritty msg" to tell alacritty to do stuff like "alacritty msg config" to update config
        "[colors.primary]" ''foreground = "#d8d8d8"'' ''background = "#000000"''
        ''dim_foreground = "None"'' # If this is set to None, the color is automatically calculated based on the foreground color. It isn't None by default.
        ''bright_foreground = "None"'' # This color is only used when draw_bold_text_with_bright_colors is true. If this is not set, the normal foreground will be used. It is set by default, but to be consistent with dim_background I'll make an exception and not remove this.
      ];
    };
    "${homeDir}/.config/qutebrowser/config.py" = {
      enable = true;
      executable = true;
      text = lib.concatStringsSep "\n" [
        ''config.set("colors.webpage.darkmode.enabled", True)''
        ''config.set('content.cookies.accept', 'no-3rdparty', 'chrome-devtools://*')''
        ''config.load_autoconfig(False)'' # Qutebrowser errors if you don't enable this when auto-generating a config, since otherwise it's able to edit it with GUI
      ];
    };
  };

  home = {inherit sessionVariables;};

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";  # Optional: use a matching dark icon set
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Adwaita";       # Optional: default cursor
      package = pkgs.gnome-themes-extra;
    };
  };
  # Dark mode for apps that respect XSettings
  xdg = {
    enable = true;
    mime.enable = true;
  };
  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "Arc-Dark";
      "Net/IconThemeName" = "Papirus-Dark";
      "Gtk/CursorThemeName" = "Adwaita";
    };
  };
  programs.i3status = {
    enableDefault = false; # Whether or not to enable the default configuration.   boolean
    enable = true; # Whether to enable i3status.  boolean
    general = {
      colors = true;
      interval = 5;
    };
    modules = let
      Indices = l: lib.range 0 (builtins.length l);
      format = l: builtins.listToAttrs (
        lib.zipListsWith
          (nameSetting: i: {
            name = builtins.elemAt nameSetting 0;
            value = {
              position = (builtins.length l) - i; # This len-index is just flipping the list, so top down is right to left on i3status.
              settings = builtins.elemAt nameSetting 1;
            };
          })
          l (Indices l));
    in format [ # Modules to add to i3status {file}`config` file. See {manpage}`i3status(1)` for options.   attribute set of (submodule)
      ["tztime local" {
        format = "%Y-%m-%d %H:%M:%S";
      }]
      ["volume master" {
        format = "♪ %volume";
        format_muted = "♪ %volume"; # Turns yellow, so no need to have a different format
        device = "pulse:alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"; # Find device name by finding ID of main sink device via `wpctl status` on the * row, then `wpctl inspect TheIDYouFound` and find "node.name = ...", and "..."" is your device name that you put after "pulse:"" here.
      }]
      ["battery all" {
        format = "%status %percentage %remaining";
      }]
      ["load" {
        format = "%5min";
#       format = "%1min";  # Default
      }]
      ["memory" {
        format = "%used";
#       format = "%used | %available"; # Default
        threshold_degraded = "10%";
#       threshold_degraded = "1G"; # Default
        format_degraded = "MEMORY: %free";
#       format_degraded = "MEMORY < %available"; # Default
      }]
      ["disk /" {
      }]
      ["read_file uptime" {
        path = "/proc/uptime";
      }]
      ["ipv6" {
        format_down = "";
      }]
      ["wireless _first_" {
        format_up = "W:%quality %ip";
        format_down = "";
      }]
      ["ethernet _first_" {
        format_up = "E: %ip (%speed)";
        format_down = "";
      }]
    ];
  };

  # gtk-theme-name="Sierra-compact-light"
  # gtk-icon-theme-name="ePapirus"
  # gtk-font-name="Ubuntu 11"
  # gtk-cursor-theme-name="Deepin"
  # gtk-cursor-theme-size=0
  # gtk-toolbar-style=GTK_TOOLBAR_BOTH
  # gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
  # gtk-button-images=1
  # gtk-menu-images=1
  # gtk-enable-event-sounds=1
  # gtk-enable-input-feedback-sounds=1
  # gtk-xft-antialias=1
  # gtk-xft-hinting=1
  # gtk-xft-hintstyle="hintfull"
  # gtk-xft-rgba="rgb"
  # gtk-modules="gail:atk-bridge"

  # gtk-cursor-theme-name = "Adwaita"
  # gtk-icon-theme-name = "Papirus-Dark"
  # gtk-theme-name = "Arc-Dark"




  programs.bash = {
    initExtra = lib.concatStrings (lib.mapAttrsToList (n: v: "export ${n}=\"${v}\"\n") sessionVariables); # I couldn't get home.sessionVariables working. Found this solution here: https://github.com/nix-community/home-manager/issues/1011
    enable = true;
    shellAliases = {
      code = "codium";
      nix-watch = "${nix-watch}/bin/nix-watch";
      NRO = "sudo nixos-rebuild switch --flake ~/nixos/#brians-laptop";
      fix-nix-hash = "nix hash convert --hash-algo sha256 --to nix32 $1"; # give in format sha256-...=
      RN = "sudo nixos-rebuild switch --flake ~/nixos/#brians-laptop && HR";
      RH = "${home-manager}/bin/home-manager switch --flake ~/nixos/#brian";
      NR = "sudo nixos-rebuild switch --flake ~/nixos/#brians-laptop && HR";
      HR = "${home-manager}/bin/home-manager switch --flake ~/nixos/#brian";
      P = "pwd | ${pkgs.xclip}/bin/xclip -selection clipboard";
      ".." = "cd .."; # Hilariously this works
      find = "${pkgs.fd}/bin/fd $@";
      net = "nmcli dev wifi && nmcli dev wifi connect --ask"; # Find a network to connect to
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles = {
      "Brian Ellingsgaard" = {
        isDefault = true;
        search = {
          default = "ddg";
          force = true;
          order = ["ddg" "google"];
          privateDefault = "ddg";
        };
        settings = {};
        # Custom Thunderbird user chrome CSS.
        userChrome = ''
        /* Hide tab bar in Thunderbird */
          #tabs-toolbar {
            visibility: collapse !important;
          }
        '';
        userContent = ''
          /* Hide scrollbar on Thunderbird pages */
          *{scrollbar-width:none !important}
        '';
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Brian-ED";
    userEmail = "brianellingsgaard9@gmail.com";
  };
}
