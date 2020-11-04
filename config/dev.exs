use Mix.Config

config :particle,
  particle_key: System.get_env("particle_key"),
  client_id: System.get_env("client_id"),
  client_secret: System.get_env("client_secret")
