{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  makeWrapper,
  # Notice: graphs will not sync without matching upstream's major electron version
  #         the specific electron version is set at top-level file to preserve override interface.
  #         whenever updating this package also sync electron version at top-level file.
  electron,
  autoPatchelfHook,
  git,
  nix-update-script,
  fetchYarnDeps,
  nodejs_18,
  yarn,
  jdk,
  clojure,
  fixup-yarn-lock,
  node-pre-gyp,
  python3,
  nodePackages,
  pkgs,
  which,
  srcOnly,
  removeReferencesTo,
  zx,
}: let
  nodeSources = srcOnly nodejs_18;
  cljsdeps = import ./deps.nix { inherit (pkgs) fetchMavenArtifact fetchgit lib; };
  classp = cljsdeps.makeClasspaths {};
  clojureWithClasspath = pkgs.writeShellScriptBin "clojure" ''  
      exec ${clojure}/bin/clojure -Scp ${classp}
  '';

  # Gulpfile internally invokes yarn install, so here we attempt
  # to force --offline in all instances of yarn
  # Unfortunately, this doesn't work, because yarn creates a new
  # copy of yarn in the project!
  #yarnOffline = pkgs.writeShellScriptBin "yarn" ''  
  #    echo running yarn with --offline:
  #    echo ${yarn}/bin/yarn --offline $@
  #    exec ${yarn}/bin/yarn --offline $@
  #'';
