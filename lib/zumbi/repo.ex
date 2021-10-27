defmodule Zumbi.Repo do
  use Ecto.Repo,
    otp_app: :zumbi,
    adapter: Ecto.Adapters.Postgres
end
