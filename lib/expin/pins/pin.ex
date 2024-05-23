defmodule Expin.Pins.Pin do
  use Ecto.Schema
  import Ecto.Changeset

  @status_values [:queued, :pinning, :pinned, :failed]

  @type t() :: %__MODULE__{
          id: non_neg_integer(),
          cid: cid(),
          name: String.t(),
          status: status(),
          origins: [String.t()],
          meta: map(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }
  @type status() :: :queued | :pinning | :pinned | :failed
  @type cid() :: String.t()

  schema "pins" do
    field :cid, :string
    field :name, :string, default: ""
    field :status, Ecto.Enum, default: :queued, values: @status_values
    field :origins, {:array, :string}, default: []
    field :meta, :map, default: %{}

    timestamps(type: :utc_datetime)
  end

  @spec create_changeset(map()) :: Ecto.Changeset.t()
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:cid, :name, :status, :origins, :meta])
    |> validate_required([:cid])
    |> validate_inclusion(:status, @status_values)
    |> validate_length(:name, max: 255)
    |> validate_length(:origins, max: 20)
    |> unique_constraint(:cid)
  end

  @spec update_status_changeset(t(), status()) :: Ecto.Changeset.t()
  def update_status_changeset(pin, status) do
    pin
    |> cast(%{status: status}, [:status])
    |> validate_required([:id, :status])
    |> validate_inclusion(:status, @status_values)
  end
end
