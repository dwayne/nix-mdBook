{ fetchNpmDeps
, fetchurl
, nodejs
, npmHooks
, stdenv
, ...
}:

{ languages }:

stdenv.mkDerivation (finalAttrs: {
  pname = "highlight.js";
  version = "10.1.1";

  src = fetchurl {
    url = "https://github.com/highlightjs/${finalAttrs.pname}/archive/refs/tags/${finalAttrs.version}.tar.gz";
    hash = "sha256-TJo5Dp4DjCwlxuk2SOWzadtP+EM9ejuWW9yjObvVw7Y=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-qL9jntsrfL5oXbbno1DAGfHYSo0HmydLd5skqnpzH+k=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    npm install
    node tools/build.js ${builtins.concatStringsSep " " languages}

    runHook postBuild
  '';

  postPatch = ''
    substituteInPlace tools/build_browser.js \
      --replace-fail \
        '.execSync("git rev-parse HEAD")' \
        '.execSync("echo 93fd0d73")'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp build/highlight.min.js $out/highlight.js

    runHook postInstall
  '';
})
