{ pkgs, ... }:

{
  home.username = "brian";
  home.homeDirectory = "/home/brian";
  home.stateVersion = "24.11"; # You should not change this value, even if you update Home Manager
  home.keyboard = null;

  # TODO this doesn\t work often. I think it will never work now that I am using SwayWM
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # Install Nix packages
  home.packages = with pkgs; [
    vim       # Code editor for when I get bored of vscodium, or when sudo-privilages is required. TODO: replace with nix-nvim
    sops      # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
    keepassxc # Password manager. TODO: Needs to be configured
    cbqn   # BQN programming language
    baobab # Drive space tree-like view
    restic # Backup the borgBackup folder at drive/backup-brian-Lenovo-Yoga-C940-14IIL-LinuxMintCinamon
    obsidian # Unfree package. Can only use for non-profit.
    python314 # python 3.14
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
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        ms-python.python # Python extension
        ms-python.vscode-pylance
        ziglang.vscode-zig
        esbenp.prettier-vscode
        formulahendry.code-runner
        vscode-extensions."13xforever".language-x86-64-assembly
        ms-vscode-remote.remote-wsl
        bradlc.vscode-tailwindcss
        rust-lang.rust-analyzer
        ms-vscode-remote.remote-ssh-edit
        ms-vscode-remote.remote-ssh
        ms-python.debugpy
        jnoortheen.nix-ide
        ritwickdey.liveserver
        eamodio.gitlens
        github.copilot
        github.copilot-chat
        hediet.vscode-drawio
        ms-vscode.cpptools
# HTML to CSS autocompletion

      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "bqn";
          publisher = "mk12";
          version = "0.1.7";
          sha256 = "18arx9nrqwlpx7b5qq9w83p4cbicz6d40x3447g300gqapfhlb3j";
        }
        {
          name = "newline";
          publisher = "chang196700";
          version = "0.0.4";
          sha256 = "0xijg1nqlrlwkl4ls21hzikr30iz8fd98ynpbmhhdxrkm3iccqa1";
        }
        {
          name = "tws"; # Trailing white space
          publisher = "jkiviluoto";
          version = "1.0.1";
          sha256 = "0aj58iasgnmd2zb7zxz587k9mfmykjwrb8h7hfvpkmh76s9bj4y5";
        }
        {
          name = "toggle-zen-mode";
          publisher = "fudd";
          version = "1.1.2";
          sha256 = "0whmbpnin1r1qnq45fpz7ayp51d4lilvbnv7llqd6jplx5b4n3ds";
        }
        {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.226";
          sha256 = "0yrc9qbdk7zznd823bqs1g6n2i5xrda0f9a7349kknj9wp1mqgqn";
        }
        {
          name = "iceworks-time-master";
          publisher = "iceworks-team";
          version = "1.0.4";
          sha256 = "05k7icssa7llbp4a44kny0556hvimmdh6fm394y5rh86bxqq0iq3";
        }
        {
          name = "suteppu";
          publisher = "Itsakaseru";
          version = "1.0.1";
          sha256 = "1z0zkznwwm0z1vyq2wsw9rf1kg8pfpb3rl7glx0zp3aq8sxvnfsf";
        }
        {
          name = "vscode-sort";
          publisher = "henriiik";
          version = "0.2.5";
          sha256 = "0sam2qfa596dcbabx3alrwsgm56a8wzb65dp45yv172kcaam5yd6";
        }
        {
          name = "slint";
          publisher = "Slint";
          version = "1.10.0";
          sha256 = "1c6bailn562zsh7wzx8jjj0y8mdzxj3sqgym5x5liw93b11kv3i3";
        }
        {
          name = "remote-explorer";
          publisher = "ms-vscode";
          version = "0.5.2025021709";
          sha256 = "02lnijwl92lq3rhv4f0kbp1bjfniipigih1myl5xmrwsp85n88xl";
        }
        {
          name = "ols";
          publisher = "DanielGavin";
          version = "0.1.34";
          sha256 = "0rl6mjkabgbwc0vnm96ax1jhjh5rrky0i1w40fhs1zqyfd83mrsx";
        }
        {
          name = "vscode-lowercase";
          publisher = "ruiquelhas";
          version = "1.0.1";
          sha256 = "03kwbnc25rfzsr7lzgkycwxnifv4nx04rfcvmfcqqhacx74g14gs";
        }
        {
          name = "vsliveshare"; # Live Share
          publisher = "MS-vsliveshare";
          version = "1.0.5948";
          sha256 = "0rhwjar2c6bih1c5w4w8gdgpc6f18669gzycag5w9s35bv6bvsr8";
        }
        {
          name = "inline-html-indent";
          publisher = "vulkd";
          version = "0.0.1";
          sha256 = "0mh7kpis821088g5qmzay76zrgvgbikl9v2jdjs3mdfkbh2rfl6s";
        }
        {
          name = "vuerd-vscode"; # ERD editor
          publisher = "dineug";
          version = "2.0.5";
          sha256 = "1agcayiz8p7n05x6wm817gdj3fwmxkdxbsf5alx4jbp1msi6qwwh";
        }
        {
          name = "chatgpt-copilot";
          publisher = "feiskyer";
          version = "4.8.4";
          sha256 = "0766vq07gjxgh4xpflzmrcx55i6b9w4hk5zg8yirvgfjscv5gvxv";
        }
        {
          name = "vscode-apl-language-client";
          publisher = "OptimaSystems";
          version = "0.0.9";
          sha256 = "050nn7f6gfzskq1yavqdw77rgl1lxs3p8dqkzrmmliqh5kqh2gr8";
        }
        {
          name = "vscode-apl-language";
          publisher = "OptimaSystems";
          version = "0.0.7";
          sha256 = "003n637vskbi4wypm8qwdy4fa9skp19w6kli1bgc162gzcbswhia";
        }
        {
          name = "vscode-autohotkey-plus-plus";
          publisher = "mark-wiemer";
          version = "6.7.0";
          sha256 = "10sf0qf0sqc5ifjf9vg2fyh7akz7swrilz6aifvyswzglglmca19";
        }
        {
          name = "i3";
          publisher = "dcasella";
          version = "1.0.0";
          sha256 = "0z7qj6bwch1cxr6pab2i3yqk5id8k14mjlvl6i9f0cmdsxqkmci5";
        }
      ];
    })

    # Shell scripts
    # give in format sha256-...=
    (pkgs.writeShellScriptBin "fix-nix-hash" ''
      nix hash convert --hash-algo sha256 --to nix32 $1
    '')
    (pkgs.writeShellScriptBin "RN" ''
      sudo nixos-rebuild switch --flake ~/nixos/#brians-laptop
    '')
    (pkgs.writeShellScriptBin "RH" ''
      home-manager switch --flake ~/nixos/#brian
    '')
    (pkgs.writeShellScriptBin "NR" ''
      sudo nixos-rebuild switch --flake ~/nixos/#brians-laptop
    '')
    (pkgs.writeShellScriptBin "HR" ''
      home-manager switch --flake ~/nixos/#brian
    '')
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
