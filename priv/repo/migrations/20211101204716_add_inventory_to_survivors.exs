defmodule Zumbi.Repo.Migrations.AddInventoryToSurvivors do
  use Ecto.Migration

  def change do
    alter table(:survivors) do
      add :inventory, :map
    end
  end
end
