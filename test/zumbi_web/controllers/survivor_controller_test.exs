defmodule ZumbiWeb.SurvivorControllerTest do
  use ZumbiWeb.ConnCase

  import Zumbi.Factory

  alias Zumbi.User.Survivor

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign in survivor" do
    test "renders survivor when data is valid", %{conn: conn} do
      survivor = params_for(:survivor)
      params =
        %{
          name: survivor.name,
          gender: survivor.gender,
          last_location: survivor.last_location,
          is_infected: true
        }

      conn = post(conn, Routes.survivor_path(conn, :sign_up), survivor: params)

      assert expected = json_response(conn, 201)["data"]
      assert expected["name"] == survivor.name
      assert expected["gender"] == survivor.gender
      assert expected["last_location"] == survivor.last_location
      assert expected["is_infected"] == false
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = params_for(:survivor, %{gender: nil, name: nil, last_location: nil, is_infected: nil})
      conn = post(conn, Routes.survivor_path(conn, :sign_up), survivor: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_survivor(_) do
    survivor = insert(:survivor)
    %{survivor: survivor}
  end
end
