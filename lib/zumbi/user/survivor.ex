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
  @optional ~w(is_infected)a
  @required ~w(name gender last_location)a
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
