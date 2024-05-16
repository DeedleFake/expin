defmodule Expin.PinJob do
  use Oban.Worker, queue: :default

  def perform(job) do
    %Oban.Job{args: %{}} = job
    dbg()
  end
end
