defmodule Expin.Pins do
  @moduledoc """
  The Pins context.
  """

  import Ecto.Query, warn: false
  alias Expin.Repo

  alias Expin.Pins.Pin
  alias Expin.Pins.Worker

  def queue_add_pin(cid, opts \\ []) when is_binary(cid) do
    opts = Keyword.validate!(opts, name: "", origins: [], meta: %{})

    %{action: :add, cid: cid, name: opts[:name], origins: opts[:origins], meta: opts[:meta]}
    |> Worker.new()
    |> Repo.insert()
  end

  def queue_delete_pin(id) when is_integer(id) do
    %{action: :delete, id: id}
    |> Worker.new()
    |> Repo.insert()
  end

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

  def upsert_pin(cid, opts \\ []) when is_binary(cid) do
    raise "not implemented"
  end

  @doc """
  Creates a pin.
  """
  def create_pin(attrs \\ %{}) do
    Pin.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pin.
  """
  def update_pin_status(id, status) do
    %Pin{id: id}
    |> Pin.update_status_changeset(%{status: status})
    |> Repo.update()
  end

  @doc """
  Deletes a pin.
  """
  def delete_pin(%Pin{} = pin) do
    Repo.delete(pin)
  end
end
