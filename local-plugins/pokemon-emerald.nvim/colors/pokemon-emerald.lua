vim.cmd("highlight clear")
vim.g.colors_name = "pokemon-emerald"
vim.o.background = "light"
vim.o.termguicolors = true

local hi = function(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

local c = {
	none = "NONE",
	fg = "#2d5016",
	fg_dim = "#486828",
	fg_muted = "#6b8f50",
	sky = "#2878a8",
	sky_bright = "#88d0f0",
	ocean = "#6868c8",
	ocean_dim = "#5858b8",
	grass = "#78a038",
	grass_bright = "#98c840",
	foliage = "#486828",
	bark = "#3d6b1e",
	sand = "#c8a828",
	sand_bright = "#e0c848",
	berry = "#c84040",
	berry_bright = "#e05050",
	cloud = "#f0f8e8",
	cloud_dim = "#d8e8c8",
	cloud_dark = "#b0c898",
}

-- UI
hi("Normal", { fg = c.fg, bg = c.none })
hi("NormalFloat", { fg = c.fg, bg = c.cloud })
hi("NormalNC", { fg = c.fg_dim, bg = c.none })
hi("FloatBorder", { fg = c.grass, bg = c.cloud })
hi("FloatTitle", { fg = c.sky, bg = c.cloud, bold = true })
hi("Cursor", { fg = c.cloud, bg = c.sky })
hi("CursorLine", { bg = "#d0e8b0" })
hi("CursorColumn", { bg = "#d0e8b0" })
hi("ColorColumn", { bg = "#d8e0c8" })
hi("LineNr", { fg = c.fg_muted })
hi("CursorLineNr", { fg = c.grass, bold = true })
hi("SignColumn", { fg = c.fg_muted, bg = c.none })
hi("VertSplit", { fg = c.cloud_dark })
hi("WinSeparator", { fg = c.cloud_dark })
hi("StatusLine", { fg = c.fg, bg = c.cloud_dim })
hi("StatusLineNC", { fg = c.fg_muted, bg = c.cloud })
hi("TabLine", { fg = c.fg_muted, bg = c.cloud })
hi("TabLineSel", { fg = c.cloud, bg = c.grass, bold = true })
hi("TabLineFill", { bg = c.cloud })
hi("Pmenu", { fg = c.fg, bg = c.cloud })
hi("PmenuSel", { fg = c.cloud, bg = c.grass })
hi("PmenuSbar", { bg = c.cloud_dim })
hi("PmenuThumb", { bg = c.grass })
hi("Visual", { bg = "#b8d898" })
hi("Search", { fg = c.fg, bg = c.sand_bright })
hi("IncSearch", { fg = c.cloud, bg = c.sky })
hi("MatchParen", { fg = c.berry, bold = true, underline = true })
hi("Folded", { fg = c.fg_muted, bg = c.cloud })
hi("FoldColumn", { fg = c.fg_muted, bg = c.none })
hi("NonText", { fg = c.cloud_dark })
hi("SpecialKey", { fg = c.cloud_dark })
hi("Directory", { fg = c.sky })
hi("Title", { fg = c.sky, bold = true })
hi("ErrorMsg", { fg = c.berry, bold = true })
hi("WarningMsg", { fg = c.sand, bold = true })
hi("MoreMsg", { fg = c.grass })
hi("Question", { fg = c.grass })
hi("WildMenu", { fg = c.cloud, bg = c.sky })
hi("DiffAdd", { bg = "#c8e8a0" })
hi("DiffChange", { bg = "#d0d8f0" })
hi("DiffDelete", { fg = c.berry, bg = "#f0d0d0" })
hi("DiffText", { bg = "#b0c0e8", bold = true })
hi("SpellBad", { undercurl = true, sp = c.berry })
hi("SpellCap", { undercurl = true, sp = c.sky })

-- Syntax
hi("Comment", { fg = c.fg_muted, italic = true })
hi("Constant", { fg = c.ocean })
hi("String", { fg = c.foliage })
hi("Character", { fg = c.foliage })
hi("Number", { fg = c.ocean })
hi("Boolean", { fg = c.ocean, bold = true })
hi("Float", { fg = c.ocean })
hi("Identifier", { fg = c.fg })
hi("Function", { fg = c.sky, bold = true })
hi("Statement", { fg = c.grass })
hi("Conditional", { fg = c.grass, bold = true })
hi("Repeat", { fg = c.grass })
hi("Label", { fg = c.grass })
hi("Operator", { fg = c.fg_dim })
hi("Keyword", { fg = c.grass, bold = true })
hi("Exception", { fg = c.berry })
hi("PreProc", { fg = c.sand })
hi("Include", { fg = c.sky })
hi("Define", { fg = c.sky })
hi("Macro", { fg = c.sand })
hi("PreCondit", { fg = c.sand })
hi("Type", { fg = c.sky })
hi("StorageClass", { fg = c.grass })
hi("Structure", { fg = c.sky })
hi("Typedef", { fg = c.sky })
hi("Special", { fg = c.sand })
hi("SpecialChar", { fg = c.sand })
hi("Tag", { fg = c.sky })
hi("Delimiter", { fg = c.fg_dim })
hi("SpecialComment", { fg = c.fg_muted, bold = true })
hi("Debug", { fg = c.berry })
hi("Underlined", { underline = true })
hi("Error", { fg = c.berry, bold = true })
hi("Todo", { fg = c.sand, bold = true })

-- Treesitter
hi("@variable", { fg = c.fg })
hi("@function", { fg = c.sky, bold = true })
hi("@function.builtin", { fg = c.sky })
hi("@keyword", { fg = c.grass, bold = true })
hi("@string", { fg = c.foliage })
hi("@type", { fg = c.sky })
hi("@type.builtin", { fg = c.sky, italic = true })
hi("@comment", { fg = c.fg_muted, italic = true })
hi("@punctuation", { fg = c.fg_dim })
hi("@constant", { fg = c.ocean })
hi("@constant.builtin", { fg = c.ocean, bold = true })
hi("@property", { fg = c.fg })
hi("@parameter", { fg = c.fg, italic = true })
hi("@tag", { fg = c.sky })
hi("@tag.attribute", { fg = c.grass })
hi("@tag.delimiter", { fg = c.fg_dim })

-- Diagnostics
hi("DiagnosticError", { fg = c.berry })
hi("DiagnosticWarn", { fg = c.sand })
hi("DiagnosticInfo", { fg = c.sky })
hi("DiagnosticHint", { fg = c.grass })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.berry })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.sand })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.sky })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.grass })

