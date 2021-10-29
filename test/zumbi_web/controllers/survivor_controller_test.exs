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
      params = params_for(:survivor, %{gender: "K", name: nil, last_location: nil})
      conn = post(conn, Routes.survivor_path(conn, :sign_up), survivor: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update location " do
    test "last location survivor", %{conn: conn} do
      survivor = insert(:survivor)

      params = %{
        last_location: "miami"
      }

      conn = put(conn, Routes.survivor_path(conn, :update_location, survivor.id), survivor: params)

      assert expected = json_response(conn, 200)["data"]
      assert expected["last_location"] == params.last_location
    end

    test "but not name", %{conn: conn} do
      survivor = insert(:survivor)

      params = %{
        last_location: "miami",
        name: "seila"
      }

      conn = put(conn, Routes.survivor_path(conn, :update_location, survivor.id), survivor: params)

      assert expected = json_response(conn, 200)["data"]
      assert expected["last_location"] == params.last_location
      assert expected["name"] == survivor.name
    end

    test "survivor doesn't exist", %{conn: conn} do
      params = %{
        last_location: "miami",
      }

      conn = put(conn, Routes.survivor_path(conn, :update_location, 1), survivor: params)

      assert expected = json_response(conn, 404)
    end
  end

  defp create_survivor(_) do
    survivor = insert(:survivor)
    %{survivor: survivor}
  end
end
