defmodule Expin.Pins.Worker do
  use GenServer, restart: :transient

  alias Expin.IPFS
  alias Expin.Pins

  @type action() :: :add_pin

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
    {:ok, _pin} = Pins.update_pin_status(pin.id, :pinning)

    case IPFS.pin_add(pin.cid) do
      {:ok, _rsp} ->
        {:ok, _pin} = Pins.update_pin_status(pin.id, :pinned)

      {:error, err} ->
        {:ok, _pin} = Pins.update_pin_status(pin.id, :failed)
        raise err
    end

    {:stop, :normal, state}
  end
end
