import Config

config :dg_test,
  ghost_url: "https://ghost.local/api/v3/content",
  ghost_key: "secret",
  solr_url: System.get_env("SOLR_URL"),
  solr_core: System.get_env("SOLR_CORE")

config :logger, level: :info
