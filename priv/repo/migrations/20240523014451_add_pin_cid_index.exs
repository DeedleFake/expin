defmodule Expin.Repo.Migrations.AddPinCidIndex do
  use Ecto.Migration

  def change do
    create index(:pins, [:cid], unique: true)
  end
end
