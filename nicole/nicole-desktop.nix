# DEPRECATED: This configuration is no longer used for any active hosts.
# Preserved for reference. All Linux hosts now use nicole-headless.nix.
# For desktop systems in the future, import wm/sway.nix and linux/desktop-essentials.nix
# Linux home-manager configuration for nicole
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Cross-platform configuration

    ./nicole-headless.nix
    # Linux-specific window manager
    wm/sway.nix

    # Linux-specific packages
    linux/desktop-essentials.nix
    linux/gaming.nix
    linux/music.nix
    linux/misc.nix
  ];

  # Linux-specific packages
  home.packages = with pkgs; [
    nodejs_25
    nix-ld
    dconf
    mesa
    libdrm

    # Linux-specific CLI tools (from server-essentials)
    otel-desktop-viewer
    otel-cli
    imv
    libsixel
    pciutils
    parted
    exfat
    pavucontrol
    helvum
    xterm
    networkmanager
    nettools
    mkp224o

    # Linux-specific dev tools
    steam-run
    dbeaver-bin
  ];

  home.sessionVariables = {
    NIXPKGS_ALLOW_UNFREE = "1";
    SHELL = "${pkgs.fish}/bin/fish";
    GTK_THEME = "Arc-Dark";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    PNPM_HOME = "$HOME/.binaries/pnpm";
  };

  home = {
    username = "nicole";
    homeDirectory = "/home/nicole";
  };

  programs = {
    firefox.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
