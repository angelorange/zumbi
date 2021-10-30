defmodule Zumbi.User.Survivor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "survivors" do
    field :gender, :string
    field :is_infected, :boolean, default: false
    field :last_location, :string
    field :name, :string
    field :flag, {:array, :string}, default: []

    timestamps()
  end

  @doc false
  @optional ~w(is_infected flag)a
  @required ~w(name gender last_location)a
  def changeset(survivor, attrs) do
    survivor
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> unique_constraint(:name)
    |> validate_length(:name, min: 4, max: 12)
    |> validate_inclusion(:gender, ["F", "M"])
  end
end
