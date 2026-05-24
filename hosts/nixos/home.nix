{ config, pkgs, ... }:

{
  home.username      = "m";
  home.homeDirectory = "/home/m";

  # ================================================================ #
  # WEZTERM                                                           #
  # ================================================================ #
  programs.wezterm = {
    enable      = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      local act     = wezterm.action
      local config  = wezterm.config_builder()

      -- ------------------------------------------------------------ --
      -- TEMEL AYARLAR                                                  --
      -- ------------------------------------------------------------ --
      config.default_prog               = { 'fish' }
      config.automatically_reload_config = true
      config.scrollback_lines           = 10000
      config.enable_scroll_bar          = false
      config.check_for_updates          = false

      -- ------------------------------------------------------------ --
      -- GÖRÜNÜM                                                        --
      -- ------------------------------------------------------------ --
      config.window_background_opacity  = 0.85
      config.text_background_opacity    = 1.0
      config.window_decorations         = "NONE"
      config.window_padding             = { left = 15, right = 15, top = 15, bottom = 15 }
      config.font                       = wezterm.font('JetBrainsMono Nerd Font')
      config.font_size                  = 13.0
      config.line_height                = 1.1
      config.cell_width                 = 1.0
      config.cursor_blink_rate          = 500
      config.default_cursor_style       = 'BlinkingBlock'

      -- ------------------------------------------------------------ --
      -- RENKLER                                                        --
      -- ------------------------------------------------------------ --
      config.colors = {
        foreground    = '#cc0000',
        background    = '#000000',
        cursor_bg     = '#ff0000',
        cursor_border = '#ff0000',
        cursor_fg     = '#000000',
        selection_bg  = '#ff0000',
        selection_fg  = '#000000',
        ansi    = { '#21222c', '#ff5555', '#50fa7b', '#f1fa8c', '#bd93f9', '#ff79c6', '#8be9fd', '#f8f8f2' },
        brights = { '#6272a4', '#ff6e6e', '#69ff94', '#ffffa5', '#d6acff', '#ff92df', '#a4ffff', '#ffffff' },
        tab_bar = {
          background        = '#000000',
          active_tab        = { bg_color = '#000000', fg_color = '#ff0000', intensity = 'Bold' },
          inactive_tab      = { bg_color = '#000000', fg_color = '#660000' },
          inactive_tab_hover = { bg_color = '#111111', fg_color = '#990000' },
          new_tab           = { bg_color = '#000000', fg_color = '#990000' },
          new_tab_hover     = { bg_color = '#111111', fg_color = '#ff0000' },
        },
      }

      -- ------------------------------------------------------------ --
      -- TAB BAR                                                        --
      -- ------------------------------------------------------------ --
      config.use_fancy_tab_bar            = false
      config.hide_tab_bar_if_only_one_tab = false
      config.tab_bar_at_bottom            = false
      config.tab_max_width                = 32
      config.selection_word_boundary      = " \t\n{}[]()\"'`"

      -- ------------------------------------------------------------ --
      -- HİPERLİNK (URL tıklanabilir)                                  --
      -- ------------------------------------------------------------ --
      config.hyperlink_rules = wezterm.default_hyperlink_rules()

      -- ------------------------------------------------------------ --
      -- LEADER TUŞU (Ctrl+A) — panel/bölme işlemleri için             --
      -- ------------------------------------------------------------ --
      config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

      -- ------------------------------------------------------------ --
      -- TUŞLAR                                                         --
      -- ------------------------------------------------------------ --
      config.keys = {

        -- Kopyala / Yapıştır
        { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'ClipboardAndPrimarySelection' },
        { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

        -- Sekme yönetimi
        { key = 't',          mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'w',          mods = 'CTRL|SHIFT', action = act.CloseCurrentTab { confirm = true } },
        { key = 'Tab',        mods = 'CTRL',        action = act.ActivateTabRelative(1) },
        { key = 'Tab',        mods = 'CTRL|SHIFT',  action = act.ActivateTabRelative(-1) },
        { key = '1',          mods = 'CTRL|SHIFT',  action = act.ActivateTab(0) },
        { key = '2',          mods = 'CTRL|SHIFT',  action = act.ActivateTab(1) },
        { key = '3',          mods = 'CTRL|SHIFT',  action = act.ActivateTab(2) },
        { key = '4',          mods = 'CTRL|SHIFT',  action = act.ActivateTab(3) },
        { key = '5',          mods = 'CTRL|SHIFT',  action = act.ActivateTab(4) },
        { key = 'LeftArrow',  mods = 'CTRL|SHIFT',  action = act.MoveTabRelative(-1) },
        { key = 'RightArrow', mods = 'CTRL|SHIFT',  action = act.MoveTabRelative(1) },

        -- Panel bölme (LEADER + tuş)
        { key = '-', mods = 'LEADER', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },
        { key = '|', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

        -- Panel arası geçiş (LEADER + yön)
        { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
        { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
        { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
        { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },

        -- Panel boyutlandırma (LEADER + büyük harf)
        { key = 'H', mods = 'LEADER', action = act.AdjustPaneSize { 'Left',  5 } },
        { key = 'L', mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
        { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up',    5 } },
        { key = 'J', mods = 'LEADER', action = act.AdjustPaneSize { 'Down',  5 } },

        -- Panel kapat / zoom
        { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
        { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

        -- Font boyutu
        { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize },

        -- Arama
        { key = 'f', mods = 'CTRL|SHIFT', action = act.Search { CaseInSensitiveString = '' } },

        -- Copy mode (klavye ile seçim)
        { key = 'x', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },

        -- Komut paleti
        { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },

        -- Tab navigator (fuzzy)
        { key = 'e', mods = 'CTRL|SHIFT', action = act.ShowTabNavigator },

        -- Tam ekran
        { key = 'F11', mods = '', action = act.ToggleFullScreen },

        -- Scroll
        { key = 'PageUp',   mods = 'SHIFT', action = act.ScrollByPage(-1) },
        { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
        { key = 'Home',     mods = 'SHIFT', action = act.ScrollToTop },
        { key = 'End',      mods = 'SHIFT', action = act.ScrollToBottom },

        -- Yeni pencere
        { key = 'n', mods = 'CTRL|SHIFT', action = act.SpawnWindow },

        -- Debug overlay
        { key = 'l', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
      }

      -- ------------------------------------------------------------ --
      -- FARE                                                           --
      -- ------------------------------------------------------------ --
      config.mouse_bindings = {
        -- Ctrl + sol tık → URL aç
        {
          event   = { Up = { streak = 1, button = 'Left' } },
          mods    = 'CTRL',
          action  = act.OpenLinkAtMouseCursor,
        },
        -- Sağ tık → yapıştır
        {
          event  = { Down = { streak = 1, button = 'Right' } },
          mods   = 'NONE',
          action = act.PasteFrom 'Clipboard',
        },
      }

      return config
    '';
  };


  # ================================================================ #
  # FISH SHELL                                                        #
  # ================================================================ #
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_color_normal         f8f8f2
      set -g fish_color_command        ff5555 --bold
      set -g fish_color_param          f8f8f2
      set -g fish_color_keyword        ff79c6
      set -g fish_color_quote          f1fa8c
      set -g fish_color_error          ff0000 --bold
      set -g fish_color_comment        6272a4
      set -g fish_color_autosuggestion 6272a4
      set -U fish_greeting ""

      fastfetch --logo ~/.config/fastfetch/nixos-ascii.txt --color-keys red --color-title white
    '';
  };


  # ================================================================ #
  # STARSHIP                                                          #
  # ================================================================ #
  programs.starship = {
    enable                = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
      format      = "$username$hostname$directory$character";

      username = {
        format      = "[$user]($style)@";
        style_user  = "bold white";
        style_root  = "bold red";
        show_always = true;
      };

      hostname = {
        format   = "[$hostname]($style):";
        style    = "bold white";
        ssh_only = false;
      };

      directory = {
        format            = "[$path]($style) ";
        style             = "bold white";
        truncation_length = 3;
        truncate_to_repo  = false;
      };

      character = {
        success_symbol = "[\\$](bold white)";
        error_symbol   = "[\\$](bold red)";
      };
    };
  };


  programs.home-manager.enable = true;
  home.stateVersion            = "25.11";
}
