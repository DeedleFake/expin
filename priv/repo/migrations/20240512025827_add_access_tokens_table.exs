defmodule Expin.Repo.Migrations.AddAccessTokensTable do
  use Ecto.Migration

  def change do
    create table(:access_tokens, primary_key: false) do
      add :token, :string, primary_key: true, null: false
      add :comment, :string, null: false, default: ""

      timestamps(type: :utc_datetime)
    end
  end
end
