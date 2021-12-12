{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (lib.mkIf stdenv.hostPlatform.isLinux wezterm)
      gdb
    ];
    enableDebugInfo = true;
  };
  programs = {
    java.enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux"; # Needed for prusti vscode extension
    vscode = {
      enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        matklad.rust-analyzer
        ms-vscode.cpptools
        arrterian.nix-env-selector
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
        name = "prusti-assistant";
        publisher = "viper-admin";
        version = "0.9.0";
        sha256 = "sha256-6Vcz4EPirN+d4VjzMky7BSHvqMdkf6GqwPiHuPNyaIU=";
      }];
    };
    neovim = {
      enable = true;
      extraConfig = ''
        colorscheme gruvbox
        lua << EOF
          require('rust-tools').setup({})
          require('lspconfig').rnix.setup({})
        EOF
      '';
      extraPackages = with pkgs; [
        rnix-lsp
        rust-analyzer
      ];
      plugins = with pkgs.vimPlugins; [
        vim-sensible
        neovim-sensible
        nvim-dap

        # Intelligence
        syntastic
        editorconfig-vim
        nvim-lspconfig
        nvim-dap

        # Languages
        vim-liquid
        vim-ps1
        vim-cpp-enhanced-highlight
        vim-pandoc
        vim-pandoc-syntax
        markdown-preview-nvim
        #yajs-vim
        #vim-sass-lint
        #rust-vim
        rust-tools-nvim
        yats-vim
        ats-vim
        vim-nix

        # Coc
        #coc-marketplace
        #coc-xml
        #coc-json
        #coc-yaml
        #coc-toml
        #coc-gitignore
        #coc-rust-analyzer
        #coc-java
        #coc-tsserver
        #coc-eslint
        #coc-vimlsp
        #coc-pyright
        #coc-powershell
        #coc-sh
        #coc-sql
        #coc-docker
        #coc-vimtex
        #coc-css
        #coc-prettier

        # Handy
        vim-surround
        vim-commentary
        #fzf
        fzf-vim

        # UI
        vim-airline
        vim-airline-themes
        vim-tmux-navigator
        vim-bufkill
        ranger-vim
        tagbar

        # Git
        vim-fugitive
        vim-rhubarb
        vim-gitgutter

        # Colorschemes
        gruvbox
      ];
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
