defmodule ExpinWeb.PinJSON do
  alias Expin.Pins.Pin

  def index(%{pins: pins}) do
    %{count: length(pins), results: pins |> Enum.map(&pin_status/1)}
  end

  def show(%{pin: pin}) do
    pin_status(pin)
  end

  def error(%{reason: reason} = error) do
    error = %{
      reason: reason,
      details: error[:details]
    }

    %{error: error}
  end

  defp pin_status(%Pin{} = pin) do
    %{
      requestid: pin.id,
      status: pin.status,
      created: pin.inserted_at,
      pin: pin(pin),
      delegates: []
    }
  end

  defp pin(%Pin{} = pin) do
    %{
      cid: pin.cid,
      name: pin.name,
      origins: pin.origins,
      meta: pin.meta
    }
  end
end
