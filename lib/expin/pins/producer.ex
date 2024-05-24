defmodule Expin.Pins.Producer do
  use GenStage

  alias Expin.Pins.{Pin, Consumer}

  @spec run(Consumer.action(), Pin.t()) :: :ok
  def run(action, pin) do
    GenStage.cast(__MODULE__, {:run, action, pin})
  end

  def start_link([]) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init([]) do
    {:producer, :no_state}
  end

  @impl true
  def handle_cast({:run, action, pin}, state) do
    Consumer.stop_worker(pin.cid)
    {:noreply, [{action, pin}], state}
  end

  @impl true
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end
end
