defmodule PhxPlayground.Repo do
  use Ecto.Repo,
    otp_app: :phx_playground,
    adapter: Ecto.Adapters.Postgres
end
