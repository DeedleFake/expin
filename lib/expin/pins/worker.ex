defmodule Expin.Pins.Worker do
  use GenServer, restart: :transient

  alias Expin.IPFS

  def start_link(opts) do
    {action, opts} = Keyword.pop!(opts, :action)
    {pin, opts} = Keyword.pop!(opts, :pin)

    GenServer.start_link(__MODULE__, {action, pin}, opts)
  end

  @impl true
  def init(args) do
    {:ok, :no_state, {:continue, args}}
  end

  @impl true
  def handle_continue({:add_pin, pin}, state) do
    IPFS.pin_add(pin.cid)
    {:stop, :normal, state}
  end
end
