{ ... }: {
  flake.modules.homeManager.misc = {
    services.kdeconnect.enable = true;
  };
}
