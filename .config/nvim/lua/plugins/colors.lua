return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = false,
			color_overrides = {
				mocha = {
					base = "#0c0e0f",
					mantle = "#0c0e0f",
					crust = "#0c0e0f",
				},
			},
		})
		vim.cmd.colorscheme("catppuccin")
	end,
}
