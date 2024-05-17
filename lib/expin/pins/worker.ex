defmodule Expin.Pins.Worker do
  use Oban.Worker, queue: :default

  def perform(%Oban.Job{args: %{"action" => action}} = job) do
    perform_action(action, job)
  end

  defp perform_action(:add, job) do
    dbg()
    :ok
  end
end
