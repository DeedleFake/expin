defmodule Expin.Pins do
  use Supervisor

  import Ecto.Query, warn: false
  alias Expin.Repo

  alias Expin.Pins.Pin

  def start_link([]) do
    Supervisor.start_link(__MODULE__, [])
  end

  @impl true
  def init([]) do
    if :ets.info(__MODULE__) == :undefined do
      :ets.new(__MODULE__, [:named_table])
    end

    children = [
      {Task.Supervisor, name: __MODULE__},
      {__MODULE__.Controller, supervisor: __MODULE__}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def queue_add_pin(cid, opts \\ []) when is_binary(cid) do
    opts = Keyword.validate!(opts, [:name, :origins, :meta])
    raise "not implemented"
  end

  def list_pins do
    Repo.all(Pin)
  end

  def fetch_pin(id), do: Repo.fetch(Pin, id)

  def create_pin(attrs \\ %{}) do
    Pin.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_pin_status(id, status) do
    %Pin{id: id}
    |> Pin.update_status_changeset(%{status: status})
    |> Repo.update()
  end

  def delete_pin(%Pin{} = pin) do
    Repo.delete(pin)
  end
end
