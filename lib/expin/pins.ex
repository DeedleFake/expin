defmodule Expin.Pins do
  @moduledoc """
  The Pins context.
  """

  import Ecto.Query, warn: false
  alias Expin.Repo

  alias Expin.Pins.Pin

  @doc """
  Returns the list of pins.
  """
  def list_pins do
    Repo.all(Pin)
  end

  @doc """
  Gets a single pin.
  """
  def fetch_pin(id), do: Repo.fetch(Pin, id)

  @doc """
  Creates a pin.
  """
  def create_pin(attrs \\ %{}) do
    %Pin{}
    |> Pin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pin.
  """
  def update_pin(%Pin{} = pin, attrs) do
    pin
    |> Pin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pin.
  """
  def delete_pin(%Pin{} = pin) do
    Repo.delete(pin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pin changes.
  """
  def change_pin(%Pin{} = pin, attrs \\ %{}) do
    Pin.changeset(pin, attrs)
  end
end
