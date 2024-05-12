defmodule Expin.Repo do
  use Ecto.Repo,
    otp_app: :expin,
    adapter: Ecto.Adapters.Postgres
end
