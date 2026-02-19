{pkgs, ...}: {
  services.displayManager.defaultSession = "niri";
  environment.systemPackages = with pkgs; [ # These are duplicates from home, TODO: Simplify the shared pkgs list
    alacritty fuzzel swaylock mako swayidle
  ];
  programs.niri.enable = true;

  security.polkit.enable = true; # polkit
  security.pam.services.swaylock = {};

  services.gnome.gnome-keyring.enable = true; # secret service

  programs.waybar.enable = true; # top bar

}
