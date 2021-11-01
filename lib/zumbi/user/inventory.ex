defmodule Zumbi.User.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :fiji_water, :integer
    field :campbell_soup, :integer
    field :first_aid_pouch, :integer
    field :ak47, :integer
  end

  @required ~w(fiji_water campbell_soup first_aid_pouch ak47)a
  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, @required)
    |> validate_required(@required)
  end
end
