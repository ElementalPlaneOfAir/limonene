{ inputs, ... }: {
  flake.modules.homeManager.nicoleLinux = { pkgs, config, ... }: {
    imports = [ inputs.self.modules.homeManager.nicoleCommon ];

    home.packages = with pkgs; [
      nodejs-slim
      nix-ld
      dconf
      mesa
      libdrm

      otel-desktop-viewer
      otel-cli
      imv
      libsixel
      pciutils
      parted
      exfat
      pavucontrol
      xterm
      networkmanager
      nettools
      mkp224o

      steam-run
      dbeaver-bin
    ];

    home.shellAliases = {
      nziina = ''eval "if set -q ZELLIJ; exit; else; eval (ssh-agent -c); /home/nicole/Documents/mycorrhizae/ziina/ziina -l 0.0.0.0:2222; end"'';
      ziina-sshget = ''set -x XDG_RUNTIME_DIR /run/user/1000 && set -x WAYLAND_DISPLAY wayland-1 && echo "ssh -p 2222 $ZELLIJ_SESSION_NAME@apiarist" | tee /dev/tty | wl-copy'';
    };

    home.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      SHELL = "${pkgs.fish}/bin/fish";
      GTK_THEME = "Arc-Dark";
      BROWSER = "firefox";
      PNPM_HOME = "$HOME/.binaries/pnpm";
    };

    home.sessionPath = [
      "$HOME/.binaries/pnpm"
    ];

    home = {
      username = "nicole";
      homeDirectory = "/home/nicole";
    };

    xdg = {
      systemDirs.data = [ "${pkgs.gsettings-desktop-schemas}/share" ];
      userDirs = {
        enable = true;
        createDirectories = true;
        music = "${config.home.homeDirectory}/Music";
        download = "${config.home.homeDirectory}/Downloads";
        documents = "${config.home.homeDirectory}/Documents";
        publicShare = "${config.home.homeDirectory}/Documents/public";
        templates = null;
      };
    };

    systemd.user.startServices = "sd-switch";

    home.stateVersion = "25.05";
  };
}
