{ inputs, ... }: {
  flake.modules.homeManager.nicoleDarwin = { pkgs, ... }: {
    imports = [ inputs.self.modules.homeManager.nicoleCommon ];

    home.sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      PNPM_HOME = "$HOME/.binaries/pnpm";
      SHELL = "${pkgs.fish}/bin/fish";
    };

    home.sessionPath = [
      "$HOME/.binaries/pnpm"
    ];

    programs.fish = {
      shellInit = ''
        fish_add_path /run/current-system/sw/bin
        fish_add_path /nix/var/nix/profiles/default/bin
      '';
    };

    home = {
      username = "nicole";
      homeDirectory = "/Users/nicole";
    };

    home.stateVersion = "25.05";
  };
}
