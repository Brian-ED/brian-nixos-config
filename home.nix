# TODO get home manager to manage files ~/.gtkrc-2.0
{ pkgs, pkgs-stable, lib, inputs, winUser, minUser, nixPath, ...}:
let
  nix-watch         = inputs.nix-watch        .packages.${pkgs.system}.default;
  home-manager      = inputs.home-manager     .packages.${pkgs.system}.home-manager;
  nixos-conf-editor = inputs.nixos-conf-editor.packages.${pkgs.system}.nixos-conf-editor;
  nil               = inputs.nil              .packages.${pkgs.system}.nil;
  k                 = inputs.k                .packages.${pkgs.system}.k;
  cbqn-native = (import ./pkgs/cbqn.nix pkgs);
  username = "brian";
  homeDir = "/home/${username}";

  startup = pkgs.writeShellScriptBin "startup" ''
    ${pkgs.paperview}/bin/paperview ${homeDir}/proj/wallpapers/frames2 3
  '';

  # Python with scientific libraries
  python3 = pkgs.python3.withPackages (p: with p;[
    yt-dlp-light pyperclip # These are dependencies of my youtube song downloader for my playlist, which is used by the I3 shortcut $mod+Control+Shift+m
    numpy matplotlib sympy pandas # Me want very much. Used often
    jupyter ipython ipykernel # Jupiter and dependencies
    mpmath # Arbitrary precision math
    scipy # Lots of mathy functions like eigenvalues and curve fitting
    (p.callPackage ./pkgs/automata.nix {cached-method = p.callPackage ./pkgs/cached-method.nix {};})
  ]);

  sessionVariables = {

    # Define the terminal prompt
    # Old: \n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\]
    # Old: [brian@brians-laptop:~/proj/brian-nixos-config]$
    # New: \[\e]0;\w\a\]\[\033[1;32m\]$(if [ "$USER" = "brian" ]; then echo; else echo "$USER:"; fi)$(if [ "$USER" = "brian" -o "$HOME" = "$PWD" ]; then echo; else echo ":"; fi)$(if [ "$HOME" = "$PWD" ]; then echo; else dirs; fi)$ \[\033[0m\]
    # New: ~/proj/brian-nixos-config$
    PS1 =let
      # https://en.wikipedia.org/wiki/ANSI_escape_code
      ESCSeq = x: Wrap"\\033[${builtins.concatStringsSep";"x}m";
      Wrap = x:"\\[${x}\\]";
      effect = {
        normal = "0";
        bold = "1";
        dim = "2";
        italic = "3";
        Underline = "4";
        # ...
      };
      color = {
        # ...
        green = "32";
        # ...
      };
      WindowTitle = x: Wrap"\\e]0;${x}\\a";
      path = "\\w";
      user = "\\u";
    in "\n"
    + WindowTitle path
    + ESCSeq[effect.bold color.green]
    + ''\$(if [ \"\$USER\" = \"${lib.escapeShellArg username}\" ]; then echo; else echo \"\$USER:\"; fi)''
    + ''\$(if [ \"\$USER\" = \"${lib.escapeShellArg username}\" -o \"\$HOME\" = \"\$PWD\" ]; then echo; else echo \":\"; fi)''
    + ''\$(if [ \"\$HOME\" = \"\$PWD\" ]; then echo; else dirs; fi)''
    + "$ " + ESCSeq[effect.normal];

    # For running the java application singeliPlayground
    GSETTINGS_SCHEMA_DIR = "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";

    EDITOR = "codium";
    BROWSER = "qutebrowser";
    TERMINAL = "alacritty";
    NH_FLAKE = "${homeDir}/nixos";
    SINGELI_PATH = inputs.singeli;
    NIX_PATH = lib.concatStringsSep ":" nixPath;
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
  # TODO: Only try cloning if connected to wifi
  # TODO: warn when a repository is removed from the list but still exists with state (autodelete if no state exists). State includes hidden files, new files, and non-default files found in .git folder.
  home.activation.makeRepos = let # It's complicated, refer to: https://home-manager-options.extranix.com/?query=home.activation&release=release-25.05
    proj = "${homeDir}/proj";
    G = "https://github.com";
    repositories_I_play_with = {
      brian-nixos-config     = { path = proj ; repo = "${G}/Brian-ED/brian-nixos-config"    ;};
      rayed-bqn              = { path = proj ; repo = "${G}/Brian-ED/rayed-bqn"             ;};
      brian-i3-config        = { path = proj ; repo = "${G}/Brian-ED/brian-i3-config"       ;};
      raylib-bqn             = { path = proj ; repo = "${G}/Brian-ED/raylib-bqn"            ;};
      bqnserver              = { path = proj ; repo = "${G}/Brian-ED/bqnserver"             ;};
      "Brian-ED.github.io"   = { path = proj ; repo = "${G}/Brian-ED/Brian-ED.github.io"    ;};
      rayed-bqn-docs         = { path = proj ; repo = "${G}/Brian-ED/rayed-bqn-docs"        ;};
      consistent_vocabulary  = { path = proj ; repo = "${G}/M1kiMinaj/consistent_vocabulary";};
    };
    cloneCommands = lib.mapAttrsToList (name: {path, repo}: ''
      if [ ! -d ${path}/${name} ]; then
        run ${pkgs.git}/bin/git clone ${repo} ${path}/${name}
      fi
    '') repositories_I_play_with;
  in lib.hm.dag.entryAfter [ "writeBoundary" "installPackages" "git" ] ''
    if [ ! -d ${proj} ]; then
      run mkdir ${proj}
    fi
    ${lib.concatStrings cloneCommands}
    if [ ! -d ${proj}/singeliPlayground ]; then
      run ${pkgs.git}/bin/git clone "${G}/dzaima/singeliPlayground" ${proj}/singeliPlayground
      git="${pkgs.git}/bin/git"
      run ${python3}/bin/python3 ${proj}/singeliPlayground/build.py
    fi
    if [ ! -d ${homeDir}/.config/i3 ]; then
      run ln -s ${proj}/brian-i3-config ${homeDir}/.config/i3
    fi
  '';

  home.keyboard = { # Keyboard configuration. Set to `null` to disable Home Manager keyboard management
    layout  = "fo,bqn";  # If `null`, then the system configuration will be used. This defaults to `null` for state version ≥ 19.09 and `"us"` otherwise
    model   = "";
    options = [ "grp:lswitch" ];  # X keyboard options; layout switching goes here
    variant =  ""; # X keyboard variant. If `null`, then the system configuration will be used. This defaults to `null` for state version ≥ 19.09 and `""` otherwise
  };

  home.pointerCursor = { # Cursor configuration. Top-level options declared under this submodule are backend independent options. Options declared under namespaces such as `x11` are backend specific options. By default, only backend independent cursor configurations are generated. If you need configurations for specific backends, you can toggle them via the enable option. For example, [](#opt-home.pointerCursor.x11.enable) will enable x11 cursor configurations. Note that this will merely generate the cursor configurations. To apply the configurations, the relevant subsytems must also be configured. For example, [](#opt-home.pointerCursor.gtk.enable) will generate the gtk cursor configuration, but [](#opt-gtk.enable) needs to be set for it to be applied
    enable = true; # Whether to enable cursor config generation
    dotIcons.enable = true; # TODO: Try true # Whether to enable `.icons` config generation for `home.pointerCursor`
    gtk.enable = true; # TODO: Whether to enable gtk config generation for `home.pointerCursor`
    name = "Vanilla-DMZ";  # The cursor name within the package
    package = pkgs.vanilla-dmz; # Package providing the cursor theme
    size = 32; # The cursor size
    x11 = {
      enable = true; # Whether to enable x11 config generation for home.pointerCursor
      defaultCursor = "left_ptr"; # TODO: try "X_cursor" # The default cursor file to use within the package
    };
  };

  home.language = { #  Language configuration. All options are null or string
    address     = "en_US.UTF-8"; # The language to use for addresses
    base        = "en_US.UTF-8"; # The language to use unless overridden by a more specific option
    collate     = "en_US.UTF-8"; # The language to use for collation (alphabetical ordering)
    ctype       = "en_US.UTF-8"; # Character classification category
    measurement = "en_US.UTF-8"; # The language to use for measurement values
    messages    = "en_US.UTF-8"; # The language to use for messages, application UI languages, etc
    monetary    = "en_US.UTF-8"; # The language to use for formatting currencies and money amounts
    name        = "en_US.UTF-8"; # The language to use for personal names
    numeric     = "en_US.UTF-8"; # The language to use for numerical values
    paper       = "en_US.UTF-8"; # The language to use for paper sizes
    telephone   = "en_US.UTF-8"; # The language to use for telephone numbers
    time        = "en_US.UTF-8"; # The language to use for formatting times
  };

  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "24.11"; # You should not change this value, even if you update Home Manager

  nixpkgs.config.allowUnfree = true;

  # Install Nix packages
  home.packages = [
    nil               # Nix langauge server
    home-manager      # Have home manager manage itself
    python3
  ] ++ (with pkgs; [
    stripe-cli
    #jdk25 # javac for SingeliPlayground
    jdk21 # java for vscode redhat java ext. Used in P3 uni project
    (writeShellScriptBin "mount-hard-drive" ''
      sudo cryptsetup luksOpen /dev/disk/by-uuid/41782a7f-3269-433b-8beb-c74fba89ef2d a
      sudo mount /dev/mapper/a /mnt/hard-drive
    '')
    (writeShellScriptBin "sing" ''
      if [ ! $@ == "" ]; then
        mkdir --parents out
        ${cbqn-native}/bin/bqn ${inputs.singeli}/singeli --out out/out.c --deplog out/log.txt $@
        ${llvmPackages_19.clangWithLibcAndBasicRtAndLibcxx}/bin/clang out/out.c -o out/a.out
        out/a.out
        rmdir out 2>/dev/null
      else
        ${cbqn-native}/bin/bqn ${inputs.singeli}/singeli --help
      fi
    '')
    trashy # For making it so I can avoid deleting files right away, and instead trash them
#   ZealOS
    nix-watch
    k   # On github: runtimeverification/k. A verification language
    qbe # Compiler backend
    qemu # Virtual machines
    gnome-screenshot
    kiwix-tools # I use this for reading wikipedia offline
    (dyalog.override { acceptLicense = true; }) ride # Dyalog APL stuff
    libreoffice-qt6-fresh
    duf              # Disk utility
    cryptsetup       # For decrypting my LUKS encrypted harddrive
    prismlauncher    # Minecraft launcher
    #wireguard-tools
    qbittorrent-enhanced # BitTorrent client
    pastel            # Command-line tool to generate, analyze, convert and manipulate colors
    bat fzf eza zoxide nushell # Some things I've been trying to improve the terminal. Bad so far.
    xcolor            # color-pick shortcut for i3
    alacritty         # My chosen terminal. Loads quickly, and doesn't have a inbuilt-windowmanager to complicate it
    xdotool           # Useful for automating tasks
    rofi              # Used by i3 for fancy UI
    rustdesk          # Remote control. Useful for helping family
    fd                # Since I forget how to use the `find` command every time, I replaced it with fd, which lists files recursively as a flat list that i can then egrep

    # Alpaca
    #php               # php is used for alpaca server
    #php84Packages.composer # composer is the php package manager
    #docker_28         # Docker is a dependency of alpaca

    #nixos-conf-editor # Editor for this configuration
    #xorg.xkbcomp      # Temporary for messing with my keyboard settings
    xorg.xev          # I use this for testing button presses on i3
    # TODO Do I really need 3 applications for light control on i3?
    xorg.xbacklight   # Modify device brightness, xrandr can only modify software brightness
    light             # My i3 config uses this
    brightnessctl      # For i3 brightness without sudo
    #sops              # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
    gnome-clocks      # Needed a timer
    keepassxc         # Password manager. TODO: Needs to be configured
    rlwrap            # Useful to make Dyalog be a more classic repl
    baobab            # Drive space tree-like view
    obsidian          # Unfree package. Can only use for non-profit
    nodejs            # Javascript interpreter
    #pgadmin4          # Postgresql for database connection
    haruna            # Video player
    #elixir            # I want to try out elixer to develop concurrent applications
    #gh                # github commands
    #libllvm           # Playing around with llvm IR
    #pet               # Snippet manager, not exactly sure what that means # TODO: Figure this out
    qutebrowser       # browser with loads of shortcuts
    lxappearance      # GTK theme switcher, useful for i3
    audacious         # For playing music
    rustc cargo       # Rust stuff
    zig zls           # Zig stuff
    firefox           # Web browser
    nemo-with-extensions # File explorer
    ffmpeg            # This is a dependency of my youtube song downloader for my playlist, which is used by the I3 shortcut $mod+Control+Shift+m
    xclip             # Clipboard utility
    unzip
    pkgs-stable.mypaint     # Basic drawing program
    xed-editor
    (agda.withPackages (p: [ p.standard-library ]))
    gnome-system-monitor
    paperview
    startup
    pavucontrol        # Audio interface
    gmetronome
    llvmPackages_19.clangWithLibcAndBasicRtAndLibcxx llvmPackages_19.clang-manpages # Will remove later, temporary till I fix permission issues with using zig for building with make
    arc-theme          # Dark theme related: Arc-Dark GTK theme
    gnome-themes-extra # Dark theme related: Includes Adwaita-dark
    simplescreenrecorder # My favorite recording software
    cbqn-native bqn386 # BQN interpreter and font
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        ms-dotnettools.vscode-dotnet-runtime
        ms-python.python # Python extension
        ms-python.vscode-pylance
        ziglang.vscode-zig
        esbenp.prettier-vscode
        formulahendry.code-runner
        vscode-extensions."13xforever".language-x86-64-assembly
        bradlc.vscode-tailwindcss
        ms-vscode-remote.remote-ssh-edit
        ms-vscode-remote.remote-ssh
        ms-python.debugpy
        jnoortheen.nix-ide
        ritwickdey.liveserver
        eamodio.gitlens
        banacorn.agda-mode
#       github.copilot
#       github.copilot-chat
        hediet.vscode-drawio
        vscjava.vscode-java-pack # This is mainly for P3 (Uni project) with vaadin to do java web development
        vscjava.vscode-java-debug # This is mainly for P3 (Uni project) with vaadin to do java web development
        redhat.java # This is mainly for P3 (Uni project) with vaadin to do java web development
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (map (x:
        let I=builtins.elemAt; in
        { name=I x 0;                   publisher=I x 1; version=I x 2; sha256=I x 3; } ) [
        [ "vscode-spring-boot"          "vmware"         "latest" "0iba4xzas6khc96vx0clsgwqhgz92q1zqpnbgff367smwfggzica" ] # This is mainly for P3 (Uni project) with vaadin to do java web development
        [ "vscode-boot-dev-pack"        "vmware"         "latest" "0k181dz71ivjn5qkz3x0f65kvnkz4pgi5jq9bwy6a14g67ipya71" ] # This is mainly for P3 (Uni project) with vaadin to do java web development
        [ "vaadin-vscode"               "vaadin"         "latest" "12nbr3br4g8q9r85xwhhsd0m3hw46srffdivml4jpj8gfh9qy3jj" ] # This is mainly for P3 (Uni project) with vaadin to do java web development
        [ "vscode-stripe"               "Stripe"         "latest" "07jwjzya4961w7mz8gpjw1300bigzpn2k8pqdng6k9b72jij80la" ]
        [ "bqn"                         "mk12"           "latest" "sha256-nTnL75BzHrpnJVO8DFfrLZZGavCC4OzvAlyrGCXSak4=" ]
        [ "newline"                     "chang196700"    "latest" "0xijg1nqlrlwkl4ls21hzikr30iz8fd98ynpbmhhdxrkm3iccqa1" ]
        [ "tws"                         "jkiviluoto"     "latest" "0aj58iasgnmd2zb7zxz587k9mfmykjwrb8h7hfvpkmh76s9bj4y5" ] # Trailing white space
        [ "toggle-zen-mode"             "fudd"           "latest" "0whmbpnin1r1qnq45fpz7ayp51d4lilvbnv7llqd6jplx5b4n3ds" ]
        [ "todo-tree"                   "Gruntfuggly"    "latest" "0yrc9qbdk7zznd823bqs1g6n2i5xrda0f9a7349kknj9wp1mqgqn" ]
        [ "iceworks-time-master"        "iceworks-team"  "latest" "05k7icssa7llbp4a44kny0556hvimmdh6fm394y5rh86bxqq0iq3" ]
        [ "suteppu"                     "Itsakaseru"     "latest" "1z0zkznwwm0z1vyq2wsw9rf1kg8pfpb3rl7glx0zp3aq8sxvnfsf" ]
        [ "vscode-sort"                 "henriiik"       "latest" "0sam2qfa596dcbabx3alrwsgm56a8wzb65dp45yv172kcaam5yd6" ]
        [ "slint"                       "Slint"          "latest" "sha256-/7zn5jpIqT//PriiJRmbygud7BmAMKVN8C6KOgfx9cI=" ]
        [ "remote-explorer"             "ms-vscode"      "latest" "10rsnl5yk08mhcwg5j7s2xsawd7v2ilcgg2rm9v904v3nd2qi8xv" ]
        #[ "ols"                         "DanielGavin"    "latest" "0rl6mjkabgbwc0vnm96ax1jhjh5rrky0i1w40fhs1zqyfd83mrsx" ] # Odin
        [ "vscode-lowercase"            "ruiquelhas"     "latest" "03kwbnc25rfzsr7lzgkycwxnifv4nx04rfcvmfcqqhacx74g14gs" ]
        #[ "vsliveshare"                 "MS-vsliveshare" "latest" "0rhwjar2c6bih1c5w4w8gdgpc6f18669gzycag5w9s35bv6bvsr8" ] # Live Share
        [ "inline-html-indent"          "vulkd"          "latest" "0mh7kpis821088g5qmzay76zrgvgbikl9v2jdjs3mdfkbh2rfl6s" ]
        #[ "chatgpt-copilot"             "feiskyer"       "latest" "0766vq07gjxgh4xpflzmrcx55i6b9w4hk5zg8yirvgfjscv5gvxv" ]
        [ "vscode-apl-language-client"  "OptimaSystems"  "latest" "050nn7f6gfzskq1yavqdw77rgl1lxs3p8dqkzrmmliqh5kqh2gr8" ]
        [ "vscode-apl-language"         "OptimaSystems"  "latest" "003n637vskbi4wypm8qwdy4fa9skp19w6kli1bgc162gzcbswhia" ]
        [ "vscode-autohotkey-plus-plus" "mark-wiemer"    "latest" "1i7gqxsgyf18165m2j6wb0ps1h6iniy89jhvhy89hnzm2i95a0ck" ]
        #[ "i3"                          "dcasella"       "latest" "0z7qj6bwch1cxr6pab2i3yqk5id8k14mjlvl6i9f0cmdsxqkmci5" ]
        #[ "idris-vscode"                "meraymond"      "latest" "0yam13n021lmc93m8rpw96ksci0jshfrlnnfdk1q9yqrxydy6320" ]
      ]);
    })
  ]);

  # manages dotfiles
  home.file = import ./home-files.nix {inherit homeDir lib pkgs;};

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

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };

  # Dark mode for apps that respect XSettings
  xdg = {
    enable = true;
    mime.enable = true;
    desktopEntries.nemo = {
      name = "Nemo";
      exec = "${pkgs.nemo-with-extensions}/bin/nemo";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "nemo.desktop" ];
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      };
    };
  };
  dconf.settings = {
    "org/cinnamon/desktop/applications/terminal" = {
      exec = "alacritty";
    };
    "org/cinnamon/desktop/interface" = {
      can-change-accels = true;
    };
  };

#  systemd.user.services.onstartBrian = {
#    Unit = {
#      Description = "On-start script";
#      PartOf = [ "graphical-session.target" ];
#      After = [ "graphical-session.target" ];
#    };
#    Service = {
#      ExecStart = lib.getExe startup;
#      Restart = "on-failure";
#    };
#    Install = {
#      WantedBy = [ "graphical-session.target" ];
#    };
#  };

  services = {
    syncthing.enable = true;

    xsettingsd = {
      enable = true;
      settings = {
        "Net/ThemeName" = "Arc-Dark";
        "Net/IconThemeName" = "Papirus-Dark";
        "Gtk/CursorThemeName" = "Adwaita";
      };
    };
    home-manager.autoExpire = {
      enable = true;
      timestamp = "-30 days";
      frequency = "monthly";
      store = {
        cleanup = true;
        options = "--delete-older-than 30d";
      };
    };
    restic2 = {
      enable = true;
      backups.localbackup = {
        insecureNoPassword = true;
        repository = "/mnt/hard-drive/restic-backup";
        paths = [
          "/home"
        ];
        exclude = [
          "/home/*/.cache"
        ];
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 75"
        ];
      };
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
              position = (builtins.length l) - i; # This len-index is just flipping the list, so top down is right to left on i3status
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
        device = "pulse:alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"; # Find device name by finding ID of main sink device via `wpctl status` on the * row, then `wpctl inspect TheIDYouFound` and find "node.name = ...", and "..."" is your device name that you put after "pulse:"" here
      }]
      ["battery all" {
        format = "%status %percentage %remaining";
      }]
      ["load" {
        format = "load %1min";
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


  programs.nh = {
    enable = true;
  };

  programs.bash = {
    initExtra = lib.concatStrings (lib.mapAttrsToList (n: v: "export ${n}=\"${v}\"\n") sessionVariables); # I couldn't get home.sessionVariables working. Found this solution here: https://github.com/nix-community/home-manager/issues/1011
    enable = true;
    shellAliases = rec {
      volup = "wpctl set-volume $(wpctl status | egrep '\\*.*Speaker'  | grep -oE '[0-9]+' | head -n 1) 10%+";
      addsong = "${python3}/bin/yt-dlp --format 251 --paths ${winUser}/Music/ $@";
      code = "codium";
      fix-nix-hash = "nix hash convert --hash-algo sha256 --to nix32 $1"; # give in format sha256-...=

      # Nix build OS things
      NRO = "${pkgs.nh}/bin/nh os   switch ${homeDir}/proj/brian-nixos-config";
      HR  = "${pkgs.nh}/bin/nh home switch ${homeDir}/proj/brian-nixos-config";
      NROQ = "sudo nixos-rebuild switch --flake ${homeDir}/proj/brian-nixos-config/#brians-laptop";
      HRQ = "${home-manager}/bin/home-manager switch --flake ${homeDir}/proj/brian-nixos-config/#brian";
      NR = "${HR} && ${NRO}"; # Runs home manager first since NRO will ask for sudo when it ends, and I don't want to wait again after providing sudo
      NRQ = "${NROQ} && ${HRQ}"; # Runs home manager last since NROQ will ask for sudo at the start, and I don't want to wait again after providing sudo

      P = "pwd | ${pkgs.xclip}/bin/xclip -selection clipboard";
      clip = "${pkgs.xclip}/bin/xclip -selection clipboard";
      lo = "${pkgs.libreoffice-qt6-fresh}/bin/libreoffice";
      "." = "cd .."; # Hilariously this works
      "," = "cd ~";
      "_" = "cd - >> /dev/null";
      mcsnorri = "prismlauncher --launch 1.21.8-extra --server 198.244.176.195:2009";
      mclocal = "prismlauncher --launch 1.21.8 --world 'Sorter Showcase v1.2'";
      mintemail = "${pkgs.thunderbird}/bin/thunderbird --profile ${minUser}/.thunderbird/v5k5cfgq.default-release $@";
      aplk = "setxkbmap -layout fo,apl -option grp:lswitch";
      bqnk = "setxkbmap -layout fo,bqn -option grp:lswitch";
      net = "nmcli dev wifi && nmcli dev wifi connect --ask"; # Find a network to connect to
      cat = "${pkgs.bat}/bin/bat $@";

      # ls-like things
      l   = "${pkgs.eza}/bin/eza --color=always --all --classify=always --long --color=always --absolute=on --header --git --git-repos --time-style=relative --total-size --no-permissions --no-user --sort extension --icons";
      ls  = "${pkgs.eza}/bin/eza --color=always       --classify=always --across                                                                                                                                      --icons";
      lsr = "${l} --tree";
      lsrf = "${pkgs.fd}/bin/fd $@";
      navfind = "fzf --height 50% --layout reverse --info inline --preview 'bat --color=always --style=full,-grid --line-range=:500 {}' --preview-window right,70%,border-none";

      rm = "rm --interactive"; # I want to remind myself before deleting stuff. Also, I shouldn't really use this, instead I should use trashy
      mv = "mv --update=none-fail"; # Accidentally deleted a file while moving it. Now, I get an error when moving a file that replaces another file
      tp = "${pkgs.trashy}/bin/trash put $@";
      d = "nix develop";
      win = "cd ${winUser}";
      min = "cd ${minUser}";
      singplay = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${homeDir}/proj/singeliPlayground/run ${cbqn-native} ${inputs.singeli}";
      singeli = "${inputs.singeli}/singeli";
      lines = " wc -l";
      "≠" = lines;
      "⌽" = "${pkgs.coreutils-full}/bin/tac ";
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
        # Custom Thunderbird user chrome CSS
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
    extraConfig.safe.directory = [
      "${winUser}/raylibAPL"
      "${winUser}/raylibAPL/imports/c-header-to-bqn-ffi"
      "${winUser}/temp-c-raylib"
    ];
    userName = "Brian-ED";
    userEmail = "brianellingsgaard9@gmail.com";
  };
}
