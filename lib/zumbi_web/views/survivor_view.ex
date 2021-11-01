defmodule ZumbiWeb.SurvivorView do
  use ZumbiWeb, :view
  alias ZumbiWeb.SurvivorView

  def render("index.json", %{survivors: survivors}) do
    %{data: render_many(survivors, SurvivorView, "survivor.json")}
  end

  def render("show.json", %{survivor: survivor}) do
    %{data: render_one(survivor, SurvivorView, "survivor.json")}
  end

  def render("survivor.json", %{survivor: survivor}) do
    %{
      id: survivor.id,
      name: survivor.name,
      gender: survivor.gender,
      last_location: survivor.last_location,
      is_infected: survivor.is_infected,
      flag: survivor.flag |> length(),
      inventory: %{
        fiji_water: survivor.inventory.fiji_water,
        first_aid_pouch: survivor.inventory.first_aid_pouch,
        campbell_soup: survivor.inventory.campbell_soup,
        ak47: survivor.inventory.ak47
      }
    }
  end
end
