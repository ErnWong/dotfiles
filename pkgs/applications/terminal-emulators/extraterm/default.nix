# { mkYarnPackage, fetchFromGitHub, fetchYarnDeps, ... }:
# mkYarnPackage rec {
#   pname = "extraterm";
#   version = "0.59.0";
#   src = fetchFromGitHub {
#     owner = "sedwards2009";
#     repo = pname;
#     rev = "v${version}";
#     sha256 = "sha256-gn/Wur1sLjdC1vgMDPRGrUAY7dd5CPN5B8DNlLfoQ/g=";
#   };
#
#   # offlineCache = fetchYarnDeps {
#   #   yarnLock = src + "/yarn.lock";
#   #   sha256 = "sha256-CXYLLZd+jWnMywoUIhToL7yQPg296HxQ5zyIe7UHkO8=";
#   # };
# }

# { stdenv, fetchurl, dpkg } :
# let
#   libPath = lib.makeLibraryPath [];
# in
# stdenv.mkDerivation rec {
#   pname = "extraterm";
#   version = "0.59.3";
#   src = fetchurl {
#     url = "https://github.com/sedwards2009/extraterm/releases/download/v0.59.3/extraterm_0.59.3_amd64.deb";
#     sha256 = "";
#   };
#   nativeBuildInputs = [ dpkg ];
# }
{ stdenv
, lib
, fetchurl
, dpkg
, atk
, glib
, pango
, gdk-pixbuf
, gtk3
, cairo
, freetype
, fontconfig
, dbus
, libXi
, libXcursor
, libXdamage
, libXrandr
, libXcomposite
, libXext
, libXfixes
, libXrender
, libX11
, libXtst
, libXScrnSaver
, libxcb
, nss
, nspr
, alsa-lib
, cups
, expat
, udev
, libpulseaudio
, at-spi2-atk
, at-spi2-core
, libxshmfence
, libdrm
, libxkbcommon
, mesa
}:

let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    gtk3
    atk
    glib
    pango
    gdk-pixbuf
    cairo
    freetype
    fontconfig
    dbus
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libxcb
    libXrender
    libX11
    libXtst
    libXScrnSaver
    nss
    nspr
    alsa-lib
    cups
    expat
    udev
    libpulseaudio
    at-spi2-atk
    at-spi2-core
    libxshmfence
    libdrm
    libxkbcommon
    mesa
  ];

in
stdenv.mkDerivation rec {
  pname = "extraterm";
  version = "0.59.3";

  src = fetchurl {
    url = "https://github.com/sedwards2009/extraterm/releases/download/v${version}/extraterm_${version}_amd64.deb";
    sha256 = "sha256-EaHu0M6mioRPCH8edhYcAtuuFOtbDb3bzCoflXnFyoE=";
  };

  nativeBuildInputs = [ dpkg ];

  # Note: chrome-sandbox has setuid which causes the following error if we just did dpkg-deb -x like how hyper does it.
  #   tar: ./opt/extraterm/chrome-sandbox: Cannot change mode to rwsrwxr-x: Operation not permitted
  #   tar: Exiting with failure status due to previous errors
  #   dpkg-deb: error: tar subprocess returned error exit status 2
  # See github.com/NixOS/nixpkgs/issues/89482
  # See github.com/NixOS/nixpkgs/issues/88971
  unpackPhase = ''
    mkdir pkg
    dpkg-deb --fsys-tarfile $src | tar --directory pkg -x --no-same-permissions --no-same-owner
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"
    ln -s "$out/opt/extraterm/extraterm" "$out/bin/extraterm"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/extraterm:\$ORIGIN" "$out/opt/extraterm/extraterm"
    mv usr/* "$out/"
    substituteInPlace $out/share/applications/extraterm.desktop \
      --replace "/opt/extraterm/extraterm" "extraterm"
  '';

  dontPatchELF = true;
  # meta = with lib; {
  #   description = "The swiss army chainsaw of terminal emulators";
  #   homepage    = "https://extraterm.org/";
  #   maintainers = with maintainers; [ ];
  #   license     = licenses.mit;
  #   platforms   = [ "x86_64-linux" ];
  # };
}
