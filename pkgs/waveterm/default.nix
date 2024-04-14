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
  nodeDeps = pkgs.mkYarnModules {
    inherit version;
    pname = "${pname}Deps";
    packageJSON = "${src}/package.json";
    yarnLock = "${src}/yarn.lock";
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

    ];
    buildInputs = [

    ];

    buildPhase = ''
      #yarn --frozen-lockfile
      cp -r "${nodeDeps}/node_modules" ./.

      #scripthaus run electron-rebuild
      #scripthaus run build-backend
      #scripthaus run webpack-build-prod
      scripthaus run build-package-linux
    '';
  }