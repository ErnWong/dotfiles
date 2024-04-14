{ pkgs, stdenv, fetchFromGitHub }:
let
  pname = "waveterm";
  version = "0.7.2";
  src = fetchFromGitHub {
    owner = "wavetermdev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NxUcBiwCK5ViAQVpx1P3pwvsr69p/ai/KztwZOFUt80=";
  };
  yarnOfflineCache = pkgs.fetchYarnDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-LGh2KmqwBfpf6MC77ME9dx43Gg3RxTpd+KSBIkEbfT0=";
  };
in
  stdenv.mkDerivation {
    inherit pname version src;
    name = "Wave Terminal";

    nativeBuildInputs = [
      pkgs.go
      pkgs.scripthaus
      pkgs.nodejs_21
      pkgs.yarn
      pkgs.fixup_yarn_lock

      pkgs.breakpointHook
    ];
    buildInputs = [

    ];

    configurePhase = ''
      # Yarn wants to write to ~/.yarnrc
      export HOME=$(mktemp -d)
    '';

    buildPhase = ''
      echo ${yarnOfflineCache}
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      fixup_yarn_lock yarn.lock
      yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --no-interactive

      # Ask scripthaus to not write history to read-only home folder.
      mkdir ./scripthaus
      export SCRIPTHAUS_HOME=$(pwd)/scripthaus
      touch ./scripthaus/.nohistory

      #mkdir ./bin
      #ls .

      echo $out

      #scripthaus run electron-rebuild
      #scripthaus run build-backend
      #scripthaus run webpack-build-prod
      scripthaus run build-package-linux
    '';
  }