in
  stdenv.mkDerivation rec {
    pname = "logseq";
    version = "0.10.9";
    src = fetchFromGitHub {
      repo = pname;
      owner = pname;
      rev = version;
      hash = "sha256-2DrxXC/GT0ZwbX9DQwG9e6h4urkMH2OCaLCEiQuo0PA=";
    };

    nativeBuildInputs = [
      nodejs_18
      #yarnOffline
      yarn
      # jdk
      clojureWithClasspath
      nodePackages.parcel
      nodePackages.node-gyp-build
      git

      which
      zx # for installing static/yarn.lock with scripts
    ];
    buildInputs = [
      fixup-yarn-lock
      node-pre-gyp
      python3
    ];

    env = {
      "ELECTRON_SKIP_BINARY_DOWNLOAD" = "1";
      "PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD" = "1";
      "PARCEL_WORKER_BACKEND" = "process";
    };

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      hash = "sha256-HHGkmiZCAtXiNeX+s+26E2WbcNH5rOSbPDYFmB6Q6xg=";
    };

    amplifyOfflineCache = fetchYarnDeps {
      yarnLock = src + "/packages/amplify/yarn.lock";
      hash = "sha256-IOhSwIf5goXCBDGHCqnsvWLf3EUPqq75xfQg55snIp4=";
    };

    tldrawOfflineCache = fetchYarnDeps {
      yarnLock = src + "/tldraw/yarn.lock";
      hash = "sha256-CtMl3MPlyO5nWfFhCC1SLb/+1HUM3YfFATAPqJg3rUo=";
    };

    # Generated by
    # cd logseq
    # nix-shell -p yarn nodejs_18
    # mkdir -p static
    # cp resources/package.json static
    # cd static
    # yarn install --mode update-lockfile
    resourcesOfflineCache = (fetchYarnDeps {
      yarnLock = ./resources-yarn.lock;
      #hash = "sha256-6rhHLAf4Tdz9BQOQx4yGGcJFDXTZEyTGL7EYeUyySAk=";
      hash = "sha256-s2DRAsZgXtjagrkZOZm931GPpm3Z4UUzpZvVwLK+wvE=";
      # TODO https://github.com/desktop/dugite/issues/182
      # https://github.com/desktop/dugite/issues/462
      postBuild = ''
        echo EPHW Fixing up dugite - removing git download and providing our own copy
        mkdir -p dugsitefix
        pushd dugsitefix
          tar --extract --file "$out/dugite___dugite_2.5.1.tgz"
          rm "$out/dugite___dugite_2.5.1.tgz"
          sed -i 's|"postinstall": "node ./script/download-git.js",||' package/package.json 
          ln -s ${git} git
          tar --create --gzip --file "$out/dugite___dugite_2.5.1.tgz" .
        popd

        # Remove hashes/integrity for this package or else yarn will try removing it from the read only offline cache
        sed -i 's|dugite-2.5.1.tgz#6ab808ebf321809edf42d974e62eea9c9e256722|dugite-2.5.1.tgz|g' "$out/yarn.lock"
        sed -i 's|integrity sha512-9OjUguynzq8v3GSmp01kbVcMmErc65ZZ0OssO/0PM2RyhD8Dzb8cCuy3z72+IxLwPwNi754jZ0FtMLAFA3D0qA==||g' "$out/yarn.lock"
      '';
    });

    patches = [
      ./dist-amplify.patch
    ];

    configurePhase = ''
      runHook preConfigure

      export HOME=$(mktemp -d)

      echo ephw before fixup
      cat yarn.lock

      sed -i "s|cp.execSync('yarn'|cp.execSync('which yarn',{stdio:'inherit'});cp.execSync('yarn --offline'|g" gulpfile.js

      yarn config --offline set yarn-offline-mirror "$tldrawOfflineCache"
      fixup-yarn-lock tldraw/yarn.lock
      yarn --offline --cwd tldraw/ install  --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts

      yarn config --offline set yarn-offline-mirror "$yarnOfflineCache"
      fixup-yarn-lock yarn.lock
      yarn install --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts --ignore-optional


      yarn config --offline set yarn-offline-mirror "$amplifyOfflineCache"
      fixup-yarn-lock packages/amplify/yarn.lock
      yarn --offline --cwd packages/amplify/ install --frozen-lockfile --offline --no-progress --non-interactive --ignore-optional --ignore-scripts --dist-dir dist

      echo ephw after fixup
      cat yarn.lock

      mkdir -p static
      #cp ${./resources-yarn.lock} static/yarn.lock
      cp ${resourcesOfflineCache}/yarn.lock static/yarn.lock
      cp resources/package.json static/package.json
      fixup-yarn-lock static/yarn.lock
      cat static/yarn.lock
      echo before install static/yarn.lock
      pushd static
      yarn config --offline set yarn-offline-mirror "$resourcesOfflineCache"
      yarn --offline install --frozen-lockfile --offline --no-progress --non-interactive --ignore-optional --ignore-scripts
      popd
      echo after install static/yarn.lock
      ls -la static/

      patchShebangs node_modules/
      patchShebangs tldraw/node_modules/
      patchShebangs packages/amplify/node_modules/

      runHook postConfigure
    '';

    # We need to build the binaries of all instances
    # of better-sqlite3. It has a native part that it wants to build using a
    # script which is disallowed.
    # Adapted from mkYarnModules, via https://github.com/NixOS/nixpkgs/blob/05a785be68dab86d48733e5d48d20605c4180eea/pkgs/by-name/ta/taler-wallet-core/package.nix#L84
    preBuild = ''
      for f in $(find -path '*/node_modules/better-sqlite3' -type d); do
        (cd "$f" && (
        npm run build-release --offline --nodedir="${nodeSources}"
        find build -type f -exec \
          ${lib.getExe removeReferencesTo} \
          -t "${nodeSources}" {} \;
        ))
      done
    '';

    buildPhase = ''
      yarn config --offline set yarn-offline-mirror "$yarnOfflineCache" --ignore-optional
      # yarn config --offline set yarn-offline-mirror "$amplifyOfflineCache"
      echo setting resources offline cache $resourcesOfflineCache
      yarn config --offline set yarn-offline-mirror "$resourcesOfflineCache"
      yarn --offline release-electron
      #yarn --offline release
    '';

    installPhase = ''
      #cp -ar static $out

      # For release-electron
      cp -ar static/out $out
    '';

    meta = {
      description = "Local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
      homepage = "https://github.com/logseq/logseq";
      changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
      license = lib.licenses.agpl3Plus;
      maintainers = [];
      platforms = ["x86_64-linux"] ++ lib.platforms.darwin;
      mainProgram = "logseq";
    };
  }