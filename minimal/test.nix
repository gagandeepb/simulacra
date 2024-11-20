{
  name = "Two machines ping each other";

  nodes = {
    # These configs do not add anything to the default system setup
    machine1 = { pkgs, ... }: { };
    machine2 = { pkgs, ... }: { };
  };

  # Note that machine1 and machine2 are now available as
  # Python objects and also as hostnames in the virtual network
  testScript = ''
    machine1.wait_for_unit("network-online.target")
    machine2.wait_for_unit("network-online.target")

    machine1.succeed("ping -c 1 machine2")
    machine2.succeed("ping -c 1 machine1")
  '';
}
