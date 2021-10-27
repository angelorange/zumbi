defmodule Zumbi.SurvivorFactory do
  defmacro __using__(_opts) do
    quote do
      def survivor_factory do
        %Zumbi.User.Survivor{
          name: sequence("chika"),
          gender: sequence("feminino"),
          last_location: sequence("osaka"),
          is_infected: false
        }
      end
    end
  end
end
