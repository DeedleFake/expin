defmodule Expin.PinJob do
  use Oban.Worker, queue: :default

  def perform(job) do
    %Oban.Job{args: args} = job
    dbg()

    {:ok, 3}
  end
end
