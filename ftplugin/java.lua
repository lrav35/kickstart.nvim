-- old
-- local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
--
-- local workspace_dir = '~/code/liberty/' .. project_name
--
package.path = package.path .. ';/Users/n0342839/.local/share/nvim/mason/packages/jdtls/'
package.cpath = package.cpath .. ';/Users/n0342839/.local/share/nvim/mason/packages/jdtls/'

local mason = require 'mason-registry'
local jdtls_path = mason.get_package('jdtls'):get_install_path()
local java_debug_path = mason.get_package('java-debug-adapter'):get_install_path()
local java_test_path = mason.get_package('java-test'):get_install_path()

local equinox_launcher_path = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

local system = 'linux'
if vim.fn.has 'win32' then
  system = 'win'
elseif vim.fn.has 'mac' then
  system = 'mac'
end
local config_path = vim.fn.glob(jdtls_path .. '/config_' .. system)

local lombok_path = jdtls_path .. '/lombok.jar'

local jdtls = require 'jdtls'

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    '/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home',
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

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

    -- 💀
    '-jar',
    equinox_launcher_path -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^      -- Must point to the                                                     Change this to
      -- eclipse.jdt.ls installation

      -- lombok
 '-javaagent:' .. lombok_path,

    -- 💀
    '-configuration',
    config_path -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^      -- Must point to the                      Change to one of `linux`, `win` or `mac`
      -- eclipse.jdt.ls installation            Depending on your system.

      -- 💀
      -- See `data directory configuration` section in the README
 '-data',
    vim.fn.stdpath 'cache' .. '/jdtls/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
  },

  -- 💀
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

local bundles = {
  vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar'), '\n'))

config['init_options'] = {
  bundles = bundles,
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
