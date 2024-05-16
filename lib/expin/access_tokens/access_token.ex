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

  def generate_changeset(token, attrs) do
    %__MODULE__{token: token}
    |> cast(attrs, [:comment])
    |> validate_required([:token])
    |> validate_length(:comment, min: 2)
  end

  def delete_changeset(id) when is_binary(id) do
    %__MODULE__{token: id}
  end
end
