defmodule Expin.Pins.Worker do
  use Oban.Worker, queue: :default

  require Logger

  alias Expin.Pins
  alias Expin.IPFS

  def perform(%Oban.Job{args: %{"action" => action}} = job) do
    perform_action(action, job)
  end

  defp perform_action(:add, job) do
    %Oban.Job{
      args: %{
        "cid" => cid,
        "name" => name,
        "origins" => origins,
        "meta" => meta
      }
    } = job

    connect_origins(origins)

    {:ok, _pin} = Pins.upsert_pin(cid, name: name, origins: origins, meta: meta)
  end

  @spec connect_origins(Enumerable.t(String.t())) :: :ok
  defp connect_origins(origins) do
    for origin <- origins do
      Task.Supervisor.async_nolink(__MODULE__.TaskSupervisor, fn ->
        with {:error, err} <- IPFS.swarm_connect(origin) do
          Logger.warning("connect to origin: #{err}")
        end
      end)
    end

    :ok
  end
end
