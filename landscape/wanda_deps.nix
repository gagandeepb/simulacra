{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    amqp = buildMix rec {
      name = "amqp";
      version = "4.0.0";

      src = fetchHex {
        pkg = "amqp";
        version = "${version}";
        sha256 = "4148c54dc35733e6c2f9208ff26bc61601cde2da993f752a3452442b018d5735";
      };

      beamDeps = [ amqp_client ];
    };

    amqp_client = buildRebar3 rec {
      name = "amqp_client";
      version = "4.0.3";

      src = fetchHex {
        pkg = "amqp_client";
        version = "${version}";
        sha256 = "ae945f7280617e9a4b17a6d49e3a2f496d716e8088ec29d8e94ecc79e5da7458";
      };

      beamDeps = [ credentials_obfuscation rabbit_common ];
    };

    bodyguard = buildMix rec {
      name = "bodyguard";
      version = "2.4.3";

      src = fetchHex {
        pkg = "bodyguard";
        version = "${version}";
        sha256 = "5bb6bcc04871e18d97da5822a4d5d25ec38158447cb767b2eea3e2eb99cdc351";
      };

      beamDeps = [ plug ];
    };

    bunt = buildMix rec {
      name = "bunt";
      version = "1.0.0";

      src = fetchHex {
        pkg = "bunt";
        version = "${version}";
        sha256 = "dc5f86aa08a5f6fa6b8096f0735c4e76d54ae5c9fa2c143e5a1fc7c1cd9bb6b5";
      };

      beamDeps = [];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.11";

      src = fetchHex {
        pkg = "castore";
        version = "${version}";
        sha256 = "e03990b4db988df56262852f20de0f659871c35154691427a5047f4967a16a62";
      };

      beamDeps = [];
    };

    cors_plug = buildMix rec {
      name = "cors_plug";
      version = "3.0.3";

      src = fetchHex {
        pkg = "cors_plug";
        version = "${version}";
        sha256 = "3f2d759e8c272ed3835fab2ef11b46bddab8c1ab9528167bd463b6452edf830d";
      };

      beamDeps = [ plug ];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.12.0";

      src = fetchHex {
        pkg = "cowboy";
        version = "${version}";
        sha256 = "8a7abe6d183372ceb21caa2709bec928ab2b72e18a3911aa1771639bef82651e";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.4.0";

      src = fetchHex {
        pkg = "cowboy_telemetry";
        version = "${version}";
        sha256 = "7d98bac1ee4565d31b62d59f8823dfd8356a169e7fcbb83831b8a5397404c9de";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.13.0";

      src = fetchHex {
        pkg = "cowlib";
        version = "${version}";
        sha256 = "e1e1284dc3fc030a64b1ad0d8382ae7e99da46c3246b815318a4b848873800a4";
      };

      beamDeps = [];
    };

    credentials_obfuscation = buildRebar3 rec {
      name = "credentials_obfuscation";
      version = "3.4.0";

      src = fetchHex {
        pkg = "credentials_obfuscation";
        version = "${version}";
        sha256 = "738ace0ed5545d2710d3f7383906fc6f6b582d019036e5269c4dbd85dbced566";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.11";

      src = fetchHex {
        pkg = "credo";
        version = "${version}";
        sha256 = "56826b4306843253a66e47ae45e98e7d284ee1f95d53d1612bb483f88a8cf219";
      };

      beamDeps = [ bunt file_system jason ];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.7.0";

      src = fetchHex {
        pkg = "db_connection";
        version = "${version}";
        sha256 = "dcf08f31b2701f857dfc787fbad78223d61a32204f217f15e881dd93e4bdd3ff";
      };

      beamDeps = [ telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.3.0";

      src = fetchHex {
        pkg = "decimal";
        version = "${version}";
        sha256 = "a4d66355cb29cb47c3cf30e71329e58361cfcb37c34235ef3bf1d7bf3773aeac";
      };

      beamDeps = [];
    };

    dialyxir = buildMix rec {
      name = "dialyxir";
      version = "1.4.5";

      src = fetchHex {
        pkg = "dialyxir";
        version = "${version}";
        sha256 = "b0fb08bb8107c750db5c0b324fa2df5ceaa0f9307690ee3c1f6ba5b9eb5d35c3";
      };

      beamDeps = [ erlex ];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.43";

      src = fetchHex {
        pkg = "earmark_parser";
        version = "${version}";
        sha256 = "970a3cd19503f5e8e527a190662be2cee5d98eed1ff72ed9b3d1a3d466692de8";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.12.5";

      src = fetchHex {
        pkg = "ecto";
        version = "${version}";
        sha256 = "6eb18e80bef8bb57e17f5a7f068a1719fbda384d40fc37acb8eb8aeca493b6ea";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.12.1";

      src = fetchHex {
        pkg = "ecto_sql";
        version = "${version}";
        sha256 = "aff5b958a899762c5f09028c847569f7dfb9cc9d63bdb8133bff8a5546de6bf5";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    elixir_uuid = buildMix rec {
      name = "elixir_uuid";
      version = "1.2.1";

      src = fetchHex {
        pkg = "elixir_uuid";
        version = "${version}";
        sha256 = "f7eba2ea6c3555cea09706492716b0d87397b88946e6380898c2889d68585752";
      };

      beamDeps = [];
    };

    erlex = buildMix rec {
      name = "erlex";
      version = "0.2.7";

      src = fetchHex {
        pkg = "erlex";
        version = "${version}";
        sha256 = "3ed95f79d1a844c3f6bf0cea61e0d5612a42ce56da9c03f01df538685365efb0";
      };

      beamDeps = [];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.37.1";

      src = fetchHex {
        pkg = "ex_doc";
        version = "${version}";
        sha256 = "6774f75477733ea88ce861476db031f9399c110640752ca2b400dbbb50491224";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
    };

    ex_machina = buildMix rec {
      name = "ex_machina";
      version = "2.8.0";

      src = fetchHex {
        pkg = "ex_machina";
        version = "${version}";
        sha256 = "79fe1a9c64c0c1c1fab6c4fa5d871682cb90de5885320c187d117004627a7729";
      };

      beamDeps = [ ecto ecto_sql ];
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
      version = "0.18.5";

      src = fetchHex {
        pkg = "excoveralls";
        version = "${version}";
        sha256 = "523fe8a15603f86d64852aab2abe8ddbd78e68579c8525ae765facc5eae01562";
      };

      beamDeps = [ castore jason ];
    };

    faker = buildMix rec {
      name = "faker";
      version = "0.18.0";

      src = fetchHex {
        pkg = "faker";
        version = "${version}";
        sha256 = "bfbdd83958d78e2788e99ec9317c4816e651ad05e24cfd1196ce5db5b3e81797";
      };

      beamDeps = [];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "1.1.0";

      src = fetchHex {
        pkg = "file_system";
        version = "${version}";
        sha256 = "bfcf81244f416871f2a2e15c1b515287faa5db9c6bcf290222206d120b3d43f6";
      };

      beamDeps = [];
    };

    google_protos = buildMix rec {
      name = "google_protos";
      version = "0.4.0";

      src = fetchHex {
        pkg = "google_protos";
        version = "${version}";
        sha256 = "4c54983d78761a3643e2198adf0f5d40a5a8b08162f3fc91c50faa257f3fa19f";
      };

      beamDeps = [ protobuf ];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.4";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "c5eb0cab91f094599f94d55bc63409236a8ec69a21a67814529e8d5f6cc90b3b";
      };

      beamDeps = [ decimal ];
    };

    joken = buildMix rec {
      name = "joken";
      version = "2.6.2";

      src = fetchHex {
        pkg = "joken";
        version = "${version}";
        sha256 = "5134b5b0a6e37494e46dbf9e4dad53808e5e787904b7c73972651b51cce3d72b";
      };

      beamDeps = [ jose ];
    };

    jose = buildMix rec {
      name = "jose";
      version = "1.11.10";

      src = fetchHex {
        pkg = "jose";
        version = "${version}";
        sha256 = "0d6cd36ff8ba174db29148fc112b5842186b68a90ce9fc2b3ec3afe76593e614";
      };

      beamDeps = [];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.2.1";

      src = fetchHex {
        pkg = "makeup";
        version = "${version}";
        sha256 = "d36484867b0bae0fea568d10131197a4c2e47056a6fbe84922bf6ba71c8d17ce";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "1.0.1";

      src = fetchHex {
        pkg = "makeup_elixir";
        version = "${version}";
        sha256 = "7284900d412a3e5cfd97fdaed4f5ed389b8f2b4cb49efc0eb3bd10e2febf9507";
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "1.0.2";

      src = fetchHex {
        pkg = "makeup_erlang";
        version = "${version}";
        sha256 = "af33ff7ef368d5893e4a267933e7744e46ce3cf1f61e2dccf53a111ed3aa3727";
      };

      beamDeps = [ makeup ];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.6";

      src = fetchHex {
        pkg = "mime";
        version = "${version}";
        sha256 = "c9945363a6b26d747389aac3643f8e0e09d30499a138ad64fe8fd1d13d9b153e";
      };

      beamDeps = [];
    };

    mox = buildMix rec {
      name = "mox";
      version = "1.2.0";

      src = fetchHex {
        pkg = "mox";
        version = "${version}";
        sha256 = "c7b92b3cc69ee24a7eeeaf944cd7be22013c52fcb580c1f33f50845ec821089a";
      };

      beamDeps = [ nimble_ownership ];
    };

    nimble_ownership = buildMix rec {
      name = "nimble_ownership";
      version = "1.0.1";

      src = fetchHex {
        pkg = "nimble_ownership";
        version = "${version}";
        sha256 = "3825e461025464f519f3f3e4a1f9b68c47dc151369611629ad08b636b73bb22d";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.4.2";

      src = fetchHex {
        pkg = "nimble_parsec";
        version = "${version}";
        sha256 = "4b21398942dda052b403bbe1da991ccd03a053668d147d53fb8c4e0efe09c973";
      };

      beamDeps = [];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
      version = "3.21.2";

      src = fetchHex {
        pkg = "open_api_spex";
        version = "${version}";
        sha256 = "f42ae6ed668b895ebba3e02773cfb4b41050df26f803f2ef634c72a7687dc387";
      };

      beamDeps = [ decimal jason plug ];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.19";

      src = fetchHex {
        pkg = "phoenix";
        version = "${version}";
        sha256 = "ba4dc14458278773f905f8ae6c2ec743d52c3a35b6b353733f64f02dfe096cd6";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_template phoenix_view plug plug_cowboy plug_crypto telemetry websock_adapter ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.6.3";

      src = fetchHex {
        pkg = "phoenix_ecto";
        version = "${version}";
        sha256 = "909502956916a657a197f94cc1206d9a65247538de8a5e186f7537c895d95764";
      };

      beamDeps = [ ecto plug postgrex ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.3";

      src = fetchHex {
        pkg = "phoenix_pubsub";
        version = "${version}";
        sha256 = "bba06bc1dcfd8cb086759f0edc94a8ba2bc8896d5331a1e2c2902bf8e36ee502";
      };

      beamDeps = [];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.4";

      src = fetchHex {
        pkg = "phoenix_template";
        version = "${version}";
        sha256 = "2c0c81f0e5c6753faf5cca2f229c9709919aba34fab866d3bc05060c9c444206";
      };

      beamDeps = [];
    };

    phoenix_view = buildMix rec {
      name = "phoenix_view";
      version = "2.0.4";

      src = fetchHex {
        pkg = "phoenix_view";
        version = "${version}";
        sha256 = "4e992022ce14f31fe57335db27a28154afcc94e9983266835bb3040243eb620b";
      };

      beamDeps = [ phoenix_template ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.16.1";

      src = fetchHex {
        pkg = "plug";
        version = "${version}";
        sha256 = "a13ff6b9006b03d7e33874945b2755253841b238c34071ed85b0e86057f8cddc";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.7.2";

      src = fetchHex {
        pkg = "plug_cowboy";
        version = "${version}";
        sha256 = "245d8a11ee2306094840c000e8816f0cbed69a23fc0ac2bcf8d7835ae019bb2f";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "2.1.0";

      src = fetchHex {
        pkg = "plug_crypto";
        version = "${version}";
        sha256 = "131216a4b030b8f8ce0f26038bc4421ae60e4bb95c5cf5395e1421437824c4fa";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.20.0";

      src = fetchHex {
        pkg = "postgrex";
        version = "${version}";
        sha256 = "d36ef8b36f323d29505314f704e21a1a038e2dc387c6409ee0cd24144e187c0f";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    protobuf = buildMix rec {
      name = "protobuf";
      version = "0.12.0";

      src = fetchHex {
        pkg = "protobuf";
        version = "${version}";
        sha256 = "75fa6cbf262062073dd51be44dd0ab940500e18386a6c4e87d5819a58964dc45";
      };

      beamDeps = [ jason ];
    };

    rabbit_common = buildRebar3 rec {
      name = "rabbit_common";
      version = "4.0.3";

      src = fetchHex {
        pkg = "rabbit_common";
        version = "${version}";
        sha256 = "ead31ba292c2cc5fda48a486417d7cfe8966f661994d7ed6c3e5f8840828e8ec";
      };

      beamDeps = [ credentials_obfuscation ranch recon thoas ];
    };

    ranch = buildRebar3 rec {
      name = "ranch";
      version = "2.1.0";

      src = fetchHex {
        pkg = "ranch";
        version = "${version}";
        sha256 = "244ee3fa2a6175270d8e1fc59024fd9dbc76294a321057de8f803b1479e76916";
      };

      beamDeps = [];
    };

    recon = buildMix rec {
      name = "recon";
      version = "2.5.6";

      src = fetchHex {
        pkg = "recon";
        version = "${version}";
        sha256 = "96c6799792d735cc0f0fd0f86267e9d351e63339cbe03df9d162010cefc26bb0";
      };

      beamDeps = [];
    };

    rhai_rustler = buildMix rec {
      name = "rhai_rustler";
      version = "1.1.1";

      src = fetchHex {
        pkg = "rhai_rustler";
        version = "${version}";
        sha256 = "6b2733ce4c6f39b4e621b8d10fe053d4ecb97ef0e52ea6970698a05ed13e6cd3";
      };

      beamDeps = [ rustler rustler_precompiled ];
    };

    rustler = buildMix rec {
      name = "rustler";
      version = "0.31.0";

      src = fetchHex {
        pkg = "rustler";
        version = "${version}";
        sha256 = "99e378459bfb9c3bda6d3548b2b3bc6f9ad97f728f76bdbae7bf5c770a4f8abd";
      };

      beamDeps = [ jason toml ];
    };

    rustler_precompiled = buildMix rec {
      name = "rustler_precompiled";
      version = "0.7.3";

      src = fetchHex {
        pkg = "rustler_precompiled";
        version = "${version}";
        sha256 = "cbc4b3777682e5f6f43ed39b0e0b4a42dccde8053aba91b4514e8f5ff9a5ac6d";
      };

      beamDeps = [ castore rustler ];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.3.0";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "7015fc8919dbe63764f4b4b87a95b7c0996bd539e0d499be6ec9d7f3875b79e6";
      };

      beamDeps = [];
    };

    telemetry_metrics = buildMix rec {
      name = "telemetry_metrics";
      version = "1.1.0";

      src = fetchHex {
        pkg = "telemetry_metrics";
        version = "${version}";
        sha256 = "e7b79e8ddfde70adb6db8a6623d1778ec66401f366e9a8f5dd0955c56bc8ce67";
      };

      beamDeps = [ telemetry ];
    };

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "1.1.0";

      src = fetchHex {
        pkg = "telemetry_poller";
        version = "${version}";
        sha256 = "9eb9d9cbfd81cbd7cdd24682f8711b6e2b691289a0de6826e58452f28c103c8f";
      };

      beamDeps = [ telemetry ];
    };

    thoas = buildRebar3 rec {
      name = "thoas";
      version = "1.2.1";

      src = fetchHex {
        pkg = "thoas";
        version = "${version}";
        sha256 = "e38697edffd6e91bd12cea41b155115282630075c2a727e7a6b2947f5408b86a";
      };

      beamDeps = [];
    };

    toml = buildMix rec {
      name = "toml";
      version = "0.7.0";

      src = fetchHex {
        pkg = "toml";
        version = "${version}";
        sha256 = "0690246a2478c1defd100b0c9b89b4ea280a22be9a7b313a8a058a2408a2fa70";
      };

      beamDeps = [];
    };

    unplug = buildMix rec {
      name = "unplug";
      version = "1.1.0";

      src = fetchHex {
        pkg = "unplug";
        version = "${version}";
        sha256 = "a3b302125ed60b658a9a7c0dff6941050bfc56dc77a0bca72facdb743159898f";
      };

      beamDeps = [ plug ];
    };

    websock = buildMix rec {
      name = "websock";
      version = "0.5.3";

      src = fetchHex {
        pkg = "websock";
        version = "${version}";
        sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
      };

      beamDeps = [];
    };

    websock_adapter = buildMix rec {
      name = "websock_adapter";
      version = "0.5.8";

      src = fetchHex {
        pkg = "websock_adapter";
        version = "${version}";
        sha256 = "315b9a1865552212b5f35140ad194e67ce31af45bcee443d4ecb96b5fd3f3782";
      };

      beamDeps = [ plug plug_cowboy websock ];
    };

    yamerl = buildRebar3 rec {
      name = "yamerl";
      version = "0.10.0";

      src = fetchHex {
        pkg = "yamerl";
        version = "${version}";
        sha256 = "346adb2963f1051dc837a2364e4acf6eb7d80097c0f53cbdc3046ec8ec4b4e6e";
      };

      beamDeps = [];
    };

    yaml_elixir = buildMix rec {
      name = "yaml_elixir";
      version = "2.11.0";

      src = fetchHex {
        pkg = "yaml_elixir";
        version = "${version}";
        sha256 = "53cc28357ee7eb952344995787f4bb8cc3cecbf189652236e9b163e8ce1bc242";
      };

      beamDeps = [ yamerl ];
    };
  };
in self

