{ self, config, lib, pkgs, ... }:
{
  imports = [
    ./vim
    ../cachix
  ];

  system.stateVersion = "22.11";

  environment = {

    systemPackages = with pkgs; [
      ark
      binutils
      coreutils
      curl
      direnv
      dnsutils
      dosfstools
      fd
      file
      git
      bottom
      gptfdisk
      iputils
      jq
      manix
      moreutils
      nix-index
      nmap
      ripgrep
      skim
      tealdeer
      unzip
      usbutils
      utillinux
      whois
      zip
      ddrescue
      ddrescueview
    ];

    shellAliases =
      let ifSudo = lib.mkIf config.security.sudo.enable;
      in
      {
        # quick cd
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";

        # git
        g = "git";
        gg = "git status -sb";

        # grep
        grep = "rg";
        gi = "grep -i";

        # internet ip
        myip = "dig +short myip.opendns.com @208.67.222.222 2>&1";

        # nix
        n = "nix";
        np = "n profile";
        ni = "np install";
        nr = "np remove";
        ns = "n search --no-update-lock-file";
        nf = "n flake";
        nepl = "n repl '<nixpkgs>'";
        srch = "ns nixos";
        orch = "ns override";
        nrb = ifSudo "sudo nixos-rebuild";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # fix nixos-option
        nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";

        # sudo
        s = ifSudo "sudo -E ";
        si = ifSudo "sudo -i";
        se = ifSudo "sudoedit";

        # top
        top = "btm";

        # systemd
        ctl = "systemctl";
        stl = ifSudo "s systemctl";
        utl = "systemctl --user";
        ut = "systemctl --user start";
        un = "systemctl --user stop";
        up = ifSudo "s systemctl start";
        dn = ifSudo "s systemctl stop";
        jtl = "journalctl";

      };

    enableDebugInfo = true;
  };

  fonts = {
    fontDir.enable = true;

    # TODO: Move some of these fonts to home-manager.
    # Will need to sort out the fontconfig.enable conflict.
    fonts = with pkgs; [
      powerline-fonts
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      ubuntu_font_family
      fira-code
      fira-code-symbols
      roboto
      roboto-slab
      roboto-mono
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
    ];

    fontconfig = {
      enable = lib.mkForce true;
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono for Powerline" ];
        sansSerif = [ "DejaVu Sans" ];
      };
    };
  };

  nix = {
    gc.automatic = true;

    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      sandbox = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" "@wheel" ];
      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    };

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };

  # For rage encryption, all hosts need a ssh key pair
  services.openssh = {
    enable = true;
    openFirewall = lib.mkDefault false;
  };

  services.earlyoom.enable = true;

  virtualisation.docker.enable = true;
  security.unprivilegedUsernsClone = true; # todo

  time.timeZone = "Pacific/Auckland";
}
