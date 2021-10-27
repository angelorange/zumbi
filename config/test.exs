import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :zumbi, Zumbi.Repo,
  username: "postgres",
  password: "postgres",
  database: "zumbi_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :zumbi, ZumbiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3zrsx5kShOj14f5VyiswQv20VdbnKc8r3jkxlUv7JI/Cu2vJF4/Whcb8Swy5gZbf",
  server: false

# In test we don't send emails.
config :zumbi, Zumbi.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
