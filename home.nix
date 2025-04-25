{ pkgs, lib, home-manager, ... }:
{
  home.username = "brian";
  home.homeDirectory = "/home/brian";
  home.stateVersion = "24.11"; # You should not change this value, even if you update Home Manager
  home.keyboard = null;

  nixpkgs.config.allowUnfree = true;

  # Install Nix packages
  home.packages = with pkgs; [
    home-manager.packages.${pkgs.system}.home-manager
    sops      # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
    keepassxc # Password manager. TODO: Needs to be configured
    baobab # Drive space tree-like view
    restic # Backup the borgBackup folder at drive/backup-brian-Lenovo-Yoga-C940-14IIL-LinuxMintCinamon
    obsidian # Unfree package. Can only use for non-profit.
    xorg.xkbcomp # Temporary for messing with my keyboard settings
    nodejs_23 # Javascript interpreter
    pgadmin4 # Postgresql for database connection
    xorg.xev # I use this for testing button presses on i3
    xorg.xbacklight # Modify device brightness, xrandr can only modify software brightness.
    haruna # Video player
    light # My i3 config uses this
    elixir # I want to try out elixer to develop concurrent applications
    gh # github commands
    libllvm # Playing around with llvm IR
    gnome-clocks # Needed a timer
    pet # Snippet manager, not exactly sure what that means
    qutebrowser # browser with loads of shortcuts
    i3status-rust
    lxappearance # Icons for i3 and dark mode maybe?
    zig zls # Zig stuff
    ghostty # Terminal emulator
    rustc cargo # Rust stuff
    audacious # For playing music
    nil # Nix langauge server
    firefox-devedition
    firefox
    nemo
    xed-editor
    # Python with scientific libraries
    (
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
#        github.copilot
#        github.copilot-chat
        hediet.vscode-drawio
        ms-vscode.cpptools
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (map (x:
        let I=builtins.elemAt; in
        { name=I x 0;                   publisher=I x 1; version=I x 2;   sha256=I x 3; } ) [
        [ "bqn"                         "mk12"           "0.1.7"          "18arx9nrqwlpx7b5qq9w83p4cbicz6d40x3447g300gqapfhlb3j" ]
        [ "newline"                     "chang196700"    "0.0.4"          "0xijg1nqlrlwkl4ls21hzikr30iz8fd98ynpbmhhdxrkm3iccqa1" ]
        [ "tws"                         "jkiviluoto"     "1.0.1"          "0aj58iasgnmd2zb7zxz587k9mfmykjwrb8h7hfvpkmh76s9bj4y5" ] # Trailing white space
        [ "toggle-zen-mode"             "fudd"           "1.1.2"          "0whmbpnin1r1qnq45fpz7ayp51d4lilvbnv7llqd6jplx5b4n3ds" ]
        [ "todo-tree"                   "Gruntfuggly"    "0.0.226"        "0yrc9qbdk7zznd823bqs1g6n2i5xrda0f9a7349kknj9wp1mqgqn" ]
        [ "iceworks-time-master"        "iceworks-team"  "1.0.4"          "05k7icssa7llbp4a44kny0556hvimmdh6fm394y5rh86bxqq0iq3" ]
        [ "suteppu"                     "Itsakaseru"     "1.0.1"          "1z0zkznwwm0z1vyq2wsw9rf1kg8pfpb3rl7glx0zp3aq8sxvnfsf" ]
        [ "vscode-sort"                 "henriiik"       "0.2.5"          "0sam2qfa596dcbabx3alrwsgm56a8wzb65dp45yv172kcaam5yd6" ]
        [ "slint"                       "Slint"          "1.10.0"         "1c6bailn562zsh7wzx8jjj0y8mdzxj3sqgym5x5liw93b11kv3i3" ]
        [ "remote-explorer"             "ms-vscode"      "0.5.2025021709" "02lnijwl92lq3rhv4f0kbp1bjfniipigih1myl5xmrwsp85n88xl" ]
        [ "ols"                         "DanielGavin"    "0.1.34"         "0rl6mjkabgbwc0vnm96ax1jhjh5rrky0i1w40fhs1zqyfd83mrsx" ]
        [ "vscode-lowercase"            "ruiquelhas"     "1.0.1"          "03kwbnc25rfzsr7lzgkycwxnifv4nx04rfcvmfcqqhacx74g14gs" ]
        [ "vsliveshare"                 "MS-vsliveshare" "1.0.5948"       "0rhwjar2c6bih1c5w4w8gdgpc6f18669gzycag5w9s35bv6bvsr8" ] # Live Share
        [ "inline-html-indent"          "vulkd"          "0.0.1"          "0mh7kpis821088g5qmzay76zrgvgbikl9v2jdjs3mdfkbh2rfl6s" ]
        [ "vuerd-vscode"                "dineug"         "2.0.5"          "1agcayiz8p7n05x6wm817gdj3fwmxkdxbsf5alx4jbp1msi6qwwh" ] # ERD editor
#        [ "chatgpt-copilot"             "feiskyer"       "4.8.4"          "0766vq07gjxgh4xpflzmrcx55i6b9w4hk5zg8yirvgfjscv5gvxv" ]
        [ "vscode-apl-language-client"  "OptimaSystems"  "0.0.9"          "050nn7f6gfzskq1yavqdw77rgl1lxs3p8dqkzrmmliqh5kqh2gr8" ]
        [ "vscode-apl-language"         "OptimaSystems"  "0.0.7"          "003n637vskbi4wypm8qwdy4fa9skp19w6kli1bgc162gzcbswhia" ]
        [ "vscode-autohotkey-plus-plus" "mark-wiemer"    "6.7.0"          "10sf0qf0sqc5ifjf9vg2fyh7akz7swrilz6aifvyswzglglmca19" ]
        [ "i3"                          "dcasella"       "1.0.0"          "0z7qj6bwch1cxr6pab2i3yqk5id8k14mjlvl6i9f0cmdsxqkmci5" ]
      ]);
    })

    # Shell scripts
    # give in format sha256-...=
    (pkgs.writeShellScriptBin "fix-nix-hash" ''
      nix hash convert --hash-algo sha256 --to nix32 $1
    '')
    (pkgs.writeShellScriptBin "RN" ''
      sudo nixos-rebuild switch --flake ~/nixos/#brians-laptop
      HR
    '')
    (pkgs.writeShellScriptBin "RH" ''
      home-manager switch --flake ~/nixos/#brian
    '')
    (pkgs.writeShellScriptBin "NR" ''
      sudo nixos-rebuild switch --flake ~/nixos/#brians-laptop
      HR
    '')
    (pkgs.writeShellScriptBin "HR" ''
      home-manager switch --flake ~/nixos/#brian
    '')
    (pkgs.stdenv.mkDerivation {
      pname = "cbqn";
      version = "rolling";
      src = pkgs.fetchFromGitHub {
        owner = "dzaima";
        repo = "CBQN";
        rev = "09642a354f124630996a6ae4e8442089625cd907";
        hash = "sha256-M1dEB4o+nXXzq/96/PvBKL3sLH84y1XYrv3yknGzhmw=";
        fetchSubmodules = true;
      };

      dontConfigure = true;
      preferLocalBuild = true;

      nativeBuildInputs = [ pkgs.pkg-config ];
      buildInputs       = [ pkgs.libffi ];

      # Set the system C compiler
      makeFlags = [ "CC=${pkgs.stdenv.cc.targetPrefix}cc" ];

      # Customize build for maximum performance.
      buildFlags = [
        "o3"
        "notui=1"
        "REPLXX=1"
        "f=-march=znver4"
        "target_from_cc=1"
      ];

      # Set up local copies of required submodules.
      preBuild = ''
        mkdir -p build/{singeliLocal,bytecodeLocal,replxxLocal}
        cp -r build/singeliSubmodule/* build/singeliLocal/
        cp -r build/bytecodeSubmodule/* build/bytecodeLocal/
        cp -r build/replxxSubmodule/* build/replxxLocal/
      '';

      postPatch = ''
        # Remove the SHELL definition from the makefile and fix shebangs.
        sed -i '/SHELL =/d' makefile
        patchShebangs build/build
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp BQN $out/bin/
        ln -sf BQN $out/bin/bqn
        ln -sf BQN $out/bin/cbqn
      '';

      meta = {
        description = "Optimized CBQN interpreter with REPLXX support for AMD Ryzen";
        homepage    = "https://github.com/dzaima/CBQN";
        license     = pkgs.lib.licenses.gpl3Only;
        platforms   = pkgs.lib.platforms.linux;
      };
    })
  ];

  # managing dotfiles through 'home.file'.
  home.file = {
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager.
  home.sessionVariables = {
    EDITOR = "codium";
  };

  # Let home-manager manage bash stuff
  # Disabled because it's producing errors like ".../starship directory missing"
#  programs.bash = {
#    enable = true;
#  };

  # git
  programs.git = {
    enable = true;
    userName = "Brian-ED";
    userEmail = "brianellingsgaard9@gmail.com";
  };
}
