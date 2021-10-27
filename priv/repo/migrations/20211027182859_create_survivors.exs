defmodule Zumbi.Repo.Migrations.CreateSurvivors do
  use Ecto.Migration

  def change do
    create table(:survivors) do
      add :name, :string
      add :gender, :string
      add :last_location, :string
      add :is_infected, :boolean, default: false, null: false

      timestamps()
    end
  end
end
