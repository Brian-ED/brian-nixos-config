{ config, pkgs, ... }:

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
    rhythmbox # For playing music. TODO: Automatically find songs from windows drive like Linux Mint
    sops      # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
    keepassxc # Password manager. TODO: Needs to be configured
    cbqn   # BQN programming language
    baobab # Drive space tree-like view
    restic # Backup the borgBackup folder at drive/backup-brian-Lenovo-Yoga-C940-14IIL-LinuxMintCinamon
    obsidian # Unfree package. Can only use for non-profit.
    python314 # python 3.14
    xorg.xkbcomp # Temporary for messing with my keyboard settings
    nodejs_23
    pgadmin4
    elixir # I want to try out elixer to develop concurrent applications
    gh # github commands
    libllvm # Playing around with llvm IR

    #warpinator # I never used warpinator
    zig zls # Zig stuff
    rustc cargo # Rust stuff
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
       bbenoist.nix  # Nix extension
        ms-python.python # Python extension
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "bqn";
          publisher = "mk12";
          version = "0.1.7";
          sha256 = "18arx9nrqwlpx7b5qq9w83p4cbicz6d40x3447g300gqapfhlb3j";
        }
        {
          name = "vscode-zig";
          publisher = "ziglang";
          version = "0.6.8";
          sha256 = "0lqw9pybd64fds473vl2m3r55qfmrmh3hk46rwlwgvgqhgcmv1dv";
        }
        {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "11.0.0";
          sha256 = "1fcz8f4jgnf24kblf8m8nwgzd5pxs2gmrv235cpdgmqz38kf9n54";
        }
        {
          name = "code-runner";
          publisher = "formulahendry";
          version = "0.12.2";
          sha256 = "0i5i0fpnf90pfjrw86cqbgsy4b7vb6bqcw9y2wh9qz6hgpm4m3jc";
        }
        {
          name = "newline";
          publisher = "chang196700";
          version = "0.0.4";
          sha256 = "0xijg1nqlrlwkl4ls21hzikr30iz8fd98ynpbmhhdxrkm3iccqa1";
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
