defmodule Expin.PinsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Expin.Pins` context.
  """

  @doc """
  Generate a pin.
  """
  def pin_fixture(attrs \\ %{}) do
    {:ok, pin} =
      attrs
      |> Enum.into(%{})
      |> Expin.Pins.create_pin()

    pin
  end
end