-- Git
hi("GitSignsAdd", { fg = c.grass })
hi("GitSignsChange", { fg = c.sky })
hi("GitSignsDelete", { fg = c.berry })

-- Telescope
hi("TelescopeBorder", { fg = c.grass })
hi("TelescopePromptBorder", { fg = c.sky })
hi("TelescopeResultsBorder", { fg = c.grass })
hi("TelescopePreviewBorder", { fg = c.grass })
hi("TelescopeTitle", { fg = c.sky, bold = true })
hi("TelescopePromptTitle", { fg = c.cloud, bg = c.sky, bold = true })
hi("TelescopeResultsTitle", { fg = c.cloud, bg = c.grass, bold = true })
hi("TelescopePreviewTitle", { fg = c.cloud, bg = c.foliage, bold = true })
hi("TelescopeSelection", { bg = "#c8e0b0" })

-- Indent
hi("IndentBlanklineChar", { fg = c.cloud_dark })
hi("IblIndent", { fg = c.cloud_dark })
hi("IblScope", { fg = c.grass })

-- Lazy / Mason / Which-key
hi("LazyButton", { fg = c.fg, bg = c.cloud_dim })
hi("LazyButtonActive", { fg = c.cloud, bg = c.grass, bold = true })
hi("WhichKey", { fg = c.grass })
hi("WhichKeyGroup", { fg = c.sky })
hi("WhichKeyDesc", { fg = c.fg })
hi("WhichKeySeparator", { fg = c.fg_muted })
