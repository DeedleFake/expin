defmodule Expin.Pins.Producer do
  use GenStage

  alias Expin.Pins

  @spec run(Pins.WorkerSupervisor.action(), Pins.Pin.t()) :: :ok
  def run(action, pin) do
    GenStage.cast(Pins, {:run, action, pin})
  end

  def start_link([]) do
    GenStage.start_link(__MODULE__, [], name: Pins)
  end

  @impl true
  def init([]) do
    {:producer, :no_state}
  end

  @impl true
  def handle_cast({:run, action, pin}, state) do
    cancel_existing(pin.cid)

    {:noreply, [{action, pin}], state}
  end

  defp cancel_existing(cid) do
    Registry.dispatch(Pins.registry(), cid, fn [{pid, _}] ->
      ConsumerSupervisor.terminate_child(Pins.worker_supervisor(), pid)
    end)
  end

  @impl true
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
