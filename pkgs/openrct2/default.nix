{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  SDL2,
  cmake,
  curl,
  discord-rpc,
  duktape,
  expat,
  flac,
  fontconfig,
  freetype,
  gbenchmark,
  icu,
  jansson,
  libGLU,
  libiconv,
  libogg,
  libpng,
  libpthreadstubs,
  libvorbis,
  libzip,
  nlohmann_json,
  openssl,
  pkg-config,
  speexdsp,
  zlib,
}:

let
  openrct2-version = "0.4.10-develop";

  # Those versions MUST match the pinned versions within the CMakeLists.txt
  # file. The REPLAYS repository from the CMakeLists.txt is not necessary.
  objects-version = "1.4.4";
  openmsx-version = "1.5";
  opensfx-version = "1.0.5";
  title-sequences-version = "0.4.6";

  openrct2-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "b0a3888d4de0950b4e9065a2861aaf00aba79592";
    hash = "sha256-c24tSGOzIWdQn9oKC/leYrRZfg7ebPpjeadH+thEzHA=";
  };

  objects-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "objects";
    rev = "v${objects-version}";
    hash = "sha256-wKxWp/DSKkxCEI0lp4X8F9LxQsUKZfLk2CgajQ+y84k=";
  };

  openmsx-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenMusic";
    rev = "v${openmsx-version}";
    hash = "sha256-p/wlvQFfu3R+jIuCcRbTMvxt0VKGGwJw0NDIsf6URWI=";
  };

  opensfx-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenSoundEffects";
    rev = "v${opensfx-version}";
    hash = "sha256-ucADnMLGm36eAo+NiioxEzeMqtu7YbGF9wsydK1mmoE=";
  };

  title-sequences-src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "title-sequences";
    rev = "v${title-sequences-version}";
    hash = "sha256-HWp2ecClNM/7O3oaydVipOnEsYNP/bZnZFS+SDidPi0=";
  };
in
stdenv.mkDerivation {
  pname = "openrct2-develop";
  version = openrct2-version;

  src = openrct2-src;

  patches = [
    # https://github.com/OpenRCT2/OpenRCT2/pull/21043
    #
    # Basically <https://github.com/OpenRCT2/OpenRCT2/pull/19785> has broken
    # OpenRCT2 - at least with older maps, as were used for testing - as stated
    # in <https://github.com/NixOS/nixpkgs/issues/263025>.
    (fetchpatch {
      name = "remove-openrct2-music.patch";
      url = "https://github.com/OpenRCT2/OpenRCT2/commit/9ea13848be0b974336c34e6eb119c49ba42a907c.patch";
      hash = "sha256-2PPRqUZf4+ys89mdzp5nvdtdv00V9Vzj3v/95rmlf1c=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    curl
    discord-rpc
    duktape
    expat
    flac
    fontconfig
    freetype
    gbenchmark
    icu
    jansson
    libGLU
    libiconv
    libogg
    libpng
    libpthreadstubs
    libvorbis
    libzip
    nlohmann_json
    openssl
    speexdsp
    zlib
  ];

  cmakeFlags = [
    "-DDOWNLOAD_OBJECTS=OFF"
    "-DDOWNLOAD_OPENMSX=OFF"
    "-DDOWNLOAD_OPENSFX=OFF"
    "-DDOWNLOAD_TITLE_SEQUENCES=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=maybe-uninitialized"
  ];

  postUnpack = ''
    mkdir -p $sourceRoot/data/assetpack

    cp -r ${objects-src}         $sourceRoot/data/object
    cp -r ${openmsx-src}         $sourceRoot/data/assetpack/openrct2.music.alternative.parkap
    cp -r ${opensfx-src}         $sourceRoot/data/assetpack/openrct2.sound.parkap
    cp -r ${title-sequences-src} $sourceRoot/data/sequence
  '';

  preConfigure =
    # Verify that the correct version of each third party repository is used.
    let
      versionCheck = cmakeKey: version: ''
        grep -q '^set(${cmakeKey}_VERSION "${version}")$' CMakeLists.txt \
          || (echo "${cmakeKey} differs from expected version!"; exit 1)
      '';
    in
    (versionCheck "OBJECTS" objects-version)
    + (versionCheck "OPENMSX" openmsx-version)
    + (versionCheck "OPENSFX" opensfx-version)
    + (versionCheck "TITLE_SEQUENCE" title-sequences-version);

  preFixup = "ln -s $out/share/openrct2 $out/bin/data";

  meta = with lib; {
    description = "Open source re-implementation of RollerCoaster Tycoon 2 (original game required)";
    homepage = "https://openrct2.io/";
    downloadPage = "https://github.com/OpenRCT2/OpenRCT2/releases";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ oxzi ];
  };
}
