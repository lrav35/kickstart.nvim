return {
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'mfussenegger/nvim-jdtls' },
    opts = {
      setup = {
        jdtls = function(_, opts)
          vim.api.nvim_create_autocmd('FileType', {
            pattern = 'java',
            callback = function()
              require('lazyvim.util').on_attach(function(_, buffer)
                vim.keymap.set('n', '<leader>di', "<Cmd>lua require'jdtls'.organize_imports()<CR>", { buffer = buffer, desc = 'Organize Imports' })
                vim.keymap.set('n', '<leader>dt', "<Cmd>lua require'jdtls'.test_class()<CR>", { buffer = buffer, desc = 'Test Class' })
                vim.keymap.set('n', '<leader>dn', "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", { buffer = buffer, desc = 'Test Nearest Method' })
                vim.keymap.set('v', '<leader>de', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", { buffer = buffer, desc = 'Extract Variable' })
                vim.keymap.set('n', '<leader>de', "<Cmd>lua require('jdtls').extract_variable()<CR>", { buffer = buffer, desc = 'Extract Variable' })
                vim.keymap.set('v', '<leader>dm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", { buffer = buffer, desc = 'Extract Method' })
                vim.keymap.set('n', '<leader>cf', '<cmd>lua vim.lsp.buf.formatting()<CR>', { buffer = buffer, desc = 'Format' })
              end)

              package.path = package.path .. ';/Users/n0342839/.local/share/nvim/mason/packages/jdtls/'
              package.cpath = package.cpath .. ';/Users/n0342839/.local/share/nvim/mason/packages/jdtls/'

              local mason = require 'mason-registry'
              local jdtls_path = mason.get_package('jdtls'):get_install_path()
              -- local java_debug_path = mason.get_package('java-debug-adapter'):get_install_path()
              -- local java_test_path = mason.get_package('java-test'):get_install_path()

              local equinox_launcher_path = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
              print('jdtls_path: ', jdtls_path)
              print('equinox_launcher_path: ', equinox_launcher_path)
              local system = 'linux'
              if vim.fn.has 'win32' then
                system = 'win'
              elseif vim.fn.has 'mac' then
                system = 'mac'
              end

              local config_path = vim.fn.glob(jdtls_path .. '/config_' .. system)
              local lombok_path = jdtls_path .. '/lombok.jar'

              local jdtls = require 'jdtls'
              local config = {
                -- The command that starts the language server
                -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
                cmd = {
                  '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home/bin/java',

                  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                  '-Dosgi.bundles.defaultStartLevel=4',
                  '-Declipse.product=org.eclipse.jdt.ls.core.product',
                  '-Dlog.protocol=true',
                  '-Dlog.level=ALL',
                  '-Xmx1g',
                  '--add-modules=ALL-SYSTEM',
                  '--add-opens',
                  'java.base/java.util=ALL-UNNAMED',
                  '--add-opens',
                  'java.base/java.lang=ALL-UNNAMED',

                  -- Must point to the eclipse.jdt.ls installation
                  '-jar',
                  equinox_launcher_path,

                  -- lombok
                  '-javaagent:' .. lombok_path,

                  '-configuration',
                  config_path,
                  '-data',
                  vim.fn.stdpath 'cache' .. '/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
                },
                -- This is the default if not provided, you can remove it. Or adjust as needed.
                -- One dedicated LSP server & client will be started per unique root_dir
                --
                -- vim.fs.root requires Neovim 0.10.
                -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
                root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),
                -- Here you can configure eclipse.jdt.ls specific settings
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- for a list of options
                settings = {
                  java = {},
                },
                -- Language server `initializationOptions`
                -- You need to extend the `bundles` with paths to jar files
                -- if you want to use additional eclipse.jdt.ls plugins.
                --
                -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
                --
                -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
                init_options = {
                  bundles = {},
                },
              }
              jdtls.start_or_attach(config)
            end,
          })
          return true
        end,
      },
    },
  },
}
