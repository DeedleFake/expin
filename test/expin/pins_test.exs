defmodule Expin.PinsTest do
  use Expin.DataCase

  alias Expin.Pins

  describe "pins" do
    alias Expin.Pins.Pin

    import Expin.PinsFixtures

    @invalid_attrs %{}

    test "list_pins/0 returns all pins" do
      pin = pin_fixture()
      assert Pins.list_pins() == [pin]
    end

    test "get_pin!/1 returns the pin with given id" do
      pin = pin_fixture()
      assert Pins.get_pin!(pin.id) == pin
    end

    test "create_pin/1 with valid data creates a pin" do
      valid_attrs = %{}

      assert {:ok, %Pin{} = pin} = Pins.create_pin(valid_attrs)
    end

    test "create_pin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pins.create_pin(@invalid_attrs)
    end

    test "update_pin/2 with valid data updates the pin" do
      pin = pin_fixture()
      update_attrs = %{}

      assert {:ok, %Pin{} = pin} = Pins.update_pin(pin, update_attrs)
    end

    test "update_pin/2 with invalid data returns error changeset" do
      pin = pin_fixture()
      assert {:error, %Ecto.Changeset{}} = Pins.update_pin(pin, @invalid_attrs)
      assert pin == Pins.get_pin!(pin.id)
    end

    test "delete_pin/1 deletes the pin" do
      pin = pin_fixture()
      assert {:ok, %Pin{}} = Pins.delete_pin(pin)
      assert_raise Ecto.NoResultsError, fn -> Pins.get_pin!(pin.id) end
    end

    test "change_pin/1 returns a pin changeset" do
      pin = pin_fixture()
      assert %Ecto.Changeset{} = Pins.change_pin(pin)
    end
  end
end
