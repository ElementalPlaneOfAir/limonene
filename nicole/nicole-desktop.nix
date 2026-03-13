# Desktop-specific home-manager additions for nicole.
# Imported by desktop systems alongside nicole-headless.nix (which baseNixOSModules provides).
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./wm/sway.nix
    ./wm/wallust.nix
    ./linux/desktop-essentials.nix
    ./linux/gaming.nix
    ./linux/music.nix
    ./linux/misc.nix
  ];

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  programs.firefox.enable = true;
}
