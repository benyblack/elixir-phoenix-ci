import Config

config :logger, level: :info

secret_key_base = System.fetch_env!("SECRET_BASE_KEY")
db_user = System.fetch_env!("DB_USERNAME")
db_pwd  = System.fetch_env!("DB_PASSWORD")
db_name = System.fetch_env!("DB_NAME")
db_host = System.fetch_env!("DB_HOST")

config :hello_world_ci, HelloWorldCiWeb.Endpoint,
  server: true,
  secret_key_base: secret_key_base

config :hello_world_ci, HelloWorldCi.Repo,
  username: db_user,
  password: db_pwd,
  database: db_name,
  hostname: db_host,
  pool_size: 15,
  ssl: true
