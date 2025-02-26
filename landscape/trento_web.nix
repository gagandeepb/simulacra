{ pkgs, trento_web_src, system, ... }:

let
  elixir = pkgs.beam.packages.erlang_26.elixir_1_15;
  beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_26;

  src = trento_web_src;
  pname = "trento-web";
  version = "trentoVersion";

  mixFodDeps = beamPackages.fetchMixDeps {
    TOP_SRC = src;
    pname = "${pname}-mix-deps";
    inherit src version;
    hash = "sha256-NS7Rqr12+lWYaxhrc/fGXPBQmf1uEHx4wNI8KOEejMU=";
    #hash = pkgs.lib.fakeHash;
  };

  # nodejs = pkgs.nodejs_20;
  # nodePackages = pkgs.buildNpmPackage rec {
  #   name = "trento-web-assets";
  #   src = "${trento_web_src}/assets";
  #
  #   npmDepsHash = "sha256-K6en5njCwMbKxuBEo6JwKj6HP1IVj3wZyGV/DvbfTX8=";
  #   # npmConfigHook = pkgs.importNpmLock.npmConfigHook;
  #   # nativeBuildInputs = with pkgs; [ nodejs_20 pixman pkg-config ];
  #   dontNpmBuild = true;
  #   inherit nodejs version;
  #
  #
  #   installPhase = ''
  #     mkdir $out
  #     cp -r node_modules $out
  #     ln -s $out/node_modules/.bin $out/bin
  #   '';
  # };
  # nodePackages = pkgs.buildNpmPackage {
  #   name = "trento-web";
  #   src = "${src}/assets";
  #   buildInputs = with pkgs; [ cacert ];
  #   # __noChroot = true;
  #   # nixConfig.sandbox = "relaxed";
  #   npmDepsHash = "sha256-K6en5njCwMbKxuBEo6JwKj6HP1IVj3wZyGV/DvbfTX8=";
  #   # npmDepsHash = pkgs.lib.fakeHash;
  #   dontNpmBuild = true;
  #   inherit nodejs version;
  #
  #
  #   installPhase = ''
  #     mkdir $out
  #     cp -r node_modules $out
  #     ln -s $out/node_modules/.bin $out/bin
  #
  #   '';
  # };
  #
  pkg = beamPackages.mixRelease {
    TOP_SRC = src;
    inherit pname version elixir src mixFodDeps;

    postBuild = ''
      ln -sf ${mixFodDeps}/deps deps

      mix release
            
    '';

  };

in

pkg

