{ inputs, ... }: {
  flake.darwinConfigurations.cheddar = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      inputs.self.modules.darwin.darwinWm
      ({ pkgs, ... }: {
        nixpkgs.overlays = [
          inputs.rust-overlay.overlays.default
        ];

        nix.enable = false;

        environment.systemPackages = [
          pkgs.pkg-config
          pkgs.openssl
        ];

        environment.shellAliases = {
          nrs = "sudo darwin-rebuild switch --flake /Users/nicole/limonene#cheddar";
        };

        nixpkgs.config.allowUnfree = true;

        users.users.nicole = {
          name = "nicole";
          home = "/Users/nicole";
        };

        system.primaryUser = "nicole";

        nix.settings = {
          extra-substituters = [
            "https://devenv.cachix.org"
          ];
          extra-trusted-public-keys = [
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          ];
        };

        system.stateVersion = 5;
      })
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useUserPackages = true;
        home-manager.useGlobalPkgs = true;
        home-manager.users.nicole.imports = [
          inputs.self.modules.homeManager.nicoleDarwin
        ];
      }
    ];
    specialArgs = { inherit inputs; };
  };
}
