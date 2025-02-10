{ config, pkgs, ... }:

{
  home.username = "brian";
  home.homeDirectory = "/home/brian";
  home.stateVersion = "24.11"; # You should not change this value, even if you update Home Manager

  # Install Nix packages
  home.packages = with pkgs; [
    vim       # Code editor for when I get bored of vscodium, or when sudo-privilages is required. TODO: replace with nix-nvim
    rhythmbox # For playing music. TODO: Automatically find songs from windows drive like Linux Mint
    sops      # Encrypted secrets viewer and editor. TODO: Is it supposed to replace KeePassXC?
    keepassxc # Password manager. TODO: Needs to be configured
    cbqn   # BQN programming language
    baobab # Drive space tree-like view
    restic # Backup the borgBackup folder at drive/backup-brian-Lenovo-Yoga-C940-14IIL-LinuxMintCinamon
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix  # Nix extension
        ms-python.python # Python extension
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
        {
          name = "bqn";
          publisher = "mk12";
          version = "0.1.7";
          sha256 = "18arx9nrqwlpx7b5qq9w83p4cbicz6d40x3447g300gqapfhlb3j";
        }
      ];
    })


    # You can also create simple shell scripts directly inside your
    # configuration. For example, this adds a command 'my-hello' to your
    # environment:
    (pkgs.writeShellScriptBin "my-hello" ''
      echo "Hello, ${config.home.username}!"
    '')

    (pkgs.writeShellScriptBin "fix-nix-hash" ''
      nix hash convert --hash-algo sha256 --to nix32 $1
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
  programs.git = {
    enable = true;
    userName = "Brian-ED";
    userEmail = "brianellingsgaard9@gmail.com";
  };
}
