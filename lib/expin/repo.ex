defmodule Expin.Repo do
  use Ecto.Repo,
    otp_app: :expin,
    adapter: Ecto.Adapters.Postgres

  @spec fetch(Ecto.Queryable.t(), term(), Keyword.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Exception.t()}
  def fetch(queryable, id, opts \\ []) do
    try do
      {:ok, get!(queryable, id, opts)}
    rescue
      e in [Ecto.NoResultsError] -> {:error, e}
    end
  end

  @spec fetch_by(Ecto.Queryable.t(), Keyword.t() | map(), Keyword.t()) ::
          {:ok, Ecto.Schema.t()} | {:error, Exception.t()}
  def fetch_by(queryable, clauses, opts \\ []) do
    try do
      {:ok, get_by!(queryable, clauses, opts)}
    rescue
      e in [Ecto.NoResultsError] -> {:error, e}
    end
  end
end
