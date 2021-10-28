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

  defp clean_params(params) do
    {_v, map} = Map.pop(params, "is_infected")

    map
  end
end
