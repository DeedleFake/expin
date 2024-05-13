defmodule Expin.Repo do
  use Ecto.Repo,
    otp_app: :expin,
    adapter: Ecto.Adapters.Postgres

  def fetch(queryable, id, opts \\ []) do
    try do
      {:ok, get!(queryable, id, opts)}
    rescue
      e in [Ecto.NoResultsError] -> {:error, e}
    end
  end

  def fetch_by(queryable, clauses, opts \\ []) do
    try do
      {:ok, get_by!(queryable, clauses, opts)}
    rescue
      e in [Ecto.NoResultsError] -> {:error, e}
    end
  end
end
