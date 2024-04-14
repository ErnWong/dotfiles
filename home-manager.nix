{ pkgs, lib, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.username = "ernwong";
  home.homeDirectory = "/home/ernwong";

  home.sessionVariables = {
    # Replace bold/underline with colors when using man
    MANPAGER = "less --RAW-CONTROL-CHARS --use-color --color d+r --color u+b";
    STARSHIP_CONFIG = pkgs.writeText "starship.toml" (lib.fileContents ./starship.toml);
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  home.packages = [
    # Audio/Music
    pkgs.ardour
    pkgs.audacity
    pkgs.lilypond
    pkgs.musescore

    # Comms
    pkgs.discord
    pkgs.chromium
    pkgs.firefox

    # Dev
    pkgs.gdb
    pkgs.gh
    pkgs.rlwrap
    pkgs.samba
    pkgs.starship
    pkgs.warp-terminal
    inputs.self.packages.x86_64-linux.waveterm

    # Games
    pkgs.runelite
    pkgs.factorio-headless

    # Utils
    pkgs.bitwarden
  ];

  home.enableDebugInfo = true;

  home.stateVersion = "23.11";

  programs.bash = {
    enable = true;
    profileExtra = ''
      eval "$(${pkgs.starship}/bin/starship init bash)"
    '';
    initExtra = ''
      eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;

    extraConfig = {
      pull.rebase = false;
      credential."https://github.com".helper = "!gh auth git-credential";
    };
  };

  programs.less = {
    enable = true;
    keys = builtins.readFile ./lesskey;
  };

  # Java needed for prusti vscode extension
  programs.java.enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      matklad.rust-analyzer
      ms-vscode.cpptools
      arrterian.nix-env-selector
      jnoortheen.nix-ide
      thenuprojectcontributors.vscode-nushell-lang
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "prusti-assistant";
        publisher = "viper-admin";
        version = "0.9.0";
        sha256 = "sha256-6Vcz4EPirN+d4VjzMky7BSHvqMdkf6GqwPiHuPNyaIU=";
      }
      {
        name = "idris2-lsp";
        publisher = "bamboo";
        version = "0.7.0";
        sha256 = "sha256-8eLvHKUPBoge50wzOfp5aK/XVJElVzKtil8Yj+PwNUU=";
      }
      {
        name = "vscode-apl-language";
        publisher = "OptimaSystems";
        version = "0.0.7";
        sha256 = "sha256-KkKuF/tPmMDeCpFOw1O4UyfliG8co3o9J3FNvc8wdgA=";
      }
      {
        name = "vscode-apl-language-client";
        publisher = "OptimaSystems";
        version = "0.0.9";
        sha256 = "sha256-KD8B8SwQR1pr/hM3dIfuNNCXz+ENb+UDnvq7Z9yxFhQ=";
      }
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "${pkgs.nil}/bin/nil";
    };
  };

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./init.vim;
    extraPackages = with pkgs; [
      rust-analyzer
      nil
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
      idris2-vim
      nvim-nu

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

  programs.nushell = {
    enable = true;
    configFile.text = builtins.readFile ./config.nu;
  };

  programs.readline = {
    enable = true;
    bindings = {
      "\\t" = "menu-complete";
      "\\e[Z" = "menu-complete-backward";
      "\\e[A" = "history-search-backward";
      "\\e[B" = "history-search-forward";
    };
    extraConfig = builtins.readFile ./inputrc;
  };

  programs.zoxide.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
