{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  random-wallpaper = pkgs.writeShellScriptBin "random-wallpaper" ''
    dir="$HOME/Pictures/wallpapers"
    wallpaper=$(ls "$dir"/*.{jpg,jpeg,png,gif,webp} 2>/dev/null | shuf -n 1)
    if [ -z "$wallpaper" ]; then
      echo "No wallpapers found in $dir"
      exit 1
    fi
    switch-wallpaper "$wallpaper"
  '';

  switch-wallpaper = pkgs.writeShellScriptBin "switch-wallpaper" ''
    wallpaper="$1"
    if [ -z "$wallpaper" ]; then
      echo "Usage: switch-wallpaper <path-to-image>"
      exit 1
    fi

    # Generate color scheme and render templates
    ${pkgs.wallust}/bin/wallust run "$wallpaper"

    # Swap wallpaper
    pkill swaybg || true
    ${pkgs.swaybg}/bin/swaybg -i "$wallpaper" -m fill &

    # Reload waybar CSS
    pkill -SIGUSR2 waybar || true

    # Hot-reload kitty colors in the current kitty instance.
    # $KITTY_LISTEN_ON is set automatically by kitty in every window when
    # allow_remote_control is enabled — no hardcoded socket path needed.
    if [ -n "$KITTY_LISTEN_ON" ]; then
      kitty @ --to "$KITTY_LISTEN_ON" set-colors --all \
        ~/.cache/wallust/colors-kitty.conf || true
    fi

    # wallust writes OSC sequences to the terminal asynchronously, so they can
    # land after the set-colors above and overwrite the background. Force it
    # back to black as the last thing the script does.
    printf '\033]11;#000000\007'
  '';
in {
  home.packages = [
    pkgs.wallust
    switch-wallpaper
    random-wallpaper
  ];

  xdg.configFile."wallust/wallust.toml".text = ''
    palette = "harddark16"
    check_contrast = true

    [templates]
    waybar.template = "waybar-colors.css"
    waybar.target = "~/.cache/wallust/waybar-colors.css"
    waybar.pywal = true

    kitty.template = "colors-kitty.conf"
    kitty.target = "~/.cache/wallust/colors-kitty.conf"
    kitty.pywal = true

    neovim.template = "colors-neovim.lua"
    neovim.target = "~/.cache/wallust/colors-neovim.lua"
    neovim.pywal = true

    neopywal.template = "colors_neopywal.vim"
    neopywal.target = "~/.cache/wallust/colors_neopywal.vim"
    neopywal.pywal = true
  '';

  # waybar color template — maps wallust palette vars to the semantic CSS vars
  # that style.css uses (bg, fg, color0..color15, etc.)
  xdg.configFile."wallust/templates/waybar-colors.css".text = ''
    @define-color bg {background};
    @define-color contrast {color0};
    @define-color lighter {color8};
    @define-color fg {foreground};
    @define-color cursorline {color1};
    @define-color comments {color8};
    @define-color cursor {color7};
    @define-color color0 {color0};
    @define-color color1 {color1};
    @define-color color2 {color2};
    @define-color color3 {color3};
    @define-color color4 {color4};
    @define-color color5 {color5};
    @define-color color6 {color6};
    @define-color color7 {color7};
    @define-color color8 {color8};
    @define-color color9 {color9};
    @define-color color10 {color10};
    @define-color color11 {color11};
    @define-color color12 {color12};
    @define-color color13 {color13};
    @define-color color14 {color14};
    @define-color color15 {color15};
  '';

  # neopywal.nvim template — full vim colorscheme palette used by neopywal to
  # theme the editor UI, syntax highlighting, and terminal colors.
  xdg.configFile."wallust/templates/colors_neopywal.vim".text = ''
    let background = "{background}"
    let foreground = "{foreground}"
    let cursor     = "{foreground}"
    let color0  = "{color0}"
    let color1  = "{color1}"
    let color2  = "{color2}"
    let color3  = "{color3}"
    let color4  = "{color4}"
    let color5  = "{color5}"
    let color6  = "{color6}"
    let color7  = "{color7}"
    let color8  = "{color8}"
    let color9  = "{color9}"
    let color10 = "{color10}"
    let color11 = "{color11}"
    let color12 = "{color12}"
    let color13 = "{color13}"
    let color14 = "{color14}"
    let color15 = "{color15}"
  '';

  # neovim terminal color template — sets terminal_color_0..15 so :terminal windows
  # and colored output match the wallpaper palette.
  xdg.configFile."wallust/templates/colors-neovim.lua".text = ''
    vim.g.terminal_color_0  = "{color0}"
    vim.g.terminal_color_1  = "{color1}"
    vim.g.terminal_color_2  = "{color2}"
    vim.g.terminal_color_3  = "{color3}"
    vim.g.terminal_color_4  = "{color4}"
    vim.g.terminal_color_5  = "{color5}"
    vim.g.terminal_color_6  = "{color6}"
    vim.g.terminal_color_7  = "{color7}"
    vim.g.terminal_color_8  = "{color8}"
    vim.g.terminal_color_9  = "{color9}"
    vim.g.terminal_color_10 = "{color10}"
    vim.g.terminal_color_11 = "{color11}"
    vim.g.terminal_color_12 = "{color12}"
    vim.g.terminal_color_13 = "{color13}"
    vim.g.terminal_color_14 = "{color14}"
    vim.g.terminal_color_15 = "{color15}"
  '';

  # kitty color template — background is fixed dark so transparency always looks good;
  # kitty's background_opacity bleeds the wallpaper through the dark base.
  xdg.configFile."wallust/templates/colors-kitty.conf".text = ''
    foreground {foreground}
    background #000000
    cursor      {color6}
    color0  {color0}
    color1  {color1}
    color2  {color2}
    color3  {color3}
    color4  {color4}
    color5  {color5}
    color6  {color6}
    color7  {color7}
    color8  {color8}
    color9  {color9}
    color10 {color10}
    color11 {color11}
    color12 {color12}
    color13 {color13}
    color14 {color14}
    color15 {color15}
  '';
}
