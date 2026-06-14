{ lib, beamPackages, nix-gitignore, buildNpmPackage, runCommand }:

let

  pname = "demo";
  version = "0.0.1";
  src = nix-gitignore.gitignoreSource [ ] ../..;

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit src version;
    pname = "${pname}-deps";
    hash = "sha256-kZr3oyZUoDriZEvcY8zUh5nBcIvbQESISXv7BJDI0Mc=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version;
    src = src + "/assets";
    npmDepsHash = "sha256-mgdimFLmwMmePbO1O/+3pOXi3p9fVq+D3eRSa+6ZmOY=";
    postPatch = ''
      # deps are required for phoenix live javascript.
      ln -sf ${mixFodDeps} ../deps
      # tailwindcss needs the source to determine which classes are used.
      ln -sf ${src}/lib ../lib
    '';
    installPhase = ''
      mkdir $out
      cp -r ../priv/static/assets/* $out/
    '';
  };

in

beamPackages.mixRelease rec {
  inherit pname version src;

  inherit mixFodDeps;

  postBuild = ''
    cp -r ${assets} priv/static/assets
    chmod -R +w priv/static/assets
    mix do deps.loadpaths --no-deps-check, phx.digest
  '';

  meta = with lib; {
    description = "Demo";
    homepage = "https://github.com/c0deaddict/demo";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ c0deaddict ];
    mainProgram = "demo";
    platforms = beamPackages.erlang.meta.platforms;
  };
}
