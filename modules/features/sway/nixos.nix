{ ... }: {
  flake.modules.nixos.sway = { pkgs, ... }: {
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    services.getty = {
      autologinUser = "nicole";
      autologinOnce = true;
    };

    environment.loginShellInit = ''
      [[ "$(tty)" == /dev/tty1 ]] && ${pkgs.sway}/bin/sway
    '';

    services.flatpak.enable = true;
  };
}
