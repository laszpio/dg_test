import Config

config :dg_test,
  ghost_url: "https://productmarketingalliance.com/ghost/api/v3/content",
  ghost_key: "#{System.get_env("GHOST_KEY")}"

config :logger, level: :info
