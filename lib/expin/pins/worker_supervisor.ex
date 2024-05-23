defmodule Expin.Pins.WorkerSupervisor do
  use ConsumerSupervisor

  alias Expin.IPFS
  alias Expin.Pins

  @type action() :: :add_pin

  def start_link([]) do
    ConsumerSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([]) do
    children = [
      %{id: __MODULE__, start: {__MODULE__, :start_worker, []}, restart: :transient}
    ]

    ConsumerSupervisor.init(children, strategy: :one_for_one, subscribe_to: [Pins])
  end

  def start_worker({action, pin}) do
    Task.start_link(fn ->
      Registry.register(Pins.registry(), pin.cid, :no_value)
      perform_action(action, pin)
    end)
  end

  defp perform_action(:add_pin, pin) do
    {:ok, _pin} = Pins.update_pin_status(pin.id, :pinning)

    case IPFS.pin_add(pin.cid) do
      {:ok, _rsp} ->
        {:ok, _pin} = Pins.update_pin_status(pin.id, :pinned)

      {:error, err} ->
        {:ok, _pin} = Pins.update_pin_status(pin.id, :failed)
        raise err
    end
  end
end