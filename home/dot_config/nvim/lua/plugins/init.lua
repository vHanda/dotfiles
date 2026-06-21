return {
	-- Used to format the code the code - call prettier / gofmt / etc
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = { "ConformInfo" },
		opts = require("configs.conform"),
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
		},
		config = true,
		opts = {
			lsp = {
				init_options = {
					onlyAnalyzeProjectsWithOpenFiles = false,
				},
				settings = {
					-- flutter-tools supports this directly under lsp.settings.
					-- Keep SDK/cache out of analysis.
					analysisExcludedFolders = {
						vim.fn.expand("~/src/flutter/flutter/bin/cache"),
						vim.fn.expand("~/src/flutter/flutter/packages"),
						vim.fn.expand("~/.pub-cache"),
					},
				},
				root_dir = function(fname)
					local util = require("lspconfig.util")
					local path = vim.fs.normalize(fname)

					-- Do not start a separate dartls for Flutter SDK/cache files.
					-- You can still jump into these files, but they won't pollute diagnostics.
					local excluded_roots = {
						vim.fs.normalize(vim.fn.expand("~/src/flutter/flutter/bin/cache")),
						vim.fs.normalize(vim.fn.expand("~/src/flutter/flutter/packages")),
						vim.fs.normalize(vim.fn.expand("~/.pub-cache")),
					}

					for _, root in ipairs(excluded_roots) do
						if path:sub(1, #root) == root then
							return nil
						end
					end

					-- Walk upward until we find a directory containing both pubspec.yaml and .git
					-- There is needed for pub workspaces
					local path = vim.fs.dirname(vim.fs.normalize(fname))
					for dir in vim.fs.parents(path) do
						if
							vim.fn.filereadable(dir .. "/pubspec.yaml") == 1
							and vim.fn.isdirectory(dir .. "/.git") == 1
						then
							return dir
						end
					end

					-- Fallback for non-workspace / non-git projects
					return util.root_pattern("pubspec.yaml")(fname)
				end,
			},
		},
	},

	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
	},
	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	opts = {
	-- 		filters = {
	-- 			git_ignored = false,
	-- 		},
	-- 		update_focused_file = {
	-- 			enable = true,
	-- 		},
	-- 		view = {
	-- 			cursorline = true,
	-- 			cursorlineopt = "line", -- make the whole row highlighted, not just text/number
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("nvim-tree").setup(opts)
	--
	-- 		-- This is so that the current line is highlighted
	-- 		-- When I'm in a particular Buffer, the corresponding file should be highlighted
	-- 		-- in Nvim-tree
	-- 		vim.api.nvim_set_hl(0, "NvimTreeCursorLine", {
	-- 			bg = "#3b4252",
	-- 			bold = true,
	-- 		})
	-- 	end,
	-- },

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
		},
		lazy = false,
		---@module 'neo-tree'
		---@type neotree.Config
		opts = {
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
			},
			buffers = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
			},
		},
		config = function(_, opts)
			require("neo-tree").setup(opts)

			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", {
				bg = "#3b4252",
				bold = true,
			})
		end,
	},

	-- Stickies certain lines which show the class / functions
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		opts = {
			enable = true,
			mode = "topline",
		},
	},

	-- Call the LSP when we rename / move a file
	{
		"antosha417/nvim-lsp-file-operations",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
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

	-- When searching for something it shows the number of occurances
	-- I'd prefer a top right bar like in vscode
	-- This also has some bugs, but it's needed for nvim-scrollbar
	{
		"kevinhwang91/nvim-hlslens",
		event = "BufReadPost",
		config = function()
			require("hlslens").setup()
		end,
	},

	{
		"petertriho/nvim-scrollbar",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"kevinhwang91/nvim-hlslens", -- optional, for search marks
		},
		config = function()
			require("scrollbar").setup({
				show = true,
				hide_if_all_visible = false,
				handlers = {
					cursor = false,
					diagnostic = true,
					gitsigns = true,
					handle = true,
					search = true,
				},
				excluded_filetypes = {
					"prompt",
					"TelescopePrompt",
					"noice",
					"neo-tree",
					"NvimTree",
					"lazy",
					"mason",
				},
			})

			require("scrollbar.handlers.gitsigns").setup()
			require("scrollbar.handlers.search").setup()
		end,
	},

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

	-- Makes the quick-fix prettier and also allows one to edit the files directly
	-- from the quickfix menu
	{
		"stevearc/quicker.nvim",
		ft = "qf",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {},
	},

	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged *:[vV\22]", -- optionally, lazy load on entering visual mode
	},

	{
		"Fluid-CAD/FluidCAD",
		config = function()
			require("fluidcad").setup()
		end,
		ft = { "javascript" },
	},

	-- Puts the command line in the middle of the screen
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

	-- Shows the IDE style of showing this breadcrumb at the top of the file
	{
		"Bekaboo/dropbar.nvim",
		lazy = false,
		config = function()
			require("dropbar").setup({
				sources = {
					path = {
						relative_to = function(buf, _win)
							return vim.fs.root(buf, { ".git" }) or vim.fn.getcwd()
						end,
					},
				},
			})

			local dropbar_api = require("dropbar.api")
			vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
			vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
			vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
		end,
	},

	-- A better top open buffer bar
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		lazy = false,
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			-- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
			-- animation = true,
			-- insert_at_start = true,
			-- …etc.
			sidebar_filetypes = {
				-- Vish: restore this
				-- NvimTree = true, -- keeps the tab bar aligned with nvim-tree
			},
			auto_hide = true,
		},
		config = function(_, opts)
			require("barbar").setup(opts)

			vim.api.nvim_set_hl(0, "BufferCurrent", { bg = "#000000", update = true })
			vim.api.nvim_set_hl(0, "BufferCurrentIcon", { bg = "#000000", update = true })
			vim.api.nvim_set_hl(0, "BufferCurrentSign", { bg = "#000000", update = true })
			vim.api.nvim_set_hl(0, "BufferCurrentSignRight", { bg = "#000000", update = true })

			-- local function apply_highlights()
			-- 	local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
			-- 	local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
			-- 	local bg = normal.bg
			-- 	local dim_fg = comment.fg
			--
			-- 	vim.api.nvim_set_hl(0, "BufferInactive", { bg = bg, fg = dim_fg })
			-- 	vim.api.nvim_set_hl(0, "BufferInactiveSign", { bg = bg, fg = dim_fg })
			-- 	vim.api.nvim_set_hl(0, "BufferInactiveMod", { bg = bg, fg = dim_fg })
			-- 	vim.api.nvim_set_hl(0, "BufferCurrent", { bg = bg })
			-- 	vim.api.nvim_set_hl(0, "BufferCurrentSign", { bg = bg })
			-- 	vim.api.nvim_set_hl(0, "BufferCurrentMod", { bg = bg })
			-- 	vim.api.nvim_set_hl(0, "BufferTabpageFill", { bg = bg })
			-- end
			--
			-- apply_highlights()

			-- Re-apply whenever NvChad's theme switcher changes the colorscheme
			-- vim.api.nvim_create_autocmd("ColorScheme", {
			-- 	callback = apply_highlights,
			-- })
		end,
		keys = {
			{ "<Tab>", "<cmd>BufferNext<CR>", desc = "buffer next" },
			{ "<S-Tab>", "<cmd>BufferPrevious<CR>", desc = "buffer prev" },
			{ "<leader>x", "<cmd>BufferClose<CR>", desc = "buffer close" },
			{ "<D-w>", "<cmd>BufferClose<CR>", desc = "buffer close (cmd+w)" },
		},
	},

	-- TODO: Explore https://github.com/stevearc/resession.nvim as an alternative
	-- The idea is that we then wouldn't need so many hacks to get git-sign and nvim-tree to work!
	{
		"rmagatti/auto-session",
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			suppressed_dirs = { "~/", "~/Desktop", "~/Downloads", "/" },
			-- log_level = 'debug',

			-- pre_save_cmds = {
			-- 	function()
			-- 		local ok, nvim_tree = pcall(require, "nvim-tree.api")
			-- 		if ok then
			-- 			nvim_tree.tree.close()
			-- 		end
			-- 	end,
			-- },
			--
			-- post_restore_cmds = {
			-- 	function()
			-- 		local ok, nvim_tree = pcall(require, "nvim-tree.api")
			-- 		if ok then
			-- 			nvim_tree.tree.open()
			-- 			nvim_tree.tree.change_root(vim.fn.getcwd())
			-- 			nvim_tree.tree.reload()
			-- 		end
			-- 	end,
			--
			-- 	function()
			-- 		local ok, gitsigns = pcall(require, "gitsigns")
			-- 		if ok then
			-- 			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			-- 				if vim.api.nvim_buf_is_loaded(buf) then
			-- 					gitsigns.attach(buf)
			-- 				end
			-- 			end
			-- 		end
			-- 	end,
			-- },
		},
	},

	-- Terminal in the middle of the screen
	{
		"akinsho/toggleterm.nvim",
		keys = { "<C-t>" }, -- or whatever key you want
		opts = {
			open_mapping = [[<C-t>]],
			direction = "float",
			float_opts = {
				border = "curved",
			},
		},
	},
}
