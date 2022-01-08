{ mkYarnPackage, fetchFromGitHub, fetchYarnDeps, ... }:
mkYarnPackage rec {
  pname = "extraterm";
  version = "0.59.0";
  src = fetchFromGitHub {
    owner = "sedwards2009";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gn/Wur1sLjdC1vgMDPRGrUAY7dd5CPN5B8DNlLfoQ/g=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    sha256 = "sha256-CXYLLZd+jWnMywoUIhToL7yQPg296HxQ5zyIe7UHkO8=";
  };
}
