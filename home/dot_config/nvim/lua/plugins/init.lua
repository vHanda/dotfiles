return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    cmd = { "ConformInfo" },
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    'nvim-flutter/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        git_ignored = false,
      },
    },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
  --
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<leader>dx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>dX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>dL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>dQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    'mcauley-penney/visual-whitespace.nvim',
    event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
  },

  {
    "Fluid-CAD/FluidCAD",
    config = function()
      require("fluidcad").setup()
    end,
    ft = { "javascript" },
  },

  {
    "rachartier/tiny-cmdline.nvim",
    lazy = false,
    init = function()
      vim.o.cmdheight = 0
      require("vim._core.ui2").enable({})
    end,
    config = function()
      require("tiny-cmdline").setup({
        width = { value = "70%" },
        position = {
          x = "50%",
          y = "50%",
        },
      })
    end,
  },

  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      -- log_level = 'debug',

      pre_save_cmds = {
        function()
          local ok, nvim_tree = pcall(require, "nvim-tree.api")
          if ok then nvim_tree.tree.close() end
        end,
      },

      post_restore_cmds = {
        function()
          local ok, nvim_tree = pcall(require, "nvim-tree.api")
          if ok then
            nvim_tree.tree.open()
            nvim_tree.tree.change_root(vim.fn.getcwd())
            nvim_tree.tree.reload()
          end
        end,

        function()
          local ok, gitsigns = pcall(require, "gitsigns")
          if ok then
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) then
                gitsigns.attach(buf)
              end
            end
          end
        end,
      },
    },
  }
}
