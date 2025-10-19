return {
	'neovim/nvim-lspconfig',
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		{ 'j-hui/fidget.nvim', opts = {} },
		'folke/neodev.nvim',
	},
	config = function()
		-- Tailwind CSS Language Server
		-- lspconfig.htmx.setup{
		-- 	filetypes = { "templ" },
		-- }
		-- lspconfig.tailwindcss.setup({
		-- 	filetypes = { "templ", "astro", "javascript", "typescript", "react" },
		-- 	settings = {
		-- 		tailwindCSS = {
		-- 			experimental = {
		-- 				classRegex = {
		-- 					-- Support for Templ class attributes
		-- 					{ "class:\\s*\"([^\"]*)", "\"([^\"]*)\"" },
		-- 					{ "class:\\s*'([^']*)", "'([^']*)'" },
		-- 					{ "class=[{]?\"?([^\"}>]*)", "\"?([^\"}]*)" }
		-- 				}
		-- 			}
		-- 		}
		-- 	}
		-- })
	end,
}
