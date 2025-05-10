{ lib, beamPackages, nix-gitignore, buildNpmPackage, runCommand }:

let

  pname = "demo";
  version = "0.0.1";
  src = nix-gitignore.gitignoreSource [ ] ../..;

  mixFodDeps = beamPackages.fetchMixDeps {
    inherit src version;
    pname = "${pname}-deps";
    hash = "sha256-EbimbwX5aXLa0E905FlHTOpV0848NJwOE9eCENTGiCg=";
  };

  assets = buildNpmPackage {
    pname = "${pname}-assets";
    inherit version;
    src = src + "/assets";
    npmDepsHash = "sha256-cDT/AkbHx9WNKEYBpSXrBU2jYpJRIM5eehPI1ta0HDw=";
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

  MIX_ENV = "prod";

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
