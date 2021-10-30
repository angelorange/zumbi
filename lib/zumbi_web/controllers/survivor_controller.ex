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
    with %Survivor{} = x9 <- User.get_survivor!(x9_id),
        %Survivor{} = survivor <- User.get_survivor!(id),
        {:ok, survivor} <- User.flag_survivor(survivor, x9) do
      render(conn, "show.json", survivor: survivor)
    end
  end

  defp clean_params(params) do
    {_v, map} = Map.pop(params, "is_infected")

    map
  end
end
