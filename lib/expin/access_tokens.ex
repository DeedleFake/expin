defmodule Expin.AccessTokens do
  @moduledoc """
  The AccessTokens context.
  """

  import Ecto.Query, warn: false
  alias Expin.Repo

  alias Expin.AccessTokens.AccessToken

  @doc """
  Returns the list of access_tokens.

  ## Examples

      iex> list_access_tokens()
      [%AccessToken{}, ...]

  """
  def list_access_tokens do
    Repo.all(AccessToken)
  end

  @doc """
  Gets a single access_token.
  """
  def get_access_token(id), do: Repo.get(AccessToken, id)

  @doc """
  Gets a single access_token.

  Raises if the Access token does not exist.

  ## Examples

      iex> get_access_token!(123)
      %AccessToken{}

  """
  def get_access_token!(id), do: Repo.get!(AccessToken, id)

  @doc """
  Creates a access_token.

  ## Examples

      iex> create_access_token(%{field: value})
      {:ok, %AccessToken{}}

      iex> create_access_token(%{field: bad_value})
      {:error, ...}

  """
  def create_access_token(attrs \\ %{}) do
    %AccessToken{}
    |> AccessToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a access_token.

  ## Examples

      iex> update_access_token(access_token, %{field: new_value})
      {:ok, %AccessToken{}}

      iex> update_access_token(access_token, %{field: bad_value})
      {:error, ...}

  """
  def update_access_token(%AccessToken{} = access_token, attrs) do
    access_token
    |> AccessToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a AccessToken.

  ## Examples

      iex> delete_access_token(access_token)
      {:ok, %AccessToken{}}

      iex> delete_access_token(access_token)
      {:error, ...}

  """
  def delete_access_token(%AccessToken{} = access_token) do
    Repo.delete(access_token)
  end

  @doc """
  Returns a data structure for tracking access_token changes.

  ## Examples

      iex> change_access_token(access_token)
      %Todo{...}

  """
  def change_access_token(%AccessToken{} = access_token, attrs \\ %{}) do
    AccessToken.changeset(access_token, attrs)
  end
end
