import Config

config :dg_test,
  ghost_url: "https://productmarketingalliance.com/ghost/api/v3/content",
  ghost_key: "#{System.get_env("GHOST_KEY")}",
  solr_url: "http://localhost:8983/solr",
  solr_core: "posts"

config :logger, level: :info
