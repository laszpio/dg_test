import Config

config :dg_test,
  ghost_url: "#{System.get_env("GHOST_URL")}",
  ghost_key: "#{System.get_env("GHOST_KEY")}",
  solr_url: "#{System.get_env("SOLR_URL")}",
  solr_core: "#{System.get_env("SOLR_CORE")}"

config :logger, level: :info
