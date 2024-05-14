defmodule Expin.AccessTokens.AccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          token: String.t(),
          comment: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key false
  schema "access_tokens" do
    field :token, :string, primary_key: true
    field :comment, :string, default: ""

    timestamps(type: :utc_datetime)
  end

  @doc """
  Returns a changeset for generating a new access token.
  """
  def generate_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:comment])
    |> validate_required([:token])
  end
end
