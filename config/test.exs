use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :hello_world_ci, HelloWorldCiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :hello_world_ci, HelloWorldCi.Repo,
  username: "postgres",
  password: "postgres",
  database: "hello_world_ci_test",
  hostname: "database",
  pool: Ecto.Adapters.SQL.Sandbox

# Configure publishing test result
config :junit_formatter,
  report_file: "report_file_test.xml",
  report_dir: "./",
  print_report_file: true,
  prepend_project_name?: true
