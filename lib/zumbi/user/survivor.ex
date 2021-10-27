defmodule Zumbi.User.Survivor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survivors" do
    field :gender, :string
    field :is_infected, :boolean, default: false
    field :last_location, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, [:name, :gender, :last_location, :is_infected])
    |> validate_required([:name, :gender, :last_location, :is_infected])
  end
end
