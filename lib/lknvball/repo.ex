defmodule Lknvball.Repo do
  use Ecto.Repo,
    otp_app: :lknvball,
    adapter: Ecto.Adapters.Postgres
end
