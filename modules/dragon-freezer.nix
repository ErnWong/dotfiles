# TODO: See github.com/KDE/plasma-desktop/blob/master/kcms/mouse/backends/x11/evdev_settings.cpp

{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.dragon-freezer;
  calculatedSettings = {
    kdeglobals.KDE.widgetStyle = cfg.settings.systemSettings.appearance.applicationStyle.widgetStyle;
    kdeglobals.KDE.ShowIconsOnPushButtons = cfg.settings.systemSettings.appearance.applicationStyle.showIconsOnButtons;
    kdeglobals.KDE.ShowIconsInMenuItems = cfg.settings.systemSettings.appearance.applicationStyle.showIconsInMenus;
    kcminputrc.Mouse.cursorTheme = cfg.settings.mouse.cursorTheme;
    kcminputrc.Mouse.cursorSize = toString cfg.settings.mouse.cursorSize;
    # kcminputrc.Mouse.Acceleration = cfg.settings.mouse.acceleration;
    # kcminputrc.Mouse.Threshold = cfg.settings.mouse.threshold;
    # kcminputrc.Mouse.MouseButtonMapping = cfg.settings.mouse.buttonMapping;
    # kcminputrc.Mouse.ReverseScrollPolarity = cfg.settings.mouse.reverseScrollPolarity;
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

    settings = {
      systemSettings = {
        appearance = {
          applicationStyle = {
            widgetStyle = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                kdeglobals KDE widgetStyle

                How individual widgets are drawn, i.e. the buttons, menus, and scroll bars.

                Example values include "Breeze", "Fusion", "Windows", "Oxygen"

                This appears to be directly related to qt's widget style plugins.
                Might be related to /run/current-system/sw/lib/qt-5.15.3/plugins/styles/
                Fusion and Windows are builtin to Qt, and so it's probably why they aren't found in that folder.

                The GUI for this setting is implemented in https://github.com/KDE/plasma-workspace/blob/c6a46adf16aa1f3debf83d96214a3f33316c9cf5/kcms/style/package/contents/ui/main.qml

                .kcfg XML file: https://github.com/KDE/plasma-workspace/blob/add0a50ddae00d45bfc3dc25c4db7938129bed01/kcms/style/stylesettings.kcfg

                TODO: Figure out how kvantum and qtcurve fits into this picture.
              '';
            };
            showIconsOnButtons = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = ''
                kdeglobals KDE ShowIconsOnPushButtons

                Whether action buttons like OK and Apply will have a small icon.

                The GUI for this setting is implemented in https://github.com/KDE/plasma-workspace/blob/c6a46adf16aa1f3debf83d96214a3f33316c9cf5/kcms/style/package/contents/ui/EffectSettingsPopup.qml

                .kcfg XML file: https://github.com/KDE/plasma-workspace/blob/add0a50ddae00d45bfc3dc25c4db7938129bed01/kcms/style/stylesettings.kcfg
              '';
            };
            showIconsInMenus = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = ''
                kdeglobals KDE ShowIconsInMenuItems

                Whether menu items show small icons alongside them.

                The GUI for this setting is implemented in https://github.com/KDE/plasma-workspace/blob/c6a46adf16aa1f3debf83d96214a3f33316c9cf5/kcms/style/package/contents/ui/EffectSettingsPopup.qml

                .kcfg XML file: https://github.com/KDE/plasma-workspace/blob/add0a50ddae00d45bfc3dc25c4db7938129bed01/kcms/style/stylesettings.kcfg
              '';
            };
          };
        };
      };
      mouse = {
        cursorTheme = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
                      kcminputrc Mouse cursorTheme
                      Sets XCURSOR_THEME
                      Example values include breeze_cursors, Oxygen_Blue, Oxygen_Yellow,
                      System Settings -> Appearance -> Cursors
                      The value is the directory name that is searched for under one of the XDG data directories (see XDG_DATA_DIRS and XDG_DATA_HOME). Note that this is different to the name shown in System Settings, as that cursor theme name comes from the index.theme file's "Icon Theme".Name values.
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
                      See settings.mouse.cursorSize for changing the size.
                      See man Xcursor.3 (man.archlinux.org/man/Xcursor.3) for folder format.
          '';
        };
        cursorSize = mkOption {
          type = types.nullOr types.int;
          default = null;
          description = ''
            kcminputrc Mouse cursorSize
            Sets XCURSOR_SIZE
            Note that not all sizes might be supported by the selected cursor theme. For example, Breeze supports 24, 36, 48, while Oxygen Blue supports 24, 48, 72.
            System Settings -> Appearance -> Cursors
            See settings.mouse.cursorTheme for changing the images used for the cursors.
            See https://wiki.archlinux.org/title/Cursor_themes
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # Note: when used as a nixos module, changes don't take affect until
    # logging out and logging back in. However, no restart is necessary.
    # Also, updated cursor don't affect programs that are already running - only
    # affects subsequently started programs.
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

# "plasma-org.kde.plasma.desktop-appletsrc":
#   . Containments."2".General.AppletOrder=3;4;5;6;7;16;17

# {
#   Containments = {
#     "2" = panel [
#       kickoff
#       pager
#       icontasks
#       marginseparator
#       (systemtray 8)
#       digitalclock
#       showdesktop
#     ];
#     "8" = private.systemtray [
#       notifications
#       devicenotifier
#       clipboard
#       printmanager
#       nightcolorcontrol
#       keyboardindicator
#       volume
#       manage-inputmethod
#       keyboardlayout
#       networkmanagement
#       battery
#       mediacontroller
#     ];
#     "20" = folder;
#   };
# }
