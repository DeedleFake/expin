defmodule Expin.Repo.Migrations.AddDefaultPinName do
  use Ecto.Migration

  def change do
    alter table(:pins) do
      modify :name, :string, default: ""
    end
  end
end
