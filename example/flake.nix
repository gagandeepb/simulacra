{
  description = "Trento Integration Tests";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    trento_agent_src = {
      url = "github:trento-project/agent/refs/tags/2.4.0";
      flake = false;
    };
    trento_web_src = {
      url = "github:trento-project/web/refs/tags/2.4.0";
      flake = false;
    };
    trento_wanda_src = {
      url = "github:trento-project/wanda/alt-experiment";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, trento_agent_src, trento_web_src, trento_wanda_src, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { config = { }; overlays = [ ]; system = system; };
      trento_agent = import ./trento_agent.nix { inherit pkgs trento_agent_src; };
      trento_web_release = import ./trento_web.nix { inherit pkgs trento_web_src system; };
      prometheus_node_exporter = pkgs.prometheus-node-exporter;
      trento_wanda_release = import ./trento_wanda.nix { inherit pkgs trento_wanda_src system; };
    in

    {
      # devShell.default = pkgs.mkShell {
      #   buildInputs = with pkgs; [ pkg-config rust-bin.stable.latest.default ];
      # };
      packages."x86_64-linux".trento_agent = trento_agent;
      # packages."x86_64-linux".rustler = inputs.rustler.packages.${system}.default;
      packages."x86_64-linux".default = trento_wanda_release;
      # packages."x86_64-linux".default = pkgs.testers.runNixOSTest (import ./test.nix { inherit pkgs trento_agent prometheus_node_exporter trento_web_release trento_wanda_release; });

      checks."x86_64-linux".default = pkgs.testers.runNixOSTest (import ./test.nix {
        inherit trento_agent prometheus_node_exporter;
      });
    };
}
