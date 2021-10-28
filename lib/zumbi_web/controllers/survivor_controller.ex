defmodule ZumbiWeb.SurvivorController do
  use ZumbiWeb, :controller

  alias Zumbi.User
  alias Zumbi.User.Survivor

  action_fallback ZumbiWeb.FallbackController

  def sign_up(conn, %{"survivor" => survivor_params}) do
    with {:ok, %Survivor{} = survivor} <- User.create_survivor(survivor_params) do
      conn
      |> put_status(:created)
      |> render("show.json", survivor: survivor)
    end
  end
end
