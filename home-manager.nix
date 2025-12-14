username:
{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
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

    # Video/streaming
    pkgs.davinci-resolve
    pkgs.obs-studio
    (pkgs.shotcut.overrideAttrs (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.wrapGAppsHook];
    }))

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
    ((import inputs.nixpkgs {
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
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "editor.fontFamily" = "'0xProto', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;
      };
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
      nvim-treesitter # Required by nvim-nu
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
