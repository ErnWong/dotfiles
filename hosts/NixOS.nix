{ suites, ... }:
{
  ### root password is empty by default ###
  imports = suites.graphical;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-label/nixos";
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
  networking.wireless.enable = true;
  networking.interfaces.enp4s0f1.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  fileSystems."/" = { device = "/dev/disk/by-label/nixos"; };
  swapDevices."/" = { device = "/dev/disk/by-label/swap"; };
}
