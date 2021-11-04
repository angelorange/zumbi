defmodule Zumbi.SurvivorFactory do
  defmacro __using__(_opts) do
    quote do
      def survivor_factory do
        %Zumbi.User.Survivor{
          name: sequence("chika"),
          gender: "F",
          last_location: sequence("osaka"),
          is_infected: false,
          inventory: %{
            fiji_water: 2,
            ak47: 2,
            campbell_soup: 2,
            first_aid_pouch: 3
          }
        }
      end
    end
  end
end
