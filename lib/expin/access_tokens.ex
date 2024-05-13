defmodule Expin.AccessTokens do
  @moduledoc """
  The AccessTokens context.
  """

  import Ecto.Query, warn: false
  alias Expin.Repo

  alias Expin.AccessTokens.AccessToken

  @doc """
  Returns the list of access tokens.
  """
  def list_access_tokens do
    Repo.all(AccessToken)
  end

  @doc """
  Gets a single access token by its unhashed ID.
  """
  def fetch_access_token(token) do
    with {:ok, id} <- token_to_id(token) do
      Repo.fetch(AccessToken, id)
    end
  end

  @doc """
  Generates a new access token.
  """
  @spec generate_access_token(map()) :: {:ok, AccessToken.t(), String.t()} | {:error, term()}
  def generate_access_token(attrs \\ %{}) do
    {id, token} = generate_token()

    result =
      %AccessToken{token: id}
      |> AccessToken.generate_changeset(attrs)
      |> Repo.insert()

    with {:ok, access_token} <- result do
      {:ok, access_token, token}
    end
  end

  @doc """
  Deletes an access token.
  """
  def delete_access_token(%AccessToken{} = access_token) do
    Repo.delete(access_token)
  end

  defp generate_token() do
    token = :crypto.strong_rand_bytes(64) |> Base.encode16(case: :lower)
    {:ok, id} = token_to_id(token)
    {id, token}
  end

  defp token_to_id(token) do
    case Base.decode16(token, case: :lower) do
      {:ok, token} ->
        {:ok, :crypto.hash(:sha256, token) |> Base.encode16(case: :lower)}

      :error ->
        {:error, "decoding token failed"}
    end
  end
end
