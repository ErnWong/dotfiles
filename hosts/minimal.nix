{ modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/profiles/headless.nix")
      (modulesPath + "/profiles/minimal.nix")
    ];

  boot.loader.grub.device = "nodev";
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [ ];
  disabledModules =
    [
      (modulesPath + "/profiles/all-hardware.nix")
      (modulesPath + "/profiles/base.nix")
    ];

  environment.defaultPackages = [];
  xdg.icons.enable = false;
  xdg.mime.enable = false;
  xdg.sounds.enable = false;

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}