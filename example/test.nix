{ pkgs, trento_agent, prometheus_node_exporter, trento_web_release, trento_wanda_release, ... }:
let
  trento_wanda_envvars = {
    CORS_ORIGIN = "localhost";
    SECRET_KEY_BASE = "<secret-key-base>";
    ACCESS_TOKEN_ENC_SECRET = "<access-token-enc-secret>";
    AMQP_URL = "amqp://trento:trento@machine3_rabbitmq/vhost";
    DATABASE_URL = "ecto://wanda_user:wanda_password@postgres-host/wanda";
  };
  trento_web_envvars = {
    AMQP_URL = "amqp://trento:trento@/vhost";
    DATABASE_URL = "ecto://trento_user:web_password@postgres-host/trento";
    EVENTSTORE_URL = "ecto://trento_user:web_password@postgres-host/trento_event_store";
    ENABLE_ALERTING = "false";
    # PROMETHEUS_URL="http://prometheus-host:9090";
    SECRET_KEY_BASE = "<secret-key-base>";
    ACCESS_TOKEN_ENC_SECRET = "<access-token-enc-secret>";
    REFRESH_TOKEN_ENC_SECRET = "<refresh-token-enc-secret>";
    ADMIN_USERNAME = "admin";
    ADMIN_PASSWORD = "sample-password";
    ENABLE_API_KEY = "true";

  };
  trento_agent_envvars = {
    TRENTO_API_KEY = "foo-bar-key";
    TRENTO_FACTS_SERVICE_URL = "amqp://trento:trento@machine3_rabbitmq:5672/vhost";
  };

in
{
  name = "Two machines with Trento Agent ping each other";

  nodes = {
    # These configs do not add anything to the default system setup
    machine1 = { pkgs, ... }: {
      systemd.services = {
        prometheus_node_exporter.enable = true;
        trento-agent = {
          enable = true;
          description = "TrentoAgent";
          unitConfig = {

            Requires = [ "${prometheus_node_exporter}.service" ];
            After = [ "${prometheus_node_exporter}.service" ];
          };
          serviceConfig = {
            ExecStart = "${trento_agent}/bin/agent start";
            Type = "simple";
            User = "root";
            Restart = "on-failure";
            RestartSec = 5;
          };
          environment = trento_agent_envvars;
          wantedBy = [ "multi-user.target" ];
        };
      };

    };
    machine2 = { pkgs, ... }: { };
    machine3_rabbitmq = { pkgs, ... }: {
      networking.firewall.enable = false;
      services.rabbitmq = {
        enable = true;
        package = pkgs.rabbitmq-server;
        port = 5672;
        # managementPlugin.enable = true;
        # managementPlugin.port = 15673;
        configItems = {
          "default_user" = "trento";
          "default_pass" = "trento";
          "listeners.tcp.1" = ":::5672";
          "default_vhost" = "vhost";
          # "default_permissions.configure" = ".*";
          # "default_permissions.read" = ".*";
          # "default_permissions.write" = ".*";
        };

      };

    };
    machine4_trento_web = { pkgs, ... }: {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_15;
        # port = postgres_port;
        ensureDatabases = [ "trento" "trento_event_store" ];
        # TODO improve secrets management
        initialScript = pkgs.writeText "init-sql-script" ''
          CREATE USER trento_user WITH PASSWORD 'trento_password';
          \c trento
          GRANT ALL ON SCHEMA public TO trento_user;
          \c trento_event_store
          GRANT ALL ON SCHEMA public TO trento_user;
        '';
      };
      # services.trento-web = {
      #   enable = false;
      #   environmentFile = "/etc/trento/trento-web";
      # };
      systemd.services = {
        trento-web = {
          enable = true;
          description = "TrentoWeb Service";
          serviceConfig = {
            ExecStart = "${trento_web_release}/bin/trento start";
            ExecStartPre = "${trento_web_release}/bin/trento eval 'Trento.Release.init()'";
            Type = "simple";
            User = "root";
            Restart = "on-failure";
            RestartSec = 5;
          };
          # attr set
          environment = trento_web_envvars;
          wantedBy = [ "multi-user.target" ];
        };
      };
    };


    machine5_trento_wanda = { pkgs, ... }: {
      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_15;
        # port = postgres_port;
        ensureDatabases = [ "wanda" ];

        # TODO improve secrets management
        initialScript = pkgs.writeText "init-sql-script" ''
          CREATE USER wanda_user WITH PASSWORD 'wanda_password';
          \c wanda
          GRANT ALL ON SCHEMA public TO wanda_user;
        '';
      };
      # services.trento-wanda = {
      #   enable = false;
      #   environmentFile = "/etc/trento/trento-wanda";
      # };
      systemd.services = {
        trento-wanda = {
          enable = true;
          description = "TrentoWanda Service";
          serviceConfig = {
            ExecStart = "${trento_wanda_release}/bin/trento start";
            ExecStartPre = "${trento_wanda_release}/bin/trento eval 'Wanda.Release.init()'";
            Type = "simple";
            User = "root";
            Restart = "on-failure";
            RestartSec = 5;
          };
          # attr set, general config, not for secrets
          environment = trento_wanda_envvars;
          wantedBy = [ "multi-user.target" ];
        };
      };
    };
  };



  # Note that machine1 and machine2 are now available as
  # Python objects and also as hostnames in the virtual network
  testScript = ''
    machine1.wait_for_unit("default.target")
    # machine2.wait_for_unit("default.target")
    # machine3_rabbitmq.succeed("rabbitmqctl set_permissions -p vhost trento_user \".*\" \".*\" \".*\"")
    machine3_rabbitmq.wait_for_unit("rabbitmq.service")
    machine3_rabbitmq.wait_for_open_port(5672)
    machine3_rabbitmq.wait_for_unit("default.target")

    # machine4_trento_web.wait_for_unit("default.target")
    # machine5_trento_wanda.wait_for_unit("default.target")

    # machine1.succeed("systemctl start trento-agent")
    machine1.succeed("systemctl status trento-agent")
    machine1.succeed("ping -c 1 machine3_rabbitmq")
    # machine1.succeed("ping -c 1 machine2")
    # machine2.succeed("ping -c 1 machine1")
    # machine2.fail("ping -c 1 machine1")
  '';
}
