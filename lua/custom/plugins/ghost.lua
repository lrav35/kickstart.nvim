return {
  {
    dir = os.getenv 'HOME' .. '/code/personal/ghost-writer.nvim',
    dependencies = {},
    config = function()
      require('ghost-writer').setup()
    end,
  },
}
