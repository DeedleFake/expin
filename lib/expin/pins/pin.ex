defmodule Expin.Pins.Pin do
  use Ecto.Schema
  import Ecto.Changeset

  @status_values [:queued, :pinning, :pinned, :failed]

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          cid: String.t(),
          name: String.t(),
          status: :queued | :pinning | :pinned | :failed,
          origins: [String.t()],
          meta: map(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "pins" do
    field :cid, :string
    field :name, :string
    field :status, Ecto.Enum, default: :queued, values: @status_values
    field :origins, {:array, :string}, default: []
    field :meta, :map, default: %{}

    timestamps(type: :utc_datetime)
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:cid, :name, :status, :origins, :meta])
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
