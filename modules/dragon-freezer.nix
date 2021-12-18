# TODO: See github.com/KDE/plasma-desktop/blob/master/kcms/mouse/backends/x11/evdev_settings.cpp

{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dragon-freezer;
  calculatedSettings = {
    kcminputrc.Mouse.cursorTheme = cfg.settings.mouse.cursorTheme;
    #kcminputrc.Mouse.Acceleration = cfg.settings.mouse.acceleration;
    #kcminputrc.Mouse.Threshold = cfg.settings.mouse.threshold;
    #kcminputrc.Mouse.MouseButtonMapping = cfg.settings.mouse.buttonMapping;
    #kcminputrc.Mouse.ReverseScrollPolarity = cfg.settings.mouse.reverseScrollPolarity;
  };
  mergedSettings = recursiveUpdate calculatedSettings cfg.extraSettings;
  groupPathToString = groupPath:
    strings.concatMapStrings (group: "[${group}]") groupPath;
  mergeGroups = group: entry: {
    groupPath = entry.groupPath;
    keyValues = group.keyValues ++ [{
      key = entry.key;
      value = entry.value;
    }];
  };
  flattenIntoGroups = settings:
    let
      settingsWithoutNull = attrsets.filterAttrsRecursive
        (_name: value: value != null)
        settings;
      entriesTree = attrsets.mapAttrsRecursive
        (path: value: {
          __dragon-freezer-leaf = true;
          groupPath = lists.init path;
          key = lists.last path;
          inherit value;
        })
        settingsWithoutNull;
      entriesList = attrsets.collect
        (x: isAttrs x && x ? __dragon-freezer-leaf)
        entriesTree;
      entryToGroupString = entry: groupPathToString entry.groupPath;
    in
    attrsets.attrValues
      (lists.groupBy'
        mergeGroups
        { groupPath = [ ]; keyValues = [ ]; }
        entryToGroupString
        entriesList);
  keyValueToString = { key, value }:
    let
      immutableMarker = if cfg.immutable then "[$i]" else "";
    in
    "${key}${immutableMarker}=${value}\n";
  groupToString = { groupPath, keyValues }:
    ''
      ${groupPathToString groupPath}
      ${strings.concatMapStrings keyValueToString keyValues}
    '';
  toIni = _fileName: settings:
    strings.concatMapStrings groupToString (flattenIntoGroups settings);
  files = mapAttrs toIni mergedSettings;
  fileDerivations = mapAttrs (fileName: pkgs.writeTextDir "etc/xdg/${fileName}") files;
  configDir = pkgs.symlinkJoin {
    name = "dragon-freezer";
    paths = attrsets.attrValues fileDerivations;
  };
in
{
  options.dragon-freezer = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables the dragon freezer.
      '';
    };

    immutable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        When true, locks your local KDE configuration (in ~/.config) and makes dragon-freezer's configuration override your local configuration. This is nondestructive, as in, it only makes dragon-freezer's configuration higher priority and leaves any existing ~/.config configuration unchanged.

        When false, your local KDE configuration will override dragon-freezer. This allows you to experiment with different settings. To update your local KDE configuration to be the same as dragon-freezer, you can click the "defaults" button in the settings app.
      '';
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = { };
    };

    settings.mouse = {
      cursorTheme = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
                    kcminputrc Mouse cursorTheme
                    Sets XCURSOR_THEME
                    Example values include breeze_cursor, Oxygen_Blue, Oxygen_Yellow,
                    System Settings -> Appearance -> Cursors
                    The value is the directory name that is searched for under one of the XDG data directories (see XDG_DATA_DIRS and XDG_DATA_HOME).
                    E.g. see /run/current-system/sw/share/icons/$cursorTheme/cursors
                    TODO: Installing new cursor themes.
                    /share/icons/Breeze_Snow
                    /share/icons/breeze_cursors
                    breeze -> /nix/store/h6l5qdh5gib5kmxgpq0ikiyp4xmn9hf9-breeze-icons-5.87.0/share/icons/breeze
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 breeze_cursors
          lrwxrwxrwx  8 root root   87 Jan  1  1970 breeze-dark -> /nix/store/h6l5qdh5gib5kmxgpq0ikiyp4xmn9hf9-breeze-icons-5.87.0/share/icons/breeze-dark
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 Breeze_Snow
          dr-xr-xr-x 14 root root 4096 Jan  1  1970 hicolor
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 KDE_Classic
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 Oxygen_Black
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 Oxygen_Blue
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 Oxygen_White
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 Oxygen_Yellow
          dr-xr-xr-x  2 root root 4096 Jan  1  1970 Oxygen_Zion
                    See wiki.archlinux.org/title/Cursor_themes
                    See man Xcursor.3 (man.archlinux.org/man/Xcursor.3) for folder format.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.extraInit = ''
      export XDG_CONFIG_DIRS="${configDir}/etc/xdg:$XDG_CONFIG_DIRS"
    '';
  };
}

# kdeglobals.KDE.widgetStyle = breeze
# kdeglobals.KDE.widgetStyle = kvantum
# kdeglobals.KDE.LookAndFeelPackage = org.kde.plasma.phone
# kdeglobals.General.ColorScheme = Numix
# kdeglobals.Icons.Theme = Numix-Circle
# kdeglobals.Icons.Theme = Ant-Dark
# plasmarc.Theme.name = org.umixproject.kde
# kcminputrc.Mouse.cursorTheme = breeze_cursors
# kwinrc."org.kde.kdecoration2".library = org.kde.kwin.aurorae
# kwinrc."org.kde.kdecoration2".theme = __aurorae__svg__Nordic
# kwinrc."org.kde.kdecoration2".theme = __aurorae__svg__Arc-Dark
# kwinrc."org.kde.kdecoration2".NoPlugin = true
# kwinrc.Windows.Placement = Maximizing
# kwinrc.Desktops.Number = 1
# kwinrc.Desktops.Rows = 1
# dolphinrc.MainWindow.MenuBar = Disabled
