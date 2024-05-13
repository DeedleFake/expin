defmodule Expin.AccessTokens.AccessToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "access_tokens" do
    field :token, :string, primary_key: true
    field :comment, :string, default: ""

    timestamps(type: :utc_datetime)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:token, :comment])
    |> validate_required([:token])
  end
end
