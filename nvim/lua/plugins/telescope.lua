return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = "Telescope",
  keys = {
    { 'ff', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
    { 'fs', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
  },
  config = function()
    require('telescope').setup{}
  end
}