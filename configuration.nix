{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  boot.binfmt.emulatedSystems = [ "armv6l-linux" "i686-linux" ];

  environment.systemPackages = [
    pkgs.kdePackages.ark
    pkgs.binutils
    pkgs.btop
    pkgs.coreutils
    pkgs.coppwr
    pkgs.curl
    pkgs.ddrescue
    pkgs.ddrescueview
    pkgs.direnv
    pkgs.distrobox
    pkgs.dnsutils
    pkgs.dosfstools
    pkgs.fd
    pkgs.file
    pkgs.gnupg
    pkgs.gptfdisk
    pkgs.iputils
    pkgs.jq
    pkgs.manix
    pkgs.moreutils
    pkgs.nix-index
    pkgs.nix-output-monitor
    pkgs.nix-tree
    pkgs.nmap
    #pkgs.patchage TODO: broken by https://github.com/NixOS/nixpkgs/pull/320924 - See https://github.com/NixOS/nixpkgs/issues/326354
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
      pkgs.google-fonts
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
      pkgs.liberation_ttf
      pkgs.ubuntu-classic
      pkgs.fira-code
      pkgs.fira-code-symbols
      pkgs.roboto
      pkgs.roboto-slab
      pkgs.roboto-mono
      pkgs.nerd-fonts.jetbrains-mono
      pkgs._0xproto
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "0xProto" ];
      };
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      ernwong = import ./home-manager.nix "ernwong";
      guest = import ./home-manager.nix "guest";
    };
  };

  # Disabled for now. Getting das_watchdog errors and problems sleeping, so going to experiment disabling musnix to see if it helps.
  #musnix = {
  #  enable = false;
  #  kernel.realtime = true;
  #};

  # Seeing if this resolves some wifi issues I'm getting with
  # kernel 6.12.55 LTS - see #25
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  networking.nftables.enable = true; # Prefer using declarative firewall to avoid confusing states.

  nix = {
    gc.automatic = true;

    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = [
        "@wheel"
        "guest" # Needed to set up home manager
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      system-features = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cosmic.cachix.org"
        "https://ernwong.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "ernwong.cachix.org-1:wCKqhqe6/Wxq70Gft+qV2Xh/qfufrvfELgSnkpi58yA="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.gnupg.agent.enable = true;

  environment.sessionVariables.EDITOR = "nvim";
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.steam = {
    enable = true;
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish.enable = true;
    publish.domain = true;
    publish.addresses = true;
    publish.workstation = true;
  };

  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.debug = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.sessionVariables.GSK_RENDERER = "ngl"; # Temporary workaround for https://gitlab.gnome.org/GNOME/gtk/-/issues/6890, https://github.com/ErnWong/dotfiles/issues/44
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.gnome.gnome-remote-desktop.enable = true;
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  services.xrdp.openFirewall = true;

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "ernwong";
  };

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

  system.stateVersion = "23.11";

  time.timeZone = "Pacific/Auckland";

  users.users = {
    ernwong = {
      initialPassword = "pleasechangeyourpassword";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "wireshark"
      ];
      shell = pkgs.nushell;
    };
    guest = {
      initialPassword = "pleasechangeyourpassword";
      isNormalUser = true;
    };
  };
}
