{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader.grub.enable = true;
  boot.loader.grub.configurationLimit = 42;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Note: Put EFI System Partition within /boot rather than be /boot,
  # so we don't need to put kernel inside the partition and run into
  # out-of-space issues. See #43
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
  };

  # Note: Put EFI System Partition within /boot rather than be /boot,
  # so we don't need to put kernel inside the partition and run into
  # out-of-space issues.
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [
      "umask=0077"
      "defaults"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  #networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  networking.hostName = "kaiki";

  # Internet Connection Sharing - share the wifi internet with ethernet.
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  networking.interfaces."eno1" = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
  };
  networking.nftables.ruleset = ''
    table ip nat {
      chain POSTROUTING {
        type nat hook postrouting priority 100;
        oifname "wlp11s0" counter masquerade
      }
    }
    table ip filter {
      chain INPUT {
        iifname "eno1" counter accept
      }
    }
  '';
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [
          "eno1"
        ];
      };
      lease-database = {
        name = "/var/lib/kea/dhcp4.leases";
        persist = true;
        type = "memfile";
      };
      rebind-timer = 2000;
      renew-timer = 1000;
      subnet4 = [
        {
          id = 1;
          pools = [
            {
              pool = "10.0.0.2 - 10.0.0.255";
            }
          ];
          subnet = "10.0.0.1/24";
        }
      ];
      valid-lifetime = 4000;
      option-data = [{
        name = "routers";
        data = "10.0.0.1";
      }];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    rocmPackages.clr
    rocmPackages.rocm-runtime
  ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
