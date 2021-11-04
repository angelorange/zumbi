defmodule ZumbiWeb.SurvivorController do
  use ZumbiWeb, :controller

  alias Zumbi.User
  alias Zumbi.User.Survivor

  action_fallback ZumbiWeb.FallbackController

  def sign_up(conn, %{"survivor" => survivor_params}) do
    with %{} = params <- clean_params(survivor_params),
         {:ok, %Survivor{} = survivor} <- User.create_survivor(params) do
      conn
      |> put_status(:created)
      |> render("show.json", survivor: survivor)
    end
  end

  def update_location(conn, %{"id" => id, "survivor" => %{"last_location" => ll}}) do
    with %Survivor{} = survivor <- User.get_survivor(id),
         {:ok, %Survivor{} = survivor} <- User.update_survivor(survivor, %{last_location: ll}) do
      render(conn, "show.json", survivor: survivor)
    end
  end

  def flag(conn, %{"id" => id, "flagger_id" => x9_id}) do
    with %Survivor{} = x9 <- User.get_survivor(x9_id),
         %Survivor{} = survivor <- User.get_survivor(id),
         {:ok, survivor} <- User.mark_infected(survivor, x9) do
      render(conn, "show.json", survivor: survivor)
    end
  end

  def trade(conn, params) do
    with %Survivor{} = survivor_one <- User.get_survivor(params["survivor_one"]),
         %Survivor{} = survivor_two <- User.get_survivor(params["survivor_two"]),
         true <- User.fair_trade?(params["deal_one"], params["deal_two"]),
         {:ok, survivors} <- User.execute_trade(survivor_one, survivor_two, params) do
      render(conn, "index.json", survivors: survivors)
    end
  end

  def report(conn, _params) do
    map = %{
      total_infected: User.get_total_infected(),
      total_non_infected: User.get_total_non_infected(),
      average_item_per_survivor: User.get_average_item_per_survivor(),
      lost_points: User.lost_points()
    }


    json(conn, %{data: map})
  end

  defp clean_params(params) do
    {_v, map} = Map.pop(params, "is_infected")

    map
  end
end
