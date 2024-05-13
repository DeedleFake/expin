defmodule Expin.Repo.Migrations.CreatePins do
  use Ecto.Migration

  def change do
    create table(:pins) do
      add :cid, :string, null: false
      add :name, :string, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
