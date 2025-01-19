return {
	"R-nvim/R.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"R-nvim/cmp-r"
	},
	-- Only required if you also set defaults.lazy = true
	lazy = false,
	-- R.nvim is still young and we may make some breaking changes from time
	-- to time. For now we recommend pinning to the latest minor version
	-- like so:
	version = "~0.1.0"
}
