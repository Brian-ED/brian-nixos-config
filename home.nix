{ config, pkgs, ... }:

{
  home.username = "brian";
  home.homeDirectory = "/home/brian";
  home.stateVersion = "24.11"; # You should not change this value, even if you update Home Manager
  home.keyboard = null;

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
      ];
    })

    # Shell scripts
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

  # git
  programs.git = {
    enable = true;
    userName = "Brian-ED";
    userEmail = "brianellingsgaard9@gmail.com";
  };
}
