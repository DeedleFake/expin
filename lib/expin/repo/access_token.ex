defmodule Expin.Repo.AccessToken do
  use Ecto.Schema

  @primary_key false
  schema "access_tokens" do
    field :token, :string, primary_key: true
    field :comment, :string, default: ""

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    import Ecto.Changeset

    struct
    |> cast(params, [:token, :comment])
    |> validate_required([:token])
  end
end
