return {
  {
    dir = os.getenv 'HOME' .. '/code/personal/ghost-writer.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      debug = false,
      default = 'anthropic',
      providers = {
        anthropic = {
          url = 'https://api.anthropic.com/v1/messages',
          model = 'claude-3-5-sonnet-20241022',
          target_state = 'content_block_delta',
          api_key_name = 'ANTHROPIC_API_KEY',
          system_prompt = 'you are a helpful assistant, what I am sending you may be notes, code or context provided by our previous conversation',
        },
      },
      ui = {
        window_width = 70,
        default_message = 'hello, how can I assist you?',
      },
      keymaps = {
        -- Global keymaps
        open = {
          key = '<leader>wo',
          desc = '[W]indow [O]pen Chat',
        },
        exit = {
          key = '<leader>we',
          desc = '[W]indow [E]xit',
        },
        prompt = {
          key = '<leader>p',
          desc = '[P]rompt',
        },
        -- Buffer-specific keymaps
        buffer = {
          resize_left = {
            key = '<A-h>',
            desc = 'Resize window left',
          },
          resize_right = {
            key = '<A-l>',
            desc = 'Resize window right',
          },
        },
        escape = {
          key = '<Esc>',
          desc = 'Cancel model streaming',
          pattern = 'model_escape_fn',
        },
      },
    },
    config = function(_, opts)
      require('ghost-writer').setup(opts)
    end,
  },
}
