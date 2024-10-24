-- NOTE: Java specific keymaps with which key
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"
vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"

local status_ok, which_key = pcall(require, 'which-key')
if not status_ok then
  return
end

local opts = {
  mode = 'n', -- NORMAL mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local vopts = {
  mode = 'v', -- VISUAL mode
  prefix = '<leader>',
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  J = {
    name = 'Java',
    o = { "<Cmd>lua require'jdtls'.organize_imports()<CR>", 'Organize Imports' },
    v = { "<Cmd>lua require('jdtls').extract_variable()<CR>", 'Extract Variable' },
    c = { "<Cmd>lua require('jdtls').extract_constant()<CR>", 'Extract Constant' },
    t = { "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", 'Test Method' },
    T = { "<Cmd>lua require'jdtls'.test_class()<CR>", 'Test Class' },
    u = { '<Cmd>JdtUpdateConfig<CR>', 'Update Config' },
  },
}

local vmappings = {
  J = {
    name = 'Java',
    v = { "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", 'Extract Variable' },
    c = { "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", 'Extract Constant' },
    m = { "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", 'Extract Method' },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)

-- If you want you can add here Old School Mappings. Me I setup Telescope, LSP and Lspsaga mapping somewhere else and I just reuse them

-- vim.keymap.set("gI", vim.lsp.buf.implementation,{ desc = "[G]oto [I]mplementation" })
-- vim.keymap.set("<leader>D", vim.lsp.buf.type_definition,{ desc = "Type [D]efinition" })
-- vim.keymap.set("<leader>hh", vim.lsp.buf.signature_help,{ desc = "Signature [H][H]elp Documentation" })

-- vim.keymap.set("gD", vim.lsp.buf.declaration,{ desc = "[G]oto [D]eclaration" })
-- vim.keymap.set("<leader>wa", vim.lsp.buf.add_workspace_folder,{ desc = "[W]orkspace [A]dd Folder" })
-- vim.keymap.set("<leader>wr", vim.lsp.buf.remove_workspace_folder,{ desc = "[W]orkspace [R]emove Folder" })
-- vim.keymap.set("<leader>wl", function()
--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- end, "[W]orkspace [L]ist Folders")

-- Create a command `:Format` local to the LSP buffer
-- vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
--   vim.lsp.buf.format()
-- end, { desc = "Format current buffer with LSP" })

-- vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "[G]oto [R]eferences - Java", expr = true, silent = true })
-- vim.keymap.set("n","gr", require("telescope.builtin").lsp_references,{ desc = "[G]oto [R]eferences" })
-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "" })
-- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "" })
-- vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "" })
-- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "" })
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "" })
-- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "" })
-- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "" })
-- vim.keymap.set('n', '<leader>wl', print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', { desc = "" })
-- vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = "" })
-- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "" })
-- vim.keymap.set('n', 'gr', vim.lsp.buf.references() && vim.cmd("copen")<CR>', { desc = "" })
-- vim.keymap.set('n', '<leader>e', vim.lsp.diagnostic.show_line_diagnostics, { desc = "" })
-- vim.keymap.set('n', '[d', vim.lsp.diagnostic.goto_prev, { desc = "" })
-- vim.keymap.set('n', ']d', vim.lsp.diagnostic.goto_next, { desc = "" })
-- vim.keymap.set('n', '<leader>q', vim.lsp.diagnostic.set_loclist, { desc = "" })

-- -- Java specific
-- vim.keymap.set("n", "<leader>di", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "" })
-- vim.keymap.set("n", "<leader>dt", "<Cmd>lua require'jdtls'.test_class()<CR>", { desc = "" })
-- vim.keymap.set("n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", { desc = "" })
-- vim.keymap.set("v", "<leader>de", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { desc = "" })
-- vim.keymap.set("n", "<leader>de", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "" })
-- vim.keymap.set("v", "<leader>dm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { desc = "" })
--
-- vim.keymap.set("n", "<leader>cf", "<cmd>lua vim.lsp.buf.formatting()<CR>", { desc = "" })
