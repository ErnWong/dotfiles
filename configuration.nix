{ pkgs, inputs, lib, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  environment.systemPackages = [
    pkgs.ark
    pkgs.binutils
    pkgs.bottom
    pkgs.coreutils
    pkgs.curl
    pkgs.ddrescue
    pkgs.ddrescueview
    pkgs.direnv
    pkgs.dnsutils
    pkgs.dosfstools
    pkgs.fd
    pkgs.file
    pkgs.git
    pkgs.gptfdisk
    pkgs.iputils
    pkgs.jq
    pkgs.manix
    pkgs.moreutils
    pkgs.nix-index
    pkgs.nix-output-monitor
    pkgs.nmap
    pkgs.patchage
    pkgs.raysession
    pkgs.ripgrep
    pkgs.skim
    pkgs.tealdeer
    pkgs.unzip
    pkgs.usbutils
    pkgs.utillinux
    pkgs.whois
    pkgs.zip
  ];

  environment.shellAliases = {
    # quick cd
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";

    # git
    g = "git";
    gg = "git status -sb";
  };

  environment.enableDebugInfo = true;

  fonts = {
    fontDir.enable = true;
    packages = [
      pkgs.powerline-fonts
      pkgs.dejavu_fonts
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
      pkgs.liberation_ttf
      pkgs.ubuntu_font_family
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.roboto
      pkgs.roboto-slab
      pkgs.roboto-mono
      (pkgs.nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      ernwong = import ./home-manager.nix;
    };
  };

  networking.networkmanager.enable = true;

  nix = {
    gc.automatic = true;

    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" "@wheel" ];
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org"
        "https://cache.garnix.io"
        "https://ernwong.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "ernwong.cachix.org-1:wCKqhqe6/Wxq70Gft+qV2Xh/qfufrvfELgSnkpi58yA="
      ];

      experimental-features = [ "nix-command" "flakes" ];
    };

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  nixpkgs.config.allowUnfree = true;

  environment.sessionVariables.EDITOR = "nvim";
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.steam = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.earlyoom.enable = true;

  security.rtkit.enable = true; # Allows pipewire ask for realtime priority.
  hardware.pulseaudio.enable = false; # Conflicts with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  time.timeZone = "Pacific/Auckland";

  users.users = {
    ernwong = {
      initialPassword = "pleasechangeyourpassword";
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.nushell;
    };
  };
}
