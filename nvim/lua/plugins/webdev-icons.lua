return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = {
    -- Custom icons for shell files
    override = {
      fish = {
        icon = "",
        color = "#4d9375",
        cterm_color = "65",
        name = "Fish",
      },
      zsh = {
        icon = "",
        color = "#428850",
        cterm_color = "65",
        name = "Zsh",
      },
    },
    -- globally enable different highlight colors per icon
    color_icons = true,
    -- globally enable default icons
    default = true,
    -- globally enable "strict" selection of icons
    strict = true,
    -- overrides by filename
    override_by_filename = {
      [".gitignore"] = {
        icon = "",
        color = "#f1502f",
        name = "Gitignore",
      },
      ["config.fish"] = {
        icon = "",
        color = "#4d9375",
        name = "FishConfig",
      },
      [".zshrc"] = {
        icon = "",
        color = "#428850",
        name = "ZshConfig",
      },
      [".zshenv"] = {
        icon = "",
        color = "#428850",
        name = "ZshEnv",
      },
      [".zprofile"] = {
        icon = "",
        color = "#428850",
        name = "ZshProfile",
      },
      ["fish_variables"] = {
        icon = "",
        color = "#4d9375",
        name = "FishVariables",
      },
    },
    -- overrides by extension
    override_by_extension = {
      ["fish"] = {
        icon = "",
        color = "#4d9375",
        name = "Fish",
      },
      ["zsh"] = {
        icon = "",
        color = "#428850",
        name = "Zsh",
      },
      ["sh"] = {
        icon = "",
        color = "#4d5a5e",
        name = "Shell",
      },
      ["bash"] = {
        icon = "",
        color = "#89e051",
        name = "Bash",
      },
    },
  },
}
