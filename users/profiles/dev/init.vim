colorscheme gruvbox
lua << EOF
  require('rust-tools').setup({})
  require('lspconfig').rnix.setup({})
EOF
