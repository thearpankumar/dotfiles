return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    ft = { "markdown" },
    config = function()
      require('render-markdown').setup({
        heading = {
          enabled = true,
          sign = true,
          icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
          backgrounds = {
            'RenderMarkdownH1Bg',
            'RenderMarkdownH2Bg', 
            'RenderMarkdownH3Bg',
            'RenderMarkdownH4Bg',
            'RenderMarkdownH5Bg',
            'RenderMarkdownH6Bg',
          },
        },
        code = {
          enabled = true,
          sign = false,
          style = 'full',
          position = 'left',
          language_pad = 0,
          disable_background = { 'diff' },
        },
        dash = {
          enabled = true,
          icon = '─',
          highlight = 'RenderMarkdownDash',
        },
        bullet = {
          enabled = true,
          icons = { '●', '○', '◆', '◇' },
        },
        checkbox = {
          enabled = true,
          unchecked = { 
            icon = '󰄱 ',
            highlight = 'RenderMarkdownUnchecked',
          },
          checked = { 
            icon = '󰱒 ',
            highlight = 'RenderMarkdownChecked',
          },
        },
        quote = {
          enabled = true,
          icon = '▋',
          highlight = 'RenderMarkdownQuote',
        },
        pipe_table = {
          enabled = true,
          style = 'full',
        },
        callout = {
          note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
          tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
          important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
          warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
          caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
        },
        link = {
          enabled = true,
          image = '󰥶 ',
          hyperlink = '󰌷 ',
        },
        sign = {
          enabled = true,
          highlight = 'RenderMarkdownSign',
        },
      })
    end,
  },
}