{config, homeDir, lib, pkgs, agda-unimath}: {
  "${homeDir}/.config/user-dirs.dirs" = {
    enable = true;
    text = ''
      # Format is XDG_xxx_DIR="$HOME/yyy", where yyy is a shell-escaped
      # homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
      # absolute path. No other format is supported.
      XDG_DESKTOP_DIR="$HOME/dataByBadApps/Desktop"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_TEMPLATES_DIR="$HOME/dataByBadApps/Templates"
      XDG_PUBLICSHARE_DIR="$HOME/dataByBadApps/Public"
      XDG_DOCUMENTS_DIR="$HOME/dataByBadApps/Documents"
      XDG_MUSIC_DIR="$HOME/dataByBadApps/Music"
      XDG_PICTURES_DIR="$HOME/Pictures"
      XDG_VIDEOS_DIR="$HOME/dataByBadApps/Videos"
    '';
  };

  "${homeDir}/.config/niri/config.kdl".source = ./modules/niri-config.kdl; # Niri config

  "${homeDir}/.config/VSCodium/User/settings.json" = {
    enable = true;
    source = config.lib.file.mkOutOfStoreSymlink "/home/brian/proj/brian-nixos-config/configs/vscode.json";
  };

  "${homeDir}/.config/alacritty/alacritty.toml" = {
    enable = true;
    # onChange   # Shell commands to run when file has changed between generations. The script will be run *after* the new files have been linked into place. Note, this code is always run when `recursive` is enabled.   strings concatenated with "\n"
    # recursive  # If the file source is a directory, then this option determines whether the directory should be recursively linked to the target location. This option has no effect if the source is a file. If `false` (the default) then the target will be a symbolic link to the source directory. If `true` then the target will be a directory structure matching the source's but whose leafs are symbolic links to the files of the source directory.   boolean
    # source     # Path of the source file or directory. If .text is non-null then this option will automatically point to a file containing that text.   path
    text = lib.concatStringsSep "\n" [
      ''font.normal = { family = "BQN386 Unicode", style = "Regular" }'' # Requires bqn386 package
      ''window.decorations = "None"'' # No difference on i3. Disabled since probably less for alacrety to do
      ''scrolling.history = 100000'' # 100,000 is the absolute max according to docs
      ''colors.cursor = { text = "CellBackground", cursor = "#7d7d7d" }''
      "[general]"
      ''live_config_reload = true''
      ''ipc_socket = false'' # Disable using "alacritty msg" to tell alacritty to do stuff like "alacritty msg config" to update config
      "[colors.primary]" ''foreground = "#d8d8d8"'' ''background = "#000000"''
      ''dim_foreground = "None"'' # If this is set to None, the color is automatically calculated based on the foreground color. It isn't None by default
      ''bright_foreground = "None"'' # This color is only used when draw_bold_text_with_bright_colors is true. If this is not set, the normal foreground will be used. It is set by default, but to be consistent with dim_background I'll make an exception and not remove this
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

  "${homeDir}/.config/agda/libraries" = {
    enable = true;
    text = ''
      ${pkgs.agdaPackages.standard-library.outPath}/standard-library.agda-lib
      ${agda-unimath.outPath}/agda-unimath.agda-lib
    '';
  };
  "${homeDir}/.config/agda/defaults" = {
    enable = true;
    text = ''
      standard-library
      agda-unimath
    '';
  };
}
