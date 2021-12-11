{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      (lib.mkIf stdenv.hostPlatform.isLinux wezterm)
      gdb
    ];
    enableDebugInfo = true;
  };
  programs = {
    java.enable = true; # Needed for prusti vscode extension
    vscode = {
      enable = pkgs.stdenv.hostPlatform.isLinux;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        matklad.rust-analyzer
        ms-vscode.cpptools
        arrterian.nix-env-selector
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
        name = "prusti-assistant";
        publisher = "viper-admin";
        version = "0.9.0";
        sha256 = "sha256-6Vcz4EPirN+d4VjzMky7BSHvqMdkf6GqwPiHuPNyaIU=";
      }];
    };
  };
}
