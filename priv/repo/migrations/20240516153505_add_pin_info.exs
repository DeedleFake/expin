defmodule Expin.Repo.Migrations.AddPinInfo do
  use Ecto.Migration

  def change do
    alter table(:pins) do
      modify :name, :text, from: :string

      add :status, :string, null: false
      add :origins, {:array, :string}, null: false, default: []
    end
  end
end
