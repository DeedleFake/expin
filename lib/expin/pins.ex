defmodule Expin.Pins do
  use Supervisor

  import Ecto.Query, warn: false
  alias Expin.Repo

  alias Expin.Pins.Pin
  alias __MODULE__.Manager

  def start_link([]) do
    Supervisor.start_link(__MODULE__, [])
  end

  @impl true
  def init([]) do
    children = [
      {DynamicSupervisor, name: __MODULE__.Supervisor},
      {Registry, keys: :unique, name: __MODULE__.Registry},
      Manager
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def queue_add_pin(cid, opts \\ []) when is_binary(cid) do
    opts = Keyword.validate!(opts, name: "", origins: [], meta: %{})

    changeset =
      Pin.create_changeset(%{
        cid: cid,
        name: opts[:name],
        origins: opts[:origins],
        meta: opts[:meta],
        status: :queued
      })

    with {:ok, pin} <- Repo.insert(changeset) do
      Manager.run(:add_pin, pin)
      {:ok, pin}
    end
  end

  def list_pins() do
    Repo.all(Pin)
  end

  def fetch_pin(id), do: Repo.fetch(Pin, id)

  def create_pin(attrs \\ %{}) do
    Pin.create_changeset(attrs)
    |> Repo.insert()
  end

  @spec update_pin_status(non_neg_integer(), Pin.status()) ::
          {:ok, Pin.t()} | {:error, Ecto.Changeset.t()}
  def update_pin_status(id, status) do
    with {:ok, pin} <- Repo.fetch(Pin, id) do
      pin |> Pin.update_status_changeset(status) |> Repo.update()
    end
  end

  def delete_pin(%Pin{} = pin) do
    Repo.delete(pin)
  end
end
