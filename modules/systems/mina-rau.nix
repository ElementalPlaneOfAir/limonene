{ inputs, ... }: {
  flake.nixosConfigurations.mina-rau = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.self.modules.nixos.bradBase
      inputs.self.modules.nixos.gaming
      inputs.hardware.nixosModules.framework-amd-ai-300-series
      ../../hardware/mina-rau.nix
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.brad.imports = [
          inputs.self.modules.homeManager.bradDesktop
        ];
      }
      # mina-rau-specific configuration
      {
        networking.hostName = "mina-rau";

        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        i18n.defaultLocale = "en_US.UTF-8";
        i18n.extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };

        # KDE Plasma 6 desktop environment
        services.xserver.enable = true;
        services.displayManager.sddm.enable = true;
        services.displayManager.sddm.wayland.enable = true;
        services.desktopManager.plasma6.enable = true;

        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };

        services.displayManager.autoLogin = {
          enable = true;
          user = "brad";
        };

        system.stateVersion = "25.05";
      }
    ];
    specialArgs = { inherit inputs; };
  };
}
