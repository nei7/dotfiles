return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					path_display = { "smart" },
					mapping = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			telescope.load_extension("ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {desc = "Fuzzy find files in cwd"})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {desc = "Find string in cwd"})
		end,
	},
}
