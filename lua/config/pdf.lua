local M = {}
local api = vim.api

local function message(buf, lines)
	if not api.nvim_buf_is_valid(buf) then
		return
	end
	local readonly = vim.bo[buf].readonly
	vim.bo[buf].readonly = false
	vim.bo[buf].modifiable = true
	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modified = false
	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = readonly
end

local function source()
	local path = vim.b.pdf_source or api.nvim_buf_get_name(0)
	if path:lower():match("%.pdf$") and vim.fn.filereadable(path) == 1 then
		return vim.fn.fnamemodify(path, ":p")
	end
	vim.notify("Open a PDF first, or supply its path", vim.log.levels.WARN)
end

function M.external()
	local path = source()
	if not path then
		return
	end
	local opener = vim.fn.has("mac") == 1 and "open" or "xdg-open"
	vim.system({ opener, path }, { text = true }, function(result)
		if result.code ~= 0 then
			vim.schedule(function()
				vim.notify(result.stderr, vim.log.levels.ERROR)
			end)
		end
	end)
end

function M.read(buf, path)
	vim.b[buf].pdf_source = path
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "pdftext"
	vim.bo[buf].readonly = true
	vim.keymap.set("n", "<leader>po", M.external, { buffer = buf, desc = "PDF: open externally" })
	vim.keymap.set("n", "<leader>pi", M.view, { buffer = buf, desc = "PDF: view pages" })
	message(buf, { "Extracting PDF text…" })
	if vim.fn.executable("pdftotext") == 0 then
		message(buf, { "PDF text needs Poppler: brew install poppler", "Use :PdfOpen for the system viewer." })
		return
	end
	local generation = (vim.b[buf].pdf_generation or 0) + 1
	vim.b[buf].pdf_generation = generation
	vim.system({ "pdftotext", "-layout", "-enc", "UTF-8", path, "-" }, { text = true }, function(result)
		vim.schedule(function()
			if not api.nvim_buf_is_valid(buf) or vim.b[buf].pdf_generation ~= generation then
				return
			end
			local text = result.stdout or ""
			if result.code ~= 0 then
				message(buf, { "Could not extract PDF text:", result.stderr or "Unknown error" })
			elseif not text:find("%S") then
				message(buf, {
					"This PDF has no extractable text (possibly scanned).",
					"Use :PdfView for pages or :PdfOpen for the system viewer.",
				})
			else
				message(
					buf,
					vim.split(
						text:gsub("\f", "\n──────── Page break ────────\n"),
						"\n",
						{ plain = true }
					)
				)
			end
		end)
	end)
end

function M.view()
	local path = source()
	if not path then
		return
	end
	if vim.fn.executable("pdftoppm") == 0 or vim.fn.executable("pdfinfo") == 0 then
		vim.notify("Install Poppler: brew install poppler", vim.log.levels.ERROR)
		return
	end
	local ok, image = pcall(require, "snacks.image")
	if not ok or not image.supports_terminal() then
		vim.notify("Page images need Ghostty/Kitty. Use :PdfText or :PdfOpen here.", vim.log.levels.WARN)
		return
	end
	vim.system({ "pdfinfo", path }, { text = true }, function(info)
		vim.schedule(function()
			local pages = tonumber((info.stdout or ""):match("Pages:%s+(%d+)"))
			if info.code ~= 0 or not pages then
				vim.notify("Cannot read PDF: " .. (info.stderr or ""), vim.log.levels.ERROR)
				return
			end
			vim.cmd("botright vnew")
			local buf = api.nvim_get_current_buf()
			vim.b[buf].pdf_source = path
			vim.bo[buf].buftype = "nofile"
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].swapfile = false
			local dir = vim.fn.tempname()
			vim.fn.mkdir(dir, "p")
			local page, generation, job = 1, 0, nil
			local function render()
				generation = generation + 1
				local token = generation
				if job then
					job:kill(15)
				end
				image.placement.clean(buf)
				message(buf, { ("Rendering page %d / %d…"):format(page, pages) })
				local prefix = dir .. "/page-" .. page
				job = vim.system({
					"pdftoppm",
					"-f",
					tostring(page),
					"-l",
					tostring(page),
					"-scale-to",
					"1800",
					"-singlefile",
					"-png",
					path,
					prefix,
				}, { text = true }, function(result)
					vim.schedule(function()
						if not api.nvim_buf_is_valid(buf) or generation ~= token then
							return
						end
						job = nil
						if result.code ~= 0 then
							message(buf, { "Page rendering failed:", result.stderr or "" })
							return
						end
						api.nvim_buf_set_name(
							buf,
							("pdf-page://%d/%d/%s"):format(buf, page, vim.fn.fnamemodify(path, ":t"))
						)
						image.buf.attach(buf, { src = prefix .. ".png" })
						vim.b[buf].pdf_page = page
						vim.b[buf].pdf_pages = pages
					end)
				end)
			end
			local function move(delta)
				page = math.max(1, math.min(pages, page + delta))
				render()
			end
			for key, delta in pairs({ ["]p"] = 1, ["[p"] = -1, ["<PageDown>"] = 1, ["<PageUp>"] = -1 }) do
				vim.keymap.set("n", key, function()
					move(delta)
				end, { buffer = buf, desc = "PDF: change page" })
			end
			vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, desc = "PDF: close pages" })
			vim.keymap.set("n", "<leader>po", M.external, { buffer = buf, desc = "PDF: open externally" })
			api.nvim_create_autocmd("BufWipeout", {
				buffer = buf,
				once = true,
				callback = function()
					generation = generation + 1
					if job then
						job:kill(15)
					end
					image.placement.clean(buf)
					-- A killed renderer may still be exiting; cleanup after it releases its files.
					vim.defer_fn(function()
						vim.fn.delete(dir, "rf")
					end, 1000)
				end,
			})
			render()
		end)
	end)
end

function M.setup()
	local group = api.nvim_create_augroup("pdf_viewer", { clear = true })
	api.nvim_create_autocmd("BufReadCmd", {
		group = group,
		pattern = "*.[pP][dD][fF]",
		callback = function(ev)
			M.read(ev.buf, vim.fn.fnamemodify(ev.file, ":p"))
		end,
	})
	api.nvim_create_user_command("PdfText", function(opts)
		if opts.args ~= "" then
			vim.cmd.edit(vim.fn.fnameescape(vim.fn.fnamemodify(opts.args, ":p")))
		else
			local path = source()
			if path then
				vim.cmd.edit(vim.fn.fnameescape(path))
			end
		end
	end, { nargs = "?", complete = "file", desc = "Read searchable PDF text" })
	api.nvim_create_user_command("PdfView", M.view, { desc = "View PDF page images" })
	api.nvim_create_user_command("PdfOpen", M.external, { desc = "Open PDF in system viewer" })
end

return M
