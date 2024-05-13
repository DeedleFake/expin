defmodule Expin.Pins.Pin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pins" do
    field :cid, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pin, attrs) do
    pin
    |> cast(attrs, [:cid, :name])
    |> validate_required([:cid, :name])
  end
end
