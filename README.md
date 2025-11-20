# TODOs
Improve README.md so it explains what this repository is. It's obvious for most nix users, but this explanation would be for non-nix users.

Make a seperated pkgs var as an optimized version to select which pkgs should be optimized.
Also make it optimize to current CPU, which needs to somehow be defined via hardware. Might want to import hardware config, and have it define a cpu arch.
     localSystem = {
       gcc.arch = "skylake";
       gcc.tune = "skylake";
       system = "x86_64-linux";
     };

improve terminal ctrl+r.
remove punctuation after comments in home.nix.
fix dark mode for clock app (gnome in general, like cursor stuff, seems pretty broken).
Please fix the file navigator! And trash.
repeat. goal: make home manager define repeat scripts like undo last minute+cancel.
nixos run ./kiwix-serve wikipedia_en_computer_maxi_2024-05.zim  --port 2112.
on startup.
expose  `home-manager switch --flake .#brian --extra-experimental-features flakes --extra-experimental-features nix-command`.
check out nix-direnv, which automatically uses the flake.nix shell for the directory you cd into.
Use [someone's nvf config](https://github.com/Elias-Ainsworth/thornevim/tree/main) and implement your own nvf config.
watch [Home manager dotfiles tutorial](https://www.youtube.com/watch?v=FcC2dzecovw).
Pushing Flakes to Cachix.
https://docs.cachix.org/pushing#flakes.
To push all flake outputs automatically, use devour-flake.
Try [miri window manager](https://github.com/davatorium/rofi/tree/next?tab=readme-ov-file#features).
Try  CopyCat.
Fix nix-shell -p something.
share nix store across dualboot. Tried count: 1.
Try i3blocks https://github.com/vivien/i3blocks.
List of things to try after setting up [snowfall lib](https://snowfall.org/reference/lib/): https://snowfall.org/.
Read this keyboard info <https://www.youtube.com/watch?v=ZczZKHwWUFY&list=RD4fKt_IP1WHc&index=23>.
Alacreti [config example](https://github.com/REALERvolker1/homescripts/blob/main/.config/alacritty/alacritty.toml).
[screenshot util](https://wiki.archlinux.org/title/Screen_capture), last i checked was [maim](https://github.com/naelstrof/maim).
