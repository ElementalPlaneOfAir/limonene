{ ... }: {
  flake.modules.homeManager.music = {
    programs.beets = {
      enable = true;
      settings = {
        "plugins" = "inline convert web embedart beetcamp discogs spotify";
        "convert" = {
          "copy_album_art" = "yes";
        };
      };
    };
  };
}
