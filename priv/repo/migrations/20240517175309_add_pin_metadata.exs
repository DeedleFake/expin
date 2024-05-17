defmodule Expin.Repo.Migrations.AddPinMetadata do
  use Ecto.Migration

  def change do
    alter table(:pins) do
      add :meta, :map, null: false, default: %{}
    end
  end
end
