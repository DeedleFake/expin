defmodule Expin.Pins.Pin do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          cid: String.t(),
          name: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @status_values [:queued, :pinning, :pinned, :failed]

  schema "pins" do
    field :cid, :string
    field :name, :string
    field :status, Ecto.Enum, default: :queued, values: @status_values
    field :origins, {:array, :string}, default: []

    timestamps(type: :utc_datetime)
  end

  def create_changeset(pin \\ %__MODULE__{}, attrs) do
    pin
    |> cast(attrs, [:cid, :name, :status, :origins])
    |> validate_required([:cid, :name])
    |> validate_inclusion(:status, @status_values)
  end

  def update_status_changeset(pin, status) do
    pin
    |> cast(%{status: status}, [:status])
    |> validate_required([:id, :status])
    |> validate_inclusion(:status, @status_values)
  end
end
