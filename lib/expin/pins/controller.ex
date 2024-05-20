defmodule Expin.Pins.Controller do
  use GenServer

  import Ecto.Query

  alias Expin.Repo
  alias Expin.Pins.Pin

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    {:ok,
     %{
       supervisor: Keyword.fetch!(opts, :supervisor)
     }, {:continue, :existing}}
  end

  @impl true
  def handle_continue(:existing, state) do
    query =
      from p in Pin,
        where: p.status in [:queued, :pinning]

    Repo.all(query) |> Enum.each(&start_pin(&1, state))

    {:noreply, state}
  end

  @impl true
  def handle_info({ref, %Pin{} = pin}, state) do
    :ets.match_delete(state.supervisor, {pin.cid, ref, :"$_"})
    {:noreply, state}
  end

  @impl true
  def handle_info({:DOWN, ref, _, _pid, _reason}, state) do
    :ets.match_delete(state.supervisor, {:"$_", ref, :"$_"})
    {:noreply, state}
  end

  defp start_pin(%Pin{} = pin, state) do
    task =
      Task.Supervisor.async_nolink(state.supervisor, fn ->
        raise "not implemented"
      end)

    :ets.insert(state.supervisor, {pin.cid, task.ref, task})
  end
end
