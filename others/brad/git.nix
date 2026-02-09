{ ... }: {
  programs.git = {
    enable = true;
    lfs.enable = false; # Very scary
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
}
