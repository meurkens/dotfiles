return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>t", builtin.find_files, {})
      vim.keymap.set("n", "<leader>r", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "css",
          "html",
          "javascript",
          "lua",
          "query",
          "ruby",
          "vim",
          "vimdoc",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "numToStr/Comment.nvim",
    opts = {
      toggler = { line = "<leader>d" },
      opleader = { line = "<leader>d" },
    },
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "ruff_lsp" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      lspconfig.lua_ls.setup({})
      lspconfig.ruff_lsp.setup({})
      lspconfig.clojure_lsp.setup({ capabilities = capabilities })

      local opts = {}
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>F", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        html = { "prettier" },
        scss = { "prettier" },
        lua = { "stylua" },
        css = { "prettier" },
        python = { "ruff_format" },
        clojure = { "clj-kondo" },
      },
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
      },
    },
  },
  -- {
  --   "echasnovski/mini.base16",
  --   config = function()
  --     vim.cmd("highlight! link @markup.heading.1.markdown Label")
  --     vim.cmd("highlight! link @markup.heading.2.markdown Boolean")
  --     vim.cmd("highlight! link @markup.heading.3.markdown Keyword")
  --     vim.cmd("highlight! link @markup.heading.4.markdown String")
  --     vim.cmd("highlight! link @markup.heading.5.markdown Statusline")
  --     vim.cmd("highlight! link @markup.heading.6.markdown Statusline")
  --
  --     require("mini.base16").setup({
  --       palette = require("mini.base16").mini_palette("#000000", "#ffffff", 75),
  --       use_cterm = {
  --         base00 = 0, -- background
  --         base01 = 0, -- linenumber background
  --         base02 = 8, -- background statusline, selection
  --         base03 = 10, -- linenumbers, comments
  --         base04 = 12, -- statusline
  --         base05 = 15, -- variable names, equality signs
  --         base06 = 5, -- unknown?
  --         base07 = 5, -- unknown?
  --         base08 = 12, -- map keys
  --         base09 = 13, -- booleans, integer literals
  --         base0A = 2, -- html
  --         base0B = 4, -- string literals
  --         base0C = 6, -- require, curly brackets
  --         base0D = 13, -- function calls
  --         base0E = 3, -- keywords
  --         base0F = 7, -- commas, brackets
  --       },
  --     })
  --
  --     -- vim.cmd("match DiagnosticFloatingError /\\s\\+$/")
  --   end,
  -- },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   config = function()
  --     vim.cmd("colorscheme rose-pine")
  --   end,
  -- },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },
  { "Olical/conjure" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
  },
  {
    "julienvincent/nvim-paredit",
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 100,
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      lspkind.init({})
      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
          }),
        },
        completion = { completeopt = "menu,menuone,noinsert" },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup({})
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "echasnovski/mini.trailspace",
    opts = {},
  },
}
