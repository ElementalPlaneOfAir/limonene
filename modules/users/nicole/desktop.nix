{ inputs, ... }: {
  flake.modules.homeManager.nicoleDesktop = {
    imports = with inputs.self.modules.homeManager; [
      nicoleLinux
      sway
      wallust
      desktopApps
      gaming
      music
      vscode
    ];

    home.sessionVariables = {
      TERMINAL = "kitty";
    };

    programs.firefox.enable = true;
  };
}
