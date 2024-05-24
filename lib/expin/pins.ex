defmodule Expin.Pins do
  use Supervisor

  import Ecto.Query, warn: false
  alias Plug.Exception
  alias Expin.Repo

  alias Expin.Pins.{Pin, Producer, WorkerSupervisor}

  @spec registry() :: GenServer.name()
  def registry(), do: __MODULE__.Registry

  def start_link([]) do
    Supervisor.start_link(__MODULE__, [])
  end

  @impl true
  def init([]) do
    children = [
      {Registry, keys: :unique, name: registry()},
      Producer,
      WorkerSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec queue_add_pin(Pin.cid(), keyword()) :: {:ok, Pin.t()} | {:error, term()}
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
      Producer.run(:add_pin, pin)
      {:ok, pin}
    end
  end

  @spec list_pins() :: [Pin.t()]
  def list_pins() do
    Repo.all(Pin)
  end

  @spec fetch_pin(non_neg_integer()) :: {:ok, Pin.t()} | {:error, Exception.t()}
  def fetch_pin(id), do: Repo.fetch(Pin, id)

  @spec update_pin_status(non_neg_integer(), Pin.status()) ::
          {:ok, Pin.t()} | {:error, Ecto.Changeset.t()}
  def update_pin_status(id, status) do
    with {:ok, pin} <- Repo.fetch(Pin, id) do
      pin |> Pin.update_status_changeset(status) |> Repo.update()
    end
  end

  @spec delete_pin(Pin.t()) :: {:ok, Pin.t()} | {:error, Ecto.Changeset.t()}
  def delete_pin(%Pin{} = pin) do
    Repo.delete(pin)
  end
end
