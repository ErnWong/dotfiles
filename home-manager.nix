username:
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (_final: prev: {
      davinci-resolve = prev.davinci-resolve.override (old: {
        buildFHSEnv =
          a:
          (old.buildFHSEnv (
            a
            // {
              extraBwrapArgs = a.extraBwrapArgs ++ [
                "--bind /run/opengl-driver/etc/OpenCL /etc/OpenCL"
                "--setenv FUSION_FONTS /run/current-system/sw/share/X11/fonts "
              ];
            }
          ));
      });
    })
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "pano@elhan.io"
        "Vitals@CoreCoding.com"
        "caffeine@patapon.info"
        "color-picker@tuberry"
        "improvmx.checker@ernestwong.nz"
      ];
    };
    "org/gnome/desktop/interface" = {
      monospace-font-name = "0xProto";
    };
  };

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    # Replace bold/underline with colors when using man
    MANPAGER = "less --RAW-CONTROL-CHARS --use-color --color d+r --color u+b";
    STARSHIP_CONFIG = pkgs.writeText "starship.toml" (lib.fileContents ./starship.toml);
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  };

  home.packages = inputs.self.packages.x86_64-linux.soundfonts-freepats ++ [
    # Audio/Music
    pkgs.aeolus
    pkgs.ardour
    pkgs.audacity
    pkgs.bespokesynth
    pkgs.calf
    pkgs.carla
    pkgs.lilypond
    pkgs.lsp-plugins
    pkgs.mamba
    pkgs.musescore
    pkgs.muse-sounds-manager
    pkgs.puredata
    pkgs.setbfree
    pkgs.sfizz
    pkgs.tap-plugins
    pkgs.x42-plugins
    pkgs.zam-plugins

    # Sound fonts
    pkgs.soundfont-arachno
    pkgs.soundfont-fluid
    pkgs.soundfont-generaluser
    pkgs.soundfont-ydp-grand

    # Art / photography
    pkgs.krita
    pkgs.inkscape
    pkgs.darktable

    # Documents
    pkgs.libreoffice
    pkgs.onlyoffice-desktopeditors

    # Video/streaming
    pkgs.davinci-resolve
    pkgs.kdePackages.kdenlive
    pkgs.obs-studio
    # note wrapGAppsHook renamed to wrapGAppsHook3 and 4, but we're disabling shotcut for now as not using it due to still image black bug.
    # (pkgs.shotcut.overrideAttrs (oldAttrs: {
    #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.wrapGAppsHook];
    # }))
    pkgs.footage
    pkgs.mpv
    pkgs.vlc

    # Comms
    pkgs.discord
    pkgs.firefox

    # Organisation
    #pkgs.logseq
    #((import inputs.nixpkgs-logseq-fix { system = "x86_64-linux"; }).logseq)
    #inputs.self.packages.x86_64-linux.logseq
    ((import inputs.nixpkgs-logseq {
      system = "x86_64-linux";
      config.permittedInsecurePackages = [
        "electron-27.3.11"
      ];
      overlays = [
        # https://github.com/NixOS/nixpkgs/issues/264531
        (self: super: {
          logseq = super.logseq.overrideAttrs (oldAttrs: {
            postFixup = ''
              makeWrapper ${super.electron_27}/bin/electron $out/bin/${oldAttrs.pname} \
                --add-flags $out/share/${oldAttrs.pname}/resources/app \
                --add-flags "--use-gl=desktop" \
                --prefix LD_LIBRARY_PATH : "${super.lib.makeLibraryPath [ super.stdenv.cc.cc.lib ]}"
            '';
          });
        })
      ];
    }).logseq
    )
    pkgs.silverbullet

    # Dev
    pkgs.gdb
    pkgs.gh
    #pkgs.gitbutler TODO not used yet and not building successfully
    pkgs.rlwrap
    pkgs.samba
    pkgs.starship
    pkgs.warp-terminal
    #inputs.self.packages.x86_64-linux.waveterm TODO waveterm not used atm so I'm not updating it, and electron 29 is eol
    pkgs.zed-editor

    # Games
    pkgs.runelite
    #(pkgs.writeShellScriptBin "factorio-seablock" ''
    #  ${((import inputs.nixpkgs-factorio1 {
    #    system = "x86_64-linux";
    #    config.allowUnfree = true;
    #  }).factorio.override {
    #    username = "";
    #    token = "";
    #  })}/bin/factorio --verbose --config=$HOME/.factorio-seablock/config/config.ini --mod-directory=$HOME/.factorio-seablock/mods
    #'')
    #(pkgs.writeShellScriptBin "factorio-1" ''
    #  ${((import inputs.nixpkgs-factorio1 {
    #    system = "x86_64-linux";
    #    config.allowUnfree = true;
    #  }).factorio.override {
    #    username = "";
    #    token = "";
    #  })}/bin/factorio --verbose --config=$HOME/.factorio-1/config/config.ini --mod-directory=$HOME/.factorio-1/mods
    #'')
    #pkgs.factorio-headless
    #inputs.self.packages.x86_64-linux.openrct2-develop

    # Utils
    pkgs.bitwarden-desktop
    pkgs.rclone
    pkgs.numbat # Alternative to Google search's unit-aware calculator
    pkgs.qbittorrent
    ((import inputs.nixpkgs-stable {
      system = "x86_64-linux";
      config.permittedInsecurePackages = [
        "dotnet-sdk-6.0.428"
        "aspnetcore-runtime-6.0.36"
      ];
    }).sonarr
    )

    # Gnome extensions
    pkgs.gnomeExtensions.pano
    pkgs.gnomeExtensions.vitals
    pkgs.gnomeExtensions.caffeine
    pkgs.gnomeExtensions.color-picker
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

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
      # Yomitan
      # Manual steps:
      # - Disable "Show this welcome guide on browser startup"
      # - Download dictionaries:
      #    - Priority 1: 旺文社国語辞典 第十一版 from https://drive.google.com/drive/folders/1TRylrqtoYi2hW9dAjci5cugNzde_WRTM
      #    - Priority 2: Jitendex https://github.com/stephenmk/Jitendex https://github.com/stephenmk/stephenmk.github.io/releases
      #    - Priority 3: 明鏡国語辞典 from https://drive.google.com/drive/folders/1TRylrqtoYi2hW9dAjci5cugNzde_WRTM
      #    - Priority 4: Pitch Accent/アクセント辞典v2 (Recommended).zip
      #    - Priority 5: Grammar/Dictionary of Japanese Grammar.zip
      #    - Priority 6: Kanji/[Kanji] KANJIDIC (English).zip
      { id = "likgccmbimhjbgkjambclfkhldnlhbnn"; } # Yomitan
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;

    settings = {
      pull.rebase = false;
      credential."https://github.com".helper = "!gh auth git-credential";
    };
  };

  programs.less = {
    enable = true;
    config = builtins.readFile ./lesskey;
  };

  # Java needed for prusti vscode extension
  programs.java.enable = pkgs.stdenv.hostPlatform.system == "x86_64-linux";

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          vscodevim.vim
          rust-lang.rust-analyzer
          ms-vscode.cpptools
          arrterian.nix-env-selector
          jnoortheen.nix-ide
          thenuprojectcontributors.vscode-nushell-lang
          inputs.icantbelievegit.packages.x86_64-linux.default
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
          {
            name = "uiua-vscode";
            publisher = "uiua-lang";
            version = "0.0.57";
            sha256 = "sha256-KIbLwn/V47qmvpHx1Vorb5FdjI4lwh1pEQSgo0EEXcI=";
          }
          {
            name = "riscv";
            publisher = "zhwu95";
            version = "0.0.8";
            sha256 = "sha256-PXaHSEXoN0ZboHIoDg37tZ+Gv6xFXP4wGBS3YS/53TY=";
          }
          {
            name = "new-vsc-prolog";
            publisher = "AmauryRabouan";
            version = "1.1.12";
            sha256 = "sha256-DXNHbjoBHTcLumRtAUHnohlpdSwT6uxvHhg+epSyYHI=";
          }
          {
            name = "language-ats";
            publisher = "ldeleris";
            version = "0.0.2";
            sha256 = "sha256-HdUV20P3Nqf+2+M2GUCXjnKqn5IWWuqhgByBzCnMkow=";
          }
        ];
      userSettings = {
        "nix.enableLanguageServer" = true;
        #"nix.serverPath" = "${pkgs.nil}/bin/nil";
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "editor.fontFamily" = "'0xProto', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
      };
    };
  };

  programs.nixvim = {
    enable = true;

    #colorschemes.gruvbox.enable = true;
    #colorschemes.gruvbox.autoLoad = true;
    #colorschemes.one.enable = true;
    colorschemes.tokyonight = {
      enable = true;
      settings = {
        dim_inactive = true;
      };
    };
    #colorschemes.ayu.enable = true;

    keymaps = [
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
        key = "gd";
      }
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_references";
        key = "gr";
      }
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_implementations";
        key = "gi";
      }
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_document_symbols";
        key = "gO";
      }
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_dynamic_workspace_symbols";
        key = "gW";
      }
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_type_definitions";
        key = "gt";
      }
      {
        key = "gD";
        lspBufAction = "declaration";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
    ];

    # Git
    plugins.fugitive.enable = true;
    plugins.rhubarb.enable = true;
    #plugins.gitgutter.enable = true;
    plugins.gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
      };
    };

    # Debug
    plugins.dap.enable = true;

    # Languages
    #plugins.idris2.enable = true;
    #plugins.rustaceanvim.enable = true;
    plugins.treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
    };
    plugins.otter.enable = true;
    plugins.lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        nixd.enable = true;
        bashls.enable = true;
        phpactor.enable = true;
        rust_analyzer.enable = true;
        jsonls.enable = true;
        html.enable = true;
        jqls.enable = true;
        idris2_lsp.enable = true;
        cmake.enable = true;
        clangd.enable = true;
      };
    };
    plugins.rainbow-delimiters.enable = true;
    plugins.treesitter-context.enable = true;
    plugins.lspsaga.enable = true;
    plugins.lsp-signature.enable = true;
    plugins.lspkind.enable = true;
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
    plugins.todo-comments.enable = true;

    # UI
    plugins.telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };

      keymaps = {
        "<leader>ff" = {
          #action = "<cmd>Telescope find_files<cr>";
          action = "find_files";
          #mode = "n";
        };
        "<leader>fg" = {
          #action = "<cmd>Telescope live_grep<cr>";
          action = "live_grep";
          #mode = "n";
        };
        "<leader>fb" = {
          #action = "<cmd>Telescope buffers<cr>";
          action = "buffers";
          #mode = "n";
        };
        "<leader>fh" = {
          #action = "<cmd>Telescope help_tags<cr>";
          action = "help_tags";
          #mode = "n";
        };
      };
    };
    plugins.web-devicons.enable = true;
    # plugins.airline = {
    #   enable = true;
    #   # settings = {
    #   #   theme = "gruvbox";
    #   # };
    # };
    plugins.tiny-inline-diagnostic.enable = true;
    plugins.which-key.enable = true;
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          #component_separators = {
          #  left = "";
          #  right = "";
          #};
          section_separators = {
            left = "";
            right = "";
          };
        };
      };
    };

    extraConfigVim = builtins.readFile ./init.vim;
    extraConfigLua = ''
      vim.g.neominimap = {
        click = {
          enabled = true,
        },
        layout = "split",
      }

      -- vim.api.nvim_create_autocmd('LspAttach', {
      --   group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
      --   callback = function(event)
      --     local buf = event.buf
      --     local builtin = require 'telescope.builtin'
      --     vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      --     vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      --     vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      --     vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
      --     vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })
      --     vim.keymap.set('n', 'grt', builtin.lsp_type_definitions, { buffer = buf, desc = '[G]oto [T]ype Definition' })
      --   end,
      -- })
    '';
    extraPackages = with pkgs; [
      rust-analyzer
      #nil
      nixd
    ];
    extraPlugins = with pkgs.vimPlugins; [
    #  vim-sensible
    #  neovim-sensible

    #  # Intelligence
    #  syntastic
    #  editorconfig-vim
    #  nvim-lspconfig

    #  # Languages
    #  vim-liquid
    #  vim-ps1
    #  vim-cpp-enhanced-highlight
    #  vim-pandoc
    #  vim-pandoc-syntax
    #  markdown-preview-nvim
    #  yats-vim
    #  ats-vim
    #  vim-nix
    #  nvim-nu

    #  # Handy
    #  vim-surround
    #  vim-commentary
    #  #fzf
    #  fzf-vim

    #  # UI
    # vim-airline
    # vim-airline-themes
      vim-tmux-navigator
      vim-bufkill
    #  ranger-vim
      tagbar
      (pkgs.vimUtils.buildVimPlugin {
        name = "neominimap.nvim";
        src = inputs.neominimap;
      })
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

  # Disabled as this is suspected to be causing hangs upon waking from sleep.
  # See: https://github.com/ErnWong/dotfiles/issues/36
  #systemd.user.services.gdrive-mount =
  #  let
  #    mountdir = "${config.home.homeDirectory}/gdrive";
  #    cachedir = "${config.home.homeDirectory}/gdrive.cache";
  #  in
  #  {
  #    Unit.Description = "Mount Google Drive";
  #    Install.WantedBy = [ "default.target" ];
  #    Service = {
  #      ExecStart = ''
  #        ${pkgs.rclone}/bin/rclone mount gdrive: ${mountdir} \
  #          --cache-dir ${cachedir} \
  #          --vfs-cache-mode full \
  #          --vfs-cache-max-age 1000000h
  #      '';
  #      # Unmount explicitly rather than just killing rclone, or else
  #      # rclone will return a non-zero exit code.
  #      # See: https://forum.rclone.org/t/non-zero-exit-status-from-rclone-mount-even-with-clean-unmount/38884/3
  #      # Also, run fusermount from /run/wrappers/bin rather than from
  #      # pkgs.fuse, so that fusermount will have the right permissions.
  #      ExecStop = "/run/wrappers/bin/fusermount -u ${mountdir}";
  #      Type = "notify";
  #      Restart = "always";
  #      RestartSec = "10s";
  #    };
  #  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "brave-browser.desktop";
      "x-scheme-handler/http" = "brave-browser.desktop";
      "x-scheme-handler/https" = "brave-browser.desktop";
      "x-scheme-handler/about" = "brave-browser.desktop";
      "x-scheme-handler/unknown" = "brave-browser.desktop";
    };
  };
}
