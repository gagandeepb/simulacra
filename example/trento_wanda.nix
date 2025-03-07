{ pkgs, trento_wanda_src, system, ... }:

let
  elixir = pkgs.beam.packages.erlang_26.elixir_1_15;
  beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_26;
  lib = pkgs.lib;

  src = trento_wanda_src;
  pname = "trento-wanda";
  version = "wandaVersion";

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "${pname}-mix-deps";
    inherit src version;
    hash = "sha256-QVCOUcIn1shCA5EWDwHkzNZpMFcsqxWnFhYb0cDdzl8=";
    #hash = pkgs.lib.fakeHash;
  };

  pkg = beamPackages.mixRelease
    {
      inherit pname version src;

      mixFodDeps = mixFodDeps;
      env = {
        APP_VERSION = version;
        RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "false";
        RHAI_RUSTLER_FORCE_BUILD = "false";
        RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";
      };
      postBuild = ''
        mix do deps.loadpaths --no-deps-check, phx.digest
      '';

    };

in

pkg



