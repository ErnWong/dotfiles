{ lib, ... }:
{
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sdb";
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "sr_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
  ];
  boot.extraModulePackages = [ ];

  networking.networkmanager.enable = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];
}