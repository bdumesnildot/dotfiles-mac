-- Wezterm config
local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

-- Colors
config.color_scheme = 'Custom Dark'
config.color_schemes = {
  ['Custom Dark'] = {
    foreground = '#cccccc',
    background = '#252526',
    cursor_bg = '#72c890',
    cursor_fg = '#252526',
    cursor_border = '#72c890',
    selection_fg = '#d26dcf',
    selection_bg = '#252526',
    scrollbar_thumb = '#72c890',
    split = '#545455',
    ansi = {
      '#1e1e1e', '#ea0000', '#6a9955', '#fdd600',
      '#569cd6', '#d26dcf', '#9cdcfe', '#cccccc',
    },
    brights = {
      '#7a7a7a', '#ef5350', '#72c890', '#dbdbA9',
      '#4dbdfb', '#d26dcf', '#9cdcfe', '#fefefe',
    },
    compose_cursor = '#fdd600',
  },
}

config.colors = {
  tab_bar = {
    background = '#252526',
    active_tab = {
      bg_color = '#252526',
      fg_color = '#cccccc',
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = '#252526',
      fg_color = '#7a7a7a',
      intensity = 'Half',
    },
    inactive_tab_hover = {
      bg_color = '#1e1e1e',
      fg_color = '#7a7a7a',
      intensity = 'Bold',
    },
    new_tab = {
      bg_color = '#252526',
      fg_color = '#7a7a7a',
    },
    new_tab_hover = {
      bg_color = '#1e1e1e',
      fg_color = '#cccccc',
    },
  },
}

-- Font
config.font = wezterm.font('MesloLGS NF', {})
config.font_size = 13
config.line_height = 1.1

-- Animation
config.animation_fps = 120
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 800
config.cursor_thickness = 6

-- Window
config.window_background_opacity = 1.0
config.window_frame = {
  font_size = 16,
}
config.window_padding = {
  left = 50,
  right = 15,
  top = 40,
  bottom = 20,
}
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.tab_max_width = 200

-- Scrollbar
config.scrollback_lines = 3500
config.enable_scroll_bar = true

-- Confirmation prompt
config.window_close_confirmation = 'NeverPrompt'

-- Treat Alt issue
config.send_composed_key_when_right_alt_is_pressed = true
config.send_composed_key_when_left_alt_is_pressed = true

-- Command palette
config.command_palette_font_size = 16.0
config.command_palette_fg_color = "#cccccc"
config.command_palette_bg_color = "#333333"

-- Key Bindings
config.keys = {
  -- command palette
  {
    key = 'p',
    mods = 'CTRL',
    action = act.ActivateCommandPalette,
  },
  -- prompt edition
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendString('\x1bb'), -- ESC + b
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendString('\x1bf'), -- ESC + f
  },
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = act.SendString('\x01'), -- CTRL + A (line start)
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = act.SendString('\x05'), -- CTRL + E (line end)
  },
  -- copy mode
  { key = 'x', mods = 'CTRL', action = wezterm.action.ActivateCopyMode },
}

config.key_tables = {
  copy_mode = {
  },
}

-- Mouse Bindings
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.Nop,
  },
}

-- Behaviour
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config