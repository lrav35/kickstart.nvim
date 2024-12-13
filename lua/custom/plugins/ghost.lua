return {
  {
    dir = os.getenv 'HOME' .. '/code/personal/ghost-writer.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('ghost-writer').setup()
    end,
  },
}
