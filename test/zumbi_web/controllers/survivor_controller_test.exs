defmodule ZumbiWeb.SurvivorControllerTest do
  use ZumbiWeb.ConnCase

  import Zumbi.Factory

  alias Zumbi.User.Survivor

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all survivors", %{conn: conn} do
      conn = get(conn, Routes.survivor_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create survivor" do
    test "renders survivor when data is valid", %{conn: conn} do
      survivor = insert(:survivor)
      params =
        %{
          name: survivor.name,
          gender: survivor.gender,
          last_location: survivor.last_location,
          is_infected: survivor.is_infected
        }

      conn = post(conn, Routes.survivor_path(conn, :create), survivor: params)

      assert expected = json_response(conn, 201)["data"]
      assert expected["name"] == survivor.name
      assert expected["gender"] == survivor.gender
      assert expected["last_location"] == survivor.last_location
      assert expected["is_infected"] == survivor.is_infected
    end

    test "renders errors when data is invalid", %{conn: conn} do
      params = params_for(:survivor, %{gender: nil, name: nil, last_location: nil, is_infected: nil})
      conn = post(conn, Routes.survivor_path(conn, :create), survivor: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update survivor" do
    setup [:create_survivor]

    test "renders survivor when data is valid", %{conn: conn, survivor: %Survivor{id: id} = survivor} do
      params = %{name: "jin", gender: "masculino", last_location: "africa", is_infected: true}

      conn = put(conn, Routes.survivor_path(conn, :update, survivor), survivor: params)

      assert expected = json_response(conn, 200)["data"]
      assert expected["name"] == params.name
      assert expected["gender"] == params.gender
      assert expected["is_infected"] == params.is_infected
      assert expected["last_location"] == params.last_location
    end

    test "renders errors when data is invalid", %{conn: conn, survivor: survivor} do
      params = %{name: nil, gender: nil, last_location: nil, is_infected: nil}

      conn = put(conn, Routes.survivor_path(conn, :update, survivor), survivor: params)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete survivor" do
    setup [:create_survivor]

    test "deletes chosen survivor", %{conn: conn, survivor: survivor} do
      conn = delete(conn, Routes.survivor_path(conn, :delete, survivor))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.survivor_path(conn, :show, survivor))
      end
    end
  end

  defp create_survivor(_) do
    survivor = insert(:survivor)
    %{survivor: survivor}
  end
end
