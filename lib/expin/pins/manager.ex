defmodule Expin.Pins.Manager do
  use GenServer

  alias Expin.Pins

  @registry Pins.Registry
  @supervisor Pins.Supervisor
  @worker Pins.Worker

  @spec run(Pins.Worker.action(), Pins.Pin.t()) :: DynamicSupervisor.on_start_child()
  def run(action, pin) do
    GenServer.call(__MODULE__, {:run, action, pin})
  end

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([]) do
    {:ok, :no_state}
  end

  @impl true
  def handle_call({:run, action, pin}, _from, state) do
    cancel_existing(pin.cid)
    result = start(action, pin)

    {:reply, result, state}
  end

  defp cancel_existing(cid) do
    Registry.dispatch(@registry, cid, fn [{pid, _}] ->
      DynamicSupervisor.terminate_child(@supervisor, pid)
    end)
  end

  defp start(action, pin) do
    DynamicSupervisor.start_child(
      @supervisor,
      {@worker, action: action, pin: pin, name: worker_name(pin.cid)}
    )
  end

  defp worker_name(cid) do
    {:via, Registry, {@registry, cid}}
  end
end
