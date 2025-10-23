# TODOs
Improve README.md so it explains what this repository is. It's obvious for most nix users, but this explanation would be for non-nix users.

Make a seperated pkgs var as an optimized version to select which pkgs should be optimized.
Also make it optimize to current CPU, which needs to somehow be defined via hardware. Might want to import hardware config, and have it define a cpu arch.
     localSystem = {
       gcc.arch = "skylake";
       gcc.tune = "skylake";
       system = "x86_64-linux";
     };
