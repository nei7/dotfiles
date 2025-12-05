{
  config,
  inputs,
  pkgs,
  ...
}:
{
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      window_padding_width = 10;
      background = "#141313";
      foreground = "#e6e1e1";
      selection_background = "#cbc4cb";
      selection_foreground = "#322f34";
      cursor = "#cbc4cb";
      cursor_text_color = "#322f34";
      url_color = "#cac5c8";
      active_border_color = "#cbc4cb";
      inactive_border_color = "#948f94";
      bell_border_color = "#ffb4ab";
      tab_bar_background = "#0f0e0e";
      active_tab_foreground = "#e6e1e1";
      active_tab_background = "#141313";
      inactive_tab_foreground = "#948f94";
      inactive_tab_background = "#1c1b1c";

      color0 = "#EDE4E4";
      color1 = "#B52755";
      color2 = "#A97363";
      color3 = "#AF535D";
      color4 = "#A67F7C";
      color5 = "#B2416B";
      color6 = "#8D76AD";
      color9 = "#B52755";
      color10 = "#A97363";
      color11 = "#AF535D";
      color12 = "#A67F7C";
      color13 = "#B2416B";
      color14 = "#8D76AD";
    };
  };
}
