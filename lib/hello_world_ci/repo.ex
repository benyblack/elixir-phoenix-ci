defmodule HelloWorldCi.Repo do
  use Ecto.Repo,
    otp_app: :hello_world_ci,
    adapter: Ecto.Adapters.Postgres
end
