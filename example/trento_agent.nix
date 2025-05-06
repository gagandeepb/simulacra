{ pkgs, trento_agent_src }:
with pkgs;
buildGoModule rec {
  pname = "trento-agent";
  version = "2.4.0";

  src = trento_agent_src;
  vendorHash = "sha256-JDf+09pEKERhq1Yjsn403fOTjAhT3VaZo+YBcw3TNfo=";
  doCheck = false;

  meta = {
    description = "Trento Agent, written in Go";
  };
}
