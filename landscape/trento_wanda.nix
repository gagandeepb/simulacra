{ pkgs, trento_wanda_src, system, rhai_rustler, crane, rustler, ... }:

let
  elixir = pkgs.beam.packages.erlang_26.elixir_1_15;
  beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang_26;
  lib = pkgs.lib;

  src = trento_wanda_src;
  pname = "trento-wanda";
  version = "wandaVersion";

  craneLib = crane.mkLib pkgs;

  rhai_rustler_src = craneLib.cleanCargoSource "${rhai_rustler}/native/rhai_rustler";

  # Common arguments can be set here to avoid repeating them later
  commonArgs = {
    pname = "rhai_rustler";
    version = "1.1.1";
    src = rhai_rustler_src;
    strictDeps = true;

    buildInputs = [
      # Add additional build inputs here
    ]; #++ lib.optionals pkgs.stdenv.isDarwin [
    # Additional darwin specific inputs can be set here
    # pkgs.libiconv
    # ];

    # Additional environment variables can be set directly
    # MY_CUSTOM_VAR = "some value";
  };

  # craneLibLLvmTools = craneLib.overrideToolchain
  #   (fenix.packages.${system}.complete.withComponents [
  #     "cargo"
  #     "llvm-tools"
  #     "rustc"
  #   ]);

  # Build *just* the cargo dependencies, so we can reuse
  # all of that work (e.g. via cachix) when running in CI
  cargoArtifacts = craneLib.buildDepsOnly commonArgs;

  # Build the actual crate itself, reusing the dependency
  # artifacts from above.
  rhai_rustler_native = craneLib.buildPackage
    (commonArgs // {
      inherit cargoArtifacts;
    });
  rustler_src = craneLib.cleanCargoSource "${rustler}";
  commonArgs2 = {
    pname = "rustler";
    version = "1.2.0";
    src = rustler_src;
    strictDeps = true;
    # cargoVendorDir = null;

    buildInputs = [
      # Add additional build inputs here
    ]; #++ lib.optionals pkgs.stdenv.isDarwin [
    # Additional darwin specific inputs can be set here
    # pkgs.libiconv
    # ];

    # Additional environment variables can be set directly
    # MY_CUSTOM_VAR = "some value";
  };
  cargoArtifacts2 = craneLib.buildDepsOnly commonArgs2;
  rustler_native = craneLib.buildPackage
    (commonArgs // {
      inherit cargoArtifacts2;
    });


  # env = {
  #   RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
  #   RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";
  # };
  buildMix = pkgs.lib.makeOverridable beamPackages.buildMix;
  # rhai_rustler_built = buildMix rec {
  #   name = "rhai_rustler";
  #   version = "1.1.1";
  #   preBuild = ''
  #     tree ${rhai_rustler_native}
  #     mix deps.compile 
  #   '';
  #   nativeBuildInputs = [ rhai_rustler_native ];
  #   buildInputs = [ pkgs.tree ];
  #   # buildInputs = [ rustler rustler_precompiled ];
  #   # nativeBuildInputs = [ rustler_built ];
  #   # hash = pkgs.lib.fakeHash;
  #   # hash = "sha256-zck0NPYBt9NdhXYHcvBiVH54WGYXgeI7scPdKh6/ygQ=";
  #   env = {
  #     RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
  #     RHAI_RUSTLER_FORCE_BUILD = "true";
  #     RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";
  #   };
  #   # src = rhai_rustler;
  #   src = beamPackages.fetchHex {
  #     pkg = "rhai_rustler";
  #     version = "${version}";
  #     sha256 = "sha256-ayczzkxvObTmIbjRD+BT1Oy5fvDlLqaXBpigXtE+bNM=";
  #   };
  #
  #   beamDeps = [ rustler_precompiled rustler ];
  # };
  #
  # rustler = buildMix rec {
  #   name = "rustler";
  #   version = "0.31.0";
  #
  #   nativeBuildInputs = [ pkgs.rustup ];
  #   src = beamPackages.fetchHex {
  #     pkg = "rustler";
  #     version = "${version}";
  #     sha256 = "99e378459bfb9c3bda6d3548b2b3bc6f9ad97f728f76bdbae7bf5c770a4f8abd";
  #   };
  #
  #   beamDeps = [ jason toml ];
  # };
  #
  # rustler_precompiled = buildMix rec {
  #   name = "rustler_precompiled";
  #   version = "0.7.1";
  #
  #   nativeBuildInputs = [ pkgs.rustup ];
  #   src = beamPackages.fetchHex {
  #     pkg = "rustler_precompiled";
  #     version = "${version}";
  #     sha256 = "sha256-ueRle5mhSD6jFQLh1YxGS+3r6QKICO2kXDpCmvRVDGY=";
  #   };
  #
  #   beamDeps = [ castore rustler ];
  # };
  #
  # jason = buildMix rec {
  #   name = "jason";
  #   version = "1.0.0";
  #
  #   src = beamPackages.fetchHex {
  #     pkg = "jason";
  #     version = "${version}";
  #     sha256 = "b96c400e04b7b765c0854c05a4966323e90c0d11fee0483b1567cda079abb205";
  #   };
  #
  #   beamDeps = [ ];
  # };
  #
  #
  # decimal = buildMix rec {
  #   name = "decimal";
  #   version = "1.0.0";
  #
  #   src = beamPackages.fetchHex {
  #     pkg = "decimal";
  #     version = "${version}";
  #     sha256 = "540d210d81f56f17f64309a4896430e727972499b37bd59342dc08d61dff74d8";
  #   };
  #
  #   beamDeps = [ ];
  # };
  #
  #
  # toml = buildMix rec {
  #   name = "toml";
  #   version = "0.7.0";
  #
  #   src = beamPackages.fetchHex {
  #     pkg = "toml";
  #     version = "${version}";
  #     sha256 = "sha256-BpAkaiR4wd79EAsMm4m06igKIr6aezE6igWKJAii+nA=";
  #   };
  #
  #   beamDeps = [ ];
  # };
  #
  #
  # castore = buildMix rec {
  #   name = "castore";
  #   version = "1.0.4";
  #
  #   src = beamPackages.fetchHex {
  #     pkg = "castore";
  #     version = "${version}";
  #     sha256 = "sha256-lBjBuBROEWVvC+mZQ9tMrwRhLj6uzvtdrpoqh1ZVhPg=";
  #   };
  #
  #   beamDeps = [ ];
  # };
  #

  # mixFodDeps = beamPackages.fetchMixDeps {
  #   TOP_SRC = src;
  #   pname = "${pname}-mix-deps";
  #   inherit src version;
  #   # hash = "sha256-oXe7EgPzCq0XEbLwf5oCV3bTE8R5yjo85Yex1mEvsak=";
  #   #hash = "sha256-zck0NPYBt9NdhXYHcvBiVH54WGYXgeI7scPdKh6/ygQ=";
  #   # hash = "sha256-A8Xtz/l0Nwwa+7mVk0IsldCFHXiymKfGJrMkkHAjtqI=";
  #   # hash = "sha256-oXe7EgPzCq0XEbLwf5oCV3bTE8R5yjo85Yex1mEvsak=";
  #   # hash = "sha256-2nE2WLeeF4NLqhUfyHXGgBR5EtTmvn8dEZrjrol7vQQ=";
  #   # hash = "sha256-77fBikiY3Iplv+s4O9W8p1tYPTCLAOD9KadRh8gOCMQ=";
  #   # hash = "sha256-oXe7EgPzCq0XEbLwf5oCV3bTE8R5yjo85Yex1mEvsak=";
  #   hash = pkgs.lib.fakeHash;
  # };

  pkg = beamPackages.mixRelease
    {
      TOP_SRC = src;
      inherit pname version elixir src;

      mixNixDeps = import ./mixnix.nix { inherit pkgs lib beamPackages rhai_rustler_native rustler_native; };

      # buildInputs = [ pkgs.tree rhai_rustler_native ];
      preBuild = ''
        tree ${rhai_rustler_native}
      '';
      #
      # mkdir - p priv/native
      # cp ${rustler}/lib/librustler.so priv/native
      # cp ${rhai_rustler_built.out}/lib/librhai_rustler.so priv/native
      # cp -R ${rustler_precompiled.src}/ ./deps/rustler_precompiled
      # cp -R ${rhai_rustler_built.out}/ ./_build/
      # cp -R ${rustler_precompiled.out}/ ./_build/
      # cp -R ${rustler.out}/ ./_build/
      # '';
      nativeBuildInputs = [ rhai_rustler_native ];
      postBuild = ''
        mix do deps.loadpaths --no-deps-check, phx.digest
        mix phx.release

      '';

    };

in

pkg


