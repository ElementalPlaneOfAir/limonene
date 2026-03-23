{ inputs, ... }: {
  flake.modules.homeManager.bradCommon = {
    imports = with inputs.self.modules.homeManager; [
      shells
      cliTools
      languages
      kitty
      fonts
      neovim
    ];

    programs.git = {
      enable = true;
      lfs.enable = false;
      settings = {
        user = {
          name = "bvenner";
          email = "bvenner@proton.me";
        };
        github = {
          user = "bvenner";
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
