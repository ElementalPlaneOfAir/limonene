{ ... }: {
  flake.modules.homeManager.desktopApps = { pkgs, ... }: {
    services.kdeconnect.enable = true;

    home.packages = with pkgs; [
      # Star shit
      stellarium

      # Acounting
      gnucash

      # Chess
      chessx
      chess-tui
      stockfish

      # ABSOLUTELY ESSENTIAL DO NOT DELETE
      duplicati
      # ----------
      # Experiments
      vlc
      mpv
      transmission_4-gtk
      zotero
      ungoogled-chromium
      tor-browser
      nicotine-plus
      vscodium-fhs
      nautilus
      # Audio
      easyeffects
      # Recording
      obs-studio
      audacity
      # Messaging
      signal-desktop
      slack
      zoom-us
      fractal # matrix client
      # Networking Stuff
      syncthing
      warp
      baobab # disk usage analyzer
      # Clipboard tools for Wine/Wayland integration
      wl-clipboard-x11 # provides xclip compatibility for Wine apps
      koreader # Another Ebook Reader, mostly for embedded
      gnome-font-viewer
      gnome-terminal
      gnome-text-editor
      gimp
      postman
    ];
  };
}
