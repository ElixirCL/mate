defmodule Mate.Repo do
  use Ecto.Repo,
    otp_app: :mate,
    adapter: Ecto.Adapters.Postgres
end
