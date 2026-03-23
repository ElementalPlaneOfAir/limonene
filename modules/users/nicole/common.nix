{ inputs, ... }: {
  flake.modules.homeManager.nicoleCommon = {
    imports = with inputs.self.modules.homeManager; [
      shells
      cliTools
      languages
      kitty
      fonts
      neovim
      opencode
    ];

    programs.git = {
      enable = true;
      lfs.enable = false;
      settings = {
        user = {
          name = "Nicole Venner";
          email = "nvenner@protonmail.ch";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    home.sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
      "$HOME/go/bin"
    ];

    programs.home-manager.enable = true;
  };
}
