{homeDir, lib, pkgs}: {
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
  "${homeDir}/.config/VSCodium/User/settings.json" = {
    enable = true;
    text = ''
      {
        "agdaMode.connection.downloadPolicy": "No, and don't ask again",
        "agdaMode.connection.paths": [
          "/home/brian/.nix-profile/bin/agda"
        ],
        "git.rebaseWhenSync": true,
        "lean4.alwaysAskBeforeInstallingLeanVersions": true,
        "java.compile.nullAnalysis.mode": "automatic",
        "redhat.telemetry.enabled": false, // This is mainly for P3 (Uni project) with vaadin to do java web development
        "bqn.enableBackslashCompletion": false,
        "code-runner.saveFileBeforeRun": true,
        "diffEditor.experimental.showMoves": true,
        "diffEditor.ignoreTrimWhitespace": false,
        "editor.fontLigatures": false, // "editor.inlayHints.enabled": "off",
        "editor.maxTokenizationLineLength": 100000,
        "editor.minimap.enabled": false,
        "editor.tabSize": 2,
        "explorer.confirmDelete": false,
        "explorer.confirmDragAndDrop": false,
        "files.autoSave": "afterDelay",
        "files.eol": "\n",
        "files.insertFinalNewline": true,
        "files.trimFinalNewlines": true,
        "git.enableSmartCommit": true,
        "git.openRepositoryInParentFolders": "never",
        "githubPullRequests.createOnPublishBranch": "never",
        "hediet.vscode-drawio.appearance": "dark",
        "hediet.vscode-drawio.resizeImages": null,
        "hediet.vscode-drawio.theme": "min",
        "idris.idris2Mode": true,
        "idris.idrisPath": "/nix/store/7mb2q6ciih9w1sk2yqyvqkfrwvi526wd-idris2-0.7.0/bin/idris2",
        "python.createEnvironment.trigger": "off",
        "stripe.cliInstallPath": "${pkgs.stripe-cli.outPath}/bin/stripe",
        "terminal.integrated.enableMultiLinePasteWarning": "never",
        "terminal.integrated.fontSize": 10,
        "update.showReleaseNotes": false,
        "window.zoomLevel": 2,
        "workbench.layoutControl.enabled": false,
        "workbench.navigationControl.enabled": false,
        "workbench.panel.showLabels": false,
        "zig.buildFilePath": "''${workspace}/build.zig",
        "zig.path": "${pkgs.zig.outPath}",
        "zig.zigPath": "${pkgs.zig.outPath}/bin/zig",
        "zig.zls.buildRunnerPath": "${pkgs.zig.outPath}/lib/zig/compilers/build_runner.zig",
        "zig.zls.enabled": "on",
        "zig.zls.path": "${pkgs.zls.outPath}/bin/zls",
        "files.exclude": {
            "**/.git": true,
        },
        "files.autoSaveDelay": 200,
        "files.associations": {
          "*.apls": "apl",
          "*.hide": "apl"
        },
        "editor.lineHeight": 1.3,
        "prettier.configPath": ".prettierrc",
        "[javascriptreact]": {
            "editor.defaultFormatter": "esbenp.prettier-vscode"
        },
        "python.analysis.autoImportCompletions": true,
        "javascript.updateImportsOnFileMove.enabled": "always",
        "git.autofetch": true,
        "code-runner.runInTerminal": true,
        "code-runner.respectShebang": false,
        "git.confirmSync": false,
        "tws.trimOnSave": false,
        "tws.highlightTrailingWhiteSpace": true,
        "nix.formatterPath": "nixfmt", // or "nixpkgs-fmt" or "alejandra" or "nix3-fmt" or pass full list of args such as  or `["treefmt", "--stdin", "{file}"]`
        "nix.enableLanguageServer": true,
        "nix.serverPath": "nil", // or "nixd"
        "workbench.sideBar.location": "right",

        "code-runner.executorMap": {
          "ahk": "autohotkey",
          "apl":"cd $dir && dyalogscript $fileName",
          "apln":"cd $dir && dyalogscript $fileName",
          "apls":"cd $dir && dyalogscript $fileName",
          "applescript": "osascript",
          "autoit": "autoit3",
          "bat": "cmd /c",
          "bqn": "bqn",
          "c": "cd $dir && cc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
          "clojure": "lein exec",
          "coffeescript": "coffee",
          "cpp": "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
          "crystal": "crystal",
          "csharp": "scriptcs",
          "d": "cd $dir && dmd $fileName && $dir$fileNameWithoutExt",
          "dart": "dart",
          "dyalog":"cd $dir && dyalogscript $fileName",
          "erlang": "escript",
          "fortran_fixed-form": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
          "fortran-modern": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
          "fortran": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
          "FortranFreeForm": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
          "fsharp": "fsi",
          "gleam": "gleam run -m $fileNameWithoutExt",
          "go": "go run",
          "groovy": "groovy",
          "haskell": "runghc",
          "haxe": "haxe --cwd $dirWithoutTrailingSlash --run $fileNameWithoutExt",
          "html": "firefox",
          "java": "cd $dir && javac $fileName && java $fileNameWithoutExt",
          "javascript": "cd $dir && node $fileName",
          "julia": "julia",
          "kit": "kitc --run",
          "less": "cd $dir && lessc $fileName $fileNameWithoutExt.css",
          "lisp": "sbcl --script",
          "lua": "lua",
          "mojo": "mojo run",
          "nim": "nim compile --verbosity:0 --hints:off --run",
          "objective-c": "cd $dir && gcc -framework Cocoa $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
          "ocaml": "ocaml",
          "odin":"odin run $dir",
          "pascal": "cd $dir && fpc $fileName && $dir$fileNameWithoutExt",
          "perl": "perl",
          "perl6": "perl6",
          "php": "php",
          "pkl": "cd $dir && pkl eval -f yaml $fileName -o $fileNameWithoutExt.yaml",
          "powershell": "powershell -ExecutionPolicy ByPass -File",
          "python": "cd $dir && python3 -u $fileName",
          "r": "Rscript",
          "racket": "racket",
          "ruby": "ruby",
          "rust": "cd $dir && cargo run", // "rust": "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
          "sass": "sass --style expanded",
          "scala": "scala",
          "scheme": "csi -script",
          "scss": "scss --style expanded",
          "shellscript": "bash",
          "singeli":"cd $dir && ~/Singeli/singeli -p \"\" $fileName",
          "sml": "cd $dir && sml $fileName",
          "spwn": "spwn build",
          "swift": "swift",
          "typescript": "ts-node",
          "v": "v run",
          "vbscript": "cscript //Nologo",
          "zig": "zig run",
        },
        "nix.serverSettings": { // LSP config can be passed via the ``nix.serverSettings.{lsp}`` as shown below.
          "nil": { // check https://github.com/oxalica/nil/blob/main/docs/configuration.md for all options available
            // "diagnostics": {
            //  "ignored": ["unused_binding", "unused_with"],
            // },
            "formatting": {
              "command": ["nixfmt"],
            },
          },
          "nixd": { // check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
            "formatting": {
              "command": ["nixfmt"],
            },
            "options": {
              // By default, this entry will be read from `import <nixpkgs> { }`.
              // You can write arbitrary Nix expressions here, to produce valid "options" declaration result.
              // Tip: for flake-based configuration, utilize `builtins.getFlake`
              "nixos": {
                "expr": "(builtins.getFlake \"/absolute/path/to/flake\").nixosConfigurations.<name>.options",
              },
              "home-manager": {
                "expr": "(builtins.getFlake \"/absolute/path/to/flake\").homeConfigurations.<name>.options",
              },
              // Tip: use ''${workspaceFolder} variable to define path
              "nix-darwin": {
                "expr": "(builtins.getFlake \"''${workspaceFolder}/path/to/flake\").darwinConfigurations.<name>.options",
              },
            },
          }
        },
        "editor.unicodeHighlight.allowedCharacters": {
          "α": true,
          "ℕ": true,
          " ": false,
          "∨": true,
          "′": true,
          "ℓ": true,
          "⊤": true,
          "×": true,
          "∣": true,
          "γ": true,
          "ℤ": true,
          "⍳": true,
          "⍴": true,
          "𝕨": true,
          "𝕩": true,
          "𝕎": true,
          "𝕏": true,
          "⍺": true,
          "˜": true,
          "´": true,
          "∪": true
        },
        "[bqn]": {
          "editor.fontFamily": "'BQN386 Unicode', 'monospace', monospace"
        },
      }
    '';
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
    '';
  };
  "${homeDir}/.config/agda/defaults" = {
    enable = true;
    text = ''
      standard-library
    '';
  };
}
