return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup{}
    
    -- Create mappings without leader key
    vim.keymap.set('n', 'ff', require('telescope.builtin').find_files, { desc = 'Find files' })
    vim.keymap.set('n', 'fs', require('telescope.builtin').live_grep, { desc = 'Live grep' })
  end
}