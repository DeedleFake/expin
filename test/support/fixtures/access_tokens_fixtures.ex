defmodule Expin.AccessTokensFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Expin.AccessTokens` context.
  """

  @doc """
  Generate a access_token.
  """
  def access_token_fixture(attrs \\ %{}) do
    {:ok, access_token} =
      attrs
      |> Enum.into(%{})
      |> Expin.AccessTokens.create_access_token()

    access_token
  end
end
