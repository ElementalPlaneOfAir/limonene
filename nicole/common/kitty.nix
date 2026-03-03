{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell = "${pkgs.fish}/bin/fish";
      confirm_os_window_close = 0;
      font_family = "VictorMono Nerd Font";
      font_size = 22;
      background_opacity = "0.8";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty-socket";
    };
    keybindings = {
      "super+c" = "copy_to_clipboard";
      "super+v" = "paste_from_clipboard";
    };
    extraConfig = ''
      include /home/nicole/.cache/wallust/colors-kitty.conf
    '';
  };
}
