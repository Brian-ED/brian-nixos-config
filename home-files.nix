{homeDir, lib, pkgs}: {
  "${homeDir}/.config/VSCodium/User/settings.json" = {
    enable = true;
    text = ''
      {
          "files.autoSave": "afterDelay",
          "git.enableSmartCommit": true,
          "explorer.confirmDragAndDrop": false,
          "explorer.confirmDelete": false,
          "zig.zls.enabled": "on",
          "prettier.configPath": ".prettierrc",
          "[javascriptreact]": {
              "editor.defaultFormatter": "esbenp.prettier-vscode"
          },
          "javascript.updateImportsOnFileMove.enabled": "always",
          "git.autofetch": true,
          "files.autoSaveDelay": 200,
          "code-runner.executorMap": {
              "bqn": "bqn",
              "javascript": "node",
              "java": "cd $dir && javac $fileName && java $fileNameWithoutExt",
              "c": "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
              "zig": "zig run",
              "cpp": "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
              "objective-c": "cd $dir && gcc -framework Cocoa $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
              "php": "php",
              "python": "python -u",
              "perl": "perl",
              "perl6": "perl6",
              "ruby": "ruby",
              "go": "go run",
              "lua": "lua",
              "groovy": "groovy",
              "powershell": "powershell -ExecutionPolicy ByPass -File",
              "bat": "cmd /c",
              "shellscript": "bash",
              "fsharp": "fsi",
              "csharp": "scriptcs",
              "vbscript": "cscript //Nologo",
              "typescript": "ts-node",
              "coffeescript": "coffee",
              "scala": "scala",
              "swift": "swift",
              "julia": "julia",
              "crystal": "crystal",
              "ocaml": "ocaml",
              "r": "Rscript",
              "applescript": "osascript",
              "clojure": "lein exec",
              "haxe": "haxe --cwd $dirWithoutTrailingSlash --run $fileNameWithoutExt",
              "rust": "cd $dir && rustc $fileName && $dir$fileNameWithoutExt",
              "racket": "racket",
              "scheme": "csi -script",
              "ahk": "autohotkey",
              "autoit": "autoit3",
              "dart": "dart",
              "pascal": "cd $dir && fpc $fileName && $dir$fileNameWithoutExt",
              "d": "cd $dir && dmd $fileName && $dir$fileNameWithoutExt",
              "haskell": "runghc",
              "nim": "nim compile --verbosity:0 --hints:off --run",
              "lisp": "sbcl --script",
              "kit": "kitc --run",
              "v": "v run",
              "sass": "sass --style expanded",
              "scss": "scss --style expanded",
              "less": "cd $dir && lessc $fileName $fileNameWithoutExt.css",
              "FortranFreeForm": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
              "fortran-modern": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
              "fortran_fixed-form": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
              "fortran": "cd $dir && gfortran $fileName -o $fileNameWithoutExt && $dir$fileNameWithoutExt",
              "sml": "cd $dir && sml $fileName",
              "mojo": "mojo run",
              "erlang": "escript",
              "spwn": "spwn build",
              "pkl": "cd $dir && pkl eval -f yaml $fileName -o $fileNameWithoutExt.yaml",
              "gleam": "gleam run -m $fileNameWithoutExt"
          },
          "git.confirmSync": false,
          "tws.trimOnSave": false,
          "tws.highlightTrailingWhiteSpace": true,
          "diffEditor.ignoreTrimWhitespace": false,


          "nix.formatterPath": "nixfmt", // or "nixpkgs-fmt" or "alejandra" or "nix3-fmt" or pass full list of args such as  or `["treefmt", "--stdin", "{file}"]`

          "nix.enableLanguageServer": true,
          "nix.serverPath": "nil", // or "nixd"
          // LSP config can be passed via the ``nix.serverSettings.{lsp}`` as shown below.
          "nix.serverSettings": {

            // check https://github.com/oxalica/nil/blob/main/docs/configuration.md for all options available
            "nil": {
              // "diagnostics": {
              //  "ignored": ["unused_binding", "unused_with"],
              // },
              "formatting": {
                "command": ["nixfmt"],
              },
            },
            // check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
            "nixd": {
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
          "workbench.sideBar.location": "right",
          "zig.path": "zig",
          "agdaMode.connection.paths": [
            "/home/brian/.nix-profile/bin/agda"
          ],
          "editor.unicodeHighlight.allowedCharacters": {
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
          "git.openRepositoryInParentFolders": "never",
          "bqn.enableBackslashCompletion": false,
          "agdaMode.connection.commandLineOptions": "-l=/home/brian/proj/agda-lib",
          "agdaMode.libraryPath": "/home/brian/proj/agda-lib",
          "files.associations": {
            "*.apls": "apl",
            "*.hide": "apl"
          },
          "idris.idrisPath": "/nix/store/7mb2q6ciih9w1sk2yqyvqkfrwvi526wd-idris2-0.7.0/bin/idris2",
          "idris.idris2Mode": true,
          "hediet.vscode-drawio.resizeImages": null,
          "stripe.cliInstallPath": "${pkgs.stripe-cli.outPath}/bin/stripe"
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
      ${homeDir}/proj/agda-lib/agda-lib.agda-lib
    '';
  };
  "${homeDir}/.config/agda/defaults" = {
    enable = true;
    text = ''
      standard-library
    '';
  };
}
