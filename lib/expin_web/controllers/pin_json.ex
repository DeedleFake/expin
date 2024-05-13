defmodule ExpinWeb.PinJSON do
  alias Expin.Pins.Pin

  @doc """
  Renders a list of pins.
  """
  def index(%{pins: pins}) do
    results =
      for pin <- pins do
        %{requestid: nil, status: "queued", pin: data(pin)}
      end

    %{count: length(pins), results: results}
  end

  @doc """
  Renders a single pin.
  """
  def show(%{pin: pin}) do
    %{data: data(pin)}
  end

  def error(%{reason: reason, details: details}) do
    %{
      error: %{
        reason: reason,
        details: details
      }
    }
  end

  defp data(%Pin{} = pin) do
    %{
      id: pin.id,
      cid: pin.cid,
      name: pin.name
    }
  end
end
