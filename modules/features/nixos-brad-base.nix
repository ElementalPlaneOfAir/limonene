{ ... }: {
  flake.modules.nixos.bradBase = { pkgs, ... }: let
    RStudio-with-my-packages = pkgs.rstudioWrapper.override {
      packages = with pkgs.rPackages; [ ggplot2 rix stringr readxl ];
    };
  in {
    # Brad's system gets flatpak (nicole's machines get this via nixos.sway instead)
    services.flatpak.enable = true;

    # Brad-specific system packages not in nixos.base
    environment.systemPackages = [
      RStudio-with-my-packages
      pkgs.nettools
    ];
  };
}
