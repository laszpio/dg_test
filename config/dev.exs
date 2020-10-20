import Config

config :dg_test,
  ghost_api: System.get_env("GHOST_API"),
  ghost_key: System.get_env("GHOST_KEY"),
  solr_url: System.get_env("SOLR_URL"),
  solr_core: System.get_env("SOLR_CORE"),
  solr_cmd: System.get_env("SOLR_CMD")

config :logger, level: :info
