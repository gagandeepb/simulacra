{ pkgs
, lib
, beamPackages
, rhai_rustler_native
, rustler_native
, ...
}:

import ./wanda_deps.nix {
  inherit beamPackages lib;
  overrides = (final: prev: {
    rhai_rustler_built = beamPackages.buildMix rec {
      name = "rhai_rustler";
      version = "1.1.1";
      preBuild = ''
        tree ${rhai_rustler_native}
        # mix deps.compile 
      '';
      nativeBuildInputs = [ rhai_rustler_native rustler_native ];
      buildInputs = [ pkgs.tree ];
      env = {
        RUSTLER_PRECOMPILED_FORCE_BUILD_ALL = "true";
        RHAI_RUSTLER_FORCE_BUILD = "true";
        RUSTLER_PRECOMPILED_GLOBAL_CACHE_PATH = "unused-but-required";
      };
      src = beamPackages.fetchHex {
        pkg = "rhai_rustler";
        version = "${version}";
        sha256 = "sha256-ayczzkxvObTmIbjRD+BT1Oy5fvDlLqaXBpigXtE+bNM=";
      };

      beamDeps = [ prev.rustler_precompiled rustler_native ];
    };



  });
}

