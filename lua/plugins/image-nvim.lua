require("image").setup {
  backend = "kitty",
  tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  max_width = 100, -- tweak to preference
  max_height = 12, -- ^
  max_height_window_percentage = math.huge, -- this is necessary for a good experience
  max_width_window_percentage = math.huge,
  window_overlap_clear_enabled = true,
  window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
}
